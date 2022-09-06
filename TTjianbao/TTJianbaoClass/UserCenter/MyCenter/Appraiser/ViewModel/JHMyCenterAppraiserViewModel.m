//
//  JHMyCenterAppraiserViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterAppraiserViewModel.h"
#import "JHMyCenterButtonModel.h"

@implementation JHMyCenterAppraiserViewModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addData];
    }
    return self;
}

- (void)addData
{
    [self.dataArray addObject:[JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_0" name:@"打赏收入" type:JHMyCenterButtonTypeReward]];
    
    [self.dataArray addObject:[JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_1" name:@"直播封面设置" type:JHMyCenterButtonTypeSetCover]];
    
    [self.dataArray addObject:[JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_2" name:@"订单鉴定" type:JHMyCenterButtonTypeOrderAppraisal]];
    
    [self.dataArray addObject:[JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_3" name:@"鉴定记录" type:JHMyCenterButtonTypeAppraisalRecord]];
    
    [self.dataArray addObject:[JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_4" name:@"认领交易鉴定" type:JHMyCenterButtonTypeGetAppraisal]];
    
    [self.dataArray addObject:[JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_5" name:@"鉴定贴回复" type:JHMyCenterButtonTypeAppraisalReply]];
    
    [self.dataArray addObject:[JHMyCenterButtonModel creatWithIcon:@"my_center_appraiser_6" name:@"禁言管理" type:JHMyCenterButtonTypeMute]];
}

@end
