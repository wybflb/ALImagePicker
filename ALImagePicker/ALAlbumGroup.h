//
//  ALAlbumGroup.h
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAlbumGroup : NSObject

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, strong) UIImage *posterImage;
@property (nonatomic, assign) ALAssetsGroupType groupType;
@property (nonatomic, copy) NSString *persistentID;
@property (nonatomic, strong) NSURL *propertyURL;

@property (nonatomic, strong) NSMutableArray *images;

@end
