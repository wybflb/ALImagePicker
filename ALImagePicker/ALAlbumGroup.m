//
//  ALAlbumGroup.m
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import "ALAlbumGroup.h"

@implementation ALAlbumGroup

- (instancetype)init
{
    if (self = [super init]) {
        self.images = [NSMutableArray array];
    }
    return self;
}

@end
