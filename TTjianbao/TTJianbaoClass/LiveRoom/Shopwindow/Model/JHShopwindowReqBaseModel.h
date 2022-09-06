//
//  JHShopwindowReqBaseModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHShopwindowReqUrlType)
{
    ///详情（编辑）
    JHShopwindowReqUrlTypeDetail= 1,
    
    ///下架
    JHShopwindowReqUrlTypeDownLine,
    
    ///历史列表删除
    JHShopwindowReqUrlTypeDownListDelete,
    
    ///上架
    JHShopwindowReqUrlTypeUpLine,
    
    ///上架列表删除
    JHShopwindowReqUrlTypeUpListDelete,
    
    ///添加商品-完成添加（来自“添加”按钮）
    JHShopwindowReqUrlTypeAddGoods,
    
    ///添加商品-完成添加（来自”编辑“按钮）
    JHShopwindowReqUrlTypeEditGoods,
};


@interface JHShopwindowReqBaseModel : JHReqModel

@property (nonatomic, copy) NSString *Id;

///请求类型（删除 上架。。。。）
@property (nonatomic, assign) JHShopwindowReqUrlType requestType;

+ (JHShopwindowReqBaseModel *)creatModelWithId:(NSString *)Id requestType:(JHShopwindowReqUrlType)requestType;

@end

@interface JHShopwindowAddGoodsReqModel : JHShopwindowReqBaseModel
//添加[无id]/修改橱窗商品
@property (nonatomic, copy) NSString* goodsCateId;// 宝贝品类 ,
@property (nonatomic, copy) NSString* listImage;// 图片 ,
@property (nonatomic, copy) NSString* price;// 价格 ,
@property (nonatomic, copy) NSString* title;// 商品名称

@property (nonatomic, copy) NSString* goodsNewCateId;// 商品名称

@end

NS_ASSUME_NONNULL_END
