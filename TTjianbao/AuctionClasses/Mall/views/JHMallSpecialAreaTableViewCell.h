//
//  JHMallSpecialAreaTableViewCell.h
//  TTjianbao
//
//  Created by 姜超 on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMallSpecialAreaModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *const kCellId_JHStoreHomeWindowTableId = @"JHStoreHomeWindowTableIdentifier";
@interface JHMallSpecialAreaTableViewCell : UITableViewCell
+ (CGFloat)cellHeight;
@property(nonatomic,strong) NSMutableArray<JHMallSpecialAreaModel *> * specialAreaModes;
@end

NS_ASSUME_NONNULL_END
