//
//  JHNewUserRedPacketAlertView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/1/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewUserRedPacketAlertView.h"
#import "JHAppAlertViewManger.h"
#import "UIImage+WebP.h"

@implementation JHNewUserRedPacketAlertViewSubModel
@end

@implementation JHNewUserRedPacketAlertViewModel
@end

@interface JHNewUserRedPacketAlertView ()

/// 是否获取了
@property (nonatomic, assign) BOOL isGet;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, weak) UIButton *closeBtn;

@property (nonatomic, weak) YYAnimatedImageView *giftImageView;

@property (nonatomic, strong) JHNewUserRedPacketAlertViewModel *model;

/// 图片是否加载完成
@property (nonatomic, assign) BOOL complete;

@end

@implementation JHNewUserRedPacketAlertView

- (void)dealloc {
    NSLog(@"🔥");
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _number = 0;
        self.backgroundColor = RGBA(0,0,0,0.5);
        YYAnimatedImageView *giftImageView = [[YYAnimatedImageView alloc] init];
        [self addSubview:giftImageView];
        [giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(270, 352));
            make.centerY.equalTo(self).offset(-6);
            make.centerX.equalTo(self);
        }];
        _giftImageView = giftImageView;
        giftImageView.userInteractionEnabled = YES;
        UIView *buttonView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self.giftImageView];
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.giftImageView).offset(15);
            make.bottom.right.equalTo(self.giftImageView).offset(-15);
            make.height.mas_offset(44);
        }];
        @weakify(self);
        [buttonView jh_addTapGesture:^{
            @strongify(self);
            if(self.complete) {
                if(self.model.noReceive && !self.isGet) {
                    [self getNewUserRedPacket];
                }
                else {
                    [self removeFromSuperview];
                    [JHGrowingIO trackEventId:@"xr_tc_jr_click" from:@"home"];
                    [JHRouterManager pushWebViewWithUrl:self.model.received.url title:@""];
                }
            }
        }];
        
        _closeBtn = [UIButton jh_buttonWithImage:@"red_packet_guide_close" target:self action:@selector(removeFromSuperview) addToSuperView:self];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.giftImageView.mas_top);
            make.size.mas_equalTo(CGSizeMake(58, 58));
            make.right.equalTo(self.giftImageView).offset(17);
        }];
    }
    return self;
}

- (void)showImage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"new_user_red_packet" ofType:@"webp"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *webpImage = [UIImage sd_imageWithWebPData:data];
    self.complete = NO;
    if(self.model.noReceive && !self.isGet) {
        @weakify(self);
        [self.giftImageView setImageWithURL:[NSURL URLWithString:self.model.noReceive.img] placeholder:webpImage options:(YYWebImageOptionSetImageWithFadeAnimation) completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(self);
            if(!image) {
                [self removeFromSuperview];
            }
            else {
                self.complete = YES;
            }
        }];
    }
    else if(self.model.received) {
        @weakify(self);
        [self.giftImageView setImageWithURL:[NSURL URLWithString:self.model.received.img] placeholder:webpImage options:(YYWebImageOptionSetImageWithFadeAnimation) completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            @strongify(self);
            if(!image) {
                [self removeFromSuperview];
            }
            else {
                self.complete = YES;
            }
        }];
    }
}

#pragma mark -------- 暴露在外 --------
+ (void)showAlertViewWithModel:(JHNewUserRedPacketAlertViewModel *)model {
    if([model isKindOfClass:[JHNewUserRedPacketAlertViewModel class]]) {
        [JHGrowingIO trackEventId:@"xr_tc_show" from:@"home"];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        JHNewUserRedPacketAlertView *appAlertView = [[JHNewUserRedPacketAlertView alloc] initWithFrame:window.bounds];
        [window addSubview:appAlertView];
        appAlertView.model = model;
        [appAlertView showImage];
    }
}

