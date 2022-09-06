//
//  JHStoreHomeListCCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/2/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CStoreChannelGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCCellId_JHStoreHomeListCCell = @"JHStoreHomeListCCellIdentifier";

@interface JHStoreHomeListCCell : UICollectionViewCell
@property (nonatomic, copy) void(^didSelectedBlock)(CStoreHomeGoodsData *data);
@property (nonatomic, strong) CStoreHomeGoodsData *curData;
@end

NS_ASSUME_NONNULL_END
