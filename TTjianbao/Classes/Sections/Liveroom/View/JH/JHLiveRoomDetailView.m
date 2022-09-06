//
//  JHLiveRoomDetailView.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/28.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHLiveRoomDetailView.h"
#import "UIView+NTES.h"
#import "JHVideoPlayControlBottomView.h"
#import "NTESLiveManager.h"
#import "TTjianbaoHeader.h"
#import "JHAnchorLiveRoomInfoView.h"
#import "JHGrowingIO.h"
#import "JHRecycleAnchorDetailView.h"

@interface JHLiveRoomDetailView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    CGFloat scale;
    CGFloat moveScale;
    CGFloat rate;
    BOOL isBegin;
    NSDictionary* eventDict; //埋点数据
    NSTimeInterval beginShowTime;
    NSString* splashDurationEvent;
}
//直播和主播介绍view
@property (nonatomic, strong) JHAnchorLiveRoomInfoView* anchorLiveRoomInfoView;
@property (nonatomic, strong)UILabel *showScaleLabel;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong)JHRecycleAnchorDetailView *recycleAnchorDetailView;
@end

@implementation JHLiveRoomDetailView

- (void)dealloc
{
    [self trackPageShowTimeByEventId:splashDurationEvent]; //退出直播间,停留时间结束
    NSLog(@"detail dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentSize = CGSizeMake(3*ScreenW, ScreenH);
        self.pagingEnabled = YES;
        //1主播介绍
        [self addSubview:self.anchorLiveRoomInfoView];
        [_anchorLiveRoomInfoView setHidden:NO]; //默认不显示
        _anchorLiveRoomInfoView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        //2其他 , 两者仅能显示一个
        [self addSubview:self.anchorDetailView];
        self.anchorDetailView.hidden = YES;
        self.anchorDetailView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        
        ///回收主播介绍
        [self addSubview:self.recycleAnchorDetailView];
        [self.recycleAnchorDetailView setHidden:YES]; //默认不显示
        self.recycleAnchorDetailView.frame = CGRectMake(0, 0, ScreenW, ScreenH);

        [self scrollRectToVisible:CGRectMake(ScreenW, 0, ScreenW, ScreenH) animated:NO];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        scale = 1.0;
    }
    return self;
}

- (void)setLiveRoomAnchorInfoModel:(JHAnchorInfoModel *)model roleType:(NSInteger)type {
    //0 鉴定观众 1 卖货观众 2卖货助理（JHAudienceUserRoleType）
    if (type == 1 || type == 2  || type == 9 || type == 10) {
        [_anchorDetailView setHidden:YES];
        [_anchorLiveRoomInfoView setHidden:NO];
        [_recycleAnchorDetailView setHidden:YES];
        [_anchorLiveRoomInfoView refreshViewWithChannelLocalId:model.roomId roleType:type];
    } else if (type == 11 || type == 12) {
        [_anchorDetailView setHidden:YES];
        [_anchorLiveRoomInfoView setHidden:YES];
        [_recycleAnchorDetailView setHidden:NO];
        [_recycleAnchorDetailView refreshViewWithChannelLocalId:model.roomId roleType:type];
    } else {
        [_anchorLiveRoomInfoView setHidden:YES];
        [_anchorDetailView setHidden:NO];
        [_recycleAnchorDetailView setHidden:YES];
    }
}

-(UIPinchGestureRecognizer *)pinchGesture
{
    if(!_pinchGesture)
    {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [self addGestureRecognizer:_pinchGesture];
        [self addSubview:self.showScaleLabel];
    }
    return _pinchGesture;
}

- (void)setIsOpenGesture:(BOOL)isOpenGesture {
    _isOpenGesture = isOpenGesture;
    if (_isOpenGesture) {
        
        self.pinchGesture.enabled = YES;
        self.showScaleLabel.hidden = NO;
    }
    else
    {
        self.pinchGesture.enabled = NO;
        self.showScaleLabel.hidden = YES;
    }
}

- (JHAnchorLiveRoomInfoView *)anchorLiveRoomInfoView
{
    if(!_anchorLiveRoomInfoView)
    {
        _anchorLiveRoomInfoView = [JHAnchorLiveRoomInfoView new];
    }
    return _anchorLiveRoomInfoView;
}

- (JHAnchorDetailView *)anchorDetailView {
    if (!_anchorDetailView) {
        _anchorDetailView = [[NSBundle mainBundle] loadNibNamed:@"JHAnchorDetailView" owner:nil options:nil].firstObject;
    }
    
    return _anchorDetailView;
}

