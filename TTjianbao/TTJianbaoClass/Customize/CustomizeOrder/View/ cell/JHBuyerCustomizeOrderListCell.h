//
//  JHBuyerCustomizeOrderListCell.h
//  TTjianbao
//
//  Created by jiangchao on 2020/11/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCustomizeOrderModel.h"
#import "JHOrderViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBuyerCustomizeOrderListCell : UICollectionViewCell
@property(strong,nonatomic)JHCustomizeOrderModel * orderMode;
@property(strong,nonatomic)NSString * orderRemainTime;
@property(weak,nonatomic)id<JHOrderViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
