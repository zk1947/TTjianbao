//
//  JHPersonHeaderCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPersonHeaderCell.h"
#import "JHCheckingView.h"
#import "YYControl.h"
#import "JHPersonInfoModel.h"
#import "TTjianbaoBussiness.h"
#import "TTjianbaoHeader.h"
#import "JHMyCenterApiManager.h"

@interface JHPersonHeaderCell ()
///用户头像
@property (nonatomic, strong) UIImageView *avatarImage;
///用户昵称
@property (nonatomic, strong) UILabel *nickNameLabel;
///昵称旁边的箭头
@property (nonatomic, strong) UIImageView *arrowImage;
///电子签约认证标签
@property (nonatomic, strong) UIImageView *identImage;
///土豪标签
@property (nonatomic, strong) UIImageView *crowImage;
///游戏等级
@property (nonatomic, strong) UIImageView *gameLevelImage;

@property (nonatomic, strong) UIView *taskView;
///身份等级
@property (nonatomic, strong) UIImageView *creditsImage;
///进度条
@property (nonatomic, strong) UIImageView *progressView;
///进度条描述文字
@property (nonatomic, strong) UILabel *descLabel;

///顶部个人信息view
@property (nonatomic, strong) UIView *infoView;
///签到有礼
//@property (nonatomic, strong) JHCheckingView *checkView;
@property (nonatomic, strong) UIButton *checkButton;

///底部粉丝 关注等整体view
@property (nonatomic, strong) UIView *bottomView;
///上升箭头
@property (nonatomic, strong) UIImageView *upImage;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labelArray;

@property (nonatomic, strong) UILabel *loginLabel;   ///请登录
@property (nonatomic, strong) UIImageView *headerImageView;


@end

@implementation JHPersonHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self configInfoView];
        [self configBottomView];
    }
    return self;
}

