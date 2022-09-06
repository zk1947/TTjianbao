//
//  JHHotwordCCell.h
//  TTjianbao
//
//  Created by LiHui on 2020/2/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHHotWordModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHHotwordCCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) JHHotWordModel *searchData;

@end

NS_ASSUME_NONNULL_END
