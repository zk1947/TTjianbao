//
//  JHCustomerFeeDescTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 定制师个人主页 - 定制费用说明

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@class JHCustomerFeesInfo;

@interface JHCustomerFeeDescTableCell : UITableViewCell

///定制费用列表数组
@property (nonatomic, strong) NSArray <JHCustomerFeesInfo *>*feeInfoArray;

@end

NS_ASSUME_NONNULL_END
