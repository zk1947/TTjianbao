//
//  JHApplyCustomizeOrderCell.h
//  TTjianbao
//
//  Created by jiangchao on 2020/9/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHApplyCustomizeOrderCell : UICollectionViewCell
@property (nonatomic, assign) BOOL iscamera;
@property (nonatomic, nonatomic) OrderMode *orderModel;
@property (strong, nonatomic)  UIImageView *selectImage;
@end

NS_ASSUME_NONNULL_END
