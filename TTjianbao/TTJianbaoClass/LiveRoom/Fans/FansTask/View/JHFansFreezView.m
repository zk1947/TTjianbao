//
//  JHFansFreezView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansFreezView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHFansClubModel.h"

@interface JHFansFreezView()
@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UILabel * nameLbl;

@property(nonatomic, strong) UILabel * detailLbl;


@property(nonatomic, strong) UIButton * showDetailBtn;

@end

@implementation JHFansFreezView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.nameLbl];
    [self.backView addSubview:self.showDetailBtn];
    [self.backView addSubview:self.detailLbl];

}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.right.equalTo(@0).inset(15);
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(8);
        make.left.equalTo(@10);
    }];
    
    [self.showDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLbl);
        make.right.equalTo(@0).inset(10);
        make.size.mas_equalTo(CGSizeMake(40, 29));
    }];
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_bottom).offset(3);
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-4);
    }];

    
}

- (void)showActionWithSender:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    self.fansClubModel.isUnFlod = sender.isSelected;
    self.detailLbl.hidden = !sender.isSelected;
    [NSNotificationCenter.defaultCenter postNotificationName:@"NSNotification_Refersh_fansHeader" object:nil];
}

- (void)setFansClubModel:(JHFansClubModel *)fansClubModel{
    _fansClubModel = fansClubModel;
    self.nameLbl.text = [NSString stringWithFormat:@"冻结粉丝亲密度%@", fansClubModel.freezeTotalExp];
    self.detailLbl.text = fansClubModel.freezeExpDesc;
    
}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xFAFAFA);
        _backView = view;
    }
    return _backView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"冻结粉丝亲密度0";
        _nameLbl = label;
    }
    return _nameLbl;
}

- (UILabel *)detailLbl{
    
    if (!_detailLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @" ";
        label.numberOfLines = 0;
        label.hidden = YES;
        _detailLbl = label;
    }
    return _detailLbl;
}

- (UIButton *)showDetailBtn{
    if (!_showDetailBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = JHFont(10);
        [btn setTitle:@"详情" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"customize_icon_anchor_arrow_up"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"customize_icon_anchor_arrow_down"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:15];
        _showDetailBtn = btn;
    }
    return _showDetailBtn;
}
@end
