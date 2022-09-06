//
//  JHMainViewStoneResaleModel.h
//  TTjianbao
//
//  Created by jiang on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
//寄售原石和已售原石高度
#define StoneBigCellImageRate (355./200.f)
#define kStoneTableCellHeight ((ScreenW - 20)/StoneBigCellImageRate)
NS_ASSUME_NONNULL_BEGIN
@interface JHMainViewStoneResaleModel : NSObject
@property (nonatomic, strong)   NSString* dealPrice;//成交价
@property (nonatomic, strong)   NSString* goodsUrl;
@property (nonatomic, strong)   NSString* goodsCode;
@property (nonatomic, strong)   NSString* goodsTitle;
@property (nonatomic, strong)   NSString* salePrice;
@property (nonatomic, strong)    NSString *seekCount;//求看人数
@property (nonatomic, strong)    NSString *offerCount;//几人出价
@property (nonatomic, strong)   NSString* stoneRestoreId;
@property (nonatomic, strong)   NSString * img;//买家图片
@property (nonatomic, strong)   NSString * offerCustomerName;//买家
@property (nonatomic, strong)   NSString * dealSequence;//第几次交易

@property (nonatomic , assign) NSInteger    title_row;// 标题显示行数
@property (nonatomic , assign) CGFloat      wh_scale; // 图片宽高比

@property (nonatomic , assign) BOOL   isVideo;

//计算之后的高度
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat titleHeight;
//
@property (nonatomic, assign) CGFloat reSaleBigCellheight;
@property (nonatomic, assign) CGFloat soldBigCellheight;
@property (nonatomic, strong) NSString * imgUrl;
@property (nonatomic, strong) NSString * channelName;
@property (nonatomic, strong) NSString * saleCustomerName;

//
@property (nonatomic, strong) NSString * label;

@end

@interface JHMainViewStoneHeaderInfoModel : NSObject
@property (nonatomic, strong)   NSString* dealCount;//成交价
@property (nonatomic, strong)   NSString* totalPrice;
+ (void)requestHeaderInfoCompletion:(JHApiRequestHandler)completion;
@end
NS_ASSUME_NONNULL_END
