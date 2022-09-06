//
//  JHRecycleUploadTypeTableViewCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleUploadTypeTableViewCell : UITableViewCell

/// 左侧商品icon
@property(nonatomic, strong, readonly) UIImageView * iconImageView;

/// title
@property(nonatomic, strong, readonly) UILabel * nameLbl;

@end

NS_ASSUME_NONNULL_END
