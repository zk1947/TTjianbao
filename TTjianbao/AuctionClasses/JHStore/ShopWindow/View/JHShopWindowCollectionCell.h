//
//  JHShopWindowCollectionCell.h
//  TTjianbao
//
//  Created by apple on 2019/11/20.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHShopWindowLayout.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JHCountDownBlock)(JHShopWindowLayout * layput);

@interface JHShopWindowCollectionCell : UICollectionViewCell

@property (nonatomic, strong) JHShopWindowLayout *layout;
@property (nonatomic, copy) JHCountDownBlock countDownEndBlock;

@end

NS_ASSUME_NONNULL_END
