//
//  JHBuryPointOperator.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/26.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHBuryPointOperator.h"
#import "NSString+AES.h"
#import "DeviceInfoTool.h"
#import "CommHelp.h"
#import "UserInfoRequestManager.h"
#import "TTjianbaoBussiness.h"
#import "Tracking.h"
@implementation JHBuryPointModel

@end

@implementation JHBuryPointLoginModel

@end

@implementation JHBuryPointShareModel

@end

@implementation JHBuryPointLiveInfoModel

@end

@implementation JHBuryPointVideoInfoModel

@end

@implementation JHBuryPointDiscoverDetailInfoModel

@end

@implementation JHBuryPointEnterBuyGoods

@end

@implementation JHBuryPointCommunityArticleModel

@end

@implementation JHBuryPointEnterTopicDetailModel

@end

@implementation JHBuryPointStoreGoodsDetailBrowseModel

@end

@implementation JHBuryPointStoreGoodsListBrowseModel

@end


@interface JHBuryPointOperator ()
@property(nonatomic, strong)JHBuryPointModel *buryModel;
@end

@implementation JHBuryPointOperator
static JHBuryPointOperator *instance = nil;

+ (JHBuryPointOperator *)shareInstance{
    static dispatch_once_t once_Token;
    dispatch_once(&once_Token, ^{
        instance = [[JHBuryPointOperator alloc] init];
    });
    
    return instance;
}

