//
//  JHMyCenterMerchantCustomizeCell.h
//  TTjianbao
//
//  Created by wangjianios on 2020/11/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

@class JHMyCenterMerchantCellButtonModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMerchantCustomizeCell : JHWBaseTableViewCell
@property (nonatomic, strong) NSMutableArray <JHMyCenterMerchantCellButtonModel *> *buttonArray;

@end

NS_ASSUME_NONNULL_END