- (void)configInfoView {
    @weakify(self);
    BOOL isLogin = [JHRootController isLogin];
    UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:isLogin ? @"icon_my_header_bg" : @"icon_my_header_bg"]];
    _headerImageView = headerImage;
    [self.contentView addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
        make.top.left.right.equalTo(self.contentView);
        make.bottom.mas_equalTo(28);
    }];
    self.layer.masksToBounds = false;
    self.contentView.layer.masksToBounds = false;
    ///头像
    _avatarImage = ({
        UIImageView *iconImage = [UIImageView new];
        iconImage.layer.cornerRadius = 30;
        iconImage.layer.masksToBounds = YES;
//        iconImage.layer.borderColor = kGlobalThemeColor.CGColor; // C2C 版本去掉边框
//        iconImage.layer.borderWidth = 1;
        iconImage.image = kDefaultAvatarImage;
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
        iconImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPersonCenterPage)];
        [iconImage addGestureRecognizer:iconTap];
        iconImage;
    });
    
    _loginLabel = ({
        UILabel *loginLabel = [[UILabel alloc] init];
        loginLabel.textColor = HEXCOLOR(0x333333);
        loginLabel.font = [UIFont fontWithName:kFontMedium size:18];
        loginLabel.text = JHLocalizedString(@"pleaseToLogin");
        loginLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toLoginPage)];
        [loginLabel addGestureRecognizer:tapGR];
        loginLabel;
    });
    _loginLabel.hidden = isLogin;
    
    UIView *infoV = [[UIView alloc] init];
    _infoView = infoV;
    _infoView.hidden = !isLogin;
    
    ///昵称
    _nickNameLabel = ({
        UILabel *nickLabel = [[UILabel alloc] init];
        nickLabel.textColor = HEXCOLOR(0x333333);
        nickLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        nickLabel.text = @"";
        nickLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPersonCenterPage)];
        [nickLabel addGestureRecognizer:nameTap];
        nickLabel;
    });
    
    ///昵称旁边的箭头
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_my_arrow"]];
    _arrowImage.contentMode = UIViewContentModeScaleAspectFit;
    
    //认证 土豪 游戏标签
    ///认证标签
    _identImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _identImage.contentMode = UIViewContentModeScaleAspectFill;
    
    YYControl *identControl = [[YYControl alloc] init];
    identControl.exclusiveTouch = YES;
    identControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                ///进签约认证界面
                [self enterMerchant];
            }
        }
    };
    
    //土豪
    _crowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//icon_my_crow
    _crowImage.contentMode = UIViewContentModeScaleAspectFill;

    ///游戏等级
    _gameLevelImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _gameLevelImage.contentMode = UIViewContentModeScaleAspectFill;

    ///任务中心
    YYControl *taskView = [[YYControl alloc] init];
    taskView.exclusiveTouch = YES;
    _taskView = taskView;
    taskView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                ///进任务中心界面
                [self taskAction];
            }
        }
    };
    
    ///身份等级
    _creditsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _creditsImage.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *progressAll = [UIImageView new];
    progressAll.backgroundColor = HEXCOLOR(0xffffff);
    progressAll.layer.cornerRadius = 1.5f;
    progressAll.layer.masksToBounds = YES;
    
    _progressView = [[UIImageView alloc] init];
    _progressView.backgroundColor = HEXCOLOR(0x333333);
    _progressView.layer.cornerRadius = 1.5f;
    _progressView.layer.masksToBounds = YES;
    
    ///进度条底部描述文字
    _descLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:kFontNormal size:9];
        label;
    });
    
    ///签到
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkButton setImage:[UIImage imageNamed:@"my_signIn_icon"] forState:UIControlStateNormal];
    [_checkButton addTarget:self action:@selector(toChecking) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.contentView addSubview:_avatarImage];
    [self.contentView addSubview:_loginLabel];
    [self.contentView addSubview:_checkButton];
    [self.contentView addSubview:_infoView];
    [_infoView addSubview:_nickNameLabel];
    [_infoView addSubview:_arrowImage];
    [_infoView addSubview:_identImage];
    [_infoView addSubview:identControl];
    [_infoView addSubview:_crowImage];
    [_infoView addSubview:_gameLevelImage];
    
    [_infoView addSubview:_taskView];
    [_infoView addSubview:_creditsImage];
    [_infoView addSubview:progressAll];
    [_infoView addSubview:_progressView];
    [_infoView addSubview:_descLabel];
    
    
    [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusAndNavBarHeight);
        make.leading.equalTo(self.contentView).offset(15);
        make.height.width.equalTo(@(60));
    }];

    [_loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
        make.height.mas_equalTo(25);
        make.centerY.equalTo(self.avatarImage);
    }];
        
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImage.mas_right).offset(5);
        make.top.equalTo(self.avatarImage).offset(8);
        make.bottom.equalTo(self.avatarImage);
        make.right.equalTo(self.descLabel);
    }];

    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoView);
        make.top.equalTo(self.infoView);
        make.height.mas_equalTo(25);
        make.width.lessThanOrEqualTo(@108);
    }];
    
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nickNameLabel);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];

    [_identImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrowImage.mas_right).offset(5);
        make.centerY.equalTo(self.arrowImage);
        make.width.mas_equalTo(0);  //49
        make.height.mas_equalTo(15);
    }];
    
    [identControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.identImage);
    }];
    
    [_crowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.identImage.mas_right).offset(5);
        make.centerY.equalTo(self.identImage);
        make.size.mas_equalTo(CGSizeMake(0, 15));
    }];
    
    ///游戏等级
    [_gameLevelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.crowImage.mas_right).offset(5);
        make.centerY.equalTo(self.crowImage);
        make.size.mas_equalTo(CGSizeMake(38, 15));
    }];
        
    [_creditsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(38, 15));
    }];
        
    [progressAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.creditsImage.mas_trailing).offset(10);
        make.top.equalTo(self.creditsImage);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(3);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.height.equalTo(progressAll);
        make.width.equalTo(@(0));
    }];
    
    [_taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.right.equalTo(progressAll).offset(20);
        make.top.bottom.equalTo(self.creditsImage);
    }];
    
    [_checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.avatarImage).offset(3);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(progressAll.mas_bottom).offset(2);
        make.leading.equalTo(progressAll);
        make.right.equalTo(_checkButton.mas_left).offset(-50);
    }];
}

