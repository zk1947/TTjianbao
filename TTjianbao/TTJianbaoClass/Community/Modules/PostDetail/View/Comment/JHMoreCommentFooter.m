//
//  JHMoreCommentFooter.m
//  TTjianbao
//
//  Created by lihui on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMoreCommentFooter.h"
#import "YYKit/YYKit.h"

@interface JHMoreCommentFooter ()

@property (nonatomic, strong) UIButton *unFoldButton;

@end

@implementation JHMoreCommentFooter


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xffffff);
        [self setupViews];
    }
    return self;
}

- (void)setShowString:(NSString *)showString {
    _showString = showString;
    [_unFoldButton setTitle:[_showString isNotBlank]?_showString:@"" forState:UIControlStateNormal];
}

- (void)setupViews {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    [btn addTarget:self action:@selector(moreCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _unFoldButton = btn;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)moreCommentAction {
    if (self.moreCommentBlock) {
        self.moreCommentBlock();
    }
}



@end
