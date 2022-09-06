//
//  JHUserHomePageHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/6/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGradientView.h"
#import "JHUserHomePageHeader.h"
#import "TTjianbao.h"
#import "JHShopEnterView.h"
#import "UIView+CornerRadius.h"
#import "UIImageView+JHWebImage.h"
#import "UserInfoRequestManager.h"
#import "JHUserInfoModel.h"
#import "JHUserInfoDetailView.h"
#import "JHSQMedalView.h"
#import "JHRootViewController+TransitPage.h"
#import "UIView+JHGradient.h"
#import "JHSQManager.h"
#import "CommHelp.h"
#import "UIView+JHShadow.h"
#import "JHPhotoBrowserManager.h"

#import "JHMenuView.h"
#import "JHChatViewController.h"
#import "JHContactListViewController.h"
#import "JHContactUserInfoModel.h"
#import "JHGreetViewController.h"
#import "JHCommunityNewListViewController.h"

#define paramsSpace 10
#define headerImageHeight 205

@interface JHUserHomePageHeader ()

@property (nonatomic, strong) UIImageView *headerImageView;
///底部展示用户信息的view
@property (nonatomic,strong) UIView *infoView;
@property (nonatomic,strong) UIView *iconView;
@property (nonatomic,strong) UIView *iconBorderView;
@property (nonatomic,strong) UIImageView *iconImageView;
//@property (nonatomic, strong) UIView *liveStatusView;//直播状态
@property (nonatomic, strong) YYAnimatedImageView *liveGifView;
//@property (nonatomic, strong) UILabel *liveStatusLabel;
@property (nonatomic,strong) UILabel *nickNameLabel; //用户名称
@property (nonatomic,strong) UILabel *userIdLabel; //用户ID
///勋章展示view
@property (nonatomic,strong) JHSQMedalView *metalView;
///关注按钮
@property (nonatomic,strong) UIButton *followButton;
///存储粉丝 关注获赞 经验标签的数组
@property (nonatomic, strong) JHUserInfoDetailView *fansView;
@property (nonatomic, strong) JHUserInfoDetailView *followView;
@property (nonatomic, strong) JHUserInfoDetailView *likeView;
@property (nonatomic, strong) JHUserInfoDetailView *exepView;
///店铺入口
@property (nonatomic,strong) JHShopEnterView *shopEnterView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, assign) CGRect headerImageFrame;
@property (strong, nonatomic) NSArray *actionArr;
@property (assign, nonatomic) BOOL isLimit;

@end


@implementation JHUserHomePageHeader

- (void)setFansCount:(NSString *)fansCount {
    if (!fansCount) {
        return;
    }
    _fansCount = fansCount;
    _fansView.value = _fansCount;
}

- (void)setFollowCount:(NSString *)followCount {
    if (!followCount) {
        return;
    }
    _followCount = followCount;
    _followView.value = _followCount;
}

- (void)setUserInfo:(JHUserInfoModel *)userInfo {
    if (!userInfo) {
        return;
    }
    
    _userInfo = userInfo;
    [_headerImageView jhSetImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholder:kDefaultCoverImage];
    self.effectView.hidden = NO;
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholder:kDefaultAvatarImage];
    _nickNameLabel.text = [_userInfo.user_name isNotBlank]?_userInfo.user_name:@"暂无昵称";
    _userIdLabel.text = [NSString stringWithFormat:@"宝友号：%@", _userInfo.user_id ? : @""];
    
    ///关注按钮
    if ([JHSQManager isAccount:_userInfo.user_id]) {
        ///是本人  编辑资料
        [_followButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    }
    else {///他人
        if (_userInfo.is_follow) {
            [self gradientColorForFollowButton:@[kColorEEE, kColorEEE]];
            [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
            [_followButton setTitleColor:kColor999 forState:UIControlStateNormal];
            [_followButton setTitleColor:kColor999 forState:UIControlStateHighlighted];
        }
        else {
            [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
            [_followButton setTitle:@"关注" forState:UIControlStateNormal];
            [_followButton setTitleColor:kColor333 forState:UIControlStateNormal];
            [_followButton setTitleColor:kColor333 forState:UIControlStateHighlighted];
        }
    }
    
    _fansView.value = _userInfo.fans_num;
    _followView.value = _userInfo.follow_num;
    _likeView.value = _userInfo.like_num;
    _exepView.value = _userInfo.experience_num;
    //直播状态
    _liveGifView.hidden = !_userInfo.is_live;
    _iconBorderView.hidden = !_userInfo.is_live;
    ///勋章
    NSArray *arr = [JHSQManager getUserMedalInfo:_userInfo];
    _metalView.tagArray = arr;
    CGFloat topSpace = 0.f, height = 0.f;
    if (arr.count > 0) {
        topSpace = 7.f;
        height = 15.f;
    }
    [_metalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIdLabel.mas_bottom).offset(topSpace);
        make.height.mas_equalTo(height);
    }];
    ///配置店铺信息
    [self configStoreInfo];
}

