//
//  JHOnlineAppraiseToolBar.m
//  TTjianbao
//
//  Created by lihui on 2020/12/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineAppraiseToolBar.h"

@interface JHOnlineAppraiseToolBar ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *placeholder;
@end

@implementation JHOnlineAppraiseToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCommentAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)handleCommentAction {
    if (self.commentBlock) {
        self.commentBlock();
    }
}

- (void)initViews {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kColorF5F6FA;
    bgView.layer.cornerRadius = 4.f;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    _bgView = bgView;
    
    _placeholder = [[UILabel alloc] init];
    _placeholder.text = @"宝友，期待你的神评";
    _placeholder.font = [UIFont fontWithName:kFontNormal size:13.];
    _placeholder.textColor = kColor999;
    [_bgView addSubview:_placeholder];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(6, 10, 6, 10));
    }];
    
    [_placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
}


@end
