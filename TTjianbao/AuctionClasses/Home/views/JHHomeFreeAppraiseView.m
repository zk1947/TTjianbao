//
//  JHHomeFreeAppraiseView.m
//  TTjianbao
//
//  Created by lihui on 2020/7/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHomeFreeAppraiseView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "CommHelp.h"
#import "UIView+JHGradient.h"
#import "JHNimNotificationModel.h"
#import "YYControl.h"
#import "JHNimNotificationManager.h"

#define descSpace  10
#define imgTitleSpace 3

#define appraiseW  ScreenW*((float)65.5/375)
#define appraiseH  73.f

@interface JHHomeFreeAppraiseView ()
///标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
///累计鉴定
@property (nonatomic, strong) UILabel *sumAppraiseLabel;
///免费申请鉴定
@property (nonatomic, strong) UIButton *freeApplyButton;
///icon_home_jianbao
@property (nonatomic, strong) UIImageView *appraiseImageView;
///介绍的点击View
@property (nonatomic, strong) YYControl *introduceView;

///首席品鉴官 - 王刚
@property (nonatomic, strong) UIButton *wangButton;

@end

@implementation JHHomeFreeAppraiseView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWaitAppraiseData:) name:JHNIMNotifaction object:nil];
        
    }
    return self;
}

- (void)updateWaitAppraiseData:(NSNotification *)notification {
    JHNimNotificationModel *model = (JHNimNotificationModel*)notification.object;
    ///排队申请人数发生改变
    if (model.type == NTESLiveCustomNotificationTypeAudiencedAppraisalCountChange) {
        [self updateAppraiseData];
        return;
    }
    //队列销毁
    if (model.type == NTESLiveCustomNotificationTypeAudiencedRemoveQueue||
        model.type == NTESLiveCustomNotificationTypeAnchourDestroyQueue) {
        [JHNimNotificationManager sharedManager].micWaitMode = nil;
        [self.freeApplyButton setTitle:@"免费申请鉴定" forState:UIControlStateNormal];
    }
}

- (void)setAppraiseCount:(NSInteger)appraiseCount {
    _appraiseCount = appraiseCount;
    NSString *appraiseStr = [CommHelp jh_numberSplitWithComma:_appraiseCount];
    NSString *str = [NSString stringWithFormat:@"已鉴定 %@ 次", appraiseStr];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:str]];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:11.], NSForegroundColorAttributeName:kColor666} range:NSMakeRange(0, str.length)];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontBoldDIN size:18.], NSForegroundColorAttributeName:kColor222} range:NSMakeRange(4, appraiseStr.length)];
    _sumAppraiseLabel.attributedText = attrStr;
}

- (void)initViews {
    _introduceView = [[YYControl alloc] init];
    _introduceView.exclusiveTouch = YES;
    [self addSubview:_introduceView];
    @weakify(self);
    _introduceView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                ///进签约认证界面
                [self enterIntroducePage];
            }
        }
    };

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"免费在线鉴定服务开创者";
    _titleLabel.font = [UIFont fontWithName:kFontMedium size:18.];
    _titleLabel.textColor = kColor222;
    [self addSubview:_titleLabel];
        
//    UIImageView *appImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appraise_home_wanggang"]];
//    appImageView.contentMode = UIViewContentModeScaleAspectFit;
//    _appraiseImageView = appImageView;
//    [self addSubview:appImageView];
        
    _sumAppraiseLabel = [[UILabel alloc] init];
    _sumAppraiseLabel.font = [UIFont fontWithName:kFontNormal size:11.];
    _sumAppraiseLabel.text = @"已鉴定 0 次";
    _sumAppraiseLabel.textColor = kColor666;
    [self addSubview:_sumAppraiseLabel];
    
//    _wangButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_wangButton setTitle:@" 首席品鉴官-王刚 " forState:UIControlStateNormal];
//    [_wangButton setTitle:@" 首席品鉴官-王刚 " forState:UIControlStateHighlighted];
//    [_wangButton setTitleColor:HEXCOLOR(0xB9855D) forState:UIControlStateNormal];
//    [_wangButton setTitleColor:HEXCOLOR(0xB9855D) forState:UIControlStateHighlighted];
//    _wangButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:11.];
//    [_wangButton setBackgroundImage:[UIImage imageNamed:@"appraise_home_name_bg"] forState:UIControlStateNormal];
//    _wangButton.userInteractionEnabled = NO;
//    [self addSubview:_wangButton];
    
    _freeApplyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _freeApplyButton.backgroundColor = HEXCOLOR(0xFEE100);
    [_freeApplyButton setTitle:@"免费申请鉴定" forState:UIControlStateNormal];
    [_freeApplyButton setTitleColor:kColor222 forState:UIControlStateNormal];
    _freeApplyButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:16.];
    _freeApplyButton.layer.cornerRadius = 5.f;
    _freeApplyButton.layer.masksToBounds = YES;
    [self addSubview:_freeApplyButton];
    [_freeApplyButton addTarget:self action:@selector(enterAppraiseListPage) forControlEvents:UIControlEventTouchUpInside];

    [self makeLayouts];
}

- (void)updateAppraiseData {
    JHMicWaitMode *micModel = [JHNimNotificationManager sharedManager].micWaitMode;
    NSString *applyStr;
    if (micModel.isWait && [micModel.waitRoomId integerValue] > 0) {
        ///当前正在申请连麦中
        applyStr = [NSString stringWithFormat:@"返回鉴定直播间(当前排在第%d位)", micModel.waitCount];
    }
    else {
        applyStr = @"免费申请鉴定";
    }
    
    [_freeApplyButton setTitle:applyStr forState:UIControlStateNormal];
}

- (void)makeLayouts {
    [_freeApplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self).offset(-12);
        make.left.equalTo(self).offset(12);
        make.height.mas_equalTo(44);
    }];
    
//    [_appraiseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.freeApplyButton.mas_top);
//        make.right.equalTo(self.freeApplyButton).offset(-5);
//        make.size.mas_equalTo(CGSizeMake(appraiseW, appraiseH));
//    }];
//
//    [_wangButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.appraiseImageView.mas_left).offset(-7);
//        make.bottom.equalTo(self.freeApplyButton.mas_top).offset(-16.5);
//        make.size.mas_equalTo(CGSizeMake(95., 20.));
//    }];
    
    [_sumAppraiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.freeApplyButton.mas_top).offset(-18);
        make.right.equalTo(self.freeApplyButton);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.freeApplyButton.mas_top).offset(-15);
        make.left.equalTo(self.freeApplyButton);
    }];
    
    [_introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.titleLabel);
        make.bottom.equalTo(self.sumAppraiseLabel);
        make.right.equalTo(self);
    }];
    
    [self layoutIfNeeded];
    [_freeApplyButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFED73A), HEXCOLOR(0xFECB33)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

///进入鉴定说明界面
- (void)enterIntroducePage {
    NSLog(@"--- enterIntroducePage ---");
    if (self.introduceBlock) {
        self.introduceBlock();
    }
}

///进入选择鉴定师界面
- (void)enterAppraiseListPage {
    NSLog(@"--- enterAppraiseListPage ---");
    if (self.enterAppraiseBlock) {
        self.enterAppraiseBlock();
    }
}

@end
