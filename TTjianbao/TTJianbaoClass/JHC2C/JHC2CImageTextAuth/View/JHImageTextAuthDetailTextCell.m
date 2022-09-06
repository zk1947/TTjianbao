//
//  JHImageTextAuthDetailTextCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageTextAuthDetailTextCell.h"

@interface JHImageTextAuthDetailTextCell ()

@property (nonatomic, strong) UILabel *lable1;
@property (nonatomic, strong) UILabel *lable2;
@property (nonatomic, strong) UILabel *lable3;
@property (nonatomic, strong) UILabel *lable4;

@end

@implementation JHImageTextAuthDetailTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    
    _lable1 = [UILabel new];
    _lable1.text = @"宝贝分类：玉石-和田玉";
    _lable1.textColor = kColor333;
    _lable1.font = JHFont(16);
    [self.contentView addSubview:_lable1];
    
    _lable2 = [UILabel new];
    _lable2.text = @"鉴定费用：";
    _lable2.textColor = kColor333;
    _lable2.font = JHFont(16);
    [self.contentView addSubview:_lable2];
    
    _lable3 = [UILabel new];
    _lable3.text = @"¥25";
    _lable3.textColor = HEXCOLOR(0xF23730);
    _lable3.font = JHMediumFont(16);
    [self.contentView addSubview:_lable3];
    
    _lable4 = [UILabel new];
    _lable4.text = @"老师您好，这是我多年前在潘家园1000元打包买的几枚咸丰通宝，麻烦您帮忙掌掌眼，感谢！";
    _lable4.textColor = kColor333;
    _lable4.font = JHFont(16);
    _lable4.numberOfLines = 0;
    [self.contentView addSubview:_lable4];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.height.mas_equalTo(22);
    }];
    
    [_lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(_lable1.mas_bottom).offset(10);
        make.height.mas_equalTo(22);
    }];
    
    [_lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_lable2.mas_right).offset(4);
        make.top.mas_equalTo(_lable1.mas_bottom).offset(10);
        make.height.mas_equalTo(22);
    }];
    
    [_lable4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(_lable2.mas_bottom).offset(10);
    }];
    
}

- (void)setModel:(JHImageTextWaitAuthDetailModel *)model{
    _model = model;
    _lable1.text = [NSString stringWithFormat:@"宝贝分类：%@-%@",_model.categoryFirstName,_model.categorySecondName];
    _lable3.text = [NSString stringWithFormat:@"¥%@",_model.appraisalFeeYuan];
    _lable4.text = _model.productDesc;
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
