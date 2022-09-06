//
//  JHCustomizeOrderInfoView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeOrderInfoView : JHOrderSubBaseView
@property(strong,nonatomic)JHCustomizeOrderModel * orderMode;
-(void)setupOrderInfo;
 @property(strong,nonatomic)JHFinishBlock viewHeightChangeBlock;
@end

NS_ASSUME_NONNULL_END
