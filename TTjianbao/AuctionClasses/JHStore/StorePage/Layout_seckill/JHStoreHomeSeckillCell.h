//
//  JHStoreHomeSeckillCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHStoreHomeCardInfoModel;

static NSString *const kCellId_JHStoreHomeTableSeckillId = @"JHStoreHomeSeckillTableIdentifier";

@interface JHStoreHomeSeckillCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic, strong) JHStoreHomeCardInfoModel *cardInfoModel;

@end

NS_ASSUME_NONNULL_END
