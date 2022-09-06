//
//  JHRecordFilterMenuView.m
//  TTjianbao
//
//  Created by lihui on 2021/3/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecordFilterMenuView.h"
#import "JHLiveRecordModel.h"

@interface JHRecordFilterMenuView ()
/** 标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/** scrollview容器*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** 记录选定的按钮*/
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation JHRecordFilterMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHRecordFilterModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    CGFloat width = 68.;
    CGFloat height = 28.;
    CGFloat margin = 10.;
    for (int i = 0; i < model.list.count; i++) {
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [tagButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        tagButton.layer.cornerRadius = height / 2;
        tagButton.clipsToBounds = YES;
        [tagButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xf5f5f5)] forState:UIControlStateNormal];
        [tagButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xfcec9d)] forState:UIControlStateSelected];
        tagButton.tag = i;
        JHRecordFilterMenuModel *menuModel = model.list[i];
        [tagButton setTitle:menuModel.title forState:UIControlStateNormal];
        tagButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13.];
        [tagButton addTarget:self action:@selector(tagButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.selectButton = tagButton;
            self.selectButton.selected = YES;
        }
        [self.scrollView addSubview:tagButton];
        
        [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(i * (width + margin));
            make.centerY.equalTo(self.scrollView);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
    }
    self.scrollView.contentSize = CGSizeMake((width + margin) * model.list.count, 0);
}

// 点击选择tag
- (void)tagButtonClickAction:(UIButton *)sender {
    self.selectButton.selected = NO;
    self.selectButton = sender;
    self.selectButton.selected = YES;
    if (self.completeSelectBlock) {
        JHRecordFilterMenuModel *tagModel = self.model.list[sender.tag];
        self.completeSelectBlock(tagModel);
    }
}

- (void)configUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.scrollView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(80);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = kColorFFF;
    }
    return _scrollView;
}
@end