- (void)configBottomView {
    
    _bottomView = [[UIView alloc] init];
    [self.contentView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.mas_bottom).offset(15);
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    NSArray *array = @[JHLocalizedString(@"follow"), JHLocalizedString(@"fans"), JHLocalizedString(@"like"), JHLocalizedString(@"score")];
    CGFloat width = (ScreenW-20)/array.count;
    CGFloat ox = 0;
    for (int i = 0; i<array.count; i++) {
        UIControl *controlView = [[UIControl alloc] init];
        controlView.tag = i;
        [controlView addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:controlView];
        
        UILabel *label1 = [UILabel new];
        label1.font = [UIFont fontWithName:kFontMedium size:18];
        label1.text = @"0";
        label1.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:label1];
        self.labelArray[i] = label1;
//        if (i == 3) {
//            UIImageView *image = [UIImageView new];
//            image.image = [UIImage imageNamed:@"icon_my_score_up"];
//            [_bottomView addSubview:image];
//            [image mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.leading.equalTo(label1.mas_trailing).offset(2);
//                make.centerY.equalTo(label1).offset(-1);
//            }];
//            _upImage = image;
//        }
        
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:kFontNormal size:12];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentCenter;
        [_bottomView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label1.mas_bottom).offset(2);
            make.width.equalTo(@(width));
            make.leading.equalTo(@(ox));
        }];
        
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView);
            make.centerX.equalTo(label);
        }];
        
        [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(label);
            make.top.equalTo(label1);
            make.bottom.equalTo(label);
        }];
        ox += width;
    }
    
    _bottomView.hidden = ![JHRootController isLogin];
}

- (void)setUserModel:(User *)userModel {
    if (!userModel) return;
    
    _userModel = userModel;
    
    [_avatarImage jhSetImageWithURL:[NSURL URLWithString:_userModel.icon] placeholder:kDefaultAvatarImage];
    _nickNameLabel.text = _userModel.name?:_userModel.mobile;
    
    self.checkButton.hidden = ![JHMyCenterApiManager shareInstance].allowSignModel.isCheckinButtonAllowed;
}

- (void)setLevelModel:(JHUserLevelInfoMode *)levelModel {
    if (!levelModel) {
        return;
    }
    
    _levelModel = levelModel;

    ///认证标签 如果是商家显示是否认证标签    
    _identImage.hidden = YES;
    [_identImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrowImage.mas_right).offset(0);
        make.width.mas_equalTo(0);
    }];
    
    if ([_levelModel.userTycoonLevelIcon isNotBlank]) {
        ///是大土豪 显示大土豪标志
        [_crowImage jhSetImageWithURL:[NSURL URLWithString:_levelModel.userTycoonLevelIcon]];
        [_crowImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.identImage.mas_right).offset(5);
            make.width.mas_equalTo(15);
        }];
    }
    else {
        _crowImage.image = [UIImage imageNamed:@""];
        [_crowImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.identImage.mas_right).offset(0);
            make.width.mas_equalTo(0);
        }];
    }
    
    if ([_levelModel.game_level_icon isNotBlank]) {
        ///游戏等级
        [_gameLevelImage jhSetImageWithURL:[NSURL URLWithString:_levelModel.game_level_icon]];
        [_gameLevelImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.crowImage.mas_right).offset(5);
            make.width.mas_equalTo(40);
        }];
    }
    else {
        _gameLevelImage.image = [UIImage imageNamed:@""];
        [_gameLevelImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.identImage.mas_right).offset(0);
            make.width.mas_equalTo(0);
        }];
    }
    
    [_identImage layoutIfNeeded];
    [_crowImage layoutIfNeeded];
    [_gameLevelImage layoutIfNeeded];
    
    ///等级称号
    [_creditsImage jhSetImageWithURL:[NSURL URLWithString:_levelModel.title_level_icon]];
    _descLabel.text = [NSString stringWithFormat:@"%d/%d %@", _levelModel.experience_num, _levelModel.level_exp_next,_levelModel.level_next_name];
    
    self.labelArray[0].text = @(levelModel.follow_num).stringValue;
    self.labelArray[1].text = @(levelModel.fans_num).stringValue;
    self.labelArray[2].text = @(levelModel.like_num).stringValue;
    self.labelArray[3].text = @(levelModel.score).stringValue;
//    _upImage.hidden = !(levelModel.is_experience_new>0);
    [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0));
    }];
    [_progressView.superview layoutIfNeeded];
    
    CGFloat w = 100 * levelModel.level_exp_percent;
    [UIView animateWithDuration:0.5 animations:^{
        [_progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(w));
        }];
        [_progressView.superview layoutIfNeeded];
    }];
}

