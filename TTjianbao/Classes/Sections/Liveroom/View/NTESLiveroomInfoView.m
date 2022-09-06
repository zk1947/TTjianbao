//
//  NTESLiveroomInfoView.m
//  TTjianbao
//
//  Created by chris on 16/4/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveroomInfoView.h"

#import "NTESLiveManager.h"
#import "NTESDataManager.h"
#import "UIView+NTES.h"
#import "JHLiveEndPageView.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"
#import "JHGrowingIO.h"

#import "UIImageView+JHWebImage.h"
#import "UIView+JHGradient.h"

@interface NTESLiveroomInfoView()



@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *countLabel;

@property (nonatomic,assign) NSInteger isAssistant;//是否助理

@property (nonatomic, strong) NSString * anchorID;
@end

@implementation NTESLiveroomInfoView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat nameW = [self getNameWidthWithLabel:_nameLabel];
    CGFloat countW = [self getNameWidthWithLabel:_countLabel];
    if (nameW<countW) {
        CGFloat ww = countW-nameW;
        [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_trailing).offset(5+ww);
        }];
    }else {
        [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.nameLabel.mas_trailing).offset(5);
        }];

    }
    
    [self layoutIfNeeded];
    
    self.width = self.careBtn.right+10;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImage imageNamed:@"bg_live_info_gray"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
        [self addSubview:self.avatar];
        [self addSubview:self.platImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.countLabel];
        [self addSubview:self.careBtn];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressAvatar)]];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatus:) name:NotificationNameFollowStatus object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redpacketFollow) name:NotificationNameredpacketFollow object:nil];
        
        [self makeLayout];
        
        
    }
    return self;
}

-(void)redpacketFollow
{
    self.careBtn.selected = YES;
}

- (void)refreshWithChatroom:(NIMChatroom *)chatroom
{

}


- (void)refreshWithChannel:(ChannelMode *)channel{
    self.isOpenFansClub = channel.isOpen;
    self.isjoinFansClub = channel.joinFlag;
    self.nameLabel.text = channel.anchorName;
    self.isAssistant = channel.isAssistant;
    self.anchorID = channel.anchorId;
    [self.avatar jhSetImageWithURL:[NSURL URLWithString:channel.anchorIcon] placeholder:kDefaultAvatarImage];
    self.avatar.userInteractionEnabled = YES;
    
    if ([channel.status integerValue]==2) {
         self.countLabel.text = [NSString stringWithFormat:@"%zd热度",channel.watchTotal] ;
    }
    else{
          self.countLabel.text = [NSString stringWithFormat:@"%zd热度",channel.watchTotal] ;
    }
    [self updateStatus:channel.isFollow];
    
    [self layoutIfNeeded];
}

- (void)makeLayout
{
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.equalTo(@30);
        make.leading.equalTo(self).offset(5);
    }];
    
    [self.platImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(self.avatar);
        
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-6);
        make.leading.equalTo(self.avatar.mas_trailing).offset(5);
        make.width.greaterThanOrEqualTo(@(20));
        make.width.lessThanOrEqualTo (@125);
        
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(9);
        make.leading.equalTo(self.avatar.mas_trailing).offset(5);
        
        make.width.greaterThanOrEqualTo(@(20));
        
    }];
    
    [_careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self);
//        make.trailing.equalTo(self).offset(-9);
        make.height.equalTo(@26);
        make.width.equalTo(@45);
    }];
        
}

#pragma mark - Get

- (UIImageView *)platImage {
    if (!_platImage) {
        _platImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_right_yellow_tm"]];
    }
    
    return _platImage;
}

- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 31, 31)];
        _avatar.layer.cornerRadius = 15.5;
        _avatar.layer.masksToBounds = YES;
    }
    return _avatar;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = HEXCOLOR(0xffffff);
        _nameLabel.font = [UIFont systemFontOfSize:12.f];
        
        _nameLabel.shadowColor = HEXCOLOR(0x666666);
        _nameLabel.shadowOffset = CGSizeMake(0, 0);
    }
    return _nameLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLabel.textColor = HEXCOLOR(0xffffff);
        _countLabel.font = [UIFont systemFontOfSize:10.f];
        _countLabel.text = @"0人";
        _countLabel.shadowColor = HEXCOLOR(0x666666);
        _countLabel.shadowOffset = CGSizeMake(0, 0);
    }
    return _countLabel;
}

