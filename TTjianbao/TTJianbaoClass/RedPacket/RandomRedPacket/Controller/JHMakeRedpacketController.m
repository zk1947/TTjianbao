//
//  JHMakeRedpacketController.m
//  TTjianbao
//
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMakeRedpacketController.h"
#import "JHRedpacketDataModel.h"
#import "JHMakeRedpacketView.h"
#import "JHPayViewController.h"

@interface JHMakeRedpacketController () <JHMakeRedpacketViewDelegate>

@property (nonatomic, strong) JHMakeRedpacketView* mView;
@property (nonatomic, strong) JHRedpacketDataModel* mData;

///红包数量（神测埋点用）
@property (nonatomic, assign) NSInteger count;

@end

@implementation JHMakeRedpacketController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //request
    JH_WEAK(self)
    [self.mData requestMakeRedpacketPageData:self.liveRoomChannelId resp:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        if(errorMsg)
            [SVProgressHUD showErrorWithStatus:errorMsg];
        else
            [self.mView refreshView:respData];
    }];
    //view
//    [self setupToolBarWithTitle:@"发红包"];
    self.title = @"发红包";
    [self.mView drawSubview];
}

- (JHMakeRedpacketView *)mView
{
    if(!_mView)
    {
        _mView = [[JHMakeRedpacketView alloc] initWithDelegate:self];
        [self.view addSubview:_mView];
        [_mView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.mas_equalTo(self.jhNavView.mas_bottom);
        }];
    }
    return _mView;
}

- (JHRedpacketDataModel *)mData
{
    if(!_mData)
    {
        _mData = [JHRedpacketDataModel new];
    }
    return _mData;
}

#pragma mark - delegate
- (void)chargeMoneyIntoRedpacket:(JHMakeRedpacketReqModel*)model
{
    model.channelId = self.liveRoomChannelId;//直播间传值
    self.count = model.totalCount;
    [SVProgressHUD show];
    JH_WEAK(self)
    [self.mData makeRedpacketRequest:model respone:^(id respData, NSString *errorMsg) {
        //跳转支付页
        JH_STRONG(self)
        if(errorMsg)
            [SVProgressHUD showErrorWithStatus:errorMsg];
        else
        {
            [self gotoPayViewController:respData];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)gotoPayViewController:(JHMakeRedpacketModel*)model
{
    JHPayViewController* payViewController = [JHPayViewController new];
    payViewController.redPacketMode = model;
    @weakify(self);
    payViewController.complete = ^{
        @strongify(self);
        [self sa_method:model];
    };
    [self.navigationController pushViewController:payViewController animated:YES];
}

- (void)sa_method:(JHMakeRedpacketModel*)model {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.channel.channelId forKey:@"channel_id"];
    [params setValue:self.channel.channelLocalId forKey:@"channel_local_id"];
    [params setValue:self.channel.title forKey:@"channel_name"];
    [params setValue:model.payMoney forKey:@"red_envelope_amount"];
    [params setValue:@(self.count) forKey:@"red_envelope_number"];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"redEnvelopeDistribute" params:params type:JHStatisticsTypeSensors];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
