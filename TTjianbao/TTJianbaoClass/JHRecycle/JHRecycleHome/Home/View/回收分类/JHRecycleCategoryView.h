//
//  JHRecycleCategoryView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/4/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleCategoryCollectionViewCell.h"
#import "JHRecycleHomeModel.h"
#import "CommAlertView.h"
#import "JHWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleCategoryView : UIView

@property(nonatomic, strong) RACSubject *reloadSubject;

- (void)setViewModel:(JHRecycleHomeGetRecyclePlateModel *__nullable)model;
+ (CGFloat)getRecycleHeight;

@end

NS_ASSUME_NONNULL_END
