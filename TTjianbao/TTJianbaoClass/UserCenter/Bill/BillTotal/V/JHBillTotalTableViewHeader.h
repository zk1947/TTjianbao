//
//  JHBillTotalTableViewHeader.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBillTotalTableViewHeader : UIView

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, copy) dispatch_block_t detailActionBlock;

@property (nonatomic, copy) dispatch_block_t getMoneyActionBlock;

@property (nonatomic, copy) NSString *accountDate;

+(CGSize)headerViewSize;

@end

NS_ASSUME_NONNULL_END
