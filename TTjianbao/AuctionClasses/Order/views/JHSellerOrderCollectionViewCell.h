//
//  JHSellerOrderCollectionViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2020/3/4.
//  Copyright © 2020年 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSellerOrderListTableViewCell.h"
@interface JHSellerOrderCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)OrderMode * orderMode;
@property(assign,nonatomic)BOOL hideButtonView;
@property(assign,nonatomic)BOOL isProblem;
@property(strong,nonatomic)NSString * orderRemainTime;
@property(weak,nonatomic)id<JHSellerOrderListTableViewCellDelegate>delegate;
@end
