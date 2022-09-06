//
//  JHMallMoreCategoryView.h
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMallCateModel;

@interface JHMallMoreCategoryView : UIView

@property (nonatomic, copy) NSArray <JHMallCateModel *>*channelArray;
@property (nonatomic, copy) void (^selectBlock)(JHMallCateModel *cateModel, NSInteger selectIndex);
@property (nonatomic, copy) void(^heightBlock)(CGFloat height);

@end

NS_ASSUME_NONNULL_END
