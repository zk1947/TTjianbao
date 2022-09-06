//
//  JHNewShopDetailInfoHeaderViewCell.h
//  TTjianbao
//
//  Created by user on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHNewShopDetailInfoModel;
@interface JHNewShopDetailInfoHeaderViewCell : UITableViewCell
@property (nonatomic, strong)JHNewShopDetailInfoModel *shopHeaderInfoModel;
///关注按钮点击回调
@property (nonatomic,   copy) JHActionBlock    followSuccessBlock;
@property (nonatomic,   copy) dispatch_block_t clickBlock;
@end

NS_ASSUME_NONNULL_END
