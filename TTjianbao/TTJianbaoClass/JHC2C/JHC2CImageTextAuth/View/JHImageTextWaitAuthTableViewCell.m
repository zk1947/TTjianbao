//
//  JHImageTextWaitAuthTableViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageTextWaitAuthTableViewCell.h"

@interface JHImageTextWaitAuthTableViewCell ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *headImgV;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UILabel *timeLable;

@property (nonatomic, strong) UILabel *priceLable;

@property (nonatomic, strong) UILabel *priceLable2;

@property (nonatomic, strong) UILabel *contentLable;

@property (nonatomic, strong) UIImageView *contentImgV1;

@property (nonatomic, strong) UIImageView *contentImgV2;

@property (nonatomic, strong) UIImageView *contentImgV3;

@property (nonatomic, strong) UIImageView *contentImgV4;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *orderLable;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSMutableArray *imgsArr;

@end

@implementation JHImageTextWaitAuthTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.imgsArr = [NSMutableArray array];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = kColorFFF;
    [_backView jh_cornerRadius:8];
    [self.contentView addSubview:_backView];
    
    _headImgV = [[UIImageView alloc]init];
    [_headImgV jh_cornerRadius:18];
    [_backView addSubview:_headImgV];
    
    _nameLable = [UILabel new];
    _nameLable.text = @"麦兜的花园";
    _nameLable.font = JHMediumFont(12);
    _nameLable.textColor = HEXCOLOR(0x000000);
    [_backView addSubview:_nameLable];
    
    _timeLable = [UILabel new];
    _timeLable.text = @"2020-01-21 12:09:34";
    _timeLable.font = JHFont(11);
    _timeLable.textColor = kColor999;
    [_backView addSubview:_timeLable];
    
    _priceLable = [UILabel new];
    _priceLable.text = @"1009.00";
    _priceLable.font = [UIFont fontWithName:@"DINAlternate-Bold" size:20];
    _priceLable.textColor = kColor333;
    [_backView addSubview:_priceLable];
    
    _priceLable2 = [UILabel new];
    _priceLable2.text = @"￥";
    _priceLable2.font = [UIFont fontWithName:@"DINAlternate-Bold" size:13];
    _priceLable2.textColor = kColor333;
    [_backView addSubview:_priceLable2];
    
    _contentLable = [UILabel new];
    _contentLable.text = @"老师您好，这是我多年前在潘家园1000元打包买的几枚咸丰通宝，麻烦您帮忙掌掌眼，感谢！";
    _contentLable.font = JHFont(14);
    _contentLable.textColor = kColor333;
    _contentLable.numberOfLines = 0;
    [_backView addSubview:_contentLable];
    
    _contentImgV1 = [[UIImageView alloc]init];
    [_contentImgV1 jh_cornerRadius:8];
    [_backView addSubview:_contentImgV1];
    
    _contentImgV2 = [[UIImageView alloc]init];
    _contentImgV2.backgroundColor = [UIColor cyanColor];
    [_contentImgV2 jh_cornerRadius:8];
    [_backView addSubview:_contentImgV2];
    
    _contentImgV3 = [[UIImageView alloc]init];
    [_contentImgV3 jh_cornerRadius:8];
    [_backView addSubview:_contentImgV3];
    
    _contentImgV4 = [[UIImageView alloc]init];
    [_contentImgV4 jh_cornerRadius:8];
    [_backView addSubview:_contentImgV4];

    [self.imgsArr addObject:_contentImgV1];
    [self.imgsArr addObject:_contentImgV2];
    [self.imgsArr addObject:_contentImgV3];
    [self.imgsArr addObject:_contentImgV4];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = HEXCOLOR(0xF0F0F0);
    [_backView addSubview:_lineView];
    
    _orderLable = [UILabel new];
    _orderLable.text = @"订单编号:3496003234596";
    _orderLable.font = JHFont(12);
    _orderLable.textColor = kColor999;
    [_backView addSubview:_orderLable];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setBackgroundImage:JHImageNamed(@"c2c_market_btbg") forState:UIControlStateNormal];
    [_button setTitle:@"去鉴定" forState:UIControlStateNormal];
    [_button setTitleColor:kColor333 forState:UIControlStateNormal];
    _button.titleLabel.font = JHFont(13);
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_button];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(36);
    }];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImgV.mas_right).offset(8);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(18);
    }];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLable.mas_left);
        make.top.mas_equalTo(_nameLable.mas_bottom).offset(2);
        make.height.mas_equalTo(16);
    }];
    
    [_priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(23);
        make.height.mas_equalTo(20);
    }];
    
    [_priceLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_priceLable.mas_left);
        make.top.mas_equalTo(28);
        make.height.mas_equalTo(15);
    }];
    
    [_contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_headImgV.mas_bottom).offset(14);
    }];
    
    [_contentImgV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_contentLable.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [_contentImgV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentImgV1.mas_right).offset(10);
        make.top.mas_equalTo(_contentLable.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [_contentImgV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentImgV2.mas_right).offset(10);
        make.top.mas_equalTo(_contentLable.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [_contentImgV4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentImgV3.mas_right).offset(10);
        make.top.mas_equalTo(_contentLable.mas_bottom).offset(12);
        make.width.height.mas_equalTo(75);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-54);
        make.height.mas_equalTo(1);
    }];
    
    [_orderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-18);
        make.height.mas_equalTo(17);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-12);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(30);
    }];
}

- (void)setModel:(JHImageTextWaitAuthListItemModel *)model{
    _model = model;
    
    //用户信息
    [self.headImgV jhSetImageWithURL:[NSURL URLWithString:_model.img] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
    self.nameLable.text = _model.name;
    //鉴定时间
    self.timeLable.text = _model.appraisalPayTime;
    //鉴定费用
    self.priceLable.text = _model.appraisalFeeYuan;
    //商品描述
    self.contentLable.text = _model.productDesc;
    //订单编号
    self.orderLable.text = [NSString stringWithFormat:@"订单编号:%@",_model.orderCode];
    //图片组
    for (int index = 0; index < self.imgsArr.count; index++) {
        UIImageView *imgv = self.imgsArr[index];
        if (_model.images.count > index) {
            imgv.hidden = NO;
            JHImageTextWaitAuthListItemsImageModel *imgModel = _model.images[index];
            [imgv jhSetImageWithURL:[NSURL URLWithString:imgModel.small] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
        }else{
            imgv.hidden = YES;
        }
    }
}

- (void)buttonAction:(UIButton *)btn{
    if (self.authDelegate && [self.authDelegate respondsToSelector:@selector(gotoAuth:)]) {
        [self.authDelegate gotoAuth:_model];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
