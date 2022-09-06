//
//  JHPurchaseTableViewCell.h
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHCornerTableViewCell.h"
#import "JHPurchaseStoneModel.h"
#import "JHUIButton.h"

#define kPurchaseTableCellHeight (130+kCellMargin)

NS_ASSUME_NONNULL_BEGIN

@interface JHPurchaseTableViewCell : JHCornerTableViewCell

@property (nonatomic, strong) JHUIButton* ctxImage;

- (void)setupSubviews:(JHStonePageType)pageType;//主动调用
- (UIButton*)addSubviewsButton:(JHStonePageType)pageType; //增加button
- (void)setCellData:(JHPurchaseStoneListModel*)model pageType:(JHStonePageType)pageType;

@end

NS_ASSUME_NONNULL_END
