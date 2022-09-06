//
//  JHPostUserInfoView.m
//  TTjianbao
//
//  Created by lihui on 2020/9/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostUserInfoView.h"
#import "UIView+JHGradient.h"
#import "JHPostDetailModel.h"
#import "UIImageView+JHWebImage.h"
#import <UIImageView+WebCache.h>
#import "JHSQModel.h"
#import "JHUserInfoViewController.h"
#import "JHSQMedalView.h"

@interface JHPostUserInfoView ()
@property (nonatomic, strong) UIImageView *authorIcon;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) YYLabel *titleLabel;
///展示各种勋章的view
@property (nonatomic, strong) JHSQMedalView *medalView;

@end

@implementation JHPostUserInfoView

- (void)dealloc {
    NSLog(@"%s被释放了！！！🔥🔥🔥🔥", __func__);
}

- (void)setUserInfo:(User *)userInfo publishTime:(NSString *)publishTime {
    [_authorIcon sd_setImageWithURL:[NSURL URLWithString:userInfo.icon] placeholderImage:kDefaultAvatarImage];
    _authorNameLabel.text = [userInfo.name isNotBlank] ? userInfo.name : @"暂无昵称";
    _timeLabel.text = [publishTime isNotBlank] ? publishTime : @"刚刚";
//    _medalView.tagArray = userInfo.;
    _followButton.hidden = YES;
}

- (void)setPostInfo:(JHPostDetailModel *)postInfo {
    if (!postInfo) {
        return;
    }
    _postInfo = postInfo;
    
    [_authorIcon jhSetImageWithURL:[NSURL URLWithString:_postInfo.publisher.avatar] placeholder:kDefaultAvatarImage];
    
    _authorNameLabel.text = [_postInfo.publisher.user_name isNotBlank]
    ? _postInfo.publisher.user_name
    : @"暂无昵称";
    
    _timeLabel.text = _postInfo.publish_time;
    _medalView.tagArray = _postInfo.publisher.levelIcons;

    _followButton.hidden = _postInfo.is_self
    ? YES
    : _postInfo.publisher.is_follow;
}

- (void)enterPersonHomePage {
    if (self.iconEnterBlock) {
        self.iconEnterBlock();
    }
}

- (void)followAction:(UIButton *)sender {
    if (self.followBlock) {
        self.followBlock(sender.selected);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _authorIcon = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _authorIcon.contentMode = UIViewContentModeScaleAspectFill;
    _authorIcon.layer.cornerRadius = 19.;
    _authorIcon.layer.masksToBounds = YES;
    [self addSubview:_authorIcon];
    _authorIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPersonHomePage)];
    [_authorIcon addGestureRecognizer:iconTap];
    
    _authorNameLabel = [[UILabel alloc] init];
    _authorNameLabel.text = @"";
    _authorNameLabel.font = [UIFont fontWithName:kFontMedium size:13];
    _authorNameLabel.textColor = HEXCOLOR(0x000000);
    [self addSubview:_authorNameLabel];
    
    _medalView = [[JHSQMedalView alloc] init];
    [self addSubview:_medalView];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"";
    _timeLabel.textColor = kColor999;
    _timeLabel.font = [UIFont fontWithName:kFontNormal size:11];
    [self addSubview:_timeLabel];

    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:kColor333 forState:UIControlStateNormal];
    [_followButton setTitleColor:kColor999 forState:UIControlStateSelected];
    _followButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [_followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followButton];
    _followButton.hidden = YES;
    
    [self makeLayouts];
}


- (void)makeLayouts {
    [_authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.leading.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    [_authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorIcon).offset(2);
        make.left.equalTo(self.authorIcon.mas_right).offset(10);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.authorIcon);
        make.left.equalTo(self.authorNameLabel);
    }];
    
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.authorIcon);
        make.size.mas_equalTo(CGSizeMake(54, 26));
    }];

    [_medalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel.mas_right).offset(5);
        make.right.equalTo(self.followButton.mas_left).offset(-10);
        make.centerY.equalTo(self.authorNameLabel);
        make.height.mas_equalTo(15.f);
    }];
        
    [_followButton layoutIfNeeded];
    _followButton.layer.cornerRadius = _followButton.height/2.;
    _followButton.layer.masksToBounds = YES;
    [_followButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:@[@0, @.5, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

@end
