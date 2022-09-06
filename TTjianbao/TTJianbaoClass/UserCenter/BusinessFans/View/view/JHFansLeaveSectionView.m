//
//  JHFansLeaveSectionView.m
//  TTjianbao
//
//  Created by Paros on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansLeaveSectionView.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHFansLeaveSectionView()
@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UIButton * seleBtn;

@property(nonatomic, strong) UIButton * detailBtn;

@property(nonatomic, strong) UILabel * desLbl;

@property(nonatomic, strong) UIView * line;
@end

@implementation JHFansLeaveSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.backView];
    [self.backView addSubview:self.seleBtn];
    [self.backView addSubview:self.detailBtn];
    [self.backView addSubview:self.desLbl];
    [self.backView addSubview:self.line];

    
//    [self refershLblText:@"和田玉粉丝等级模版" appendSep:YES];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.seleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seleBtn.mas_right);
        make.centerY.equalTo(@0);
    }];

    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-15);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 38));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0).inset(12);
        make.bottom.equalTo(@0);
        make.height.mas_equalTo(1.f);
    }];
}

- (void)refershLblText:(NSString*)text appendSep:(BOOL)need andColor:(UIColor*)color{
    NSMutableAttributedString *attText  = [[NSMutableAttributedString alloc] initWithString:text
                                                                              attributes:@{NSFontAttributeName: JHFont(14), NSForegroundColorAttributeName: color}];

    if (need) {
        NSMutableAttributedString *appAttText  = [[NSMutableAttributedString alloc]
                                                  initWithString:@" [推荐] "
                                                  attributes:@{NSFontAttributeName: JHFont(14), NSForegroundColorAttributeName: UIColor.redColor}];
        [attText appendAttributedString:appAttText];
    }
    self.desLbl.attributedText = attText;
}

- (void)setModel:(JHBusinessFansLevelTemplateVosModel *)model{
    _model = model;
    BOOL rem = ![model.recommendFlag isEqualToString:@"0"];
    self.seleBtn.enabled = rem;
    UIColor *textColor = rem ? HEXCOLOR(0x333333) : HEXCOLOR(0x999999);
    [self refershLblText:model.templateName appendSep:rem andColor:textColor];
    
    
}

- (void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    self.detailBtn.selected = isShow;
    self.line.hidden = isShow;
}

- (void)setIsSelted:(BOOL)isSelted{
    _isSelted = isSelted;
    self.seleBtn.selected = isSelted;

}
- (void)selActionWithSender:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    if (self.selteSectionBlock) {
        self.selteSectionBlock(self.fanSection, self.model);
    }

}

- (void)detailActionWithSender:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    if (self.showDetailBlock) {
        self.showDetailBlock(self.fanSection, sender.selected);
    }

}

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}

- (UIButton *)seleBtn{
    if (!_seleBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"fans_setting_business_selected"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"fans_setting_business_normal"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _seleBtn = btn;
    }
    return _seleBtn;
}

- (UIButton *)detailBtn{
    if (!_detailBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"customize_icon_anchor_arrow_up"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"customize_icon_anchor_arrow_down"] forState:UIControlStateNormal];
        [btn setTitle:@"详情" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(14);
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:15];
        [btn addTarget:self action:@selector(detailActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn = btn;
    }
    return _detailBtn;
}

- (UILabel *)desLbl{
    if (!_desLbl) {
        UILabel *label = [UILabel new];
        _desLbl = label;
    }
    return _desLbl;
}
- (UIView *)line{
    if (!_line) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xeeeeee);
        _line = view;
    }
    return _line;
}

@end
