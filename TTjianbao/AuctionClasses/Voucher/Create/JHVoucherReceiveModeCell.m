//
//  JHVoucherReceiveModeCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVoucherReceiveModeCell.h"

@interface JHVoucherReceiveModeCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *btn1, *btn2;
@end

@implementation JHVoucherReceiveModeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyleEnabled = NO;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:15] textColor:kColor333];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_btn1) {
        _btn1 = [UIButton buttonWithTitle:@"领取" titleColor:kColor333];
        _btn1.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_btn1 setImage:[UIImage imageNamed:@"voucher_icon_checked_normal"] forState:UIControlStateNormal];
        [_btn1 setImage:[UIImage imageNamed:@"voucher_icon_checked_selected"] forState:UIControlStateSelected];
        [_btn1 setImageInsetStyle:MRImageInsetStyleLeft spacing:10];
        _btn1.selected = YES;
        [self.contentView addSubview:_btn1];
    }
    
    if (!_btn2) {
        _btn2 = [UIButton buttonWithTitle:@"给个人发放" titleColor:kColor333];
        _btn2.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_btn2 setImage:[UIImage imageNamed:@"voucher_icon_checked_normal"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"voucher_icon_checked_selected"] forState:UIControlStateSelected];
        [_btn2 setImageInsetStyle:MRImageInsetStyleLeft spacing:10];
        [self.contentView addSubview:_btn2];
    }
    
    @weakify(self);
    [[_btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (!self.btn1.isSelected) {
            self.btn1.selected = !self.btn1.selected;
            self.btn2.selected = !self.btn2.selected;
            if (self.didSelectedBlock) {
                self.didSelectedBlock(0);
            }
        }
    }];
    
    [[_btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (!self.btn2.isSelected) {
            self.btn1.selected = !self.btn1.selected;
            self.btn2.selected = !self.btn2.selected;
            if (self.didSelectedBlock) {
                self.didSelectedBlock(1);
            }
        }
    }];
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .heightIs(30).autoWidthRatio(0);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _btn1.sd_layout
    .leftSpaceToView(_titleLabel, 0)
    .centerYEqualToView(self.contentView)
    .widthIs(85)
    .heightIs(44);
    
    _btn2.sd_layout
    .leftSpaceToView(_btn1, 0)
    .centerYEqualToView(self.contentView)
    .widthIs(150)
    .heightIs(44);
}

- (void)setTitle:(NSString *)title selectedIndex:(NSInteger)index {
    _titleLabel.text = title;
    _btn1.selected = index==0;
    _btn2.selected = index==1;
}

@end
