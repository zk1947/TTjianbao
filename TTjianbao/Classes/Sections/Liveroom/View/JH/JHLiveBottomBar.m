//
//  JHLiveBottomBar.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/10.
//  Copyright © 2018年 Netease. All rights reserved.
//
#import "JHShopwindowRequest.h"
#import "JHWebViewController.h"
#import "JHLiveRoomSheetMoreView.h"
#import "JHLiveStoreView.h"
#import "JHLiveBottomBar.h"
#import "UMengManager.h"
#import "JHQYChatManage.h"
#import "UIView+NTES.h"
#import "JHDoteNumberLabel.h"
#import "TTjianbaoBussiness.h"
#import "JHNimNotificationManager.h"
#import "JHDotButtonView.h"
#import "JHUIFactory.h"
#import "UIImage+JHColor.h"
#import "JHIMEntranceManager.h"
@interface JHLiveBottomBar ()

@property (weak, nonatomic) IBOutlet UIButton *helperBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helperBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appraiseBtnWidth;
@property (weak, nonatomic) IBOutlet JHDoteNumberLabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTrailingWidth;
@property (weak, nonatomic) IBOutlet UIImageView *helperImage;
@property (weak, nonatomic) IBOutlet JHDoteNumberLabel *doteLabel;
//去掉未读数 不链接xib

@property (strong, nonatomic) JHDoteNumberLabel *chatNumLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareToGiftWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sayWhatBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listBtnTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBtnTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sayWhateBtnLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeBtnTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likeBtnCountTop;


@property (weak, nonatomic) IBOutlet UIButton *appraiseQueue;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UIButton *likeCountBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftToAppraiseBtnWidth;
@property (weak, nonatomic) IBOutlet JHDoteNumberLabel *clamOderNum;
@property (weak, nonatomic) IBOutlet UIButton *clamOrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *chatLabel;

@property (weak, nonatomic) IBOutlet UIButton *auctionBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *auctionToChatWidth;

@property (weak, nonatomic) IBOutlet UIButton *sendRedPacketBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendRedToChatWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helperBtnTrailing;

@property (nonatomic, weak) UIButton *moreButton;
@property (nonatomic, weak) UIButton *publishIdleButton;//发布闲置
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftBtnTrailing;

@property (nonatomic, assign) BOOL auctionHidden;

@property (nonatomic, strong) UIButton *quickReplyBtn;
@property(nonatomic,strong)CAGradientLayer *gradientLayer;


@property (nonatomic, strong) UIButton *shanGouBtn;

@end


@implementation JHLiveBottomBar


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenBtn) name:@"NotificationNameHiddenAppraiseBtn" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderNumber) name:@"NotificationNameUpdateOrderNumber" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChatNum:) name:NotificationNameChatUnreadCountChanged object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopwindowNotificationNum:) name:@"shopwindowNotificationNum" object:nil];
    
    self.hidden = YES;
   
    
    [self.likeCountBtn jh_cornerRadius:5.5];
    [self.sayWhateBtn addSubview:self.quickReplyBtn];
    [self.quickReplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sayWhateBtn);
        make.right.equalTo(self.sayWhateBtn).offset(-5);
        make.size.mas_equalTo(CGSizeMake(38, 24));
    }];
//    self.sayWhateBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.sayWhateBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    self.customizeButtonType = JHLiveButtonStyleNormal;
}

- (void) hiddenBtn {
    self.appraiseBtnWidth.constant = 0;
}
#pragma mark - setter

- (void)setChannel:(ChannelMode *)channel
{
    _channel = channel;
    [JHShopwindowRequest requestshopwindowNumWithId:self.channel.channelLocalId successBlock:^(NSString * _Nonnull text) {
        NSInteger num = [text integerValue];
         self.shopwindowButtonNum = text;
        [self shopwindowButtonHidden];
        if(num > 0)
        {
            text = [NSString stringWithFormat:@"%@",@(num)];
        }
        else
        {
            text = @"购";
        }
        [self.shopwindowButton setAttributedTitle:[JHLiveBottomBar getShadowWithText:text] forState:UIControlStateNormal];
       
    }];
}

