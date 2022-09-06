//
//  JHC2CProductDetailBottomInfoCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHC2CProoductDetailModel;

@interface JHC2CProductDetailBottomInfoCell : UITableViewCell
@property(nonatomic, strong) JHC2CProoductDetailModel * model;

@property(nonatomic, copy) void (^tapJuBao)(void);

@end

NS_ASSUME_NONNULL_END