- (void)configStoreInfo {
    CGFloat enterHeight = 0;
    CGFloat enterSpace = 0;
    if (_userInfo.storeInfo != nil) {
        _shopEnterView.storeInfo = _userInfo.storeInfo;
        ///如果是特卖商家 则显示店铺的UI 否则隐藏
        enterHeight = 58.f;
        enterSpace = -15.f;
        [_shopEnterView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(enterHeight);
            make.bottom.equalTo(self.infoView).offset(enterSpace);
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorF5F6FA;
        
        //hutao--add
        self.isLimit = NO;
        
        [self setupViews];
        
        [self getLimit];
        
    }
    return self;
}

//hutao--add
- (void)getLimit
{
    if ([JHRootController isLogin])
    {
        [self requestShowLimit];
    }
}

- (void)requestShowLimit
{
    //判断是否可以发送社区官方消息接口
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *url = FILE_BASE_STRING(@"/auth/customer/canCommMsg");
    NSLog(@"权限：%@",url);
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSDictionary *dic = respondObject.data;
        NSString *canCommMsg = dic[@"canCommMsg"];
        if ([canCommMsg intValue] == 1)
        {
            self.isLimit = YES;
            self.userIdLabel.textColor = kColorTopicTitle;
        }
        else
        {
            self.isLimit = NO;
            self.userIdLabel.textColor = kColor666;
        }
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        self.isLimit = NO;
        self.userIdLabel.textColor = kColor666;
    }];
}


///进入直播间
- (void)enterLiveHomePage {
    if (self.userInfo.is_live) {
        ///如果是直播中的时候进入直播间
        [JHRootController EnterLiveRoom:_userInfo.room_id fromString:JHEventPersonalcenter];
    }else{
        /** 查看大图*/
        if(self.userInfo.avatar && self.iconImageView) {
            [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[self.userInfo.avatar] mediumImages:@[self.userInfo.avatar] origImages:@[self.userInfo.avatar] sources:@[self.iconImageView] currentIndex:0 canPreviewOrigImage:NO showStyle:GKPhotoBrowserShowStyleZoom];
        }
    }
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.alpha = 0.95;
        _effectView = effectView;
    }
    return _effectView;
}

