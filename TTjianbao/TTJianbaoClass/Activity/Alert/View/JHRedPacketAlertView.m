//
//  JHRedPacketAlertView.m
//  TTjianbao
//
//  Created by apple on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHCircleView.h"
#import "JHRedPacketAlertView.h"
#import "JHRedPacketDetailController.h"
#import "JHRedPacketAlertListView.h"
#import "JHRedPacketDetailViewModel.h"
#import "JHAppAlertViewManger.h"
#import "JHGrowingIO.h"
@interface JHRedPacketAlertView ()<CAAnimationDelegate>

@property (nonatomic, strong) JHRoomRedPacketModel *model;

@property (nonatomic, weak) UIImageView *redView;

@property (nonatomic, weak) UIImageView *avatorView;

@property (nonatomic, weak) UILabel *nickNameLabel;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) JHCircleView *circleView;

@end

@implementation JHRedPacketAlertView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccessMethod) name:NotificationNameRedPacketShareSuccess object:nil];
    }
    return self;
}
#pragma mark --------------- method creatUI ---------------
- (void)createUI
{
    UIImageView *redView = [UIImageView jh_imageViewWithImage:@"red_packet_alert_bg" addToSuperview:self];
    redView.userInteractionEnabled = YES;
    [redView jh_cornerRadius:12];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(280.f, 370.f));
        make.center.equalTo(self);
    }];
    _redView = redView;
    
    UIImageView *avatorView = [UIImageView jh_imageViewAddToSuperview:redView];
    [avatorView jh_cornerRadius:17.5 borderColor:RGB(255, 240, 219) borderWidth:1];
    [avatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(redView);
        make.top.equalTo(redView).offset(30.f);
        make.height.width.mas_equalTo(35.f);
    }];
    _avatorView = avatorView;
    
    UILabel *nickNameLabel = [UILabel jh_labelWithFont:14 textColor:RGB(252.f, 222.f, 179.f) addToSuperView:redView];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatorView.mas_bottom).offset(5.f);
        make.centerX.equalTo(redView);
    }];
    _nickNameLabel = nickNameLabel;
    
    UILabel *titleLabel = [UILabel jh_labelWithBoldFont:22 textColor:RGB(252, 222, 179) addToSuperView:redView];
    titleLabel.textAlignment = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nickNameLabel.mas_bottom).offset(30.f);
        make.centerX.equalTo(redView);
        make.width.mas_equalTo(250.f);
    }];
    _titleLabel = titleLabel;
 
    UIButton *closeButton = [UIButton jh_buttonWithImage:@"appraise_redPacket_close" target:self action:@selector(hiddenAlert) addToSuperView:self];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(redView.mas_right);
        make.bottom.equalTo(redView.mas_top);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
}

- (void)createOpenTypeUIWithModel:(JHRoomRedPacketModel *)model{
    
    [self setModel:model];
    
    UIImageView *lineView = [UIImageView jh_imageViewWithImage:@"red_packet_alert_line" addToSuperview:self.redView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redView).offset(-78.f);
        make.centerX.equalTo(self.redView);
        make.size.mas_equalTo(CGSizeMake(290.f, 65.f));
    }];
    
    if (model.takeConditionDesc.length > 0) {
        
        UILabel *descLabel = [UILabel jh_labelWithText:model.takeConditionDesc font:12 textColor:RGB(252, 222, 179) textAlignment:1 addToSuperView:self.redView];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lineView.mas_top).offset(-5.f);
            make.centerX.equalTo(self.redView);
            make.width.mas_equalTo(250.f);
        }];
    }
    
    NSString *tip = model.tip ? model.tip : @"存入账户津贴，可直接使用";
    UILabel *tipLabel = [UILabel jh_labelWithText:tip font:12 textColor:RGB(252.f, 222.f, 179.f) textAlignment:1 addToSuperView:self.redView];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redView).offset(-18.f);
        make.centerX.equalTo(self.redView);
    }];
    
    UIButton *openButton = [UIButton jh_buttonWithImage:model.takeConditionType == 1 ? @"red_packet_alert_open_bg" : @"red_packet_alert_open" target:self action:@selector(openClick:) addToSuperView:self.redView];
    openButton.layer.zPosition = 50;
    [openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView).offset(7.f);
        make.centerX.equalTo(self.redView);
        make.size.mas_equalTo(CGSizeMake(100.f, 100.f));
    }];
    
    if(model.takeConditionType == 1)
    {
        _circleView = [JHCircleView jh_viewWithColor:UIColor.clearColor addToSuperview:openButton];
        _circleView.jh_height = 66;
        [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(openButton);
            make.size.mas_equalTo(CGSizeMake(66,66));
        }];
        
        UIView *view = [UIView jh_viewWithColor:RGB(255, 144, 82) addToSuperview:_circleView];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.circleView).insets(UIEdgeInsetsMake(1, 1, 1, 1));
        }];
        [view jh_cornerRadius:32];
        @weakify(self);
        [view jh_addTapGesture:^{
            @strongify(self);
            [self makeToast:@"你观看时长不足" duration:2.0 position:CSToastPositionCenter];
        }];
        
        UILabel *timeLabel = [UILabel jh_labelWithFont:26 textColor:RGB(255, 231, 196) textAlignment:1 addToSuperView:view];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(11);
            make.centerX.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(45, 20));
        }];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        
        UIImageView *imageView = [UIImageView jh_imageViewWithImage:@"red_packet_alert_open_word" addToSuperview:view];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_centerY).offset(3);
            make.centerX.mas_equalTo(view);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        RAC(timeLabel, text) = [RACObserve(self.model, currentTime) map:^id _Nullable(id  _Nullable value) {
            @strongify(self);
            NSInteger current = [value integerValue];
            long num = self.model.continueViewTime - current;
            if(num == 0)
            {
                [openButton setImage:JHImageNamed(@"red_packet_alert_open") forState:UIControlStateNormal];
                [self.circleView removeFromSuperview];
            }
            return [NSString stringWithFormat:@"%@s",@(num)];
        }];
        RAC(self.circleView, jh_progress) = RACObserve(model, progress);
        
        self.model.removeBlock = ^{
            @strongify(self);
            [self removeSelfView];
        };
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.model.roomId forKey:@"room_id"];
    [params setValue:self.model.redPacketId forKey:@"red_packet_id"];
    [params setValue:self.model.channelId forKey:@"channel_local_id"];
    [params setValue:self.model.sendCustomerId forKey:@"send_customer_id"];
    [JHGrowingIO trackEventId:@"live_red_packet_popup" variables:params];
}

