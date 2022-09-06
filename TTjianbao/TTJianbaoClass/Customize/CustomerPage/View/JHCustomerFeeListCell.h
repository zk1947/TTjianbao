//
//  JHCustomerFeeListCell.h
//  TTjianbao
//
//  Created by lihui on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 定制师个人主页 - 定制师费用说明cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCustomerFeesInfo;

@interface JHCustomerFeeListCell : UICollectionViewCell

@property (nonatomic, strong) JHCustomerFeesInfo *feeInfo;


@end

NS_ASSUME_NONNULL_END
