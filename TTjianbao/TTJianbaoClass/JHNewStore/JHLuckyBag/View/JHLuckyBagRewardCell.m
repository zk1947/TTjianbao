//
//  JHLuckyBagRewardCell.m
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagRewardCell.h"

@interface JHLuckyBagRewardCell ()

@property (nonatomic, strong) UIImageView *goodsImgv;
@property (nonatomic, strong) UILabel *titExpLab;
@property (nonatomic, strong) UILabel *titLab;
@property (nonatomic, strong) UIView *line;

@end

@implementation JHLuckyBagRewardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
        [self layoutView];
    }
    return self;
}

- (void)setupView{
    _goodsImgv = [UIImageView new];
    [_goodsImgv jh_cornerRadius:16.5];
    _goodsImgv.image = JHImageNamed(@"newStore_detail_shopProduct_Placeholder");
    [self.contentView addSubview:_goodsImgv];
    
    _titExpLab = [UILabel new];
    _titExpLab.text = @"小巴好可爱小巴好可爱…";
    _titExpLab.font = JHFont(13);
    _titExpLab.textColor = kColor333;
    [self.contentView addSubview:_titExpLab];
    
    _titLab = [UILabel new];
    _titLab.text = @"2021-8-19 16:00:00";
    _titLab.font = JHFont(12);
    _titLab.textColor = kColor666;
    [self.contentView addSubview:_titLab];
    
    _line = [UIView new];
    _line.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self.contentView addSubview:_line];
}

- (void)layoutView{
    [_goodsImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(33);
    }];
    
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_goodsImgv);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(18);
    }];
    
    [_titExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_goodsImgv);
        make.left.mas_equalTo(_goodsImgv.mas_right).offset(10);
        make.right.mas_equalTo(_titLab.mas_left).offset(-20);
        make.height.mas_equalTo(18);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(JHLuckyBagRewardModel *)model{
    _model = model;
    [_goodsImgv jhSetImageWithURL:[NSURL URLWithString:_model.img] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
    _titExpLab.text = _model.name;
    _titLab.text = _model.prizeTime;
}

- (void)setIsOnAlert:(BOOL)isOnAlert{
    _isOnAlert = isOnAlert;
    if (_isOnAlert) {
        [_goodsImgv jh_cornerRadius:23.5];
        [_goodsImgv mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(47);
        }];
        
        [_titExpLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_goodsImgv).offset(3);
            make.left.mas_equalTo(_goodsImgv.mas_right).offset(10);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(18);
        }];
         
        [_titLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titExpLab.mas_bottom).offset(6);
            make.left.mas_equalTo(_titExpLab);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(18);
        }];
        
        _line.hidden = YES;
    }
}

@end
