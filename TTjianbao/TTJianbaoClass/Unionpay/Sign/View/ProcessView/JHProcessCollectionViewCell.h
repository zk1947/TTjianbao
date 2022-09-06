//
//  JHProcessCollectionViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHProcessModel;

static NSString *const kProcessCellIdentifer = @"kProcessCellIdentifer";

@interface JHProcessCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JHProcessModel *processModel;
@property (nonatomic, strong) NSIndexPath *indexPath;


@end

NS_ASSUME_NONNULL_END
