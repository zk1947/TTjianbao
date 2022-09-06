//
//  JHUnionSignSalePopView.h
//  TTjianbao
//  Description:寄售签约弹框
//  Created by Jesse on 20/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUnionSignSalePopView : UIView

@property (nonatomic, copy) JHActionBlock activeBlock;

+ (JHUnionSignSalePopView*)showUnsignCannotSaleView; //请他签约
+ (JHUnionSignSalePopView*)showSaleSignView; //寄售签约提示
+ (JHUnionSignSalePopView*)showResellSignView; //转售签约提示
@end

NS_ASSUME_NONNULL_END
