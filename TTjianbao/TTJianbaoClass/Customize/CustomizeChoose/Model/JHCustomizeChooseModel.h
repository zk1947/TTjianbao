//
//  JHCustomizeChooseModel.h
//  TTjianbao
//
//  Created by user on 2020/12/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeChooseTemplatesModel : NSObject
@property (nonatomic, assign) NSInteger ID;   /// 分组ID
@property (nonatomic,   copy) NSString *img;  /// 分组图片
@property (nonatomic,   copy) NSString *name; /// 分组名称
@end



/// 定制师分组列表
@interface JHCustomizeChooseListModel : NSObject
@property (nonatomic, assign) NSInteger defaultId; /// 服务端下发，选中高亮的id
@property (nonatomic, strong) NSArray<JHCustomizeChooseTemplatesModel *> *templates; /// 内容数组
@end



/// 定制师列表请求model
@interface JHCustomizeChooseRequestModel : NSObject
@property (nonatomic, assign) NSInteger customizeFeeId; /// 定制分类ID
@property (nonatomic, assign) NSInteger isExcel;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@end



@class JHCustomizeChooseFeesModel;
@class JHCustomizeChooseOpusListModel;
@class JHCustomizeChooseMaterialsModel;
@interface JHCustomizeChooseModel : NSObject
@property (nonatomic,   copy) NSString *canCustomize;    /// 是否支持定制：0-暂停定制、1-申请定制
@property (nonatomic, assign) NSInteger channelId;       /// 直播间ID
@property (nonatomic,   copy) NSString *commentGrade;    /// 好评度
@property (nonatomic, assign) NSInteger customerId;      /// 定制师ID
@property (nonatomic, assign) NSInteger customizedFeeId; /// 定制分类ID
@property (nonatomic,   copy) NSString *feeName;         /// 定制分类名称
@property (nonatomic, strong) NSArray<JHCustomizeChooseFeesModel *> *fees; /// 定制费用集合
@property (nonatomic,   copy) NSString *img; /// 定制师头像
@property (nonatomic,   copy) NSString *introduction; /// 定制师介绍
@property (nonatomic,   copy) NSString *maxPrice; /// 分类价格最大值
@property (nonatomic,   copy) NSString *minPrice; /// 分类价格最小值
@property (nonatomic,   copy) NSString *name; /// 定制师名称
@property (nonatomic, strong) NSArray<JHCustomizeChooseOpusListModel *> *opusList; /// 代表作列表
@property (nonatomic, assign) NSInteger status; /// 直播间状态：0：禁用； 1：空闲； 2：直播中； 3：直播录制
@property (nonatomic, strong) NSArray<NSString *> *tags; /// 定制师标签
@property (nonatomic,   copy) NSString *title; /// 定制师职称
@property (nonatomic, assign) NSInteger waitCount; /// 直播间连麦排队人数

@property (nonatomic, strong) NSArray<JHCustomizeChooseMaterialsModel *> *materials; /// 可定制材质

@end


/// 可定制材质
@interface JHCustomizeChooseMaterialsModel :NSObject
@property (nonatomic,   copy) NSString *ID;    /// 定制费用ID
@property (nonatomic,   copy) NSString *img;   /// 图片地址
@property (nonatomic,   copy) NSString *name;  /// 定制类别名称
@property (nonatomic, assign) NSInteger supportFlag;
@end



/// 定制费用说明
@class JHCustomizeChooseFeesPriceWrapperModel;
@interface JHCustomizeChooseFeesModel :NSObject
@property (nonatomic, assign) NSInteger ID;                                            /// 定制费用ID
@property (nonatomic,   copy) NSString *img;                                           /// 图片地址
@property (nonatomic, strong) NSString *maxPrice;                                      /// 价格最大值
@property (nonatomic, strong) NSString *minPrice;                                      /// 价格最小值
@property (nonatomic,   copy) NSString *name;                                          /// 定制类别名称
@property (nonatomic, strong) JHCustomizeChooseFeesPriceWrapperModel *maxPriceWrapper; /// 最大价格包装类
@property (nonatomic, strong) JHCustomizeChooseFeesPriceWrapperModel *minPriceWrapper; /// 最小价格包装类
@end

@interface JHCustomizeChooseFeesPriceWrapperModel :NSObject
@property (nonatomic,   copy) NSString *priceFraction;
@property (nonatomic,   copy) NSString *pricePart;
@property (nonatomic,   copy) NSString *priceSign;
@end



/// 代表作实体
@interface JHCustomizeChooseOpusListModel :NSObject
@property (nonatomic,   copy) NSString *coverUrl;          /// 封面
@property (nonatomic, assign) NSInteger customerId;        /// 定制师ID
@property (nonatomic,   copy) NSString *desc;              /// 描述
@property (nonatomic, assign) NSInteger ID;                /// 代表作ID
@property (nonatomic, strong) NSArray<NSString *> *images; /// 代表作附件地址
@property (nonatomic,   copy) NSString *reason;            /// 审核未通过的原因
@property (nonatomic, assign) NSInteger status;            /// 审核状态：0-待审核、1-通过、2-不通过
@property (nonatomic,   copy) NSString *title;             /// 标题
@end











NS_ASSUME_NONNULL_END

