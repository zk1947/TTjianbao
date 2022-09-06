//
//  JHAnniversaryViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/3/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnniversaryViewModel.h"
#import <SVProgressHUD.h>
@implementation JHAnniversaryViewModel

+(void)requestOrderBannerViewBlock:(void (^)(BOOL, NSArray<BannerCustomerModel *> * _Nullable))bannerBlock
{
    [HttpRequestTool getWithURL: COMMUNITY_FILE_BASE_STRING(@"/ad/9") Parameters:nil successBlock:^(RequestModel *respondObject) {
        if(!bannerBlock)
        {
            return;
        }
        
        if(!IS_ARRAY(respondObject.data))
        {
            bannerBlock(NO,nil);
            return;
        }
        NSArray *array = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if(array.count && bannerBlock)
        {
            bannerBlock(YES,array);
        }
        else
        {
            bannerBlock(NO,nil);
        }
    } failureBlock:^(RequestModel *respondObject) {
        bannerBlock(NO,nil);
        [SVProgressHUD showInfoWithStatus:respondObject.message];
    }];
}

@end
