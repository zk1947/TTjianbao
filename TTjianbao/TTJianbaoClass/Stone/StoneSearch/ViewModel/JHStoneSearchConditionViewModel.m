//
//  JHStoneSearchConditionViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSearchConditionViewModel.h"
#import <SVProgressHUD.h>
@implementation JHStoneSearchConditionViewModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self creatDataSource];
    }
    return self;
}

-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    
    NSString *urlStr = FILE_BASE_STRING(@"/anon/stone-label/list");
    [HttpRequestTool postWithURL:urlStr Parameters:@{} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if(IS_ARRAY(respondObject.data))
        {
            self.tagArray = [JHStoneSearchConditionModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        }
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showInfoWithStatus:respondObject.message];
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    }];
}

#pragma mark --------------- 赋值 ---------------
-(void)creatDataSource
{
    NSArray *priceArray = @[@"0-1000", @"1000-5000", @"5000-10000"];
    
    for (int i = 0; i < priceArray.count; i++) {
        JHStoneSearchConditionModel *model = [JHStoneSearchConditionModel new];
        model.label = priceArray[i];
        switch (i) {
            case 0:
            {
                model.lowPrice = @"0";
                model.heighPrice = @"1000";
            }
                break;
                
                case 1:
                {
                    model.lowPrice = @"1000";
                    model.heighPrice = @"5000";
                }
                break;
                
                case 2:
                {
                    model.lowPrice = @"5000";
                    model.heighPrice = @"10000";
                }
                break;
                
            default:
                break;
        }
        [self.priceArray addObject:model];
    }
    
    
    NSArray *array = @[@"1天内", @"3天内", @"7天内", @"14天内"];
    NSArray *array2 = @[@"1", @"3", @"7", @"14"];
    for (int i = 0; i < array.count; i++) {
        JHStoneSearchConditionModel *model = [JHStoneSearchConditionModel new];
        model.label = array[i];
        model.ID = array2[i];
        [self.dateArray addObject:model];
    }
    
    self.sectionTitleArray = @[@"价格区间（元）",@"上架时间",@"标签"];
}

-(void)cancleData
{
    self.lowPrice = @"";
    self.heighPrice = @"";
    
    for(JHStoneSearchConditionModel *model in self.dateArray)
    {
        model.isSelected = NO;
    }
    
    for(JHStoneSearchConditionModel *model in self.tagArray)
    {
        model.isSelected = NO;
    }
}

#pragma mark --------------- get ---------------
-(NSMutableArray *)dateArray
{
    if(!_dateArray)
    {
        _dateArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _dateArray;
}

-(NSMutableArray *)priceArray
{
    if(!_priceArray)
    {
        _priceArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _priceArray;
}

-(NSMutableArray *)tagArray
{
    if(!_tagArray)
    {
        _tagArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _tagArray;
}
@end