- (UIButton *)careBtn {
    if (!_careBtn) {
        _careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _careBtn.backgroundColor = [UIColor clearColor];
        _careBtn.layer.cornerRadius = 12;
        _careBtn.layer.masksToBounds = YES;
        [_careBtn setTitle:@"关注" forState:UIControlStateNormal];
        
        [_careBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        
        [_careBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _careBtn.titleLabel.font = JHFont(12);
        [_careBtn addTarget:self action:@selector(careOffAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _careBtn;
}

- (CGFloat)avatarAndNickSpacing
{
    return 5.f;
}

- (CGFloat)nickAndCountSpacing
{
    return 1.0f;
}

- (CGFloat)nickRightMargin
{
    return 18.f;
}

- (CGFloat)nickTopMargin
{
    return 2.f;
}

- (void)careOffAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(didPressCareOffButton:)]) {
        [self.delegate didPressCareOffButton:btn];
    }
    
    [JHGrowingIO trackEventId:JHTracklive_info_attention variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];

}
//头像点击
- (void)didPressAvatar {
    if (_delegate && [_delegate respondsToSelector:@selector(didPressAnchorAvatar:)]) {
        [self.superview endEditing:YES];
        [self.delegate didPressAnchorAvatar:nil];
    }
    [JHGrowingIO trackEventId:JHTracklive_anchorinfo_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];

}

- (void)updateStatus:(NSInteger)isfollow{
    if ([[UserInfoRequestManager sharedInstance].user.customerId isEqualToString:self.anchorID]) { //主播端
        if (self.isOpenFansClub) {
            [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@45.);
            }];
            [_careBtn jh_setGradientBackgroundWithColors:nil locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            [_careBtn setImage:[UIImage imageNamed:@"fansJoined_anchorbg"] forState:UIControlStateNormal];
            [_careBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
            [self hiddenCareBtn];
        }
        
    }else if(self.isAssistant){//助理端
        if (isfollow == 1) {
            if (self.isOpenFansClub) {
                _careBtn.alpha = 1;
                [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@45.);
                }];
                
                [_careBtn jh_setGradientBackgroundWithColors:nil locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
                [_careBtn setImage:[UIImage imageNamed:@"fansJoined_anchorbg"] forState:UIControlStateNormal];
                [_careBtn setTitle:@"" forState:UIControlStateNormal];
                
            }else{
                _careBtn.alpha = 0.;
                [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0.);
                }];
            }
            
            [self layoutIfNeeded];
            
        }
        else {
            [_careBtn setTitle:@"关注" forState:UIControlStateNormal];
            [_careBtn setImage:nil forState:UIControlStateNormal];
            [_careBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@45.);
            }];
            _careBtn.alpha = 1;
            [self layoutIfNeeded];
        }
    }else{//用户端
        if (isfollow == 1) {
            if (self.isOpenFansClub) {
                _careBtn.alpha = 1;
                [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@45.);
                }];
                
                [_careBtn jh_setGradientBackgroundWithColors:nil locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
                if (self.isjoinFansClub) {
                    [_careBtn setImage:[UIImage imageNamed:@"fansJoined_bg"] forState:UIControlStateNormal];
                }else{
                    [_careBtn setImage:[UIImage imageNamed:@"fansEnter_bg"] forState:UIControlStateNormal];
                }
                [_careBtn setTitle:@"" forState:UIControlStateNormal];
                
            }else{
                _careBtn.alpha = 0.;
                [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@0.);
                }];
            }
            
            [self layoutIfNeeded];
            
        }
        else {
            [_careBtn setTitle:@"关注" forState:UIControlStateNormal];
            [_careBtn setImage:nil forState:UIControlStateNormal];
            [_careBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@45.);
            }];
            _careBtn.alpha = 1;
            [self layoutIfNeeded];
        }
    }
    
    CGFloat right = self.right;
    CGFloat ox = ScreenW - (50+45+10+5+40+5);
    if (right>ox) {
        CGFloat nameWidth = _nameLabel.width;
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(nameWidth-(right-ox)));
        }];
    }
}

- (void)hiddenCareBtn {
    [_careBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0.);
    }];
    [self layoutIfNeeded];
    
}

- (CGFloat)getNameWidthWithLabel:(UILabel *)label {
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(125,20) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes: @{NSFontAttributeName:label.font} context:nil].size;
    if (size.width<20) {
        return 20;
    }
    return size.width;

}

- (CGFloat)getCountWidthWithLabel:(UILabel *)label {
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT,20) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes: @{NSFontAttributeName:label.font} context:nil].size;
    if (size.width<20) {
        return 20;
    }

    return size.width;
    
}
@end
