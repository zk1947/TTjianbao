//
//  JHGraphicalSubListModel.h
//  TTjianbao
//
//  Created by miao on 2021/6/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHGraphicalSubModel;
@class JHGraphicalBottomModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHGraphicalSubListModel : NSObject


/// 图文鉴定区分买家订单和卖家订单
/// @param isSeller YES ==  卖方
- (instancetype)initWithIsSeller:(BOOL)isSeller;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

/// 如果服务端在返回体里面有这个字段，则请求下一页时客户端需要原封不动的带上这个字段
@property (nonatomic, copy) NSString *cursor;
/// 是否有下一页
@property(nonatomic, assign) BOOL  hasMore;
/// 拿到的结果
@property(nonatomic, strong) NSArray <JHGraphicalSubModel*> *resultList;

@end


@interface JHGraphicalSubModel  : NSObject
@property (nonatomic, copy) NSString *applyTime; // 申请时间（订单创建时间）格式：2021/04/06 11:05
@property (nonatomic, copy) NSString *appraisalCateId;// 鉴定类目id（末级）
@property (nonatomic, copy) NSString *appraisalCateName; // 鉴定类目
@property (nonatomic, strong) NSDictionary *buttonsVo; // 底部button的按钮
@property (nonatomic, copy) NSString *goodsId;//鉴定商品id
@property (nonatomic, copy) NSString * orderCode;//订单id 对应t_order
@property (nonatomic, copy) NSString * orderId;//订单id 对应t_order
@property (nonatomic, copy) NSString  *orderStatus;
@property (nonatomic, copy) NSString *orderStatusText;//订单状态（明文）
@property (nonatomic, strong) NSDictionary *goodsImg;
@property (nonatomic, copy) NSString *showImageSmallUrl;
@property (nonatomic, assign) BOOL  isSeller;
@property (nonatomic, copy) NSString *expireTime;//过期时间戳
@property (nonatomic, strong) NSArray <JHGraphicalBottomModel *> *bottomButtons;

@end



NS_ASSUME_NONNULL_END
