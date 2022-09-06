//
//  JHStoreHomeSellerPanelCCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CStoreHomeSellerData;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCCellId_JHStoreHomeSellerPanelCCell = @"JHStoreHomeSellerPanelCCellIdentifier";

typedef void (^PanelItemSelectedBlock)(CStoreHomeSellerData *selectedData);

@interface JHStoreHomeSellerPanelCCell : UICollectionViewCell

//@property (nonatomic,   copy) PanelItemSelectedBlock didSelectedItemBlock;

@property (nonatomic, strong) CStoreHomeSellerData *sellerData;

@property (nonatomic, assign) BOOL isLastItem; //是否是最后一条数据

@end

NS_ASSUME_NONNULL_END
