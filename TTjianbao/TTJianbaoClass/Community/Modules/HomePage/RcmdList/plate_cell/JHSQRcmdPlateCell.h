//
//  JHSQRcmdPlateCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  推荐页 - 横向热门版块cell
//

#import "YDBaseTableViewCell.h"
#import "JHPlateListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSQRcmdPlateCell : YDBaseTableViewCell

@property (nonatomic, strong) NSMutableArray <JHPlateListData *> *plateList;

+ (CGFloat)cellHeight;

@property (nonatomic, assign) JHPageType pageType;

@end

NS_ASSUME_NONNULL_END
