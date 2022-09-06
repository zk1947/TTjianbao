//
//  JHUserAuthOtherCertTableCell.h
//  TTjianbao
//
//  Created by lihui on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHImageViewCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN
@class JHUserAuthModel;

@interface JHUserAuthOtherCertTableCell : JHWBaseTableViewCell
@property (nonatomic, copy) void (^updateBlock)(void);
@property (nonatomic, strong) NSMutableArray *certImageArray;
@property (nonatomic, strong) JHUserAuthModel *authModel;

@end

NS_ASSUME_NONNULL_END
