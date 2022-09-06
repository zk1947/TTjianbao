//
//  JHStoneSignFooter.m
//  TTjianbao
//
//  Created by lihui on 2020/4/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSignFooter.h"
#import "UIView+CornerRadius.h"

#import "JHSelectContractViewController.h"
#import "JHUnionSignView.h"

@interface JHStoneSignFooter ()

@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) JHUnionSignView *signView;   ///签约view

@end

@implementation JHStoneSignFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kColorEEE;
    
    _whiteBackView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    
    _signView = ({
        JHUnionSignView *signView = [[JHUnionSignView alloc] init];
        signView.isOrange = NO;
        signView;
    });
    
    [self addSubview:_whiteBackView];
    [_whiteBackView addSubview:lineView];
    [_whiteBackView addSubview:_signView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBackView).offset(10);
        make.right.equalTo(self.whiteBackView).offset(-10);
        make.top.equalTo(self.whiteBackView);
        make.height.mas_equalTo(1);
    }];
    
    [_whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 10, 10));
    }];
    
    [_signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.whiteBackView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    [_whiteBackView layoutIfNeeded];
    [_whiteBackView yd_setCornerRadius:8.f corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
}

@end
