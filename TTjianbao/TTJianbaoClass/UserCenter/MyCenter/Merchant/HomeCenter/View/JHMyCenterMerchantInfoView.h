//
//  JHMyCenterMerchantInfoCell.h
//  TTjianbao
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMerchantInfoView : UIView

@property (nonatomic, strong) UILabel *totalMoneyLabel;

@property (nonatomic, strong) UILabel *incomeFreezeLabel;

@property (nonatomic, strong) UILabel *withdrawLabel;

@property (nonatomic, strong) UILabel *oldIncomeFreezeLabel;

@property (nonatomic, strong) UILabel *oldWithdrawLabel;

@property (nonatomic, copy) dispatch_block_t buttonClick;

@property (nonatomic, strong) UILabel *oldDateTipLabel;

@property (nonatomic, strong) UILabel *dateNewTipLabel;


-(void)reload;

@end

NS_ASSUME_NONNULL_END
