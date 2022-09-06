//
//  JHUserFriendListCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHUserFriendListCell.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "CUserFriendModel.h"
#import "UserFriendApiManager.h"
#import "TTjianbaoHeader.h"


@interface JHUserFriendListCell ()

@property (nonatomic, strong) UIImageView *iconView; //头像
@property (nonatomic, strong) UIImageView *vipImgV; //大V标记
@property (nonatomic, strong) UILabel *nameLabel; // 用户名
@property (nonatomic, strong) UIButton *followBtn; //关注按钮

@property (nonatomic, strong) UIImageView *roleIcon; ///认证鉴定师、主播
@property (nonatomic, strong) UIImageView *crowIcon; ///大客户标识
@property (nonatomic, strong) UIImageView *titleLevelIcon; ///称号
@property (nonatomic, strong) UIImageView *gameLevelIcon; ///勋章（游戏级别）

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JHUserFriendListCell

+ (CGFloat)cellHeight {
    return 80.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.clipsToBounds = YES;
        _iconView.sd_cornerRadius = @(25.0);
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconView];
    }
    
    if (!_vipImgV) {
        _vipImgV = [UIImageView new];
        _vipImgV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_vipImgV];
    }
    
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.0] textColor:kColor222];
        [self.contentView addSubview:_nameLabel];
    }
    
    //认证鉴定师
    if (!_roleIcon) {
        _roleIcon = [UIImageView new];
        _roleIcon.clipsToBounds = YES;
        _roleIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_roleIcon];
    }
    
    //称号等级
    if (!_crowIcon) {
        _crowIcon = [UIImageView new];
        _crowIcon.clipsToBounds = YES;
        _crowIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_crowIcon];
    }
    
    //称号等级
    if (!_titleLevelIcon) {
        _titleLevelIcon = [UIImageView new];
        _titleLevelIcon.clipsToBounds = YES;
        _titleLevelIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_titleLevelIcon];
    }
    
    //游戏等级
    if (!_gameLevelIcon) {
        _gameLevelIcon = [UIImageView new];
        _gameLevelIcon.clipsToBounds = YES;
        _gameLevelIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_gameLevelIcon];
    }
    
    //关注按钮
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        _followBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.0];
        _followBtn.layer.cornerRadius = 17.0;
        _followBtn.layer.masksToBounds = YES;
        [_followBtn setAdjustsImageWhenHighlighted:NO];
        _followBtn.exclusiveTouch = YES;
        [_followBtn addTarget:self action:@selector(didClickedFollowBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_followBtn];
        [self updateFollowBtnStatus];
    }
    
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorCellLine;
        [self.contentView addSubview:_lineView];
    }
    
    //布局
    _iconView.sd_layout
    .leftSpaceToView(self.contentView, 15.0)
    .centerYEqualToView(self.contentView)
    .widthIs(50.0)
    .heightIs(50.0);
    
    _vipImgV.sd_layout
    .rightEqualToView(_iconView)
    .bottomEqualToView(_iconView)
    .widthIs(11).heightIs(13);
    
    _followBtn.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .widthIs(70.0)
    .heightIs(34.0);
    
    _nameLabel.sd_layout
    .topEqualToView(_iconView)
    .leftSpaceToView(_iconView, 10)
    .rightSpaceToView(_followBtn, 10)
    .heightIs(30.0);
    
    _roleIcon.sd_layout
    .leftSpaceToView(_iconView, 10)
    .topSpaceToView(_nameLabel, 0)
    .widthIs(45).heightIs(15.0);
    
    _crowIcon.sd_layout
    .leftSpaceToView(_roleIcon, 5)
    .topSpaceToView(_nameLabel, 0)
    .widthIs(15.0).heightIs(15.0);
    
    _titleLevelIcon.sd_layout
    .leftSpaceToView(_crowIcon, 5)
    .topSpaceToView(_nameLabel, 0)
    .widthIs(38).heightIs(15.0);
    
    _gameLevelIcon.sd_layout
    .leftSpaceToView(_titleLevelIcon, 5)
    .topSpaceToView(_nameLabel, 0)
    .widthIs(38).heightIs(15.0);
    
    _lineView.sd_layout
    .leftSpaceToView(self.contentView, 15.0)
    .rightSpaceToView(self.contentView, 15.0)
    .bottomEqualToView(self.contentView)
    .heightIs(0.5);
}

