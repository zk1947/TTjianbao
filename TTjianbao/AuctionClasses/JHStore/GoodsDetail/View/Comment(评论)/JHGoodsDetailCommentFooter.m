//
//  JHGoodsDetailCommentFooter.m
//  TTjianbao
//
//  Created by lihui on 2020/3/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailCommentFooter.h"
#import "TTjianbaoHeader.h"

@interface JHGoodsDetailCommentFooter ()

@property (nonatomic, strong) UIButton *findAllButton;

@end

@implementation JHGoodsDetailCommentFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = HEXCOLOR(0xEEEEEE);
    [btn setTitleColor:HEXCOLOR(0x9999999) forState:UIControlStateNormal];
    [btn setTitle:@"查看全部评论" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    _findAllButton = btn;
    [self addSubview:btn];
    btn.sd_cornerRadiusFromHeightRatio = @0.5;
    btn.sd_layout.centerXEqualToView(self).centerYEqualToView(self).widthIs(108).heightIs(28);
    @weakify(self);
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self allCommentBtnClicked];
    }];
}

- (void)setTotalCommentStr:(NSString *)totalCommentStr
                ComentList:(NSArray*)commentList totalCommentCount:(NSInteger)totalComentCount {
    if (![totalCommentStr isNotBlank]) {
        return;
    }
    _totalCommentCountStr = totalCommentStr;
    _commentList = commentList;
    _totalCommentCount = totalComentCount;
    
    if (totalComentCount > 0 && commentList.count >= totalComentCount) {
        [_findAllButton setTitle:@"— 已显示全部评论 —" forState:UIControlStateNormal];
        _findAllButton.userInteractionEnabled = NO;
        _findAllButton.backgroundColor = [UIColor clearColor];
        _findAllButton.sd_resetLayout
        .centerXEqualToView(self).centerYEqualToView(self).widthIs(ScreenWidth).heightIs(28);

    } else if (totalComentCount == 0 && commentList.count == 0) {
        [_findAllButton setTitle:@"— 暂无评论 —" forState:UIControlStateNormal];
        _findAllButton.userInteractionEnabled = NO;
        _findAllButton.backgroundColor = [UIColor clearColor];
        _findAllButton.sd_resetLayout
        .centerXEqualToView(self).centerYEqualToView(self).widthIs(ScreenWidth).heightIs(28);
    }
}

///查看全部点击事件
- (void)allCommentBtnClicked {
    if (self.findAllBlock) {
        self.findAllBlock();
    }
}


@end
