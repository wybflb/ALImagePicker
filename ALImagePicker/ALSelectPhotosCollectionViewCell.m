//
//  ALSelectPhotosCollectionViewCell.m
//  ALImagePicker
//
//  Created by Arien Lau on 15/8/13.
//  Copyright (c) 2015年 Arien Lau. All rights reserved.
//

#import "ALSelectPhotosCollectionViewCell.h"

@implementation ALSelectPhotosCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.contentView.layer.borderWidth = 1;
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.imageView];
        
        self.selectIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 22 -10, self.contentView.frame.size.height - 22 -10, 22, 22)];
        [self.contentView addSubview:self.selectIconImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.selectIconImageView.image = [UIImage imageNamed:@"ALPhotosSelectedIcon.png"];
    } else {
        self.selectIconImageView.image = nil;
    }
}

@end