- (void)setRoleType:(JHLiveRole)roleType {
    _roleType = roleType;
    if (roleType == JHLiveRoleAnchor || roleType == JHLiveRoleSaleAnchor) {
        /// 鉴定主播，卖货主播显示说点什么
        [self.sayWhateBtn setTitle:@"说点什么" forState:UIControlStateNormal];
    } else {
        [self.sayWhateBtn setTitle:@"跟主播聊点什么" forState:UIControlStateNormal];
    }
    self.sayWhateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    self.sayWhatBtnWidth.constant = 109;
    self.sayWhateBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.orderBtn.hidden = YES;
    self.doteLabel.hidden = YES;
    _appraiseBtn.hidden = NO;
    
    self.giftToAppraiseBtnWidth.constant = 10;
    self.clamOderNum.hidden = YES;
    self.clamOrderBtn.hidden = YES;
    self.pauseActionBtn.hidden = YES;
    
    self.shareToGiftWidth.constant = 10;
    _numLabel.hidden = YES;
    _listBtn.hidden = NO;
    self.quickReplyBtn.hidden = YES;
    
    
    if(roleType == JHLiveRoleCustomizeAndience || roleType == JHLiveRoleCustomizeHelper){//定制观众
        [self.sayWhateBtn setTitle:@"与主播沟通" forState:UIControlStateNormal];
        self.shopwindowButton.hidden = NO;
        _sayWhateBtnLeading.constant = 52;
        self.sayWhatBtnWidth.constant = 90;
        self.appraiseQueue.hidden = YES;
        self.likeBtn.hidden = NO;
        self.likeCountBtn.hidden = NO;
        self.likeBtnCountTop.constant = 0;
        _shareBtnTrailing.constant = 54;
        self.helperBtn.hidden = YES;
        self.auctionToChatWidth.constant = 10;
    
        _giftBtn.hidden = YES;
        _helperImage.hidden = NO;
        _chatLabel.hidden = YES;
        
        if(!_moreButton)
        {
            _moreButton = [UIButton jh_buttonWithImage:@"live_room_more" target:self action:@selector(moreMethod:) addToSuperView:self];
            [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.shareBtn.mas_left).offset(-8);
                make.width.height.bottom.equalTo(self.shareBtn);
            }];
        }
        
        self.sendRedPacketBtn.hidden = YES;
        [_appraiseBtn setTitle:@"连麦定制" forState:UIControlStateNormal];
        self.appraiseBtnWidth.constant = 75;
        self.toTrailingWidth.constant = 145;
        [self updateCustomizeButtonStyle:self.customizeButtonType];
        [_appraiseBtn setBackgroundImage:[UIImage gradientThemeImageSize:CGSizeMake(75, 38) radius:19] forState:UIControlStateNormal];
        _appraiseBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _appraiseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }else if(roleType == JHLiveRoleRecycleAndience){//回收
        [self.sayWhateBtn setTitle:@"与主播沟通" forState:UIControlStateNormal];
        _appraiseBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        _appraiseBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _appraiseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.sayWhatBtnWidth.constant = 90;
        _appraiseBtnWidth.constant = 75;
        _toTrailingWidth.constant = 144;
        [_appraiseBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _appraiseBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _helperBtn.hidden = YES;
        _helperImage.hidden = YES;
        _chatLabel.hidden = YES;
        _chatNumLabel.hidden = YES;
        _shareBtn.hidden = YES;
        _giftBtn.hidden = YES;
        [_appraiseBtn setBackgroundImage:[UIImage gradientThemeImageSize:CGSizeMake(80, 38) radius:19] forState:UIControlStateNormal];
        [_appraiseBtn setTitle:@"申请连麦" forState:UIControlStateNormal];
        _appraiseBtn.enabled = YES;
        self.likeBtn.hidden = NO;
        self.likeCountBtn.hidden = NO;
        if(!_moreButton)
        {
            _moreButton = [UIButton jh_buttonWithImage:@"live_room_more" target:self action:@selector(moreMethod:) addToSuperView:self];
            [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.likeBtn.mas_left).offset(-8);
                make.width.height.bottom.equalTo(self.likeBtn);
            }];
        }
        if(!_publishIdleButton)
        {
            _publishIdleButton = [UIButton jh_buttonWithImage:@"live_room_publishidle" target:self action:@selector(publishIdleMethod:) addToSuperView:self];
            [_publishIdleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.moreButton.mas_left).offset(-8);
                make.width.height.bottom.equalTo(self.likeBtn);
            }];
        }
        if (self.hasShanGou) {
            [self addSubview:self.shanGouBtn];
            [self.shanGouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(@0);
                make.right.equalTo(self.listBtn.mas_left).offset(-10);
                make.size.mas_equalTo(CGSizeMake(38, 38));
            }];
        }

    }else if (roleType == JHLiveRoleAnchor ) {//鉴定主播
        if(self.isResaleRoom)return;

        _listBtnTrailing.constant = 63;
        _appraiseBtnWidth.constant = 37;
        _shareBtnTrailing.constant = 161;
        _sayWhateBtnLeading.constant = 12;
        _appraiseBtn.hidden = YES;
        self.shopwindowButton.hidden = YES;
        
        _giftBtnWidth.constant = 0;
        _shareToGiftWidth.constant = 0;
        
        _helperBtnWidth.constant = 0;
        _helperImage.hidden = YES;
        _chatLabel.hidden = YES;
        
        _toTrailingWidth.constant = 15;
        self.likeBtn.hidden = YES;
        self.likeCountBtn.hidden = YES;
        self.giftToAppraiseBtnWidth.constant = 104;
        //        self.clamOderNum.hidden = NO;
        self.clamOrderBtn.hidden = YES;
        self.pauseActionBtn.hidden = NO;
        self.appraiseQueue.hidden = NO;
        self.shareBtn.hidden = NO;
        
        self.sendRedPacketBtn.hidden = YES;
        self.listBtn.hidden = YES;
        self.orderBtn.hidden = NO;
        self.doteLabel.hidden = YES;//暂时全部隐藏,后续补充逻辑(不知为什么更新逻辑被删掉了)NO;
        [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-59);
            make.centerY.equalTo(self);
            make.height.equalTo(@37);
            make.width.equalTo(@37);
            
        }];
        [self updateShareBtn];
        
        
    } else if (_roleType<JHLiveRoleSaleAnchor){//鉴定观众 连麦 申请连麦
        _numLabel.hidden = YES;
        [self.sayWhateBtn setTitle:@"跟主播聊点什么" forState:UIControlStateNormal];
        _appraiseBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        _appraiseBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _appraiseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _appraiseBtnWidth.constant = 80;
        [_appraiseBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _appraiseBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _giftBtnWidth.constant = 37;
        _giftBtnTrailing.constant = 199;
        _helperBtnWidth.constant = -10;
        _helperImage.hidden = YES;
        _chatLabel.hidden = YES;
        _chatNumLabel.hidden = YES;
        [_appraiseBtn setBackgroundImage:[UIImage gradientThemeImageSize:CGSizeMake(80, 38) radius:19] forState:UIControlStateNormal];
        
        if (roleType == JHLiveRoleAudience) {
            [_appraiseBtn setTitle:@"申请鉴定" forState:UIControlStateNormal];
            _appraiseBtn.enabled = YES;
            _shareBtnTrailing.constant = 152;
            [self updateLikeBtn];
            [self updateShareBtn];
            if (_shopwindowButton) {
                self.shopwindowButton.hidden = YES;
            }
            
        } else  if (roleType == JHLiveRoleLinker){
            
            [_appraiseBtn setTitle:@"鉴定中" forState:UIControlStateNormal];
            _appraiseBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            _appraiseBtn.enabled = YES;
        }else if (roleType == JHLiveRoleApplication) {
            [self updateAppraiseButtonNum:JHLiveRoleApplication];
        }
        
    }else {//卖货
        

        _giftToAppraiseBtnWidth.constant = 0;
        self.auctionBtn.hidden = NO;
        _auctionHidden = NO;
        _numLabel.hidden = YES;
        self.sendRedPacketBtn.hidden = NO;
        
        if (_roleType == JHLiveRoleSaleAnchor || _roleType == JHLiveRoleSaleHelper) {//卖货主播和助理
            if(self.isResaleRoom)return;
            self.auctionToChatWidth.constant = 57;
            self.helperBtnWidth.constant = 37;
            self.appraiseBtnWidth.constant = 0;
            self.giftBtnWidth.constant = 0;
            self.shareToGiftWidth.constant = 0;
            self.toTrailingWidth.constant = 0;
            _toTrailingWidth.constant = 15;
            
            _orderBtn.hidden = YES;
            _auctionBtn.hidden = YES;
            _auctionHidden = YES;
            _sendRedPacketBtn.hidden = YES;
            _helperBtn.hidden = YES;
            _chatLabel.hidden = YES;
            _chatNumLabel.hidden = YES;
            _helperImage.hidden = YES;
            
            [self updateNewShareBtn];
            if(_roleType == JHLiveRoleSaleAnchor)
            {
                _likeBtn.hidden = YES;
                self.likeCountBtn.hidden = YES;
                _shareBtnTrailing.constant = 15;
                _listBtnTrailing.constant = 63;
                _auctionBtn.hidden = YES;
                _auctionHidden = YES;
            }else if(_roleType == JHLiveRoleSaleHelper)
            {
                _likeBtn.hidden = NO;
                [self.likeBtn setImage:[UIImage imageNamed:@"live_room_praise"] forState:UIControlStateNormal];
                
                self.likeCountBtn.hidden = NO;
                self.likeBtnCountTop.constant = 0;
                [self.gradientLayer removeFromSuperlayer];
                _likeBtnTrailing.constant = 15;
                _shareBtnTrailing.constant = 63;
                _listBtnTrailing.constant = 115;
                
            }
//            self.shopwindowButton.hidden = NO;
            if (self.hasShanGou) {
                [self addSubview:self.shanGouBtn];
                [self.shanGouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(@0);
                    make.right.equalTo(self.listBtn.mas_left).offset(-10);
                    make.size.mas_equalTo(CGSizeMake(38, 38));
                }];
            }
        }else {
            
            [self.sayWhateBtn setTitle:@"向主播询价" forState:UIControlStateNormal];
            self.auctionToChatWidth.constant = 10;
            _helperBtnWidth.constant = 37;

            _helperImage.hidden = NO;
            _chatLabel.hidden = YES;
            
            self.orderBtn.hidden = YES;
            self.doteLabel.hidden = YES;
            
            self.appraiseBtnWidth.constant = 0;
            self.toTrailingWidth.constant = 62;
            self.likeBtn.hidden = NO;
            self.likeCountBtn.hidden = NO;
            self.likeBtnCountTop.constant = 0;
            [self.gradientLayer removeFromSuperlayer];
            
            if (_roleType == JHLiveRoleSaleAndience) {
                self.giftBtnWidth.constant = 0;
                self.shareToGiftWidth.constant = 0;
                if (![self.channel.channelCategory isEqualToString:@"restoreStone"]) {
                    //normal("常规直播间"),roughOrder("原石直播间")  常规 跟 原石观众显示快捷回复
                    self.quickReplyBtn.hidden = NO;
                    self.sayWhatBtnWidth.constant = 123;
                    self.sayWhateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 40);
                }
                
            }
        }
        
    }
    
    NSInteger num = [JHQYChatManage  unreadMessage];
    _chatNumLabel.text = @(num).stringValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameChatUnreadCountChanged object:@(num)];
    self.hidden = NO;
    self.hidden = self.isBackLook;
    self.auctionBtn.hidden = YES;
    _auctionHidden = YES;
    [self setSendRedPacket];
    
    if(_roleType == JHLiveRoleSaleAnchor || _roleType == JHLiveRoleSaleHelper || _roleType == JHLiveRoleSaleAndience)
    {
        [self shopwindowButton];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.appraiseQueue removeFromSuperview];
        });
        if(_roleType == JHLiveRoleSaleAndience )
        {
            if (self.channel.isAssistant) {
                return;
            }
            if (![self.channel.channelCategory isEqualToString: @"restoreStone"] ) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.sendRedPacketBtn removeFromSuperview];
                    [self.auctionBtn removeFromSuperview];
                });
            }
            [self updateNewShareBtn];
            [self.likeBtn setImage:[UIImage imageNamed:@"live_room_praise"] forState:UIControlStateNormal];
