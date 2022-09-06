//
//  JHVoucherSelectListView.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  直播间 - 代金券多选弹出视图
//

#import <UIKit/UIKit.h>
#import "JHVoucherListModel.h"

NS_ASSUME_NONNULL_BEGIN

//typedef void (^VoucherSelectedBlock)(NSArray<JHVoucherListData *> *selectedList);

@interface JHVoucherSelectListView : UIView

@property (nonatomic, copy) dispatch_block_t closeBlock;

/**
 * sellerId：卖家id
 * customerId：买家id
 */
+ (instancetype)voucherWithSellerId:(NSString *)sellerId customerId:(NSString *)customerId;

@end

NS_ASSUME_NONNULL_END
