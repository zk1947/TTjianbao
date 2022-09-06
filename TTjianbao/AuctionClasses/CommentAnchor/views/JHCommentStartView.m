//
//  JHCommentStartView.m
//  TTjianbao
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHCommentStartView.h"
@interface JHCommentStartView ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *btnArray;

@end

@implementation JHCommentStartView

- (instancetype)init
{
    self = [super init];
    if (self) {
    
        [self makeUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self makeUI];
}

- (void)makeUI {
    _leftSpace = 100;
    self.btnArray = [NSMutableArray array];
    
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"icon_comment_star_empt"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_comment_star_fill"] forState:UIControlStateSelected];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btnArray addObject:btn];
    }
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.levelLabel];
    self.selectedCount = 5;


}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = HEXCOLOR(0x666666);
        
    }
    
    return _titleLabel;
}


- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [UILabel new];
        _levelLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _levelLabel.textColor = HEXCOLOR(0x999999);
        _levelLabel.text = @"非常好";
//        _levelLabel.hidden = YES;
        
    }
    
    return _levelLabel;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    for (int i = 0; i<self.btnArray.count; i++) {
        UIButton *btn = self.btnArray[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(self.leftSpace + i * 35);
            make.centerY.equalTo(self);
            make.height.equalTo(self);
            
        }];
    }

    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(self.leftSpace+self.btnArray.count*35);
    }];
    
}

- (void)setLeftSpace:(CGFloat)leftSpace {
    _leftSpace = leftSpace;
    [self layoutSubviews];
}

- (void)setSelectedCount:(NSInteger)selectedCount {
    _selectedCount = selectedCount;
    for (int i = 0; i<self.btnArray.count; i++) {
        if (i<_selectedCount) {
            self.btnArray[i].selected = YES;
        }else {
            self.btnArray[i].selected = NO;
        }
    }
    
    if (_selectedCount == 1) {
        _levelLabel.text = @"非常差";
    }else if (_selectedCount == 2) {
        _levelLabel.text = @"差";
    }else if (_selectedCount == 3) {
        _levelLabel.text = @"一般";
    }else if (_selectedCount == 4) {
        _levelLabel.text = @"好";
    }else {
        _levelLabel.text = @"非常好";
    }
}


- (void)btnAction:(UIButton *)btn {
    if (self.isShow) {
        return;
    }
    self.selectedCount = btn.tag;
    if (self.selectedComplete) {
        self.selectedComplete(btn);
    }
}

@end
