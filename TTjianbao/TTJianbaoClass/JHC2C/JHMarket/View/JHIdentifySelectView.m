//
//  JHIdentifySelectView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentifySelectView.h"
@interface JHIdentifySelectView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *sel1Button;
@property (nonatomic, strong) UIButton *sel2Button;
@property (nonatomic, strong) UILabel *deLabel;
@end

@implementation JHIdentifySelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
    
}
- (void)didClickSel1Action : (UIButton *)sender {
    sender.selected = !sender.selected;
    self.sel2Button.selected = false;
    if (self.model.attrValues.count <= 1) return;
    if (sender.selected) {
        self.model.selectedAttrValues = @[self.model.attrValues[0]];
    }else {
        self.model.selectedAttrValues = @[];
    }
}
- (void)didClickSel2Action : (UIButton *)sender {
    sender.selected = !sender.selected;
    self.sel1Button.selected = false;
    
    if (self.model.attrValues.count <= 1) return;
    if (sender.selected) {
        self.model.selectedAttrValues = @[self.model.attrValues[1]];
    }else {
        self.model.selectedAttrValues = @[];
    }
    
}

- (void)setupData {
    if (self.model == nil) return;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", self.model.attrName]; 
    
    if (self.model.attrValues.count <= 1) return;
    
    [self.sel1Button setTitle:self.model.attrValues[0].name forState:UIControlStateNormal];
    [self.sel2Button setTitle:self.model.attrValues[1].name forState:UIControlStateNormal];
    
    @weakify(self)
    [RACObserve(self.sel1Button, selected) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL selected = [x boolValue];
        if (selected) {
            self.sel1Button.backgroundColor = HEXCOLOR(0xfcec9d);
        }else {
            self.sel1Button.backgroundColor = HEXCOLOR(0xf5f5f5);
        }
    }];
  
    [RACObserve(self.sel2Button, selected) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL selected = [x boolValue];
        if (selected) {
            self.sel2Button.backgroundColor = HEXCOLOR(0xfcec9d);
        }else {
            self.sel2Button.backgroundColor = HEXCOLOR(0xf5f5f5);
        }
    }];
}

- (void)setupUI {
    [self addSubview:self.sel1Button];
    [self addSubview:self.sel2Button];
}
- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(@90);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(@28);
    }];
    [self.deLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    [self.sel1Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(0);
    }];
    [self.sel2Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sel1Button.mas_right).offset(6);
        make.width.height.centerY.mas_equalTo(self.sel1Button);
    }];
}
#pragma mark - Lazy
- (void)setModel:(JHAppraisalAttrsResultlModel *)model {
    _model = model;
    [self setupData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UIButton *)sel1Button {
    if (!_sel1Button) {
        _sel1Button = [self getButtonWithTitle:@""];
        [_sel1Button addTarget:self action:@selector(didClickSel1Action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sel1Button;
}
- (UIButton *)sel2Button {
    if (!_sel2Button) {
        _sel2Button = [self getButtonWithTitle:@""];
        [_sel2Button addTarget:self action:@selector(didClickSel2Action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sel2Button;
}
- (UIButton *)getButtonWithTitle : (NSString *)title{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = HEXCOLOR(0xf5f5f5);
    [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
    [button jh_cornerRadius:16];
    return button;
}
- (UILabel *)deLabel {
    if (!_deLabel) {
        _deLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
        _deLabel.text = @":";
    }
    return _deLabel;
}
@end
