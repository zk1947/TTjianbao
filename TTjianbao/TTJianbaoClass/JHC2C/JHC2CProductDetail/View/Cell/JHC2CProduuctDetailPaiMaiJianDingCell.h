//
//  JHC2CProduuctDetailPaiMaiJianDingCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHC2CProoductDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProduuctDetailPaiMaiJianDingCell : UITableViewCell
@property(nonatomic, strong) JHC2CProoductDetailModel * model;

@property(nonatomic, copy) void(^goJianDingBlock)(void);

@end

NS_ASSUME_NONNULL_END
