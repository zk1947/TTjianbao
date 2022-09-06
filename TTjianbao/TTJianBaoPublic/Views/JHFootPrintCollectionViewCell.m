//
//  JHFootPrintCollectionViewCell.m
//  TTjianbao
//
//  Created by YJ on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFootPrintCollectionViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "TTJianBaoColor.h"
#import "UIImageView+WebCache.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoMarco.h"
#import "UIImageView+Tool.h"

#define HEADERVIEW_WIDTH  58

@interface JHFootPrintCollectionViewCell()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *circleImageView;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIView  *statusView;
@property (strong, nonatomic) UILabel *statusLabel;
//@property (strong, nonatomic) UIImageView *sIconImageView;
//@property (strong, nonatomic) UIImageView *playingImage;
@property (strong, nonatomic) YYAnimatedImageView *playingImage;

@property (strong, nonatomic) UILabel *followCount;
@property (strong, nonatomic) UIButton *followBtn;

@end

@implementation JHFootPrintCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.left.offset(0);
            make.right.offset(0);
        }];
        
        [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).with.offset(13);
            make.centerX.equalTo(self.backView);
            make.width.mas_equalTo(HEADERVIEW_WIDTH);
            make.height.mas_equalTo(HEADERVIEW_WIDTH);
        }];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.circleImageView);
            make.width.mas_equalTo(HEADERVIEW_WIDTH-8);
            make.height.mas_equalTo(HEADERVIEW_WIDTH-8);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.circleImageView.mas_bottom).with.offset(5);
            make.right.equalTo(self.backView).with.offset(-5);
            make.left.equalTo(self.backView).with.offset(5);
            make.height.mas_equalTo(20);
        }];
        
        [self.followCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(3);
            make.left.equalTo(self.backView).with.offset(5);
            make.right.equalTo(self.backView).with.offset(-5);
            make.height.mas_equalTo(15);
        }];
        
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.followCount.mas_bottom).with.offset(15);
            make.centerX.equalTo(self.backView);
            make.width.mas_equalTo(62);
            make.height.mas_equalTo(29);
         }];

        self.statusView.sd_layout
        .centerXEqualToView(self.circleImageView)
        .topSpaceToView(self.circleImageView, -15)
        .widthIs(36)
        .heightIs(15);
        
        [self.playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(2.5);
            make.left.offset(3);;
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(10);
        }];
        
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.right.offset(0);
            make.bottom.offset(0);
            make.left.equalTo(self.playingImage.mas_right).with.offset(0);
        }];
    }
    
    return self;
}
- (void)setLiveRoomMode:(JHLiveRoomMode *)liveRoomMode
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:liveRoomMode.anchorIcon] placeholderImage:kDefaultAvatarImage];
    //[self.headImageView sd_setImageWithURL:[NSURL URLWithString:liveRoomMode.smallCoverImg] placeholderImage:kDefaultAvatarImage];
    self.titleLabel.text = liveRoomMode.anchorName;
    self.followCount.text = [NSString stringWithFormat:@"%ld人关注",(long)liveRoomMode.recommendCount];
    
    [self setFollowBtnStyle:liveRoomMode.isFollow];
    
    //status：2代表开播的 ；1代表未开播的
    [self setCircleImageViewStyle:liveRoomMode.status];
}

- (UIView *)backView
{
    if (!_backView)
    {
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
    }
    return _backView;
}

- (UIImageView *)circleImageView
{
    if (!_circleImageView)
    {
        _circleImageView = [[UIImageView alloc] init];
        _circleImageView.layer.cornerRadius = HEADERVIEW_WIDTH/2;
        _circleImageView.layer.borderWidth = 2.0f;
        [self.backView addSubview:_circleImageView];
    }
    return _circleImageView;
}

- (void)setCircleImageViewStyle:(NSString *)status
{
    if ([status integerValue] == 2)
    {
        //开播
        self.statusView.hidden = NO;
        self.circleImageView.layer.borderColor = YELLOW_COLOR.CGColor;
        
        //NSURL * url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"icon_pic.gif" ofType:nil]];
         //[self.sIconImageView yh_setImage:url];
        
        self.playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
    }
    else
    {
        //未开播
        self.statusView.hidden = YES;
        self.circleImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (UIImageView *)headImageView
{
    if (!_headImageView)
    {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.cornerRadius = (HEADERVIEW_WIDTH-8)/2;
        [self.circleImageView addSubview:_headImageView];
    }
    return _headImageView;
}

- (UIView *)statusView
{
    if (!_statusView)
    {
        _statusView = [[UIView alloc] init];
        _statusView.hidden = YES;
        _statusView.layer.cornerRadius = 2.0f;
        _statusView.backgroundColor = YELLOW_COLOR;
        [self.backView addSubview:_statusView];
    }
    return _statusView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        //_titleLabel.text = @"翡翠严选产品";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _titleLabel.textColor = BLACK_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)followCount
{
    if (!_followCount)
    {
        _followCount = [[UILabel alloc] init];
        //_followCount.text = @"53535人关注";
        _followCount.textColor = LIGHTGRAY_COLOR;
        _followCount.font = [UIFont fontWithName:kFontNormal size:11.0f];
        _followCount.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:_followCount];
    }
    return _followCount;
}

- (UIButton *)followBtn
{
    if (!_followBtn)
    {
        _followBtn = [[UIButton alloc] init];
        _followBtn.layer.cornerRadius = 4.0f;
        _followBtn.layer.borderWidth = 1.0f;
        _followBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13.0f];
        [_followBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_followBtn];
    }
    return _followBtn;
}

- (void)setFollowBtnStyle:(BOOL)isFollowed
{
    if (isFollowed)
    {
        //已关注
        self.followBtn.backgroundColor = [UIColor whiteColor];
        self.followBtn.layer.borderColor = MLIGHTGRAY_COLOR.CGColor;
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:GRAY_COLOR forState:UIControlStateNormal];
    }
    else
    {
        //未关注
        self.followBtn.backgroundColor = YELLOW_COLOR;
        self.followBtn.layer.borderColor = YELLOW_COLOR.CGColor;
        [self.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    }
}

- (YYAnimatedImageView *)playingImage
{
    if (!_playingImage)
    {
        _playingImage = [[YYAnimatedImageView alloc] init];
        _playingImage.contentMode=UIViewContentModeScaleAspectFit;
        [self.statusView addSubview:_playingImage];
    }
    return _playingImage;
}


//- (UIImageView *)sIconImageView
//{
//    if (!_sIconImageView)
//    {
//        _sIconImageView = [[UIImageView alloc] init];
//        //_sIconImageView.backgroundColor = [UIColor whiteColor];
//        [self.statusView addSubview:_sIconImageView];
//    }
//    return _sIconImageView;
//}

- (UILabel *)statusLabel
{
    if (!_statusLabel)
    {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"直播";
        _statusLabel.font = [UIFont fontWithName:kFontNormal size:9.0f];
        _statusLabel.textColor = BLACK_COLOR;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.statusView addSubview:_statusLabel];
    }
    return _statusLabel;
}

-(void)onClickBtnAction:(UIButton*)button
{
    self.userInteractionEnabled = NO;
    self.followBtn.enabled = NO;
    
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];
    
    if (self.buttonClick)
    {
        self.buttonClick([NSNumber numberWithInteger:self.cellIndex]);
    }
}

-(void)changeButtonStatus
{
    self.followBtn.enabled = YES;
    self.userInteractionEnabled = YES;
}

@end
