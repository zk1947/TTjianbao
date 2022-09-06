//
//  JHRecycleMeAttentionCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleMeAttentionListModel;
@interface JHRecycleMeAttentionCell : UITableViewCell


- (void)refreshWithHomeSquareModel:(JHRecycleMeAttentionListModel*)model;


@end

NS_ASSUME_NONNULL_END
