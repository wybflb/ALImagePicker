//
//  ALSelectImagesViewController.h
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ALSelectImageGroupsViewControllerDelegate;

typedef NS_ENUM(NSInteger, ALSelectImageShowType) {
    ALSelectImageShowTypeAlbum, /**< 相册列表界面*/
    ALSelectImageShowTypeSavePhotos, /**< 相机胶卷界面*/
};

@interface ALSelectImageGroupsViewController : UIViewController

@property (nonatomic, weak) id<ALSelectImageGroupsViewControllerDelegate>delegate;
@property (nonatomic, assign) BOOL isShowNoImageGroup; /**< 是否显示没有照片的分组*/

- (instancetype)initWithShowType:(ALSelectImageShowType)showType maxSelectedImagesCount:(NSUInteger)maxCount;

@end

@protocol ALSelectImageGroupsViewControllerDelegate <NSObject>
@optional
/**
 获取相册分组失败
 @param error 获取相册分组的错误信息
 */
- (void)selectedImagesController:(ALSelectImageGroupsViewController *)controller didFailGetGroupsWithError:(NSError *)error;
/**
 用户取消了选择
 */
- (void)selectedImagesControllerDidCancel:(ALSelectImageGroupsViewController *)controller;
/**
 用户已经选择了照片
 @param assets 用户选择的照片的数组，数组每一项为ALAsset对象
 */
- (void)selectedImagesController:(ALSelectImageGroupsViewController *)controller didSelectImageAssets:(NSMutableArray *)assets;

@end