//
//  JHRichImageRankCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRichImageRankCell.h"
#import <YYKit/YYKit.h>

@interface JHRichImageRankCell ()
@property (nonatomic, strong) UIImageView * coverImage;
@property (nonatomic, strong) YYAnimatedImageView *videoIconImage;
@end

@implementation JHRichImageRankCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _coverImage=[[UIImageView alloc]init];
        _coverImage.image=[UIImage imageNamed:@""];
        _coverImage.userInteractionEnabled=YES;
        _coverImage.backgroundColor=[UIColor clearColor];
        _coverImage.layer.cornerRadius = 8;
        _coverImage.contentMode=UIViewContentModeScaleAspectFill;
        _coverImage.layer.masksToBounds = YES;
        [self.contentView addSubview:_coverImage];

        [_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _videoIconImage = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"sq_rcmd_icon_video"]];
        _videoIconImage.userInteractionEnabled = YES;
        _videoIconImage.contentMode = UIViewContentModeScaleAspectFit;
        _videoIconImage.clipsToBounds = YES;
        [_coverImage addSubview:_videoIconImage];
        [_videoIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_coverImage);
        }];
        _videoIconImage.hidden=YES;
    }
    return self;
}
-(void)setMode:(JHAlbumPickerModel *)mode{
    _mode = mode;
    _coverImage.image = (UIImage*)mode.image;
    _videoIconImage.hidden=!_mode.isVideo;
}
@end
