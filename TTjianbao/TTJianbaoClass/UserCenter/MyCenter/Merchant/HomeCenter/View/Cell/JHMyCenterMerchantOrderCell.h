//
//  JHMyCenterMerchantOrderCell.h
//  TTjianbao
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

@class JHMyCenterMerchantCellButtonModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMerchantOrderCell : JHWBaseTableViewCell

@property (nonatomic, strong) NSMutableArray <JHMyCenterMerchantCellButtonModel *> *buttonArray;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
