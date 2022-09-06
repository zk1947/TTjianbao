//
//  JHSendLivingTipManeger.m
//  TTjianbao
//
//  Created by apple on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSendLivingTipManeger.h"
#import "CommAlertView.h"
static JHSendLivingTipManeger *manager = nil;
@interface JHSendLivingTipManeger ()
@property (nonatomic,strong) CommAlertView *alert;
@property (nonatomic,strong) NSString * channelLocalId;
@end

@implementation JHSendLivingTipManeger

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });

    return manager;
}

- (void)sendLivingTipManeger:(UIView *)sView andChannelLocalId:(NSString *)channelLocalId{
    
    if ([self.channelLocalId isEqualToString:channelLocalId]) {
        
        [[UIApplication sharedApplication].keyWindow makeToast:@"每天只有一次开播提醒机会哦！" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    self.alert = [[CommAlertView alloc] initWithTitle:@"确认发送开播提醒?" andDesc:@"确认发送后，宝友将收到您的直播push通知。每天只有一次开播提醒机会哦~" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
    [sView addSubview:self.alert];
    @weakify(self);
    self.alert.handle = ^{
        @strongify(self);
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/channel/send-living-tip/auth") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
            self.channelLocalId = channelLocalId;
           
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            if (respondObject.message.length>0) {
                [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.5 position:CSToastPositionCenter];
            }
        }];
    };
}
@end
