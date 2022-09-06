//
//  JHC2CProductDetailJianDingCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHC2CProoductDetailModel;

@interface JHC2CProductDetailJianDingCell : UITableViewCell

/// 详情model
@property(nonatomic, strong) JHC2CProoductDetailModel * model;

@property(nonatomic, strong) NSString * productID;

@end

NS_ASSUME_NONNULL_END
