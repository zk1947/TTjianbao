//
//  JHBuyTrueFalseView.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class JHBuyAppraiseModel;
@interface JHBuyTrueFalseView : BaseView

/** 设置真假视图*/
@property (nonatomic, assign) BOOL isWorksTrue;
/** 传model*/
@property (nonatomic, strong) JHBuyAppraiseModel *model;

@end

NS_ASSUME_NONNULL_END