//            self.shopwindowButton.hidden = NO;
            _shareBtnTrailing.constant = 59;
            self.helperBtnTrailing.constant = 108;
            if(!_moreButton)
            {
                _moreButton = [UIButton jh_buttonWithImage:@"live_room_more" target:self action:@selector(moreMethod:) addToSuperView:self];
                [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.helperBtn.mas_left).offset(-12);
                    make.width.height.bottom.equalTo(self.helperBtn);
                }];
            }
        }
        if ([self.channel.channelCategory isEqualToString: @"restoreStone"] &&  _roleType == JHLiveRoleSaleAndience) {
            
            [self.sayWhateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
            }];
            self.moreButton.hidden = YES;
            self.sendRedPacketBtn.hidden = NO;
            self.shopwindowButton.hidden = YES;
        }
        else
        {
            [self.sayWhateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(55);
            }];
        }
    }
    
//    if(_moreButton && !_moreButton.isHidden)
//    {
//        self.helperBtnWidth.constant = 0;
//        self.helperImage.hidden = YES;
//    }
    self.likeCountBtn.hidden = self.likeBtn.isHidden;
}



-(void)shopwindowButtonHidden{
    if (_roleType == JHLiveRoleCustomizeAndience || _roleType == JHLiveRoleRecycleAndience) {
        if ([self.shopwindowButtonNum integerValue]<=0) {
            [self.sayWhateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(10);
            }];
            self.shopwindowButton.hidden = YES;
        }else{
            self.shopwindowButton.hidden = NO;
            [self.sayWhateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(52);
            }];
        }
    }
    else if(_roleType == JHLiveRoleSaleAndience)
    {
        
        if ([self.channel.channelCategory isEqualToString: @"roughOrder"] || (_shopwindowButton &&  _roleType == JHLiveRoleSaleAndience && [self.shopwindowButtonNum integerValue]<=0)) {
            
            [self.sayWhateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
            }];
            self.shopwindowButton.hidden = YES;
        }
        else
        {
            self.shopwindowButton.hidden = NO;
            [self.sayWhateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(55);
            }];
        }
    }else{
        if ((_roleType == JHLiveRoleSaleAnchor || _roleType == JHLiveRoleSaleHelper) && ![self.channel.channelCategory isEqualToString: @"restoreStone"] && ![self.channel.channelCategory isEqualToString: @"roughOrder"]){
            self.shopwindowButton.hidden = NO;
            [self.sayWhateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(55);
            }];
        }else{
            [self.sayWhateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
            }];
            self.shopwindowButton.hidden = YES;
        }
    }
    
}
-(void)publishIdleMethod:(UIButton *)sender{
    //发布闲置
    if (_delegate && [_delegate respondsToSelector:@selector(publishIdleMethodAction)]) {
            [_delegate publishIdleMethodAction];
        }
    [self sa_trackingWithOther_name:@"releaseIdle"];
}
-(void)moreMethod:(UIButton *)sender
{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    CurrentAudienceType type = CurrentAudienceTypeNormal;
    if (_roleType == JHLiveRoleCustomizeAndience) {
        type = CurrentAudienceTypeCustom;
    }else if(_roleType == JHLiveRoleRecycleAndience){
        type = CurrentAudienceTypeRecycle;
        [self sa_trackingWithOther_name:@"more"];
    }
    [JHLiveRoomSheetMoreView showSheetViewWithAuctionHidden:_auctionHidden isCustomizeAudience:type text:@"" block:^(NSInteger index) {
        switch (index) {
            case 0: {
                [self auctionAction:self.moreButton];
            }
                break;
                
            case 1: {
                [self sendRedPacketAction:self.sendRedPacketBtn];
            }
                break;
                
            case 2: {
                JHWebViewController *webVC = [JHWebViewController new];
                webVC.titleString = @"举报";
                NSString *url = H5_BASE_HTTP_STRING(@"/jianhuo/app/report.html?");
                url = [url stringByAppendingFormat:@"rep_source=6&rep_obj_id=%@&live_user_id=%@",self.channel.channelId, self.channel.anchorId];
                webVC.urlString = url;
                [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
            }
                break;
                
            case 3: {
                [self chatHelperAction:self.helperBtn];
            }
                break;
            case 4: {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
            }
                break;
            case 5:{
                [self shareAction:nil];
            }
            default:
                break;
        }
    }];
}
- (void)updateCustomizeButtonStyle:(JHLiveButtonStyle)customizeType{
    self.customizeButtonType = customizeType;
    if (customizeType == JHLiveButtonStyleNormal) {
        [_appraiseBtn setTitle:@"连麦定制" forState:UIControlStateNormal];
        _appraiseBtn.enabled = YES;
    }else if(customizeType == JHLiveButtonStyleWaitQueue){
        int waitNum = [JHNimNotificationManager sharedManager].customizeWaitMode.waitCount;
        [_appraiseBtn setTitle:[NSString stringWithFormat:@"第%d位\n排队中", waitNum] forState:UIControlStateNormal];
        [_appraiseBtn.titleLabel setFont:JHMediumFont(13)];
        {// 富文本
            NSString *text = _appraiseBtn.titleLabel.text;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
            //获取要修改的文字范围
            NSRange foundRange = [text rangeOfString:@"排队中"];
            //字体样式
            [attrString addAttribute:NSFontAttributeName value:JHFont(10) range:foundRange];
            //重新赋值
            _appraiseBtn.titleLabel.attributedText = attrString;
        }
        _appraiseBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _appraiseBtn.enabled = YES;
    }else if(customizeType == JHLiveButtonStylePause){
        [_appraiseBtn setTitle:@"暂停连麦" forState:UIControlStateNormal];
        _appraiseBtn.enabled = NO;
    }else if(customizeType == JHLiveButtonStyleLinker){
        [_appraiseBtn setTitle:@"定制中" forState:UIControlStateNormal];
        _appraiseBtn.enabled = NO;
    }
}
- (void)updateRecycleButtonStyle:(JHLiveButtonStyle)customizeType{
    self.customizeButtonType = customizeType;
    if (customizeType == JHLiveButtonStyleNormal) {
        [_appraiseBtn setTitle:@"申请连麦" forState:UIControlStateNormal];
        _appraiseBtn.enabled = YES;
    }else if(customizeType == JHLiveButtonStyleWaitQueue){
        int waitNum = [JHNimNotificationManager sharedManager].recycleWaitMode.waitCount;
        [_appraiseBtn setTitle:[NSString stringWithFormat:@"第%d位\n排队中", waitNum] forState:UIControlStateNormal];
        [_appraiseBtn.titleLabel setFont:JHMediumFont(13)];
        {// 富文本
            NSString *text = _appraiseBtn.titleLabel.text;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
            //获取要修改的文字范围
            NSRange foundRange = [text rangeOfString:@"排队中"];
            //字体样式
            [attrString addAttribute:NSFontAttributeName value:JHFont(10) range:foundRange];
            //重新赋值
            _appraiseBtn.titleLabel.attributedText = attrString;
        }
        _appraiseBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _appraiseBtn.enabled = YES;
    }else if(customizeType == JHLiveButtonStylePause){
        [_appraiseBtn setTitle:@"暂停连麦" forState:UIControlStateNormal];
        _appraiseBtn.enabled = NO;
    }else if(customizeType == JHLiveButtonStyleLinker){
        [_appraiseBtn setTitle:@"连麦中" forState:UIControlStateNormal];
        _appraiseBtn.enabled = NO;
    }
}
- (void)updateAppraiseButtonNum:(JHLiveRole)roleType{
    if (roleType == JHLiveRoleApplication)
    {
        int waitNum = [JHNimNotificationManager sharedManager].micWaitMode.waitCount;
        [_appraiseBtn setTitle:[NSString stringWithFormat:@"第%d位\n鉴定排队中", waitNum] forState:UIControlStateNormal];
        [_appraiseBtn.titleLabel setFont:JHMediumFont(13)];
        {// 富文本
            NSString *text = _appraiseBtn.titleLabel.text;
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
            //获取要修改的文字范围
            NSRange foundRange = [text rangeOfString:@"鉴定排队中"];
            //字体样式
            [attrString addAttribute:NSFontAttributeName value:JHFont(10) range:foundRange];
            //重新赋值
            _appraiseBtn.titleLabel.attributedText = attrString;
        }
        _appraiseBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _appraiseBtn.enabled = YES;
        
    }
}

- (void)setCanAuction:(NSInteger)canAuction {
    _canAuction = canAuction;
    self.auctionBtn.hidden = !canAuction;
    _auctionHidden = !canAuction;
    if(self.isResaleRoom)
    {
        self.auctionBtn.hidden = YES;
        _auctionHidden = YES;
        _canAuction = NO;
    }
    
    [self setSendRedPacket];
}

- (void)setSendRedPacket {
    if (_roleType == JHLiveRoleSaleAnchor || _roleType == JHLiveRoleSaleHelper) {//卖货主播和助理
        if (self.isResaleRoom) {
            self.sendRedToChatWidth.constant = 104;
        } else {
            self.sendRedToChatWidth.constant = 104 - (self.canAuction?0:47);
        }
    }else if (_roleType == JHLiveRoleSaleAndience){
        self.sendRedToChatWidth.constant = 57 - (self.canAuction?0:47);
    }
}
#pragma mark - action

- (IBAction)auctionAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(popAuctionListAction:)]) {
        [_delegate popAuctionListAction:sender];
    }
    
}
- (IBAction)popInputBarAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(popInputBarAction)]) {
        [_delegate popInputBarAction];
    }
}

