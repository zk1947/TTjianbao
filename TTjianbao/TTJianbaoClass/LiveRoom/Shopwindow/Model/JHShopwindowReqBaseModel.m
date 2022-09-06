//
//  JHShopwindowReqBaseModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopwindowReqBaseModel.h"

@implementation JHShopwindowReqBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"Id" : @"id"
    };
}

+ (NSArray *)mj_ignoredPropertyNames
{
    return @[@"requestType"];
}

+ (JHShopwindowReqBaseModel *)creatModelWithId:(NSString *)Id requestType:(JHShopwindowReqUrlType)requestType
{
    JHShopwindowReqBaseModel *req = [JHShopwindowReqBaseModel new];
    req.requestType = requestType;
    req.Id = Id;
    return req;
}

- (NSString *)uriPath
{
    switch (_requestType) {
        case JHShopwindowReqUrlTypeDetail:///详情（编辑）
            return @"/app/showGoods/detail";
            break;
            
        case JHShopwindowReqUrlTypeDownLine:///下架
            return @"/app/showGoods/downLine";
            break;
            
        case JHShopwindowReqUrlTypeDownListDelete:///历史列表删除
            return @"/app/showGoods/downListDel";
            break;
            
        case JHShopwindowReqUrlTypeUpLine:///上架
            return @"/app/showGoods/upLine";
            break;
            
        case JHShopwindowReqUrlTypeUpListDelete:///上架列表删除
            return @"/app/showGoods/upListDel";
            break;
            
        case JHShopwindowReqUrlTypeAddGoods:///添加商品-完成添加（来自“添加”按钮）
            return @"/app/showGoods/add";
            break;

        case JHShopwindowReqUrlTypeEditGoods:///添加商品-完成添加（来自”编辑“按钮）
            return @"/app/showGoods/edit";
            break;
            
        
        default:
            break;
    }
}

@end

@implementation JHShopwindowAddGoodsReqModel

@end

