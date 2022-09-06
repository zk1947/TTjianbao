//
//  JHMyShopViewModel.m
//  TTjianbao
//
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMyShopViewModel.h"
#import "UserInfoRequestManager.h"
#import "NSTimer+Help.h"
#import "SVProgressHUD.h"

#import "TTjianbaoMarcoKeyword.h"

@interface JHMyShopViewModel ()

@property (nonatomic, copy) NSTimer *timer;

@end

@implementation JHMyShopViewModel



-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    UserInfoRequestManager *user = [UserInfoRequestManager sharedInstance];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/withdraw/myWithdrawAccount") Parameters:@{@"customerType" : @(user.user.type) , @"customerId":user.user.customerId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (IS_DICTIONARY(respondObject.data)) {
            _dataSource = [JHMyShopModel mj_objectWithKeyValues:respondObject.data];
        }
        [subscriber sendNext:@1];
        [subscriber sendCompleted];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    }];
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        User *user = [UserInfoRequestManager sharedInstance].user;
        
        [self.dataArray addObject:@[@{@"title":@"订单管理",@"imageName":@"icon_shop_order"}]];
        
        [self.dataArray addObject:@[@{@"title":@"订单评价管理",@"imageName":@"icon_shop_reply"}]];
        
        if (user.enCreateVoucher == 1) {
            [self.dataArray addObject:@[@{@"title":@"代金券管理",@"imageName":@"icon_shop_coupon"}]];
        }
        
        [self.dataArray addObject:@[@{@"title":@"问题单",@"imageName":@"icon_shop_question"}]];
        
        [self.dataArray addObject:@[@{@"title":@"宝友心愿单管理",@"imageName":@"icon_shop_wish"}]];
        
        if (!user.isAssistant)
        {
            [self.dataArray addObject:@[@{@"title":@"助理管理",@"imageName":@"icon_shop_assistant"}]];
        }
        
        [self.dataArray addObject:@[@{@"title":@"禁言管理",@"imageName":@"icon_shop_setMute"}]];
        
        [self.dataArray addObject:@[@{@"title":@"订单导出记录",@"imageName":@"icon_shop_takeout"}]];
        
        if (!user.blRole_communityShop)
        {
            [self.dataArray addObject:@[@{@"title":@"直播回放",@"imageName":@"icon_shop_backplay"}]];
            [self.dataArray addObject:@[@{@"title":@"商家培训直播间",@"imageName":@"icon_shop_train"}]];
        }
        
    }
    return self;
}



- (void)setLabel:(UILabel *)label toNum:(CGFloat)number timeInterval:(NSTimeInterval)timeInterval
{
    CGFloat num = number /(timeInterval *25.3333f);
    __block CGFloat lastValue = 0.0;
    
    
    _timer = [NSTimer jh_scheduledTimerWithTimeInterval:0.04 repeats:YES block:^{
        lastValue = lastValue + num;

        if (number <= lastValue) {
            label.text = [NSString stringWithFormat:@"%.2f",number];
            [self.timer invalidate];
            self.timer = nil;
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%.2f",lastValue];
        }
    }];
}

-(void)dealloc
{
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
