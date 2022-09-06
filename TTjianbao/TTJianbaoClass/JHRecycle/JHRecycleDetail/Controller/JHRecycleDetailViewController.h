//
//  JHRecycleDetailViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收详情

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleDetailViewController : JHBaseViewController
/** 商品ID*/
@property (nonatomic, copy) NSString *productId;
/** 页面来源，出价记录必传*/
@property (nonatomic, copy) NSString *fromSource;
/**用户身份 1:商家 2:用户*/
@property (nonatomic, assign) NSInteger identityType;

@end

NS_ASSUME_NONNULL_END
