//
//  JHShoplistTableCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHSellerInfo;

@protocol JHShoplistTableCellDelegate <NSObject>

- (void)focusShop:(JHSellerInfo *)model;

@end


@interface JHShoplistTableCell : UITableViewCell

@property (nonatomic, weak) id<JHShoplistTableCellDelegate> delegate;

@property (nonatomic, strong) JHSellerInfo *sellerInfo;

@property (nonatomic, assign) CGFloat cellHeight;

- (CGFloat)cellHeight;


@end

NS_ASSUME_NONNULL_END