- (void)createFailTypeUIWithModel:(JHRoomRedPacketModel *)model{
    [self setModel:model];

    UIImageView *lineView = [UIImageView jh_imageViewWithImage:@"red_packet_alert_light_line" addToSuperview:self.redView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redView).offset(-78.f);
        make.centerX.equalTo(self.redView);
        make.size.mas_equalTo(CGSizeMake(290.f, 65.f));
    }];
    
    
    UIButton *detailButton = [UIButton jh_buttonWithTitle:@"看看宝友的手气" fontSize:12 textColor:RGB(252.f, 222.f, 179.f) target:self action:@selector(detailPageClick) addToSuperView:self.redView];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.redView).offset(-10.f);
        make.left.right.equalTo(self.redView);
        make.height.mas_equalTo(33.f);
    }];
}

#pragma mark --------------- set ---------------
- (void)setModel:(JHRoomRedPacketModel *)model
{
    _model = model;
 
    [JHAppAlertViewManger addRedPacketWithId:_model.redPacketId];
    
    [self.avatorView jh_setAvatorWithUrl:_model.sendCustomerImg];
    
    self.nickNameLabel.text = _model.sendCustomerName;
    
    self.titleLabel.text = _model.wishes;
}

#pragma mark --------------- Action ---------------
- (void)detailPageClick
{
    [self sa_methodWithId:self.model.redPacketId name:self.model.wishes type:@"看看宝友的手气"];
    JHRedPacketAlertListView *view = [[JHRedPacketAlertListView alloc]initWithFrame:[JHRouterManager jh_getViewController].view.bounds];
    view.viewModel.redPacketId = self.model.redPacketId;
    view.hasHeader = NO;
    [[JHRouterManager jh_getViewController].view addSubview:view];
    [self removeSelfView];
}

- (void)openClick:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });

    if ([self isLgoin]) {
        if(self.model.takeConditionType == 1 && (self.model.continueViewTime > self.model.currentTime)) {
            [self makeToast:@"你观看时长不足" duration:2.0 position:CSToastPositionCenter];
            return;
        }
        if(self.model.takeConditionType == 2) { ///分享红包
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRedPacketGotoShare object:nil];
            return;
        }
        CABasicAnimation *basicAnim = [CABasicAnimation animation];
        basicAnim.keyPath = @"transform.rotation.y";
        basicAnim.toValue = @(2*M_PI);
        basicAnim.duration = 1.0;
        basicAnim.delegate = self;
        [sender.layer addAnimation:basicAnim forKey:nil];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.model.roomId forKey:@"room_id"];
    [params setValue:self.model.channelId forKey:@"channel_local_id"];
    [params setValue:self.model.redPacketId forKey:@"red_packet_id"];
    [params setValue:self.model.sendCustomerId forKey:@"send_customer_id"];
    [params setValue:@1 forKey:@"is_next"];
    [JHGrowingIO trackEventId:@"live_red_packet_popup_click" variables:params];
}

