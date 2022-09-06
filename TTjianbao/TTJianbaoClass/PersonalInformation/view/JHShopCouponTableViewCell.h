//
//  JHShopCouponTableViewCell.h
//  TTjianbao
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSaleCouponModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHShopCouponTableViewCell : UITableViewCell
@property (nonatomic, strong) JHSaleCouponModel *mode;
@property (nonatomic, copy) JHActionBlock buttonClick;
@property (nonatomic, assign) NSInteger state;//0无效 1有效 2发放
@property (nonatomic, strong)NSIndexPath *indexPath;
- (void)setHeaderStyle;

@end

NS_ASSUME_NONNULL_END
