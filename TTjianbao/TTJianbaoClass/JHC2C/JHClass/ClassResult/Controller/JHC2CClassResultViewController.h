//
//  JHC2CClassResultViewController.h
//  TTjianbao
//
//  Created by hao on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CClassResultViewController : JHBaseViewController
///分类名称
@property (nonatomic, copy) NSString *cateName;
///分类id
@property (nonatomic, copy) NSString *cateId;
///点击来源 1:查看全部(一级分类)  2：列表（二级分类）
@property (nonatomic, copy) NSString *cateLevel;

@end

NS_ASSUME_NONNULL_END