- (IBAction)moreAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(moreAction)]) {
        [_delegate moreAction];
    }
    
}
// 直播间-更多功能-在线客服
- (IBAction)chatHelperAction:(id)sender {
    _chatNumLabel.hidden = YES;
    
    if (self.roleType == JHLiveRoleSaleAndience) {
        if ([self.delegate respondsToSelector:@selector(onAndienceTapChat)]) {
            [self.delegate onAndienceTapChat];
        }
    }else {
        if ([self.chatLabel.text isEqualToString:@"联系商家"]) {
//            [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self.viewController anchorId:self.self.channel.anchorId];
            [JHIMEntranceManager pushSessionWithUserId:self.channel.anchorId sourceType:JHIMSourceTypeLive];
        } else {
//            [JHIMEntranceManager pushSessionWithUserId:self.channel.anchorId sourceType:JHIMSourceTypeLive isBusiness:true];
            [[JHQYChatManage shareInstance] showChatWithViewcontroller:self.viewController];
        }
    }
    
    [JHGrowingIO trackEventId:JHTracklive_bottom_kefu variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    
    
}

- (void)updateChatNum:(NSNotification *)noti {
    if (self.roleType >= JHLiveRoleSaleAnchor) {
        NSInteger num = [noti.object integerValue];
        _chatNumLabel.text = @(num).stringValue;
        if (!_helperImage.hidden) {
            if (num == 0) {
                _chatNumLabel.hidden = YES;
            }else {
                _chatNumLabel.hidden = NO;
            }
            
        }
        
    }else {
        _chatNumLabel.hidden = YES;
    }
}

-(void)shopwindowNotificationNum:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.shopwindowButton setAttributedTitle:[JHLiveBottomBar getShadowWithText:[NSString stringWithFormat:@"%@",noti.object]] forState:UIControlStateNormal];
        self.shopwindowButtonNum = noti.object;
        [self shopwindowButtonHidden];
    });
}


