//
//  JHGraphiclOrderListCell.h
//  TTjianbao
//
//  Created by 张坤 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGraphicalSubListModel.h"
@protocol JHGraphiclOrderDelegate;
@class JHGraphicalSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHGraphiclOrderListCell : UICollectionViewCell
@property (strong,nonatomic) JHGraphicalSubModel *orderMode;
@property (strong,nonatomic) NSString * orderRemainTime;
@property (nonatomic, weak) id<JHGraphiclOrderDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