-(void)shareSuccessMethod {
    [JHRedPacketDetailViewModel openRedPacketWithRedPacketId:self.model.redPacketId CompleteBlock:^(BOOL isSuccess, JHGetRedpacketModel * _Nonnull data, NSString * _Nonnull errorMsg) {

        if (data.conditionCheckFlag == 0) {
            self.model.isOpen = YES;
            if(isSuccess){
                if(self.model.takeConditionType == 3) {
                    ///领取后自动关注状态（服务器改值，不需要手动掉接口）
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameredpacketFollow object:nil];
                }
                JHRedPacketAlertListView *view = [[JHRedPacketAlertListView alloc]initWithFrame:[JHRouterManager jh_getViewController].view.bounds];
                view.viewModel.dataSources = data;
                view.viewModel.redPacketId = self.model.redPacketId;
                view.hasHeader = YES;
                [view reloadViewData];
                [[JHRouterManager jh_getViewController].view addSubview:view];
                [self removeSelfView];
            }
            else
            {
                JHRedPacketAlertView *view = [[JHRedPacketAlertView alloc]initWithFrame:[JHRouterManager jh_getViewController].view.bounds];
                self.model.wishes = data.tips1;
                [view createFailTypeUIWithModel:self.model];
                [[JHRouterManager jh_getViewController].view addSubview:view];
                [self removeSelfView];
            }
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:errorMsg];
            [self removeSelfView];
        }
        [self sa_openMethod];
    }];
}

- (void)sa_openMethod {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.model.trackingParams];
    [params setValue:self.model.redPacketId forKey:@"red_envelope_id"];
    [params setValue:self.model.wishes forKey:@"red_envelope_name"];
    [params setValue:self.model.sendCustomerType forKey:@"anchor_role"];
    [params setValue:self.model.sendCustomerName forKey:@"anchor_nick_name"];
    [params setValue:self.model.sendCustomerId forKey:@"anchor_id"];
    if(self.model.trackingParams && [self.model.trackingParams valueForKey:@"channel_id"]) {
        [params setValue:[self.model.trackingParams valueForKey:@"channel_id"] forKey:@"channel_id"];
    }
    
    if(self.model.trackingParams && [self.model.trackingParams valueForKey:@"channel_local_id"]) {
        [params setValue:[self.model.trackingParams valueForKey:@"channel_local_id"] forKey:@"channel_local_id"];
    }

    [JHAllStatistics jh_allStatisticsWithEventId:@"zbjhdRedEncelopeReceive" params:params type:JHStatisticsTypeSensors];
}

- (void)sa_methodWithId:(NSString *)Id name:(NSString *)name type:(NSString *)type {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:Id forKey:@"red_envelope_id"];
    [params setValue:name forKey:@"red_envelope_name"];
    [params setValue:type forKey:@"operation_type"];
    if(self.model.trackingParams && [self.model.trackingParams valueForKey:@"channel_id"]) {
        [params setValue:[self.model.trackingParams valueForKey:@"channel_id"] forKey:@"channel_id"];
    }
    
    if(self.model.trackingParams && [self.model.trackingParams valueForKey:@"channel_local_id"]) {
        [params setValue:[self.model.trackingParams valueForKey:@"channel_local_id"] forKey:@"channel_local_id"];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"zbjhdRedEncelopeOperation" params:params type:JHStatisticsTypeSensors];
    
}

#pragma mark --------------- 动画delegate ---------------
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self shareSuccessMethod];
}

-(void)showAlert
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath=@"transform.scale";
    anim.values = @[@0.6, @1 , @1.2 , @1];
    anim.duration = 0.5;
    anim.repeatCount = 1;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [self.redView.layer addAnimation:anim forKey:nil];
}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeSelfView];
    }];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.model.roomId forKey:@"room_id"];
    [params setValue:self.model.redPacketId forKey:@"red_packet_id"];
    [params setValue:self.model.channelId forKey:@"channel_local_id"];
    [params setValue:self.model.sendCustomerId forKey:@"send_customer_id"];
    [params setValue:@0 forKey:@"is_next"];
    [JHGrowingIO trackEventId:@"live_red_packet_popup_click" variables:params];
    [self sa_methodWithId:self.model.redPacketId name:self.model.wishes type:@"关闭"];
}

-(void)removeSelfView {
    if(_circleView) {
        [_circleView removeFromSuperview];
    }
    [self removeFromSuperview];
}

-(BOOL)isLgoin {
    if (![JHRootController isLogin]) {
        [self removeSelfView];
        
        [JHGrowingIO trackEventId:@"enter_live_in" from:@"live_popup_receive_click"];
        
        [JHRootController presentLoginVCWithTarget:[JHRouterManager jh_getViewController] complete:^(BOOL result) {

            if (result) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JHNotifactionNameLiveLoginFinish object:nil];
            }
        }];
        return  NO;
    }
    return  YES;
}

/// 显示红包弹框
+ (void)showWithModel:(JHRoomRedPacketModel *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    JHRedPacketAlertView * alertView = [[JHRedPacketAlertView alloc] initWithFrame:window.bounds];
    [window addSubview:alertView];
    [alertView createOpenTypeUIWithModel:sender];
    [alertView showAlert];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:sender.trackingParams];
    [params setValue:sender.redPacketId forKey:@"red_envelope_id"];
    [params setValue:sender.wishes forKey:@"red_envelope_name"];
    [params setValue:sender.sendCustomerType forKey:@"anchor_role"];
    [params setValue:sender.sendCustomerName forKey:@"anchor_nick_name"];
    [params setValue:sender.sendCustomerId forKey:@"anchor_id"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"zbjhdRedEncelopeExposure" params:params type:JHStatisticsTypeSensors];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
