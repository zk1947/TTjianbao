//
//  JHRecycleGoodsDetailInfoNavView.h
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleGoodsDetailInfoNavView : UIView
@property (nonatomic, copy) dispatch_block_t backBlock;
- (void)changeNavBackBlack:(BOOL)isChange;
- (void)setNavViewTitle:(NSString *)str;
- (void)setTitleLabelAlpha:(CGFloat)alpha;
@end






NS_ASSUME_NONNULL_END
