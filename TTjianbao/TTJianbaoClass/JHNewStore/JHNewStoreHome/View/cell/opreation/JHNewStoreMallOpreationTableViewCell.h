//
//  JHNewStoreMallOpreationTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMallOperateModel;

@interface JHNewStoreMallOpreationTableViewCell : UITableViewCell

@property (nonatomic, strong) JHMallOperateModel *operateModel;
@property (nonatomic, strong) NSIndexPath *indexPath;


@end

NS_ASSUME_NONNULL_END
