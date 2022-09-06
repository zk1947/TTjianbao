//
//  JHPostCommentFooterView.m
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostCommentFooterView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "UIView+CornerRadius.h"
#import "TTjianbaoMarcoUI.h"

@interface JHPostCommentFooterView ()
@property (nonatomic, strong) UIView *lineView;
///展开回复按钮
@property (nonatomic, strong) UIButton *unfoldButton;
///底部灰线
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation JHPostCommentFooterView

- (void)setCommentCount:(NSString *)commentCount {
    
    if (!commentCount) {
        return;
    }
    
    _commentCount = commentCount;
    NSString * str = ([commentCount integerValue] > 0) ? [NSString stringWithFormat:@"展开%@条回复", _commentCount] : @"";
    [_unfoldButton setTitle:str forState:UIControlStateNormal];
    _unfoldButton.hidden = !([commentCount integerValue] > 0);
    _lineView.hidden = _unfoldButton.hidden;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    _showBottomLine = showBottomLine;
    _bottomLine.hidden = !showBottomLine;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = HEXCOLOR(0xF9FAF9);
    [self addSubview:bottomView];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorEEE;
    _lineView = line;
    [bottomView addSubview:line];
    _lineView.hidden = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"展开0条回复" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_post_detail_subreply_triple"] forState:UIControlStateNormal];
    [btn setTitleColor:kColor999 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [btn  addTarget:self action:@selector(__handleUnfoldEvent) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    _unfoldButton.hidden = YES;
    _unfoldButton = btn;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = kColorF5F6FA;
    _bottomLine = bottomLine;
    [self addSubview:_bottomLine];
        
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 55, 15, 15));
    }];
    
    [_unfoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(33);
        make.top.equalTo(bottomView);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.unfoldButton.mas_left).offset(-4);
        make.centerY.equalTo(self.unfoldButton);
        make.size.mas_equalTo(CGSizeMake(20, 1));
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(55);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(1.);
    }];
    
    [bottomView layoutIfNeeded];
    [bottomView yd_setCornerRadius:8.f corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    [_unfoldButton layoutIfNeeded];
    [_unfoldButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}

#pragma mark -
#pragma maek - action event

///展开点击事件
- (void)__handleUnfoldEvent {
    if (self.unfoldBlock) {
        self.unfoldBlock(self.footerSection, self);
    }
}

@end