/// 领取
- (void)getNewUserRedPacket {
    
    self.number += 1;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"home" forKey:@"from"];
    [params setValue:@(self.number) forKey:@"clickCnt"];
    
    [JHGrowingIO trackEventId:@"xr_tc_lq_click" variables:params];
    
    if([JHRootController isLogin]) {
        NSString *url = FILE_BASE_STRING(@"/activity/api/exclusive/newUser/auth/receive");
        [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
            self.isGet = YES;
            [self showImage];
            JHTOAST(respondObject.message);
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            JHTOAST(respondObject.message);
        }];
    }
    else {
        [JHGrowingIO trackEventId:@"enter_live_in" from:@"newuser_red_onekey_click"];
        [JHRootController presentLoginVCWithTarget:JHRootController complete:^(BOOL result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getNewUserRedPacketAlertViewWithAppear];
            });
        }];
    }
}

/// location 新人红包入口   1：源头直购-首页      2：源头直购-商城
+ (void)getNewUserRedPacketEntranceWithLocation:(NSInteger)location complete:(nonnull void (^)(JHNewUserRedPacketAlertViewModel * _Nullable))complete {
        
    NSString *url = FILE_BASE_STRING(@"/activity/api/exclusive/newUser/entry");
//    url = @"http://172.17.214.69:9090/mock/12/activity/api/exclusive/newUser/entry";
    [HttpRequestTool getWithURL:url Parameters:@{@"location" : @(location)} successBlock:^(RequestModel * _Nullable respondObject)
    {
        JHNewUserRedPacketAlertViewModel *model = [JHNewUserRedPacketAlertViewModel mj_objectWithKeyValues:respondObject.data];
        if(complete) {
            complete(model);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if(complete) {
            complete(nil);
        }
    }];
}

/// 弹框 展示中
- (void)getNewUserRedPacketAlertViewWithAppear {
    NSString *url = FILE_BASE_STRING(@"/activity/api/exclusive/newUser/dialog");
    [HttpRequestTool getWithURL:url Parameters:@{@"location" : @(1)} successBlock:^(RequestModel * _Nullable respondObject) {
        JHNewUserRedPacketAlertViewModel *model = [JHNewUserRedPacketAlertViewModel mj_objectWithKeyValues:respondObject.data];
        if(model.show && model.received && !model.noReceive) {
            self.isGet = YES;
            [self showImage];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
    }];
}

/// 弹框
+ (void)getNewUserRedPacketAlertView {
///location = 1 目前只能在源头直购-直播购物调
    NSString *url = FILE_BASE_STRING(@"/activity/api/exclusive/newUser/dialog");
    [HttpRequestTool getWithURL:url Parameters:@{@"location" : @(1)} successBlock:^(RequestModel * _Nullable respondObject) {
        JHNewUserRedPacketAlertViewModel *model = [JHNewUserRedPacketAlertViewModel mj_objectWithKeyValues:respondObject.data];
        [self addModel:model];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
    }];
}

+ (void)addModel:(JHNewUserRedPacketAlertViewModel *)model {
    
    BOOL isLogin = [JHRootController isLogin];
    if((!isLogin && [self newUserRedPacketCanAppear] && model.show) || (isLogin && model.show))
    {
        JHAppAlertModel *m = [JHAppAlertModel new];
        m.type = JHAppAlertTypeNewUserRedPacket;
        m.localType = JHAppAlertLocalTypeMallPage;
        m.typeName = AppAlertNewSellerPacket;
        m.body = model;
        [JHAppAlertViewManger addModelArray:@[m]];
    }
}

///重置新人礼包逻辑 每日一次
+ (BOOL)newUserRedPacketCanAppear {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYYMMdd";
    NSString *dateString = [formatter stringFromDate:date];
    NSInteger num1 = dateString.integerValue;
    
    NSInteger num2 = [[NSUserDefaults standardUserDefaults]integerForKey:@"newUserRedPacketDisAppearDate"];
    if(num1 != num2) {
        [[NSUserDefaults standardUserDefaults] setInteger:num1 forKey:@"newUserRedPacketDisAppearDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return (num1 != num2);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


