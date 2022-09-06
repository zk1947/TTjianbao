//
//  JHOrderDetailMode.m
//  TTjianbao
//
//  Created by jiang on 2019/12/13.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHOrderDetailMode.h"
#import "JHGraphicalBottomModel.h"

@implementation JHOrderDetailMode
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"myCouponVoList" : @"CoponMode",
        @"mySellerCouponVoList" : @"CoponMode",
        @"attachmentList" : @"JHRestoreOrderAttachmentMode",
        @"discountAllCouponVoList": @"CoponMode",
        @"goodsImgs": @"JHGroDetailImageUrlModel",
    };
}
-(void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues{

//    if (self.orderPrice) {
//        self.orderPrice = [NSString stringWithFormat:@"%.2f",[self.orderPrice floatValue]];
//    }
}

- (NSArray<JHGraphicalBottomModel *> *)bottomButtons {
    NSMutableArray *resultList = [NSMutableArray arrayWithCapacity:1];
    NSArray *allKeys = self.buttonsVo.allKeys;
    for (NSString *key in allKeys) {
        NSString *isShow = [self.buttonsVo objectForKey:key];
        JHGraphicalBottomModel *model = [[JHGraphicalBottomModel alloc]init];
        model.kindName = key;
        model.isShow = [isShow isEqualToString:@"1"] ? YES : NO;
        if (model.isShow) {
            [resultList addObject:model];
        }
    }
    return [[resultList reverseObjectEnumerator] allObjects];
}

@end

@implementation JHRestoreOrderAttachmentMode

@end

@implementation JHGroDetailImageUrlModel

@end

@implementation JHOrderCateMode
+(NSArray*)getSellerOrderListCateArry{
 
   NSMutableArray *array = [NSMutableArray array];
       JHOrderCateMode * mode1 = [[JHOrderCateMode alloc]init];
       mode1.title = @"全部";
       mode1.status = @"all";
       [array addObject:mode1];
       
       JHOrderCateMode * mode2 = [[JHOrderCateMode alloc]init];
       mode2.title = @"待付款";
       mode2.status = @"waitpay";
       [array addObject:mode2];
    
       JHOrderCateMode * mode3 = [[JHOrderCateMode alloc]init];
       mode3.title = @"待发货";
       mode3.status = @"waitsellersend";
       [array addObject:mode3];
    
       JHOrderCateMode * mode4 = [[JHOrderCateMode alloc]init];
       mode4.title = @"已发货";
       mode4.status = @"portalsent";
       [array addObject:mode4];
    
       JHOrderCateMode * mode5 = [[JHOrderCateMode alloc]init];
       mode5.title = @"已完成";
       mode5.status = @"buyerreceived";
       [array addObject:mode5];
    
       JHOrderCateMode * mode6 = [[JHOrderCateMode alloc]init];
          mode6.title = @"退款售后";
          mode6.status = @"refund";
          [array addObject:mode6];
      
       return array ;
    
}
+(NSArray*)getBuyerOrderListCateArry{
    
   
    NSMutableArray *array = [NSMutableArray array];
    JHOrderCateMode * mode1 = [[JHOrderCateMode alloc]init];
    mode1.title = @"全部";
    mode1.status = @"all";
    [array addObject:mode1];
    
    JHOrderCateMode * mode2 = [[JHOrderCateMode alloc]init];
    mode2.title = @"待付款";
    mode2.status = @"waitpay";
    [array addObject:mode2];
    
    JHOrderCateMode * mode3 = [[JHOrderCateMode alloc]init];
    mode3.title = @"待卖家发货";
    mode3.status = @"waitsellersend";
    [array addObject:mode3];
    
       JHOrderCateMode * mode8 = [[JHOrderCateMode alloc]init];
       mode8.title = @"待平台收货";
       mode8.status = @"sellersent";
       [array addObject:mode8];
    
    JHOrderCateMode * mode4 = [[JHOrderCateMode alloc]init];
    mode4.title = @"待鉴定";
    mode4.status = @"waitportalappraise";
    [array addObject:mode4];
    
    JHOrderCateMode * mode5 = [[JHOrderCateMode alloc]init];
    mode5.title = @"待收货";
    mode5.status = @"portalsent";
    [array addObject:mode5];
    
    JHOrderCateMode * mode6 = [[JHOrderCateMode alloc]init];
    mode6.title = @"已完成";
    mode6.status = @"buyerreceived";
    [array addObject:mode6];
    
    JHOrderCateMode * mode7 = [[JHOrderCateMode alloc]init];
    mode7.title = @"退款售后";
    mode7.status = @"refund";
    [array addObject:mode7];
    
    return array;
    
}
@end

