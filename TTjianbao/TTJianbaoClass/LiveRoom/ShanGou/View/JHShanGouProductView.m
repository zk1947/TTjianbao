//
//  JHShanGouProductView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/10/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShanGouProductView.h"



@interface JHShanGouProductView()
@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UIImageView * mainImageView;

@property(nonatomic, strong) UILabel * titleLbl;

@property(nonatomic, strong) UIButton * firstBtn;

@property(nonatomic, strong) UILabel * priceAttLbl;

@end

@implementation JHShanGouProductView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, 108, 160)];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.backView];
    [self.backView addSubview:self.mainImageView];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.firstBtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProductView:)];
    [self.backView addGestureRecognizer:tap];
    
}

- (void)setModel:(JHShanGouModel *)model{
    _model = model;
    self.titleLbl.text = model.productTitle;
    [self.mainImageView jhSetImageWithURL:[NSURL URLWithString:model.productImg] placeholder:kDefaultCoverImage];
    [self refreshPrice:model.price];
}


- (void)tapProductView:(UIGestureRecognizer*)ges{
    if (self.tapProduct) {
        self.tapProduct(self.model);
    }
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@108);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainImageView.mas_bottom).offset(5);
        make.left.equalTo(@0).offset(5);
        make.right.equalTo(@0).offset(-5);
    }];
    [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0).offset(-4);
        make.size.mas_equalTo(CGSizeMake(100, 22));
        make.centerX.equalTo(@0);
    }];
}


#pragma mark -- <action>

- (void)firstActionWithSender:(UIButton*)sender{
    [self removeFromSuperview];
}

- (void)refreshPrice:(NSString*)price{
    NSString *sepStr = @"￥";
    NSString *totalStr = [sepStr stringByAppendingFormat:@"%@",price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:totalStr
                                                                            attributes:@{NSFontAttributeName : JHBoldFont(12),
                                                                                         NSForegroundColorAttributeName : HEXCOLOR(0xffffff)}];
    [str setAttributes:@{NSFontAttributeName : JHBoldFont(10),
                         NSForegroundColorAttributeName : HEXCOLOR(0xffffff)}
                 range:[totalStr rangeOfString:sepStr]];
    self.priceAttLbl.attributedText = str;
}


#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        _backView = view;
    }
    return _backView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(11);
        label.text = @"本轮闪购商品名称…";
        label.textColor = HEXCOLOR(0x333333);
        _titleLbl = label;
    }
    return _titleLbl;
}


- (UIButton *)firstBtn{
    if (!_firstBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = HEXCOLOR(0xFF352E);
        [btn addTarget:self action:@selector(firstActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        YYImage *image = [YYImage imageNamed:@"shangou_shan.webp"];
        YYAnimatedImageView *statusView = [[YYAnimatedImageView alloc] initWithImage:image];
        statusView.contentMode = UIViewContentModeScaleAspectFit;
        [btn addSubview:statusView];
        [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(25, 22));
        }];
        
        UIImage *image1 = [UIImage imageNamed:@"shangou_qiang"];
        UIImageView *qiang = [[UIImageView alloc] initWithImage:image1];
        [statusView addSubview:qiang];
        [qiang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        
        UILabel *attLbl = [UILabel new];
        [btn addSubview:attLbl];
        [attLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@0).offset(4);
            make.right.equalTo(statusView.mas_left).offset(4);
        }];
        self.priceAttLbl = attLbl;
        _firstBtn = btn;
        
    }
    return _firstBtn;

}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.image =  [UIImage imageNamed:@"shangou_icon"];
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UIImageView *)mainImageView{
    if (!_mainImageView) {
        UIImageView *view = [UIImageView new];
        [view addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.top.left.equalTo(@0);
        }];
        _mainImageView = view;
    }
    return _mainImageView;
}


@end
