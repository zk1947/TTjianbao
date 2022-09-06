//
//  JHStoreCollectionListCCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/1/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CStoreCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCCellId_JHStoreCollectionListCCell = @"JHStoreCollectionListCCellIdentifier";

@interface JHStoreCollectionListCCell : UICollectionViewCell

@property (nonatomic, copy) void(^didSelectedBlock)(CStoreCollectionData *data);
@property (nonatomic, copy) void(^didClickShopBlock)(CStoreCollectionData *data);

@property (nonatomic, assign) BOOL isListLayout;
@property (nonatomic, strong) CStoreCollectionData *curData;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
