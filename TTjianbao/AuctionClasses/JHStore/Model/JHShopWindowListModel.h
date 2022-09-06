//
//  JHShopWindowListModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/5/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  3.1.7 专题（橱窗）页改版
//  导航标签下商品列表数据
//

#import "YDBaseModel.h"
#import "JHGoodsInfoMode.h"
#import "JHShopWindowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHShopWindowListModel : YDBaseModel

//自定义接口请求字段
@property (nonatomic, assign) NSInteger sc_id; //橱窗id
@property (nonatomic, assign) NSInteger tag_id; //标签id，默认0：全部
@property (nonatomic, assign) NSInteger sort; //排序方式 [0:默认排序方式，1:最新=时间逆序，2:价格降序，3:价格升序]

//接口返回数据
@property (nonatomic, strong) NSMutableArray <JHGoodsInfoMode *> *goodsList; //<goods_list>

//自定义layout
@property (nonatomic, strong) NSMutableArray <JHShopWindowLayout *> *layoutList;

- (NSString *)toUrl;
- (void)configModel:(JHShopWindowListModel *)model;

@end

NS_ASSUME_NONNULL_END