- (void)setupViews {
    _headerImageView = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    [self addSubview:_headerImageView];
    [_headerImageView addSubview:self.effectView];
    self.effectView.hidden = YES;
    
    JHGradientView *layer = [JHGradientView new];
    [layer setGradientColor:@[(__bridge id)RGBA(0,0,0,0).CGColor,(__bridge id)RGBA(0,0,0,0.2).CGColor] orientation:JHGradientOrientationVertical];
    [_headerImageView addSubview:layer];
    [layer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headerImageView);
        make.height.mas_equalTo(205);
    }];
    
    _infoView = [[UIView alloc] init];
    _infoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_infoView];
    
    _iconView = [[UIView alloc] init];
    _iconView.backgroundColor = [UIColor whiteColor];
    [_infoView addSubview:_iconView];
    
    _iconBorderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
    [_infoView addSubview:_iconBorderView];
    _iconBorderView.hidden = YES;

    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.userInteractionEnabled = YES;
    [_iconView addSubview:_iconImageView];
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterLiveHomePage)];
    [_iconImageView addGestureRecognizer:iconTap];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data];
    _liveGifView = [[YYAnimatedImageView alloc] initWithImage:image];
    _liveGifView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_liveGifView];
    _liveGifView.hidden = YES;
    
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.text = @"";
    _nickNameLabel.textColor = kColor333;
    _nickNameLabel.font = [UIFont fontWithName:kFontMedium size:22];
    [self addSubview:_nickNameLabel];
    
    _userIdLabel = [[UILabel alloc] init];
    _userIdLabel.textColor = kColor666;
    //_userIdLabel.textColor = kColorTopicTitle;
    _userIdLabel.font = [UIFont fontWithName:kFontNormal size:10];
    [self addSubview:_userIdLabel];
    
    _userIdLabel.userInteractionEnabled = YES;
    [_userIdLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenuView)]];

    
    ///勋章标识view
    _metalView = [[JHSQMedalView alloc] init];
    _metalView.backgroundColor = HEXCOLOR(0xffffff);
    [self.infoView addSubview:_metalView];
    
    _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _followButton.backgroundColor = kColorMain;
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    _followButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [_followButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_followButton addTarget:self action:@selector(followEventAction) forControlEvents:UIControlEventTouchUpInside];
    [self gradientColorForFollowButton:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)]];
    [_infoView addSubview:_followButton];
    
    _fansView = [self createControlWithBlockType:JHDetailBlockTypeFans];
    [_fansView setTitle:@"粉丝" value:@"0"];
    [self addSubview:_fansView];
    
    _followView = [self createControlWithBlockType:JHDetailBlockTypeFollow];
    [_followView setTitle:@"关注" value:@"0"];
    [self addSubview:_followView];

    _likeView = [self createControlWithBlockType:JHDetailBlockTypeLike];
    [_likeView setTitle:@"获赞" value:@"0"];
    [self addSubview:_likeView];

    _exepView = [self createControlWithBlockType:JHDetailBlockTypeExp];
    [_exepView setTitle:@"经验" value:@"0"];
    [self addSubview:_exepView];

    _shopEnterView = [[JHShopEnterView alloc] init];
    _shopEnterView.backgroundColor = HEXCOLOR(0xF9FAF9);
    [_infoView addSubview:_shopEnterView];
    
    [self makeLayouts];
}

- (void)showMenuView
{
    self.userIdLabel.userInteractionEnabled = NO;
    
//    if (![JHRootController isLogin])
//    {
//        @weakify(self);
//        [JHRootController presentLoginVC:^(BOOL result)
//        {
//            @strongify(self);
//            if (result)
//            {
//                [self requestShowStatus];
//            }
//        }];
//    }
//    else
//    {
//        [self requestShowStatus];
//    }
    
    //hutao--change
    if (self.isLimit)
    {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        CGRect rect = [self.userIdLabel convertRect: self.userIdLabel.bounds toView:window];
        CGPoint point = CGPointMake(rect.origin.x, rect.origin.y);
        JHMenuView *view = [JHMenuView menuViewAtPoint:point];
        view.block = ^(NSInteger index)
        {
            if (index == 0)
            {
                //联系宝友埋点
                [JHGrowingIO trackEventId:@"community_write_contactBaoyou_enter"];

                JHChatViewController *vc = [[JHChatViewController alloc] init];
                vc.userId = self.userInfo.user_id;
                vc.name = self.userInfo.user_name;
                [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                //复制宝友号埋点
                [JHGrowingIO trackEventId:@"community_write_copyBaoyouNum_enter"];

                NSString *str = self.userIdLabel.text;
                if ([str containsString:@"宝友号："])
                {
                    str = [str substringFromIndex:4];
                }
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = str;

                [UITipView showTipStr:@"复制成功"];
            }
        };
        [view show];
    }
    
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];
}

- (void)requestShowStatus
{
    //判断是否可以发送社区官方消息接口
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *url = FILE_BASE_STRING(@"/auth/customer/canCommMsg");
    NSLog(@"权限：%@",url);
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSDictionary *dic = respondObject.data;
        NSString *canCommMsg = dic[@"canCommMsg"];
        if ([canCommMsg intValue] == 1)
        {
            UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
            CGRect rect = [self.userIdLabel convertRect: self.userIdLabel.bounds toView:window];
            //CGPoint point = CGPointMake(self.userIdLabel.origin.x, self.userIdLabel.origin.y);
            CGPoint point = CGPointMake(rect.origin.x, rect.origin.y);
            JHMenuView *view = [JHMenuView menuViewAtPoint:point];
            view.block = ^(NSInteger index)
            {
                if (index == 0)
                {
                    //联系宝友埋点
                    [JHGrowingIO trackEventId:@"community_write_contactBaoyou_enter"];
                    
                    JHChatViewController *vc = [[JHChatViewController alloc] init];
                    vc.userId = self.userInfo.user_id;
                    vc.name = self.userInfo.user_name;
                    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    //复制宝友号埋点
                    [JHGrowingIO trackEventId:@"community_write_copyBaoyouNum_enter"];
                    
                    NSString *str = self.userIdLabel.text;
                    if ([str containsString:@"宝友号："])
                    {
                        str = [str substringFromIndex:4];
                    }
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = str;

                    [UITipView showTipStr:@"复制成功"];
                }
            };
            [view show];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {

    }];
    
    [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];
}

