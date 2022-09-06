//
//  JHStoreHomeRcmdPanelCCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/22.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CStoreHomeGoodsData;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCCellId_JHStoreHomeRcmdPanelCCell = @"JHStoreHomeRcmdPanelCCellIdentifier";

typedef void (^PanelItemSelectedBlock)(CStoreHomeGoodsData *selectedData);

@interface JHStoreHomeRcmdPanelCCell : UICollectionViewCell

@property (nonatomic, copy) PanelItemSelectedBlock didSelectedItemBlock;
@property (nonatomic, copy) void(^countDownEndBlock)(CStoreHomeGoodsData *data);

@property (nonatomic, strong) CStoreHomeGoodsData *goodsData;

@end

NS_ASSUME_NONNULL_END
