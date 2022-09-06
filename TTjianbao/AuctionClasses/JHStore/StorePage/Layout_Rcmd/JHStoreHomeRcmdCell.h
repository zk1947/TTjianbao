//
//  JHStoreHomeRcmdCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  今日推荐样式cell
//  不要随意修改！！
//

#import "YDBaseTableViewCell.h"
#import "JHStoreHomeRcmdPanel.h"
@class CStoreHomeListData;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHStoreHomeRcmdCell = @"JHStoreHomeRcmdCellIdentifier";

@interface JHStoreHomeRcmdCell : YDBaseTableViewCell

@property (nonatomic, assign) BOOL isLastCell; //是否是当前页最后一条数据
@property (nonatomic, strong) CStoreHomeListData *curData;

#pragma mark - 下列属性Fix：横向滑动ccView联动问题
//@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong, readonly) JHStoreHomeRcmdPanel *panel;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
