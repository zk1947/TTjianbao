//
//  JHMarketCategoryTableViewCell.h
//  TTjianbao
//
//  Created by zk on 2021/5/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMarketHomeModel.h"
#import "JHMarketScrollAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketCategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) JHMarketScrollAnimationView *animationView;

@property (nonatomic, copy) NSArray <JHMarketHomeKingKongItemModel *>*categoryInfos;

@end

NS_ASSUME_NONNULL_END
