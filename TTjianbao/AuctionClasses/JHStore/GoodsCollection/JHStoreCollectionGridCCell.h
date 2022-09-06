//
//  JHStoreCollectionGridCCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CStoreCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCCellId_JHStoreCollectionGridCCell = @"JHStoreCollectionGridCCellIdentifier";

//typedef void (^CellSelectedBlock)(CStoreCollectionData *selectedData);

@interface JHStoreCollectionGridCCell : UICollectionViewCell

@property (nonatomic, copy) void(^didSelectedBlock)(CStoreCollectionData *data);

@property (nonatomic, assign) BOOL isListLayout;
@property (nonatomic, strong) CStoreCollectionData *curData;

@end

NS_ASSUME_NONNULL_END
