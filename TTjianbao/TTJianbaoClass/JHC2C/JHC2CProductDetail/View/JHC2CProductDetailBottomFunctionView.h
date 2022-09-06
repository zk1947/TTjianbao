//
//  JHC2CProductDetailBottomFunctionView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHVButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHC2CProductDetailBottomFunctionView_Type){
    JHC2CProductDetailBottomFunctionView_Type_YiKouJia = 0,///一口价
    JHC2CProductDetailBottomFunctionView_Type_PaiMaiZhong,///拍卖中
    JHC2CProductDetailBottomFunctionView_Type_LingXian,///拍卖中（领先）
    JHC2CProductDetailBottomFunctionView_Type_ZhongPai,///中拍了
    JHC2CProductDetailBottomFunctionView_Type_Finish,///已结束
    JHC2CProductDetailBottomFunctionView_Type_XiaJia,///下架
    JHC2CProductDetailBottomFunctionView_Type_YiShouChu,///已售出
} ;

@interface JHC2CProductDetailBottomFunctionView : UIView

@property(nonatomic, strong) JHVButton * saveBtn;
@property(nonatomic, strong) JHVButton * chatBtn;

@property(nonatomic, strong) UIButton * largeMainBtn;
@property(nonatomic, strong) UIButton * smallLeftBtn;
@property(nonatomic, strong) UIButton * smallRightBtn;

@property(nonatomic, readonly) JHC2CProductDetailBottomFunctionView_Type type;

/// 是否收藏
@property(nonatomic) BOOL  hasCollecte;
- (void)refershStatusWithType:(JHC2CProductDetailBottomFunctionView_Type)type;

@end

NS_ASSUME_NONNULL_END
