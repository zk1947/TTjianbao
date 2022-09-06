//
//  JHShopHeaderView.h
//  TTjianbao
//
//  Created by apple on 2019/11/22.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHSellerInfo;

@interface JHShopHeaderView : UIView

@property (nonatomic, strong) JHSellerInfo *sellerInfo;

- (void)changeHeaderViewTop:(CGFloat)headerHeight depency:(UIView *)depencyView;




@end

NS_ASSUME_NONNULL_END
