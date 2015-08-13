//
//  ALSelectPhotosViewController.m
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import "ALSelectPhotosViewController.h"
#import "ALSelectPhotosCollectionViewCell.h"

static NSString *ALSelectPhotoViewTitle = @"选择照片";
static NSString *ALSelectPhotosCellReuseIdentifier = @"ALSelectPhotosCellReuseIdentifier";
static CGFloat const ALMinImageLineSpacing = 2.0;
static CGFloat const ALMinImageVerticalSpacing = 2.0;

@interface ALSelectPhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@end

@implementation ALSelectPhotosViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = ALSelectPhotoViewTitle;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = ALMinImageVerticalSpacing;
    layout.minimumLineSpacing = ALMinImageLineSpacing;
    CGFloat viewWidth = MIN(self.view.frame.size.width, self.view.frame.size.height);
    NSInteger totalImageWidth = (viewWidth - 3 * ALMinImageLineSpacing);
    totalImageWidth = totalImageWidth - totalImageWidth % 4;
    CGFloat imageWidth = totalImageWidth/4.0;
    layout.itemSize = CGSizeMake(imageWidth, imageWidth);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[ALSelectPhotosCollectionViewCell class] forCellWithReuseIdentifier:ALSelectPhotosCellReuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView reloadData];
    NSUInteger numberOfPhotos = [self.delegate numberOfPhotosAtIndexPath:self.indexPath];
    if (numberOfPhotos > 0) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:([self.delegate numberOfPhotosAtIndexPath:self.indexPath]-1) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(gotoNextStep)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public
- (void)reloadData
{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfPhotosAtIndexPath:)]) {
        return [self.delegate numberOfPhotosAtIndexPath:self.indexPath];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALSelectPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALSelectPhotosCellReuseIdentifier forIndexPath:indexPath];
    
    ALAsset *asset = [self.delegate assetAtIndex:indexPath.row forIndexPath:self.indexPath];
    cell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    if ([self.collectionView.indexPathsForSelectedItems containsObject:indexPath]) {
        cell.selectIconImageView.image = [UIImage imageNamed:@"ALPhotosSelectedIcon.png"];
    } else {
        cell.selectIconImageView.image = nil;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedIndexPaths = [collectionView indexPathsForSelectedItems];
    NSUInteger maxCount = [self.delegate maxSelectedCount];
    if (selectedIndexPaths.count >= maxCount) {
        NSString *message = [NSString stringWithFormat:@"您最多可以选择%@张照片", @([self.delegate maxSelectedCount])];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSArray *array = [collectionView indexPathsForSelectedItems];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);
//- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

// These methods provide support for copy/paste actions on cells.
// All three should be implemented if any are.
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;

// support for custom transition layout
//- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout;
#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(ALMinImageVerticalSpacing, 0, ALMinImageVerticalSpacing, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark - Private
- (void)gotoNextStep
{
    NSArray *selectedIndexPaths = [self.collectionView indexPathsForSelectedItems];
    if (selectedIndexPaths.count) {
        NSMutableArray *result = [NSMutableArray array];
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            ALAsset *asset = [self.delegate assetAtIndex:indexPath.row forIndexPath:self.indexPath];
            [result addObject:asset];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectPhotosViewController:didChooseImageAssets:)]) {
                [self.delegate selectPhotosViewController:self didChooseImageAssets:result];
            }
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有选择任何照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
