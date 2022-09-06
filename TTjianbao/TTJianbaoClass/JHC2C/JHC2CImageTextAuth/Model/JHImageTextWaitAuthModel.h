//
//  JHImageTextWaitAuthModel.h
//  TTjianbao
//
//  Created by zk on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHImageTextWaitAuthModel : NSObject

@end

@interface JHImageTextWaitAuthListModel : NSObject

@property (nonatomic, assign) int pageNo;//页码

@property (nonatomic, assign) int pageSize;//分页总页数

@property (nonatomic, assign) int pages;//分页总页数

@property (nonatomic, assign) BOOL hasMore;//是否有下一页

@property (nonatomic, assign) int sort;//排序 默认0

@property (nonatomic, assign) int total;//（运营后台取值用，app端可忽略）总条数

@property (nonatomic, strong) NSArray *resultList;//分页数据    array    待鉴定列表响应对象

@end

@interface JHImageTextWaitAuthListItemModel : NSObject

@property (nonatomic, assign) int taskId;//鉴定记录id

@property (nonatomic, copy) NSString *img;//用户头像

@property (nonatomic, strong) NSArray *images;//图片

@property (nonatomic, copy) NSString *name;//用户名

@property (nonatomic, copy) NSString *appraisalPayTime;// 鉴定支付时间

@property (nonatomic, copy) NSString *productDesc;//商品描述

@property (nonatomic, assign) int recordInfoId;//图文信息鉴定id

@property (nonatomic, copy) NSString *appraisalFeeYuan;//鉴定费用（单位为元）

@property (nonatomic, copy) NSString *orderCode;//订单编号

@property (nonatomic, assign) CGFloat cellHeight;//

@end

@interface JHImageTextWaitAuthListItemsImageModel : NSObject

@property (nonatomic, copy) NSString *origin;//原图

@property (nonatomic, copy) NSString *small;//缩略图

@property (nonatomic, copy) NSString *medium;//小图

@property (nonatomic, copy) NSString *big;//大图

@property (nonatomic, copy) NSString *w;//宽

@property (nonatomic, copy) NSString *h;//高

@end

@interface JHImageTextWaitAuthDetailModel : NSObject

@property (nonatomic, copy) NSString *categoryFirstName;//一级分类名称

@property (nonatomic, copy) NSString *categorySecondName;//二级分类名称

@property (nonatomic, copy) NSString *appraisalFeeYuan;//鉴定费用

@property (nonatomic, copy) NSString *productDesc;//描述

@property (nonatomic, strong) NSArray *images;//图片

@property (nonatomic, strong) NSArray *videos;//视频

@property (nonatomic, assign) CGFloat cellHeight;//

@end

@interface JHImageTextWaitAuthDetailImageModel : NSObject

@property (nonatomic, copy) NSString *origin;//原图

@property (nonatomic, copy) NSString *medium;//小图

@property (nonatomic, copy) NSString *w;//宽

@property (nonatomic, copy) NSString *big;//大图

@property (nonatomic, copy) NSString *h;//高

@property (nonatomic, copy) NSString *small;//缩略图

@property (nonatomic, assign) CGFloat cellHeight;//

@end

@interface JHImageTextWaitAuthDetailVideoModel : NSObject

@property (nonatomic, copy) NSString *converUrl;//视频封面地址

@property (nonatomic, copy) NSString *url;//视频地址

@property (nonatomic, assign) CGFloat cellHeight;//

@end

NS_ASSUME_NONNULL_END
