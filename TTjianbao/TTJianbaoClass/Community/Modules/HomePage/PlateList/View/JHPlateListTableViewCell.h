//
//  JHPlateListTableViewCell.h
//  TTjianbao
//
//  Created by wangjianios on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN
@class JHPlateListData;

@interface JHPlateListTableViewCell : JHWBaseTableViewCell

///版块信息
@property (nonatomic, strong) JHPlateListData *model;

@end

NS_ASSUME_NONNULL_END
