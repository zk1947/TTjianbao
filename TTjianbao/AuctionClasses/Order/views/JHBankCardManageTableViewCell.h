//
//  JHBankCardManageTableViewCell.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^JHBankCardUpdateOpenBankBlock)(JHBankCardModel *bankCardModel);

@interface JHBankCardManageTableViewCell : UITableViewCell
@property (nonatomic, strong) JHBankCardModel *bankCardModel;
@property(nonatomic, copy) JHBankCardUpdateOpenBankBlock bankCardUpdateOpenBankBlock;
@end

NS_ASSUME_NONNULL_END
