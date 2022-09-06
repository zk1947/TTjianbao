//
//  JHC2CProductDetailBottomInfoCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailBottomInfoCell.h"
#import "JHC2CProoductDetailModel.h"


@interface JHC2CProductDetailBottomInfoCell()

@property(nonatomic, strong) UIButton * juBaoBtn;

@property(nonatomic, strong) UILabel * wantLbl;

@property(nonatomic, strong) UILabel * midLbl;

@property(nonatomic, strong) UILabel * seeLbl;

@property(nonatomic, strong) UIView * backGaryView;


@property(nonatomic, strong) UIView * jianDingView;
@property(nonatomic, strong) UIView * danBaoView;
@property(nonatomic, strong) UIView * realNameView;


@end

@implementation JHC2CProductDetailBottomInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setItems];
        [self layoutItems];
    }
    return self;
}

    
- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.juBaoBtn];
    [self.contentView addSubview:self.wantLbl];
    [self.contentView addSubview:self.midLbl];
    [self.contentView addSubview:self.seeLbl];
    [self.contentView addSubview:self.backGaryView];
    
    
    [self.backGaryView addSubview:self.jianDingView];
    [self.backGaryView addSubview:self.danBaoView];
    [self.backGaryView addSubview:self.realNameView];
    
}

- (void)layoutItems{
    [self.juBaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(11);
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.right.equalTo(@0).offset(-12);
    }];
    [self.wantLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.juBaoBtn);
        make.right.equalTo(self.juBaoBtn.mas_left).offset(-10);
    }];
    [self.midLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.juBaoBtn);
        make.right.equalTo(self.wantLbl.mas_left).offset(-5);
    }];
    [self.seeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.juBaoBtn);
        make.right.equalTo(self.midLbl.mas_left).offset(-5);
    }];
    [self.backGaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.juBaoBtn.mas_bottom).offset(13);
        make.height.mas_equalTo(68);
        make.left.bottom.right.equalTo(@0).inset(12);
    }];
    
    [self.danBaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 68));
        make.left.equalTo(@0).offset(40);
    }];
    [self.jianDingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 68));
        make.centerX.equalTo(@0);
    }];
    [self.realNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 68));
        make.right.equalTo(@0).offset(-40);
    }];
    
}


- (UIView*)getTipViewWithImageName:(NSString*)imageName andTitle:(NSString*)title{
    UIView *view = [UIView new];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    UILabel *label = [UILabel new];
    label.font = JHFont(12);
    label.textColor = HEXCOLOR(0x666666);
    label.text = title;
    
    [view addSubview:imageView];
    [view addSubview:label];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@0).offset(13);
//        make.size.mas_equalTo(CGSizeMake(21, 23));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@0).offset(-12);
    }];

    return view;
}

- (void)setModel:(JHC2CProoductDetailModel *)model{
    _model = model;
    self.wantLbl.text = [NSString stringWithFormat:@"%@人想要", model.productExt.wantCount];
    self.seeLbl.text = [NSString stringWithFormat:@"%@次浏览", model.productExt.viewCount];
}
- (void)juBaoAction{
    if (self.tapJuBao) {
        self.tapJuBao();
    }
}

#pragma mark -- <set and get>

- (UIButton *)juBaoBtn{
    if (!_juBaoBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_jinggao"] forState:UIControlStateNormal];
        [btn setTitle:@"举报" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(12);
        btn.layer.cornerRadius = 10;
        btn.layer.borderWidth = 0.5;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2);
        btn.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
        [btn addTarget:self action:@selector(juBaoAction) forControlEvents:UIControlEventTouchUpInside];
        _juBaoBtn = btn;
    }
    return _juBaoBtn;
}


- (UILabel *)wantLbl{
    if (!_wantLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.text = @"49人想要";
        label.textColor = HEXCOLOR(0x999999);
        _wantLbl = label;
    }
    return _wantLbl;
}
- (UILabel *)midLbl{
    if (!_midLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.text = @"·";
        label.textColor = HEXCOLOR(0x999999);
        _midLbl = label;
    }
    return _midLbl;
}
- (UILabel *)seeLbl{
    if (!_seeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.text = @"677次浏览";
        label.textColor = HEXCOLOR(0x999999);
        _seeLbl = label;
    }
    return _seeLbl;
}

- (UIView *)backGaryView{
    if (!_backGaryView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF8F8F8);
        view.layer.cornerRadius = 4;
        _backGaryView = view;
    }
    return _backGaryView;
}

- (UIView *)jianDingView{
    if (!_jianDingView) {
        UIView *view = [self getTipViewWithImageName:@"c2c_pd_jiandingfuwu" andTitle:@"鉴定服务"];
        _jianDingView = view;
    }
    return _jianDingView;
}

- (UIView *)danBaoView{
    if (!_danBaoView) {
        UIView *view = [self getTipViewWithImageName:@"c2c_pd_danbao" andTitle:@"担保交易"];
        _danBaoView = view;
    }
    return _danBaoView;
}
- (UIView *)realNameView{
    if (!_realNameView) {
        UIView *view = [self getTipViewWithImageName:@"c2c_pd_shimingrenzheng" andTitle:@"实名认证"];
        _realNameView = view;
    }
    return _realNameView;
}


@end
