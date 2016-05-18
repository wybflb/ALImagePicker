//
//  RootViewController.m
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import "RootViewController.h"
#import "ALImagePicker.h"
#import "ALSelectImageGroupsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface RootViewController () <ALImagePickerDelegate, ALSelectImageGroupsViewControllerDelegate>
@property (nonatomic, strong) ALImagePicker *imagePicker;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(70, 100, 150, 70);
    [button setTitle:@"OpenImagePicker" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(70, 200, 150, 70);
    [button setTitle:@"OpenAlbum" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonDidTaped:(UIButton *)button
{
    if (!self.imagePicker) {
        self.imagePicker = [[ALImagePicker alloc] init];
        self.imagePicker.delegate = self;
    }
    [self.imagePicker showActionSheetFromView:self.view presentingController:self.navigationController];
}

- (void)openAlbum:(UIButton *)button
{
    ALSelectImageGroupsViewController *selectImagesController = [[ALSelectImageGroupsViewController alloc] initWithShowType:ALSelectImageShowTypeSavePhotos maxSelectedImagesCount:9];
    selectImagesController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectImagesController];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - ALImagePickerDelegate
- (void)imagePicker:(ALImagePicker *)picker didSelectedImage:(UIImage *)image
{
    NSLog(@"%@", image);
    self.imagePicker = nil;
}

#pragma mark - ALSelectImageGroupsViewControllerDelegate
- (void)selectedImagesController:(ALSelectImageGroupsViewController *)controller didFailGetGroupsWithError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)selectedImagesControllerDidCancel:(ALSelectImageGroupsViewController *)controller
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)selectedImagesController:(ALSelectImageGroupsViewController *)controller didSelectImageAssets:(NSMutableArray *)assets
{
    NSLog(@"%s", __FUNCTION__);
    for (ALAsset *asset in assets) {
        NSLog(@"asset->%@", asset);
    }
}


@end
