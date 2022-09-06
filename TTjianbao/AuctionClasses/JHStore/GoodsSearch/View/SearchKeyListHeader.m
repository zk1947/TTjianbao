//
//  SearchKeyListHeader.m
//  ForkNews
//
//  Created by wuyd on 2018/5/14.
//  Copyright © 2018年 wuyd. All rights reserved.
//

#import "SearchKeyListHeader.h"
#import "TTjianbaoHeader.h"

static const CGFloat kPaddingLeft15 = 15.0;


@interface SearchKeyListHeader ()
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) 
@property (nonatomic, strong) UIView *lineView;
@end

@implementation SearchKeyListHeader

+ (CGFloat)headerHeight {
    return 38.0f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.0] textColor:[UIColor blackColor]];
        [self addSubview:_titleLabel];
    }
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"dis_searchDelete"] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:kColor222 forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:kColor999 forState:UIControlStateHighlighted];
        _deleteBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _deleteBtn.hidden = YES;
        [self addSubview:_deleteBtn];
        [_deleteBtn addTarget:self action:@selector(deleteHistoryData) forControlEvents:UIControlEventTouchUpInside];
    }

    //布局
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kPaddingLeft15);
        make.width.lessThanOrEqualTo(@(120)); //小于等于
        make.top.bottom.equalTo(self);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 38.0));
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self);
    }];
}

- (void)deleteHistoryData {
    if (self.deleteBtnClickBlock) {
        self.deleteBtnClickBlock();
    }
}

- (void)setKeyType:(YDSearchKeyType)keyType{
    _keyType = keyType;
    if (_keyType == YDSearchKeyTypeHot) {
        _titleLabel.text = @"商城热搜";
        _deleteBtn.hidden = YES;
    } else if (_keyType == YDSearchKeyTypeHistory) {
        _titleLabel.text = @"历史记录";
        _deleteBtn.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
