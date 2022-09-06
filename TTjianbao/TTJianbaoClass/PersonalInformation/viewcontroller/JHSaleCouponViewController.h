//
//  JHSaleCouponViewController.h
//  TTjianbao
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSaleCouponViewController : JHBaseViewExtController <JXCategoryListContentViewDelegate>

@property (nonatomic, assign) NSInteger state;//1生效， 0失效， 2发放
@property (nonatomic,   copy) JHActionBlock createBlock;
@property (nonatomic,   copy) JHActionBlocks countChangedBlock;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
