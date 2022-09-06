//
//  JHLiveRoomCustomBtnView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomCustomBtnView.h"

@implementation JHLiveRoomCustomBtnView
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLORA(0x000000, 0.4);
        [self createViews];
    }
    return self;
}
-(void)createViews
{
    [self leftImageView];
    [self rightImageView];
    [self titleLabel];

}
-(UIImageView *)leftImageView
{
    if(!_leftImageView)
    {
        _leftImageView = [UIImageView new];
        [self addSubview:_leftImageView];
        _leftImageView.userInteractionEnabled = YES;
        _leftImageView.image = [UIImage imageNamed:@""];
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
            make.centerY.equalTo(self);
        }];
    }
    return _leftImageView;
}
-(UIImageView *)rightImageView
{
    if(!_rightImageView)
    {
        _rightImageView = [UIImageView new];
        [self addSubview:_rightImageView];
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.image = [UIImage imageNamed:@"icon_live_right_light_arrow"];
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-5);
            make.width.equalTo(@3);
            make.height.equalTo(@5);
            make.centerY.equalTo(self);
        }];
    }
    return _rightImageView;
}
-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:9.0];
        _titleLabel.textColor = HEXCOLOR(0xffffff);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.leftImageView.mas_right).with.offset(4);
            make.right.equalTo(self.rightImageView.mas_left).with.offset(-4);
            make.height.equalTo(@16);

        }];
    }
    return _titleLabel;
}


@end
