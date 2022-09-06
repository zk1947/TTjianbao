//
//  JHMyCompeteMainView.h
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMyCompeteModel.h"
#import "JHMyAuctionListItemModel.h"
#import "JHMyCompeteViewController.h"

@protocol JHMyCompeteDelegate;
@class JHMyCompeteCollectionViewCell;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ButtonMyActionBlock)(JHMyAuctionListItemModel *model, BOOL isPay);

@interface JHMyCompeteMainView : UIView

@property (nonatomic, weak) id<JHMyCompeteDelegate> delegate;

@property (nonatomic, copy) ButtonMyActionBlock buttonActionBlock;

@property (nonatomic, strong) JHMyCompeteViewController *myVc;
 
@end

NS_ASSUME_NONNULL_END
