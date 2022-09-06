//
//  JHPersonTableViewCell.h
//  TTjianbao
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMyCellModel;

@interface JHPersonTableViewCell : UICollectionViewCell
@property (nonatomic, strong) JHMyCellModel *model;
@end

NS_ASSUME_NONNULL_END
