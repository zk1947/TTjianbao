//
//  JHLiveRoomRedPacketViewModel.m
//  TTjianbao
//
//  Created by yaoyao on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomRedPacketViewModel.h"
#import "JHRedPacketButton.h"
#import "JHRoomRedPacketModel.h"
#import "JHAppAlertViewManger.h"
#import "NSTimer+Help.h"

@interface JHLiveRoomRedPacketViewModel ()

@property (nonatomic, weak) UIView *littleRedSuperView;

@property (nonatomic, strong) JHRedPacketButton *littleRedControl;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *roomId;

@property (nonatomic, assign) CGRect littleRedRect;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) JHRoomRedPacketModel *redPacketModel;

@end

@implementation JHLiveRoomRedPacketViewModel

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
#pragma mark - get
- (NSMutableArray *)redPacketList {
    if (!_redPacketList) {
        _redPacketList = [NSMutableArray array];
    }
    return _redPacketList;
}

- (JHRedPacketButton *)littleRedControl {
    if (!_littleRedControl) {
        _littleRedControl = [[JHRedPacketButton alloc] initWithFrame:self.littleRedRect];
        [self.littleRedSuperView addSubview:_littleRedControl];
        @weakify(self);
        [_littleRedControl jh_addTapGesture:^{
            @strongify(self);
            [self popBigPacket];
        }];
    }
    return _littleRedControl;
}

#pragma mark - private
- (void)showLittleRedPacket {
    [self updateRedCount:self.redPacketList.count];
}

- (void)popBigPacket {
    if (self.redPacketList.count > 0) {
        JHRoomRedPacketModel *redpacket = self.redPacketList.firstObject;
        redpacket.channelId = self.channelId;
        redpacket.trackingParams = self.trackingParams;
        JHAppAlertModel *model = [JHAppAlertModel new];
        model.type = JHAppAlertTypeRedPacket;
        model.localType = JHAppAlertLocalTypeLiveRoom;
        model.typeName = AppAlertRandomRedPacket;
        model.body = redpacket;
        [JHAppAlertViewManger addModelArray:@[model]];
        
        @weakify(self);
        [RACObserve(redpacket, isOpen) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if([x boolValue]){
                [self updateReceivedRedId:redpacket.redPacketId];
            }
        }];
    }
}

- (void)request {
    
    JHGetRoomRedPacketReqModel *model = [[JHGetRoomRedPacketReqModel alloc] init];
    model.channelId = self.channelId;
    [JH_REQUEST asynPost:model success:^(id respData) {
        [self.redPacketList removeAllObjects];
        NSArray *array = [JHRoomRedPacketModel mj_objectArrayWithKeyValuesArray:respData];
        for (JHRoomRedPacketModel *m in array) {
            if(self.isAnchor || self.isAssistant)
            {
                if(m.takeConditionType == 0)
                {
                    m.roomId = self.roomId;
                    m.channelId = self.channelId;
                    [self.redPacketList addObject:m];
                }
            }
            else
            {
                m.roomId = self.roomId;
                m.channelId = self.channelId;
                [self.redPacketList addObject:m];
            }
        }
        
        [self showLittleRedPacket];
        [self popBigPacket];
        [self updateRedCount:self.redPacketList.count];

    } failure:^(NSString *errorMsg) {

    }];
}

#pragma mark - public
- (void)reuqestRedListChannelId:(NSString *)channelId
                         roomId:(NSString *)roomId
                      superView:(UIView *)superView
                          right:(CGFloat)right
                         top:(CGFloat)top {
    
    _littleRedRect.size = [JHRedPacketButton viewSize];
    _littleRedRect.origin.x = ScreenW - right - _littleRedRect.size.width;
    _littleRedRect.origin.y = top;
    self.littleRedSuperView = superView;
    self.channelId = channelId;
    self.roomId = roomId;
    if(_littleRedControl)
    {
        [_littleRedControl removeFromSuperview];
        _littleRedControl = nil;
    }
    [self request];
}

- (void)showBigPacketWithModel:(JHRoomRedPacketModel *)model {
    
    if((self.isAnchor || self.isAssistant) && model.takeConditionType > 0)
    {
        return;
    }
    if(self.redPacketList.count > 0)
    {
        JHRoomRedPacketModel *m = self.redPacketList.firstObject;
        if(m.removeBlock)
        {
            m.removeBlock();
        }
    }
    [self.redPacketList insertObject:model atIndex:0];
    [self updateRedCount:self.redPacketList.count];
    [self popBigPacket];
    
}

- (void)updateRedCount:(NSInteger)count {
    self.littleRedControl.hidden = count<=0;
    self.littleRedControl.redPacketNum = count;
    if(count > 0)
    {
        self.redPacketModel = self.redPacketList.firstObject;
        if(self.redPacketModel.takeConditionType == 1)
        {
            [self.littleRedControl stopRemoveAllAnimation];
            [self.timer jh_star];
            self.redPacketModel.currentTime = 0;
            self.redPacketModel.progress = 0;
            self.littleRedControl.timeNum = self.redPacketModel.continueViewTime - self.redPacketModel.currentTime;
        }
        else
        {
            [self.littleRedControl starAnimation];
            self.littleRedControl.timeNum = -1;
            [self.timer jh_stop];
        }
    }
}

- (void)updateReceivedRedId:(NSString *)redId {
    for (NSInteger i = self.redPacketList.count-1; i>=0; i--) {
        JHRoomRedPacketModel *model = self.redPacketList[i];
        if ([model.redPacketId isEqualToString:redId]) {
            [self.redPacketList removeObject:model];
        }
    }
    [self updateRedCount:self.redPacketList.count];
}

- (NSTimer *)timer
{
    if(!_timer)
    {
        @weakify(self);
        _timer = [NSTimer jh_scheduledTimerWithTimeInterval:1 repeats:YES block:^{
            @strongify(self);
            self.redPacketModel.currentTime ++;
            self.redPacketModel.progress = self.redPacketModel.currentTime / (CGFloat)self.redPacketModel.continueViewTime;
            self.littleRedControl.timeNum = self.redPacketModel.continueViewTime - self.redPacketModel.currentTime;
            
            if(self.redPacketModel.currentTime >= self.redPacketModel.continueViewTime)
            {
                [self.littleRedControl starAnimation];
                [self.timer jh_stop];
            }
        }];
    }
    return _timer;
}
@end
