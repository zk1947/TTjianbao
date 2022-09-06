//
//  JHMarketSpecialCollectionViewCell.h
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMarketHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketSpecialCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JHMarketHomeSpecialItemModel *model;

@property (nonatomic, strong) RACSubject *reloadImageSignal;

+ (CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