- (IBAction)shareAction:(id)sender {
    [JHGrowingIO trackEventId:JHTracklive_bottom_sharebtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(shareAction)]) {
        [_delegate shareAction];
    }
}

- (IBAction)popGiftAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(popGiftAction)]) {
        [_delegate popGiftAction];
    }
    [JHGrowingIO trackEventId:JHTracklive_bottom_giftbtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    return;
    switch (_roleType) {
        case JHLiveRoleAudience:
            if (_delegate && [_delegate respondsToSelector:@selector(popGiftAction)]) {
                [_delegate popGiftAction];
            }
            
            break;
        case JHLiveRoleAnchor:
            if (_delegate && [_delegate respondsToSelector:@selector(popGiftAction)]) {
                [_delegate popGiftAction];
            }
            
            break;
        case JHLiveRoleApplication:
            if (_delegate && [_delegate respondsToSelector:@selector(popGiftAction)]) {
                [_delegate popGiftAction];
            }
            
            break;
            
            
        default:
            break;
    }
    
}

- (IBAction)appraiseAction:(id)sender {
    if (_roleType == JHLiveRoleCustomizeAndience) {
        //连麦定制
        if (_delegate && [_delegate respondsToSelector:@selector(onLineToCustomize:)]) {
            [_delegate onLineToCustomize:self.customizeButtonType];
        }
    }else if(_roleType == JHLiveRoleRecycleAndience){
       // 回收连麦
        if (_delegate && [_delegate respondsToSelector:@selector(onLineToRecycle:)]) {
        [_delegate onLineToRecycle:self.customizeButtonType];
        }
        [self sa_trackingWithOther_name:@"applyConnection"];
    }
    else{
        if (_delegate && [_delegate respondsToSelector:@selector(appraiseActionWithType:)]) {
            [_delegate appraiseActionWithType:_roleType];
        }
    }
    
}

