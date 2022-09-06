//
//  JHRecordFilterMenuView.h
//  TTjianbao
//
//  Created by lihui on 2021/3/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecordFilterModel;
@class JHRecordFilterMenuModel;
@interface JHRecordFilterMenuView : UIView
/** 返回选定的tags*/
@property (nonatomic, copy) void(^completeSelectBlock)(JHRecordFilterMenuModel *tagModel);
/** 赋值Model*/
@property (nonatomic, strong) JHRecordFilterModel *model;

@end

NS_ASSUME_NONNULL_END
