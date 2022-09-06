//
//  JHC2CProductUploadDetailInfoView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHC2CUploadProductDetailModel.h"
#import "JHC2CProductUploadJianDingButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductUploadDetailInfoView : UIView

///属性字典， 为空字符串为未选择
@property(nonatomic, strong) NSMutableDictionary * attDic;

@property(nonatomic, strong) NSDictionary * netAttDic;

/// 加个按钮节点击回调
@property(nonatomic, copy) void (^tapPriceBlock)(NSString *currentPrice);

@property(nonatomic, strong) JHC2CProductUploadJianDingButton * jianDingBtn;


/// 价格 0 一口价  1竞拍
@property(nonatomic) NSInteger priceType;

/// 邮费
@property(nonatomic, strong) NSString * postPrice;

/// 价格
@property(nonatomic, strong) NSString * price;

- (instancetype)initWithFrame:(CGRect)frame withModelArr:(NSArray<BackAttrRelationResponse*>*)arr;
@end

NS_ASSUME_NONNULL_END
