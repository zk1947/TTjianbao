//
//  JHBuyerOrderCollectionViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2020/3/4.
//  Copyright © 2020年 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderListTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBuyerOrderCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)OrderMode * orderMode;
@property(strong,nonatomic)NSString * orderRemainTime;
@property(weak,nonatomic)id<JHOrderListTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
