//
//  JHShanGouProductView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/10/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JHShanGouModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHShanGouProductView : UIView

@property(nonatomic, copy) void (^tapProduct)(JHShanGouModel* model);

@property(nonatomic, strong) JHShanGouModel * model;

@end

NS_ASSUME_NONNULL_END