- (void)aesPostString:(NSString *)jsonString {
    NSLog(@" >BuryPoint2埋点==%@",jsonString);
    
    [HttpRequestTool getWithURL:BurySeverURL Parameters:@{@"cnt":[jsonString aci_encryptWithAES]} successBlock:^(RequestModel *respondObject) {
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}



- (JHBuryPointModel *)buryModel {
    if (!_buryModel) {
        JHBuryPointModel *bury = [[JHBuryPointModel alloc] init];
        bury.ver = @"1.0";
        bury.app_ver = [DeviceInfoTool getAppVersion];
        bury.duid =  [CommHelp getKeyChainUUID];
        bury.platform = @"ios";
        _buryModel = bury;
    }
    
    return _buryModel;
}

- (void)appStartBury {
    JHBuryPointLoginModel *model = [[JHBuryPointLoginModel alloc] init];
    model.brand = @"Apple";
    model.model = [DeviceInfoTool deviceVersion];
    model.os_ver = [UIDevice currentDevice].systemVersion;
    model.app_ver = [DeviceInfoTool getAppVersion];
    model.channel = JHAppChannel;
    model.platform = @"ios";
    model.is_new = [CommHelp isInstalledApp] == 1?0:1;
    model.reyun_id = [Tracking getDeviceId];
    model.idfa = [CommHelp deviceIDFA];

    self.buryModel.e_type = @"appStart";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
    
    
}


- (void)devInBury {
    JHBuryPointLoginModel *model = [[JHBuryPointLoginModel alloc] init];
    model.brand = @"Apple";
    model.model = [DeviceInfoTool deviceVersion];
    model.os_ver = [UIDevice currentDevice].systemVersion;
    model.app_ver = [DeviceInfoTool getAppVersion];
    model.channel = JHAppChannel;
    model.platform = @"ios";
    model.is_new = [CommHelp isInstalledApp] == 1?0:1;
    model.reyun_id = [Tracking getDeviceId];
    model.idfa = [CommHelp deviceIDFA];

    self.buryModel.e_type = @"devIn";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
        
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/opt/event/app_active") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

- (void)devOutBury {
    JHBuryPointLoginModel *model = [[JHBuryPointLoginModel alloc] init];
    model.brand = @"Apple";
    model.model = [DeviceInfoTool deviceVersion];
    model.os_ver = [UIDevice currentDevice].systemVersion;
    model.app_ver = [DeviceInfoTool getAppVersion];
    model.channel = JHAppChannel;
    model.platform = @"ios";
    model.is_new = [CommHelp isInstalledApp] == 1?0:1;
    model.reyun_id = [Tracking getDeviceId];
    model.idfa = [CommHelp deviceIDFA];
    
    self.buryModel.e_type = @"devOut";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/opt/event/app_inactive") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
    
}


- (void)userLogoutBury {
    self.buryModel.e_type = @"userLogout";
    self.buryModel.e_info = [NSDictionary dictionary];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

- (void)shareBuryWithModel:(JHBuryPointShareModel *)model {
    self.buryModel.e_type = @"share";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

+ (void)buryWithEventId:(NSString *)eventId param:(id)param {
    [[JHBuryPointOperator shareInstance] buryWithEtype:eventId param:param];
}

- (void)buryWithEtype:(NSString *)eType param:(NSDictionary *)param
{
    User *u = [UserInfoRequestManager sharedInstance].user;
    self.buryModel.e_type = eType;
    self.buryModel.e_info = param;
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = u.customerId ? u.customerId : @"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

- (void)liveLikeBuryWithModel:(JHBuryPointLiveInfoModel *)model isDouble:(BOOL)isDouble {
    self.buryModel.e_type = isDouble?@"live_watch_doubleland":@"live_landbtn";

    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
    
}

- (void)liveInBuryWithModel:(JHBuryPointLiveInfoModel *)model {
    self.buryModel.e_type = @"liveIn";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
    
}

- (void)liveOutBuryWithModel:(JHBuryPointLiveInfoModel *)model {
    self.buryModel.e_type = @"liveOut";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
    
}



- (void)videoInBuryWithModel:(JHBuryPointVideoInfoModel *)model {
    self.buryModel.e_type = @"videoPlayStart";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
    
}

- (void)videoOutBuryWithModel:(JHBuryPointVideoInfoModel *)model {
    self.buryModel.e_type = @"videoPlayEnd";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.c_time = [[CommHelp getNowTimeTimestampMS] integerValue];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
    
}

- (void)discoverDetailInBuryWithModel:(JHBuryPointDiscoverDetailInfoModel *)model {
    self.buryModel.e_type = @"sqDetailViewStart";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

- (void)discoverDetailOutBuryWithModel:(JHBuryPointDiscoverDetailInfoModel *)model {
    self.buryModel.e_type = @"sqDetailViewEnd";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

- (void)discoverEnterBuyGoodsQyWithModel:(JHBuryPointEnterBuyGoods *)model {
    self.buryModel.e_type = @"sqDetailInquiry";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

//进入话题页统计
- (void)enterTopicDetailWithModel:(JHBuryPointEnterTopicDetailModel *)model {
    self.buryModel.e_type = JHTrackSQIntoTopicPage;
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

- (void)viewTimeWithChannelLocalId:(NSString *)Id type:(NSInteger)type bz_val:(NSInteger)bz_val {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"bz_id"] = Id;
    dic[@"type"] = @(type);
    dic[@"bz_val"] = @(bz_val);
    dic[@"time"] = @([[CommHelp getNowTimeTimestampMS] integerValue]);
    
    self.buryModel.e_type = @"viewTime";
    self.buryModel.e_info = dic;
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
//    “bz_id”:234234,//业务id - 给谁点 channelLocalId
//    “type”: ,公共值类型
//    “bz_val”:1,//业务值

}

///商城商品详情开始浏览
- (void)beginBrowseStoreGoodsDetail:(JHBuryPointStoreGoodsDetailBrowseModel *)model {
    self.buryModel.e_type = @"saleWareDetailViewStart";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

///商城商品详情结束浏览
- (void)endBrowseStoreGoodsDetail:(JHBuryPointStoreGoodsDetailBrowseModel *)model {
    self.buryModel.e_type = @"saleWareDetailViewEnd";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

///商城商品列表Item浏览
- (void)browseStoreGoodsList:(JHBuryPointStoreGoodsListBrowseModel *)model {
    self.buryModel.e_type = @"saleWareListItemBrowse";
    self.buryModel.e_info = [model mj_keyValues];
    self.buryModel.uid = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    NSString *string = [self.buryModel mj_JSONString];
    [self aesPostString:string];
}

@end