- (IBAction)orderAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(orderListAction)]) {
        self.doteLabel.hidden = YES;
        self.doteLabel.text = @"0";
        [_delegate orderListAction];
    }
    
}

- (IBAction)likeAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(pressLikeAction:)]) {
        [_delegate pressLikeAction:self.likeCountBtn];
    }
    
}

- (IBAction)likeCountAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(pressLikeAction:)]) {
        [_delegate pressLikeAction:self.likeCountBtn];
    }
    
}

- (IBAction)clamOrderAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(claimOrderListAction)]) {
        [_delegate claimOrderListAction];
    }
    
}

- (IBAction)pauseAppraiseAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(canAppraiseAction:)]) {
        [_delegate canAppraiseAction:sender];
    }
    
}


- (void)setLinkNum:(NSInteger)linkNum {
    _linkNum = linkNum;
    _numLabel.text = @(linkNum).stringValue;
    _numLabel.hidden = linkNum<=0;
    
}

//为什么注释掉？？？
- (void)updateOrderNumber{
//    NSInteger num = [self.doteLabel.text integerValue];
//    num++;
//    if (num == 0) {
//        self.doteLabel.hidden = YES;
//    }else {
//        if (!self.isResaleRoom) {
//            self.doteLabel.hidden = NO;
//            self.doteLabel.text = @(num).stringValue;
//
//        }else {
//            self.doteLabel.hidden = YES;
//        }
//    }
}


- (void)setLikeCount:(NSInteger)likeCount {
    
    _likeCount = likeCount;
    
    if(likeCount >= 100000)
    {
        [self.likeCountBtn setTitle:[NSString stringWithFormat:@"%zd万",likeCount/10000] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeCountBtn setTitle:[NSString stringWithFormat:@"%zd",likeCount] forState:UIControlStateNormal];
    }

}


- (CGFloat)shareBtnCenterX {
    [self layoutIfNeeded];
    _shareBtnCenterX = self.shareBtn.centerX;
    return _shareBtnCenterX;
}

