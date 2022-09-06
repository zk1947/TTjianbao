//
//  JHJHMyCenterCollectionView.h
//  TTjianbao
//
//  Created by apple on 2020/4/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMyCenterCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/// 个人中心商家的模块
@interface JHMyCenterCollectionView : UIView

///每行多少个（默认四个）
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSMutableArray <JHMyCenterMerchantCellButtonModel *> *buttonArray;

@end

NS_ASSUME_NONNULL_END
