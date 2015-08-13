//
//  ALSelectPhotosViewController.h
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ALSelectPhotosViewControllerDelegate;

@interface ALSelectPhotosViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<ALSelectPhotosViewControllerDelegate>delegate;

- (void)reloadData;

@end

@protocol ALSelectPhotosViewControllerDelegate <NSObject>
@required
- (NSUInteger)numberOfPhotosAtIndexPath:(NSIndexPath *)indexPath;
- (ALAsset *)assetAtIndex:(NSUInteger)index forIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)maxSelectedCount;
@optional
- (void)selectPhotosViewController:(ALSelectPhotosViewController *)controller didChooseImageAssets:(NSMutableArray *)assets;

@end