//
//  JHUserAuthAlertTableCell.h
//  TTjianbao
//
//  Created by lihui on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHUserAuthModel;

@interface JHUserAuthAlertTableCell : JHWBaseTableViewCell
@property (nonatomic, strong) JHUserAuthModel *authModel;

@end

NS_ASSUME_NONNULL_END