//商家认证信息
- (void)configMerchantCert {
    
//    @property (nonatomic, assign) NSInteger business_type; //0非商家 1老商家 2新商家
//    @property (nonatomic, assign) NSInteger real_type; //认证类型：0未认证 1个人认证 2商家认证
//    @property (nonatomic, assign) NSInteger sign_type; //签约类型：0未签约 1已签约
//    @property (nonatomic, copy) NSString *title; //个人姓名/企业名称
//    @property (nonatomic, copy) NSString *tips; //提示文案
//    @property (nonatomic, assign) BOOL is_need_sign; //是否强制签约：0否 1是
    
//    if (_levelModel.sign.business_type > 0) { //是商家
//        JHUserSignInfo *signInfo = _levelModel.sign;
//        BOOL isSign = @(signInfo.sign_type).boolValue;
//        _identImage.userInteractionEnabled = !isSign;
//        NSString *str = isSign ? @"icon_my_idented":@"icon_my_unident";
//        _identImage.image = [UIImage imageNamed:str];
//
//    }
//    else { //非商家
//        [_gameLevelImage jhSetImageWithURL:[NSURL URLWithString:_levelModel.game_level_icon] placeholder:nil];
//    }
}

#pragma mark -
#pragma mark - target action

///签到有礼
- (void)toChecking {
    if (![JHRootController isLogin]) {
        @weakify(self);
        [JHRootController presentLoginVC:^(BOOL result) {
            @strongify(self);
            if (result) {
                [self getUserCheckInfo];
            }
        }];
        return;
    }
    
    ///上报签到信息
    [JHMyCenterApiManager commitCheckInfo];
    
    if (self.signActionBlock) {
        self.signActionBlock(nil);
    }
}

///登录标签的点击事件 这个肯定是未登录的点击事件
- (void)toLoginPage {
    [JHRootController presentLoginVC:^(BOOL result) {
    }];
}

///进入任务中心页面
- (void)taskAction {
    if (self.taskBlock) {
        self.taskBlock(nil);
    }
}

- (NSMutableArray<UILabel *> *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _labelArray;
}

- (void)enterPersonCenterPage {
    if (self.personHomeBlock) {
        self.personHomeBlock(nil);
    }
}

///进入签约认证界面
- (void)enterMerchant {
    if (self.enterMerchantCertBlock) {
        self.enterMerchantCertBlock();
    }
}

- (void)creditsAction {
    if (self.scoreBlock) {
        self.scoreBlock(nil);
    }
}

- (void)controlAction:(UIControl *)control {
    if (self.headerActionBlock) {
        self.headerActionBlock(self, control);
    }
}

#pragma mark -
#pragma mark - data
///已经停止调用 多次调用 显示红点不准确  ----- 被我用了（lh:勿删！！！）
///别在cell里调用接口 cell复用时候 会重复多次调用
- (void)getUserCheckInfo {
    @weakify(self);
    [JHMyCenterApiManager isAllowCustomerCheck:^(JHAllowSignModel *respObj, BOOL hasError) {
        if (!hasError) {
            @strongify(self);
            if (respObj.isCheckinButtonAllowed) {
                ///如果显示按钮 则跳转到签到页面
                [JHMyCenterApiManager commitCheckInfo];
                self.checkButton.hidden = !respObj.isCheckinButtonAllowed;
                if (self.signActionBlock) {
                    self.signActionBlock(nil);
                }
            }
            else {
                [UITipView showTipStr:JHLocalizedString(@"onlyNewUserCan")];
            }
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL isLogin = [JHRootController isLogin];
    self.loginLabel.hidden = isLogin;
    self.infoView.hidden = !isLogin;
    self.bottomView.hidden = !isLogin;
    self.headerImageView.image = [UIImage imageNamed:isLogin ? @"icon_my_header_bg":@"icon_my_header_bg"];
    if (!isLogin) {
        _avatarImage.image = kDefaultAvatarImage;
        _checkButton.hidden = NO;
    }
    
    [_nickNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView);
    }];
    
    CGFloat top = [JHRootController isLogin] ? 0 : 12;
    [_avatarImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusAndNavBarHeight + top);
    }];
    
    if ([JHRootController isLogin]) {
        [_checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.avatarImage).offset(15);
        }];
    }
    else {
        [_checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(self.avatarImage).offset(3);
        }];
    }
}


@end
