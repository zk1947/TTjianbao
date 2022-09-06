//
//  JHGoodsDetailViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/3/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  商品详情
//

#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodsDetailViewController : YDBaseViewController

@property (nonatomic, copy) NSString *goods_id;     ///商品id
@property (nonatomic, copy) NSString *seller_id;    ///商家id
@property (nonatomic, strong) NSString *ses_id;//场次id

///统计相关
@property (nonatomic, copy) NSString *fromRecommendType; //为您推荐 入口来源「与下面的有点重复」
///entry_type:页面来源 请求数据from参数也用这个 如需修改需慎重
@property (nonatomic, copy) NSString *entry_type; //入口来源
@property (nonatomic, copy) NSString *entry_id; //entry_type对应的入口ID

///Growing埋点
@property (nonatomic, assign) BOOL isFromShopWindow; //是否从橱窗商品列表进入
@property (nonatomic, assign) NSInteger shopWindowId; //橱窗id

@end

NS_ASSUME_NONNULL_END