#pragma mark getter -
- (JHDotButtonView *)resaleBtn {
    if (!_resaleBtn) {
        _resaleBtn = [[JHDotButtonView alloc] init];
        _resaleBtn.height = 37;
        [_resaleBtn.button setTitle:@"寄售" forState:UIControlStateNormal];
        _resaleBtn.type = 0;
        [_resaleBtn.button addTarget:self action:@selector(andienceTapResaleAction:) forControlEvents:UIControlEventTouchUpInside];
        [_resaleBtn.button setBackgroundImage:[UIImage imageNamed:@"icon_room_resale_bg"] forState:UIControlStateNormal];
        _resaleBtn.button.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_resaleBtn.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _resaleBtn.button.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        
        
    }
    return _resaleBtn;
}
- (void)pressWaitPayEnter:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popQuickReplyView:)]) {
        [self.delegate popQuickReplyView:sender];
    }
}
- (UIButton *)quickReplyBtn{
    if (!_quickReplyBtn) {
        _quickReplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quickReplyBtn setBackgroundImage:[UIImage imageNamed:@"quickBtnImage"] forState:UIControlStateNormal];
        [_quickReplyBtn addTarget:self action:@selector(pressWaitPayEnter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quickReplyBtn;
}
- (JHDotButtonView *)userActionBtn {
    if (!_userActionBtn) {
        _userActionBtn = [[JHDotButtonView alloc] init];
        _userActionBtn.height = 37;
        
        _userActionBtn.type = 1;
        [_userActionBtn.button setTitle:@"宝友\n操作" forState:UIControlStateNormal];
        [_userActionBtn.button addTarget:self action:@selector(userAction:) forControlEvents:UIControlEventTouchUpInside];
        _userActionBtn.button.titleLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _userActionBtn.button.titleLabel.numberOfLines = 2;
        _userActionBtn.button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _userActionBtn;
}

- (JHDotButtonView *)insaleBtn {
    if (!_insaleBtn) {
        _insaleBtn = [[JHDotButtonView alloc] init];
        _insaleBtn.height = 37;
        
        _insaleBtn.type = 1;
        [_insaleBtn.button setTitle:@"在售" forState:UIControlStateNormal];
        [_insaleBtn.button addTarget:self action:@selector(insaleAction:) forControlEvents:UIControlEventTouchUpInside];
        _insaleBtn.button.titleLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _insaleBtn.button.titleLabel.numberOfLines = 2;
        _insaleBtn.button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _insaleBtn;
}
-(void)updateShareBtn
{
//    [self.shareBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    self.shareBtn.backgroundColor = [UIColor colorWithHexStr:@"ffde00"];
//    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//    self.shareBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:10.0];
//    [self.shareBtn setTitleColor:[UIColor colorWithHexStr:@"000000"] forState:UIControlStateNormal];
}
-(void)updateNewShareBtn
{
    [self.shareBtn setImage:[UIImage imageNamed:@"live_room_share"] forState:UIControlStateNormal];
    self.shareBtn.backgroundColor = [UIColor clearColor];
    [self.shareBtn setTitle:@"" forState:UIControlStateNormal];
    self.shareBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:10.0];
    [self.shareBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
}
-(void)updateLikeBtn
{
//    [self.likeBtn setImage:[UIImage imageNamed:@"icon_live_like_btn"] forState:UIControlStateNormal];
    self.likeCountBtn.hidden = NO;
//    self.likeBtnCountTop.constant = 26;
//    [self.likeCountBtn.layer addSublayer:self.gradientLayer];
    if([self isRestoreStoneRoomAndAnchor])
        self.likeCountBtn.hidden = YES;
}
//回血&主播
- (BOOL)isRestoreStoneRoomAndAnchor
{//restoreStone(回血直播间)
    if([self.channel.channelCategory isEqualToString: @"restoreStone"] && (_roleType == JHLiveRoleSaleAnchor || _roleType == JHLiveRoleSaleHelper))
    {
        return YES;
    }
    return NO;
}

-(CAGradientLayer *)gradientLayer
{
    if(!_gradientLayer)
    {
        _gradientLayer =  [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.likeCountBtn.width, self.likeCountBtn.height);
         _gradientLayer.startPoint = CGPointMake(0, 0);
         _gradientLayer.endPoint = CGPointMake(1, 0);
         _gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
         [_gradientLayer setColors:@[(id)[[UIColor colorWithHexStr:@"F7B62A"] CGColor],(id)[[UIColor colorWithHexStr:@"F15744"] CGColor]]];//渐变数组
      
    }
    return _gradientLayer;
}

- (UIButton *)shanGouBtn{
    if (!_shanGouBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"shangou_send"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shanGouBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _shanGouBtn = btn;
    }
    return _shanGouBtn;
}

-(void)addGradientLayer
{

}
- (void)setIsResaleRoom:(BOOL)isResaleRoom {
    _isResaleRoom = isResaleRoom;
    [self setSendRedPacket];
    if (isResaleRoom) {
        //chat_icon_service
        [self.helperBtn setImage:[UIImage imageNamed:@"chat_icon_service"] forState:UIControlStateNormal];
        //label_helper
        self.helperImage.image = [UIImage imageNamed:@"label_helper"];
        //icon_live_like_btn
        [self updateLikeBtn];
        [self updateShareBtn];
        
 
        self.helperImage.hidden = NO;
        self.orderBtn.hidden = YES;
        self.doteLabel.hidden = YES;
        
        self.auctionBtn.hidden = YES;
        _auctionHidden = YES;
        self.doteLabel.hidden = YES;
        
        self.sendRedPacketBtn.hidden = NO;
        self.shareBtn.hidden = NO;
        self.helperBtn.hidden = NO;
        
        
        
        if (self.roleType == JHLiveRoleSaleAnchor || self.roleType == JHLiveRoleSaleHelper) {
            [self.sayWhateBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@12);
            }];
            self.listBtn.hidden = YES;
            self.shopwindowButton.hidden = YES;
            [self addSubview:self.userActionBtn];
            [self addSubview:self.insaleBtn];
            [self addSubview:self.sendRedPacketBtn];

            if(self.roleType == JHLiveRoleSaleAnchor)
            {
                [self.insaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-110);
                    make.centerY.equalTo(self);
                    make.width.equalTo(@37);
                    make.height.equalTo(@37);
                    
                }];
//                self.shareBtnTrailing.constant = 12;
                [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-12);
                    make.centerY.equalTo(self);
                    make.width.equalTo(@37);
                    make.height.equalTo(@37);
                }];
                [self.sendRedPacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-210);
                    make.centerY.equalTo(self);
                    make.height.equalTo(@37);
                    make.width.equalTo(@37);
                }];
                [self.userActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-160);
                    make.centerY.equalTo(self);
                    make.height.equalTo(@37);
                    make.width.equalTo(@37);
                    
                }];
                self.helperBtnTrailing.constant = 61;
                
            }else if (self.roleType == JHLiveRoleSaleHelper)
            {
                [self.sendRedPacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-260);
                    make.centerY.equalTo(self);
                    make.height.equalTo(@37);
                    make.width.equalTo(@37);
                }];
                [self.userActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-210);
                    make.centerY.equalTo(self);
                    make.height.equalTo(@37);
                    make.width.equalTo(@37);
                    
                }];
                self.helperBtnTrailing.constant = 110;
