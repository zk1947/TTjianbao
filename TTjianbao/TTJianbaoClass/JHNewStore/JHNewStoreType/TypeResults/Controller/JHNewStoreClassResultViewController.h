//
//  JHNewStoreClassResultViewController.h
//  TTjianbao
//
//  Created by hao on 2021/8/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  商场分类结果页

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreClassResultViewController : JHBaseViewController
///分类名称
@property (nonatomic, copy) NSString *cateName;
///分类id
@property (nonatomic, copy) NSString *cateId;
///点击来源 1:查看全部(一级分类)  2：列表（二级分类）
@property (nonatomic, copy) NSString *cateLevel;
///一分类名称（注：只有二级分类过来需要传）
@property (nonatomic, copy) NSString *firstCateName;
@end

NS_ASSUME_NONNULL_END
