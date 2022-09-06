//
//  JHClaimOrderListViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/25.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHClaimOrderListViewController : JHBaseViewExtController
@property(nonatomic, assign) BOOL isLiving;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) JHActionBlock clickImage;
- (void)catchImage:(UIImage *)image;

- (void)requestData;

@property(nonatomic, assign) BOOL isApraising;

@end

NS_ASSUME_NONNULL_END
