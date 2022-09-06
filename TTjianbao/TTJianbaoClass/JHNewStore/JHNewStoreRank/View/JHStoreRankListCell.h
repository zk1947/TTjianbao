//
//  JHStoreRankListCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHStoreRankListModel;
@interface JHStoreRankListCell : UITableViewCell
@property (nonatomic, strong) JHStoreRankListModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