-(void)changeButtonStatus
{
    self.userIdLabel.userInteractionEnabled = YES;
}

- (void)gradientColorForFollowButton:(NSArray <UIColor *>*)colors {
    [_followButton jh_setGradientBackgroundWithColors:colors locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

- (void)makeLayouts {
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(headerImageHeight);
    }];
    
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerImageView);
    }];
    
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headerImageView.mas_bottom).offset(-15);
        make.top.mas_equalTo(headerImageHeight-15);
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.infoView).offset(15);
        make.centerY.equalTo(self.infoView.mas_top).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    ///黄圈的view
    [_iconBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView).insets(UIEdgeInsetsMake(-2, -2, -2, -2));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    
    [_liveGifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageView);
        make.bottom.equalTo(self.iconImageView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView).offset(15);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(15);
        make.right.equalTo(self.infoView).offset(-10);
    }];
    
    [_userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nickNameLabel);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(5);
    }];
    
    [_metalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIdLabel);
        make.right.equalTo(self.infoView).offset(-10);
        make.top.equalTo(self.userIdLabel.mas_bottom).offset(7);
        make.height.mas_equalTo(15);
    }];
    //关注按钮
    [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.infoView).offset(-15);
        make.top.equalTo(self.infoView).offset(10);
        make.size.mas_equalTo(CGSizeMake(146, 30));
    }];
        
    [_shopEnterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView).offset(15);
        make.right.equalTo(self.infoView).offset(-15);
        make.bottom.equalTo(self.infoView);
        make.height.mas_equalTo(0);
    }];
    
    [_fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.bottom.equalTo(self.shopEnterView.mas_top).offset(-15);
    }];
        
    [_followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fansView.mas_right).offset(paramsSpace);
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.bottom.equalTo(self.fansView);
    }];
    
    [_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followView.mas_right).offset(paramsSpace);
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.bottom.equalTo(self.followView);
    }];

    [_exepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeView.mas_right).offset(paramsSpace);
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.bottom.equalTo(self.likeView);
    }];

    [self layoutIfNeeded];
    [_infoView yd_setCornerRadius:12 corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    _iconImageView.layer.cornerRadius =_iconImageView.height/2.f;
    _iconImageView.clipsToBounds = YES;
    _iconView.layer.cornerRadius = 40.f;
    [_iconView setLayerShadow:HEXCOLORA(0x000000,.2f) offset:CGSizeMake(0, 3) radius:5.f];
    
    _followButton.layer.cornerRadius = _followButton.height/2;
    _followButton.layer.masksToBounds = YES;
    _headerImageFrame = _headerImageView.frame;
    
}

- (void)followEventAction {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    if (self.followBlock) {
        self.followBlock([JHSQManager isAccount:_userInfo.user_id], @(self.userInfo.is_follow).boolValue);
    }
}

- (JHUserInfoDetailView *)createControlWithBlockType:(JHDetailBlockType)blockType {
    JHUserInfoDetailView *control = [JHUserInfoDetailView new];
    control.exclusiveTouch = YES;
    @weakify(self);
    control.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                //点击事件
                [self handleClickEvent:blockType];
            }
        }
    };
    return control;
}

- (void)handleClickEvent:(JHDetailBlockType)blockType {
    if (self.userDetailEventBlock) {
        self.userDetailEventBlock(blockType);
    }
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGRect frame = self.headerImageFrame;
    frame.origin.y = contentOffsetY;
    if (contentOffsetY < 0) {
        frame.size.height -= contentOffsetY;
    }
    NSLog(@"contentOffsetY--- %f", contentOffsetY);

    [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(frame.origin.y);
        make.height.mas_equalTo(frame.size.height);
    }];
}

@end
