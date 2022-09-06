//
//  JHAppraisePayInfoView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "BaseView.h"
#import "JHOrderHeaderTitleView.h"
#import "JHAppraisePayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraisePayInfoView : BaseView
@property(nonatomic,strong) UIView * contentScroll;
@property(strong,nonatomic) NSArray* payWayArray;
@property(copy,nonatomic) JHFinishBlock dissBlock;
@property(copy,nonatomic) JHActionBlock payBlock;
@property(copy,nonatomic) JHFinishBlock protocalBlock;
@property(strong,nonatomic) JHAppraisePayModel* appraisePayModel;
@end

NS_ASSUME_NONNULL_END
