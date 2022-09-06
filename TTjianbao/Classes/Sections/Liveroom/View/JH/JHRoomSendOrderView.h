//
//  JHRoomSendOrderView.h
//  TTjianbao
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPopBaseView.h"
#import "ChannelMode.h"
#import "JHSendOrderModel.h"

//normal("常规订单"),
//processingOrder("加工订单"),
//processingGoods("加工服务订单"),
//roughOrder("原石订单"),
//giftOrder("福利单"),
//daiGouOrder("代购订单");
//customizedOrder   定制服务单
//customizedIntentionOrder   定制服务意向单
#define JHOrderCategoryNorm @"normal" //JHOrderCategoryNormal 与JHOrderCategory Enum重复
#define JHOrderCategoryGiftOrder @"giftOrder"
#define JHOrderCategoryHandling @"processingOrder"
#define JHOrderCategoryHandlingService @"processingGoods"
#define JHOrderCategoryRoughOrder @"roughOrder"
#define JHOrderCategoryDaiGouOrder @"daiGouOrder"
#define JHOrderCategoryCustomizedOrder @"customizedOrder"
#define JHOrderCategoryCustomizedIntentionOrder @"customizedIntentionOrder"

NS_ASSUME_NONNULL_BEGIN

typedef void (^customizePackageNextBlock)(JHSendOrderModel *model);
typedef void (^customizePackageCloseBlock)(void);

@interface JHRoomSendOrderView : JHPopBaseView
@property (copy, nonatomic) NSString *anchorId;
@property (copy, nonatomic) NSString *customerId;
@property (copy, nonatomic) NSString *roomId;
@property (strong, nonatomic) OrderTypeModel *orderCategory;

@property (copy, nonatomic, nullable) NSString *biddingId;
@property (assign, nonatomic) BOOL isLaughOrder;//哄场单
@property (assign, nonatomic) BOOL isAssistant;//助理
@property (assign, nonatomic) BOOL isAnction;//创建竞拍
@property (nonatomic, copy) JHActionBlock auctionUploadFinish;

@property (nonatomic, copy) JHActionBlock clickImage;
@property (nonatomic, copy) JHActionBlock addSelfToView;

@property (nonatomic, copy) JHActionBlocks sendOrderBlock;

@property (nonatomic, assign) BOOL isCustomizeSelf; /// 当前自己是否是定制主播
@property (nonatomic, assign) BOOL isCustomizePackage; /// 当前自己是否是定制套餐
@property (nonatomic,   copy) customizePackageNextBlock nextBlock; /// 定制套餐下一步回调
@property (nonatomic,   copy) customizePackageCloseBlock closeBlock; /// 关闭

- (void)showImageViewAction:(UIImage *)image;
- (void)showOrderTypePicker:(NSMutableArray *)orderTypes;

/// 定制套餐
- (NSDictionary *)getCagetoryInfo;
- (NSString *)getImageUrl;
@end

NS_ASSUME_NONNULL_END
