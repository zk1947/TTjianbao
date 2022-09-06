//
//  JHFlashSendOrderModel.h
//  TTjianbao
//
//  Created by user on 2021/10/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface JHFlashSendOrderRequestModel : NSObject
/// 商品标题
@property (nonatomic,   copy) NSString *productTitle;
/// 商品图片
@property (nonatomic,   copy) NSString *productImg;
/// 新二级分类id
@property (nonatomic,   copy) NSString *anewSecondCategoryId;
/// 旧二级分类id
@property (nonatomic,   copy) NSString *oldSecondCategoryId;
/// 商品单价（x.xx）
@property (nonatomic,   copy) NSString *price;
/// 材料费（x.xx）
@property (nonatomic,   copy) NSString *materialCost;
/// 手工费（x.xx）
@property (nonatomic,   copy) NSString *manualCost;
/// 商品库存
@property (nonatomic,   copy) NSString *store;
/// 商品类型 normal-常规 processingOrder-加工 giftOrder-福利单
@property (nonatomic,   copy) NSString *productType;
/// 主播Id
@property (nonatomic,   copy) NSString *anchorId;
@end



/// 闪购本轮用户名单
@class JHFlashSendOrderUserListPeopleModel;
@interface JHFlashSendOrderUserListModel : NSObject
/// 商品编码
@property (nonatomic,   copy) NSString *productCode;
/// 商品状态 0-上架 1-下架 2-已售罄
@property (nonatomic, assign) NSInteger productStatus;
/// 参与人数
@property (nonatomic,   copy) NSString *userNumber;
/// 商品库存
@property (nonatomic,   copy) NSString *usableStore;
/// 总分页
@property (nonatomic,   copy) NSString *total;
///
@property (nonatomic, strong) NSArray<JHFlashSendOrderUserListPeopleModel *> *rows;
@end

@interface JHFlashSendOrderUserListPeopleModel : NSObject
/// 用户昵称
@property (nonatomic,   copy) NSString *nickName;
/// 时间
@property (nonatomic,   copy) NSString *createTime;
@end





/// 闪购记录
@class JHFlashSendOrderRecordListItemModel;
@interface JHFlashSendOrderRecordListModel : NSObject
/// 总分页
@property (nonatomic,   copy) NSString *total;
///
@property (nonatomic, strong) NSArray<JHFlashSendOrderRecordListItemModel *> *rows;
@end


@interface JHFlashSendOrderRecordListItemModel : NSObject
/// 商品编码
@property (nonatomic,   copy) NSString *productCode;
/// 商品标题
@property (nonatomic,   copy) NSString *productTitle;
/// 商品金额
@property (nonatomic,   copy) NSString *price;
/// 创建时间
@property (nonatomic,   copy) NSString *createTime;
@end


NS_ASSUME_NONNULL_END
