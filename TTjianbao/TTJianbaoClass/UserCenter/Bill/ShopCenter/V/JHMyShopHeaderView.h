//
//  JHMyShopHeaderView.h
//  TTjianbao
//
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyShopHeaderView : UIView

@property (nonatomic, strong) UIImageView *avatorView;

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UILabel *totalMoneyLabel;

@property (nonatomic, strong) UILabel *incomeFreezeLabel;

@property (nonatomic, strong) UILabel *withdrawLabel;

@property (nonatomic, strong) UILabel *oldIncomeFreezeLabel;

@property (nonatomic, strong) UILabel *oldWithdrawLabel;

@property (nonatomic, strong) UILabel *oldDateTipLabel;

@property (nonatomic, strong) UILabel *dateNewTipLabel;

@property (nonatomic, copy) dispatch_block_t buttonClick;

@end

NS_ASSUME_NONNULL_END