- (JHRecycleAnchorDetailView *)recycleAnchorDetailView {
    if (!_recycleAnchorDetailView) {
        _recycleAnchorDetailView = [[JHRecycleAnchorDetailView alloc] init];
    }
    return _recycleAnchorDetailView;
}


- (UILabel *)showScaleLabel {
    if (!_showScaleLabel) {
        _showScaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _showScaleLabel.textColor = [UIColor whiteColor];
        _showScaleLabel.font = [UIFont boldSystemFontOfSize:25];
        _showScaleLabel.hidden = YES;
    }
    return _showScaleLabel;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self endKeyboard];
    [self trackLiveRoomDetailEvent];
}

- (void)endKeyboard {
    if (self.contentOffset.x == ScreenW) {
        
    }else {
        [self endEditing:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([gestureRecognizer.view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.count == 2) {
        return;
    }
    [self.viewController touchesBegan:touches withEvent:event];
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    NSLog(@"=============scale== %f",recognizer.scale);

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.showScaleLabel.center = CGPointMake(self.mj_offsetX+ScreenW/2., ScreenH/2.);
        self.showScaleLabel.hidden = NO;
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {

        moveScale = scale * recognizer.scale;
        if (moveScale>5) {
            moveScale = 5;
            recognizer.scale = moveScale/scale;
        }
        
        if (moveScale<1) {
            moveScale = 1;
            recognizer.scale = moveScale/scale;
        }

        if (self.scaleActionBlock) {
            self.scaleActionBlock(@(moveScale));
        }else {
            [[NIMAVChatSDK sharedSDK].netCallManager changeLensPosition:moveScale];
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        scale = moveScale;
        self.showScaleLabel.hidden = YES;
    }
    
    NSString *dStr      = [NSString stringWithFormat:@"%.2f", moveScale];
    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
    NSString *mScale    = [dn stringValue];
    self.showScaleLabel.text = [NSString stringWithFormat:@"x%@",mScale];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    /*
     直接拖动UISlider，此时touch时间在150ms以内，UIScrollView会认为是拖动自己，从而拦截了event，导致UISlider接受不到滑动的event。但是只要按住UISlider一会再拖动，此时此时touch时间超过150ms，因此滑动的event会发送到UISlider上。
     */
    UIView *view = [super hitTest:point withEvent:event];
    
    if([view isKindOfClass:[UISlider class]] || isBegin)
    {
        //如果响应view是UISlider,则scrollview禁止滑动
        self.scrollEnabled = NO;
    }
    else
    {   //如果不是,则恢复滑动
        if (self.scrollEnabled) {
                self.scrollEnabled = YES;
        }
    }
    return view;
}

#pragma mark - track event
//传入必要参数
- (void)setLiveRoomEventData:(NSDictionary*)dict roleType:(JHAudienceUserRoleType)type
{
    if(type == 1 || type == 2)
    {
        eventDict = [NSDictionary dictionaryWithDictionary:dict];
    }
}
//页面停留时间
- (void)trackPageShowTimeByEventId:(NSString*)eventId
{
    NSMutableDictionary* mDic = [NSMutableDictionary dictionaryWithDictionary:eventDict];
    NSTimeInterval endShowTime = [[NSDate date] timeIntervalSince1970];
    NSString *duration = [NSString stringWithFormat:@"%.f", endShowTime - beginShowTime];
    [mDic setObject:duration forKey:@"duration"];
    
    [JHGrowingIO trackPublicEventId:eventId paramDict:mDic];
}

- (void)trackLiveRoomDetailEvent
{
    if (self.contentOffset.x < ScreenW)
    {//left
        [JHGrowingIO trackPublicEventId:@"left_splash_page" paramDict:eventDict]; //left 进入事件
        beginShowTime = [[NSDate date] timeIntervalSince1970];
        splashDurationEvent = @"left_splash_page_time";
    }
    else if (self.contentOffset.x > ScreenW)
    {//right
        [JHGrowingIO trackPublicEventId:@"right_splash_page" paramDict:eventDict]; //right 进入事件
        beginShowTime = [[NSDate date] timeIntervalSince1970];
        splashDurationEvent = @"right_splash_page_time";
    }
    else
    {//center
        [self trackPageShowTimeByEventId:splashDurationEvent];
    }
}

@end
