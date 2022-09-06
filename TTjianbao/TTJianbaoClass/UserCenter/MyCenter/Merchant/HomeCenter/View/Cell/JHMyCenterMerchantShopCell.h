//
//  JHMyCenterShopCell.h
//  TTjianbao
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN
@class JHMyCenterMerchantCellButtonModel;
@interface JHMyCenterMerchantShopCell : JHWBaseTableViewCell
@property (nonatomic, strong) NSMutableArray <JHMyCenterMerchantCellButtonModel *> *buttonArray;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
