//
//  ALImagePicker.h
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ALImagePickerDelegate;

@interface ALImagePicker : NSObject

@property (nonatomic, weak) id<ALImagePickerDelegate>delegate;

- (void)showActionSheetFromView:(UIView *)view presentingController:(UIViewController *)viewController;
- (void)showCameraWithPresentingController:(UIViewController *)viewController;

@end

@protocol ALImagePickerDelegate <NSObject>

- (void)imagePicker:(ALImagePicker *)picker didSelectedImage:(UIImage *)image;

@end