//                [self.insaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.leading.trailing.top.bottom.equalTo(self.orderBtn);
//
//                }];
                [self.insaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(@-160);
                    make.centerY.equalTo(self);
                    make.width.equalTo(@37);
                    make.height.equalTo(@37);
                    
                }];
                self.shareBtnTrailing.constant = 63;
                
            }
            
        } else if (self.roleType == JHLiveRoleSaleAndience) {
            //TODO:yaoyao去掉寄售按钮
            //              [self addSubview:self.resaleBtn];
            //              [self.resaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //                              make.leading.trailing.top.bottom.equalTo(self.orderBtn);
            //
            //              }];
//            self.helperBtnTrailing.constant = 110;
//            self.helperBtnWidth.constant = 43;
        }
    }
}
- (void)shanGouBtnActionWithSender:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(onShanGouBtnAction)]) {
        [self.delegate onShanGouBtnAction];
    }
}
- (void)insaleAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(onAnchorTapInsaleAction)]) {
        [self.delegate onAnchorTapInsaleAction];
    }
}

- (void)userAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(onAnchorTapUserAction)]) {
        [self.delegate onAnchorTapUserAction];
    }
}

- (void)andienceTapResaleAction:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(onAndienceTapResaleAction)]) {
        [self.delegate onAndienceTapResaleAction];
    }
}

- (IBAction)sendRedPacketAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(sendRedPacketAction:)]) {
        [self.delegate sendRedPacketAction:sender];
    }
}

- (IBAction)clickListBtnAction:(UIButton *)sender
{
    CGFloat trailing = self.listBtnTrailing.constant;
    if([self.delegate respondsToSelector:@selector(clickListBtnAction:Trailing:)])
    {
        [self.delegate clickListBtnAction:sender Trailing:trailing];
    }
}

- (void)setChatTitle:(NSString *)title {
    self.chatLabel.text = title;
}

- (UIButton *)shopwindowButton
{
    if(!_shopwindowButton)
    {
        _shopwindowButton = [UIButton jh_buttonWithBackgroundimage:@"live_room_shopwindow_enter" target:self action:@selector(enterShopwindowAction) addToSuperView:self];
        _shopwindowButton.hidden = YES;
        _shopwindowButton.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        _shopwindowButton.jh_font([UIFont boldSystemFontOfSize:14]);
        [_shopwindowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(34, 42));
        }];
    }
    return _shopwindowButton;
}

- (void)enterShopwindowAction
{
    JHLiveStoreViewType type = (_roleType == JHLiveRoleSaleAnchor || _roleType == JHLiveRoleSaleHelper) ? JHLiveStoreViewTypeSaler : JHLiveStoreViewTypeUser;
    JHLiveStoreView *storeView = [[JHLiveStoreView alloc] initWithType:type channel:self.channel];
    [JHRootController.currentViewController.view addSubview:storeView];
    
    [JHGrowingIO trackEventId:JHChannelLocalldShopClick variables:@{@"channelLocalId":self.channel.channelLocalId ? : @""}];
    [self sa_trackingWithOther_name:@"商品橱窗"];
}
- (void)sa_trackingWithOther_name:(NSString *)other_name{
    
    [JHTracking trackEvent:@"clickOther" property:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"直播间页",@"other_name":other_name,@"live_type":self.channel.channelCategory}];
    
}
+ (NSAttributedString *)getShadowWithText:(NSString *)text
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 4;
    shadow.shadowColor = [UIColor colorWithRed:227/255.0 green:125/255.0 blue:0/255.0 alpha:1.0];
    shadow.shadowOffset =CGSizeMake(0,1);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes: @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}];
    return string;
}


@end