- (void)updateFollowBtnStatus {
    [_followBtn setTitle:_curData.is_follow ? @"已关注" : @"关注" forState:UIControlStateNormal];
    UIColor *bgColor = _curData.is_follow ? [UIColor whiteColor] : kColorMain;
    UIColor *titleColor = _curData.is_follow ? kColor999 : kColor333;
    UIColor *titleHLColor = _curData.is_follow ? kColor999 : kColor333;
    UIColor *borderColor = _curData.is_follow ? kColor999 : [UIColor clearColor];
    CGFloat borderWidth = _curData.is_follow ? 1 : 0;
    
    [_followBtn setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
    [_followBtn setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateDisabled];
    
    [_followBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [_followBtn setTitleColor:titleHLColor forState:UIControlStateHighlighted];
    
    _followBtn.layer.borderWidth = borderWidth;
    _followBtn.layer.borderColor = borderColor.CGColor;
}

- (void)didClickedFollowBtn {
    CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.followBtn.activityView.transform = transform;
    [self.followBtn startQueryAnimate];
    //_collectBtn.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    @weakify(self);
    if (_curData.is_follow) {
        //发起取消关注请求
        [UserFriendApiManager cancelFollowWithUserId:_curData.user_id fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
            @strongify(self);
            [self.followBtn stopQueryAnimate];
            if (respObj) {
                self.curData.is_follow = NO;
                [self updateFollowBtnStatus];
                if (self.didFollowRequestBlock) {
                    self.didFollowRequestBlock(NO);
                }
            }
        }];
    
    } else {
        //发起关注请求
        [UserFriendApiManager followWithUserId:_curData.user_id fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
            @strongify(self);
            [self.followBtn stopQueryAnimate];
            if (respObj) {
                self.curData.is_follow = YES;
                [self updateFollowBtnStatus];
                if (self.didFollowRequestBlock) {
                    self.didFollowRequestBlock(YES);
                }
            }
        }];
    }
}

- (void)setCurData:(CUserFriendData *)curData {
    _curData = curData;

    [_iconView jhSetImageWithURL:[NSURL URLWithString:curData.avatar] placeholder:kDefaultAvatarImage];
    
    _nameLabel.text = _curData.user_name;
    
//    if (curData.role == 1) {
//        self.vipImgV.image = [UIImage imageNamed:@"dis_appraiserVerify"];
//    } else if (curData.is_certification == 1) {
//        self.vipImgV.image = [UIImage imageNamed:@"dis_providerVerify"];
//    } else {
//        self.vipImgV.image = nil;
//    }
    self.vipImgV.image = nil;

    
    //认证鉴定师
    if ([curData.role_icon isNotBlank]) {
        _roleIcon.sd_resetLayout
        .leftSpaceToView(_iconView, 10).topSpaceToView(_nameLabel, 0).widthIs(45).heightIs(15.0);
    } else {
        _roleIcon.sd_resetLayout
        .leftSpaceToView(_iconView, 10).widthIs(0);
    }
    JH_WEAK(self)
    [_roleIcon jhSetImageWithURL:[NSURL URLWithString:curData.role_icon] placeholder:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        if (image) {
            self.roleIcon.sd_layout.widthIs(image.size.width / image.size.height * 15);
            [self.roleIcon updateLayout];
        }
    }];
    [_titleLevelIcon jhSetImageWithURL:[NSURL URLWithString:curData.title_level_icon]];
    [_gameLevelIcon jhSetImageWithURL:[NSURL URLWithString:curData.game_level_icon]];
    
    if ([curData.userTycoonLevelIcon isNotBlank]) {
        [_crowIcon jhSetImageWithURL:[NSURL URLWithString:curData.userTycoonLevelIcon]];
        _crowIcon.sd_layout
        .leftSpaceToView(_roleIcon, 5).topSpaceToView(_nameLabel, 0).widthIs(15).heightIs(15.0);
    } else {
        _crowIcon.sd_layout.leftSpaceToView(_roleIcon, 0).widthIs(0);
    }
    
    //称号等级
    if ([curData.title_level_icon isNotBlank]) {
        _titleLevelIcon.sd_resetLayout
        .leftSpaceToView(_crowIcon, 5).topSpaceToView(_nameLabel, 0).widthIs(38).heightIs(15.0);
    } else {
        _titleLevelIcon.sd_resetLayout.leftSpaceToView(_crowIcon, 0).widthIs(0);
    }
    
    //勋章
    if ([curData.game_level_icon isNotBlank]) {
        _gameLevelIcon.sd_resetLayout
        .leftSpaceToView(_titleLevelIcon, 5).topSpaceToView(_nameLabel, 0).widthIs(38).heightIs(15.0);
    } else {
        _gameLevelIcon.sd_resetLayout.leftSpaceToView(_titleLevelIcon, 0).widthIs(0);
    }
    
    if ([[UserInfoRequestManager sharedInstance].user.customerId isEqualToString:@(_curData.user_id).stringValue]) {
        _followBtn.hidden = YES;
    }
    else {
        _followBtn.hidden = NO;
        [self updateFollowBtnStatus];
    }
}

@end
