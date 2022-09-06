//
//  JHShopCollectionViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/3/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHShopCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^myShopBlock)(void);
@property (nonatomic, copy) void (^shopHomeBlock)(void);

- (void)reloadShopInfo;


@end

NS_ASSUME_NONNULL_END
