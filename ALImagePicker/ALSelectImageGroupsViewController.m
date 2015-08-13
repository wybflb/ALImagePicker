//
//  ALSelectImagesViewController.m
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import "ALSelectImageGroupsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAlbumGroup.h"
#import "ALSelectPhotosViewController.h"

static NSString *ALSelectImageGroupViewTitle = @"相簿";

@interface ALSelectImageGroupsViewController () <UITableViewDataSource, UITableViewDelegate, ALSelectPhotosViewControllerDelegate>
@property (nonatomic, assign) NSUInteger maxSelectedCount;
@property (nonatomic, assign) ALSelectImageShowType showType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *albums;
@end

@implementation ALSelectImageGroupsViewController

- (instancetype)initWithShowType:(ALSelectImageShowType)showType maxSelectedImagesCount:(NSUInteger)maxCount
{
    self = [super init];
    if (self) {
        self.maxSelectedCount = maxCount;
        self.showType = showType;
        self.albums = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = ALSelectImageGroupViewTitle;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelectImages)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在系统设置->隐私->照片 中打开此应用的授权" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } else if (self.showType == ALSelectImageShowTypeSavePhotos) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ALSelectPhotosViewController *photosViewController = [[ALSelectPhotosViewController alloc] init];
        photosViewController.indexPath = indexPath;
        photosViewController.delegate = self;
        [self.navigationController pushViewController:photosViewController animated:NO];
    }
    [self getAllAssetsGroupsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (ALAssetsLibrary *)sharedAssetsLibrary
{
    static ALAssetsLibrary * assetsLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetsLibrary = [[ALAssetsLibrary alloc] init];
    });
    return assetsLibrary;
}

- (void)getAllAssetsGroupsData
{
    [[self sharedAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            __block ALAlbumGroup *albumGroup = [[ALAlbumGroup alloc] init];
            albumGroup.groupName = [group valueForProperty:ALAssetsGroupPropertyName];
            albumGroup.posterImage = [UIImage imageWithCGImage:group.posterImage];
            albumGroup.groupType = [[group valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            albumGroup.persistentID = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
            albumGroup.propertyURL = [group valueForProperty:ALAssetsGroupPropertyURL];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                NSString *type = [result valueForProperty:ALAssetPropertyType];
                if ([type isEqualToString:ALAssetTypePhoto]) {
                    [albumGroup.images addObject:result];
                }
            }];
            if (self.isShowNoImageGroup) {
                [self.albums addObject:albumGroup];
            } else if (albumGroup.images.count > 0) {
                [self.albums addObject:albumGroup];
            }
            if (self.showType == ALSelectImageShowTypeSavePhotos && albumGroup.groupType == ALAssetsGroupSavedPhotos) {
                UIViewController *VC = self.navigationController.topViewController;
                if ([VC isKindOfClass:[ALSelectPhotosViewController class]]) {
                    ALSelectPhotosViewController *photosVC = (ALSelectPhotosViewController *)VC;
                    //在这一步的时候self.albums.count至少已经为1，故不做错误判断处理
                    photosVC.indexPath = [NSIndexPath indexPathForRow:(self.albums.count-1) inSection:0];
                    [photosVC reloadData];
                }
            }
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedImagesController:didFailGetGroupsWithError:) ]) {
            [self.delegate selectedImagesController:self didFailGetGroupsWithError:error];
        }
    }];
}

- (void)cancelSelectImages
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedImagesControllerDidCancel:)]) {
            [self.delegate selectedImagesControllerDidCancel:self];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"ALSelectedImagesTableViewCellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ALAlbumGroup *group = self.albums[indexPath.row];
    cell.imageView.image = group.posterImage;
    cell.textLabel.text = group.groupName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"共(%@)张", @(group.images.count)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAlbumGroup *group = self.albums[indexPath.row];
    if (group.images.count > 0) {
        ALSelectPhotosViewController *photosViewController = [[ALSelectPhotosViewController alloc] init];
        photosViewController.indexPath = indexPath;
        photosViewController.delegate = self;
        [self.navigationController pushViewController:photosViewController animated:YES];
    }
}

#pragma mark - ALSelectPhotosViewControllerDelegate
- (NSUInteger)numberOfPhotosAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.albums.count) {
        ALAlbumGroup *group = self.albums[indexPath.row];
        return group.images.count;
    }
    return 0;
}

- (ALAsset *)assetAtIndex:(NSUInteger)index forIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.albums.count) {
        ALAlbumGroup *group = self.albums[indexPath.row];
        if (index < group.images.count) {
            return group.images[index];
        }
    }
    return nil;
}

- (NSUInteger)maxSelectedCount
{
    return _maxSelectedCount;
}

- (void)selectPhotosViewController:(ALSelectPhotosViewController *)controller didChooseImageAssets:(NSMutableArray *)assets
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedImagesController:didSelectImageAssets:)]) {
        [self.delegate selectedImagesController:self didSelectImageAssets:assets];
    }
}

@end
