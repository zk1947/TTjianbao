//
//  JHMallOpreationTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///直播购物首页 - 运营位部分

#import "JHMallBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class JHMallOperateModel;

@interface JHMallOpreationTableCell : JHMallBaseTableViewCell
+ (CGFloat)viewHeight;

@property (nonatomic, strong) JHMallOperateModel *operateModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
