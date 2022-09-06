//
//  JHBusinessPublishAttributeCell.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHBusinessGoodsAttributeSelectModel;

@interface JHBusinessPublishTextAttributeCell : UITableViewCell
- (void)setCellModel:(JHBusinessGoodsAttributeSelectModel *)model;
@end

@interface JHBusinessPublishAttributeCell : UITableViewCell
- (void)setCellModel:(JHBusinessGoodsAttributeSelectModel *)model;
@end

NS_ASSUME_NONNULL_END
