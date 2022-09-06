//
//  JHLuckyBagShowListCell.m
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagShowListCell.h"

@interface JHLuckyBagShowListCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *actionTimeLab;
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *goodsImgv;
@property (nonatomic, strong) UILabel *titExpLab;
@property (nonatomic, strong) UILabel *titLab;
@property (nonatomic, strong) UILabel *bagTimeExpLab;
@property (nonatomic, strong) UILabel *bagTimeLab;
@property (nonatomic, strong) UILabel *numExpLab;
@property (nonatomic, strong) UILabel *numLab;

@end

@implementation JHLuckyBagShowListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
        [self layoutView];
    }
    return self;
}

- (void)setupView{
    
    _backView = [UIView new];
    _backView.backgroundColor = kColorFFF;
    [_backView jh_cornerRadius:8];
    [self.contentView addSubview:_backView];
    
    _actionTimeLab = [UILabel new];
    _actionTimeLab.text = @"2021-07-31 15:59:59";
    _actionTimeLab.font = JHFont(12);
    _actionTimeLab.textColor = kColor333;
    [_backView addSubview:_actionTimeLab];
    
    _statusLab = [UILabel new];
    _statusLab.text = @"进行中";
    _statusLab.font = JHFont(12);
    _statusLab.textColor = kColor333;
    [_backView addSubview:_statusLab];
    
    _line = [UIView new];
    _line.backgroundColor = HEXCOLOR(0xF5F6FA);
    [_backView addSubview:_line];
    
    _goodsImgv = [UIImageView new];
    [_goodsImgv jh_cornerRadius:5];
    _goodsImgv.image = JHImageNamed(@"newStore_detail_shopProduct_Placeholder");
    [_backView addSubview:_goodsImgv];
    
    _titExpLab = [UILabel new];
    _titExpLab.text = @"福袋名称";
    _titExpLab.font = JHFont(13);
    _titExpLab.textColor = kColor666;
    [_backView addSubview:_titExpLab];
    
    _titLab = [UILabel new];
    _titLab.text = @"和田玉吊坠";
    _titLab.font = JHFont(13);
    _titLab.textColor = kColor333;
    [_backView addSubview:_titLab];
    
    _bagTimeExpLab = [UILabel new];
    _bagTimeExpLab.text = @"福袋时间";
    _bagTimeExpLab.font = JHFont(13);
    _bagTimeExpLab.textColor = kColor666;
    [_backView addSubview:_bagTimeExpLab];
    
    _bagTimeLab = [UILabel new];
    _bagTimeLab.text = @"10:30";
    _bagTimeLab.font = JHFont(13);
    _bagTimeLab.textColor = kColor333;
    [_backView addSubview:_bagTimeLab];
    
    _numExpLab = [UILabel new];
    _numExpLab.text = @"奖励个数";
    _numExpLab.font = JHFont(13);
    _numExpLab.textColor = kColor666;
    [_backView addSubview:_numExpLab];
    
    _numLab = [UILabel new];
    _numLab.text = @"3";
    _numLab.font = JHFont(13);
    _numLab.textColor = kColor333;
    [_backView addSubview:_numLab];
    
}

- (void)layoutView{
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_actionTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.height.mas_equalTo(17);
    }];
    
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(17);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(37);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
    }];
    
    [_goodsImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(66);
    }];
    
    [_titExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(10);
        make.left.mas_equalTo(_goodsImgv.mas_right).offset(10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(18);
    }];
    
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).offset(10);
        make.left.mas_equalTo(_titExpLab.mas_right).offset(9);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(18);
    }];
    
    [_bagTimeExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titExpLab.mas_bottom).offset(7);
        make.left.mas_equalTo(_goodsImgv.mas_right).offset(10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(18);
    }];
    
    [_bagTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bagTimeExpLab.mas_top);
        make.left.mas_equalTo(_bagTimeExpLab.mas_right).offset(9);
        make.height.mas_equalTo(18);
    }];
    
    [_numExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bagTimeExpLab.mas_bottom).offset(7);
        make.left.mas_equalTo(_goodsImgv.mas_right).offset(10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(18);
    }];
    
    [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_numExpLab.mas_top);
        make.left.mas_equalTo(_numExpLab.mas_right).offset(9);
        make.height.mas_equalTo(18);
    }];
}

- (void)setModel:(JHLuckyBagShowModel *)model{
    _model = model;
    
    _actionTimeLab.text = _model.createTime;
    _statusLab.text = _model.bagStatusDes;
    //福袋状态码 1:进行中 2:已下架 3:已开奖
    if (_model.bagStatus == 1) {
        _statusLab.textColor = HEXCOLOR(0xFC4200);
    }else if (_model.bagStatus == 2){
        _statusLab.textColor = HEXCOLOR(0x999999);
    }else if (_model.bagStatus == 3){
        _statusLab.textColor = HEXCOLOR(0x333333);
    }
    [_goodsImgv jhSetImageWithURL:[NSURL URLWithString:_model.imgUrl] placeholder:JHImageNamed(@"newStore_detail_shopProduct_Placeholder")];
    _titLab.text = _model.bagTitle;
    _bagTimeLab.text = [self getMMSSFromSS:_model.countdownSeconds];
    _numLab.text = [NSString stringWithFormat:@"%d",_model.prizeNumber];
}

//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSInteger)seconds{
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];

    //不足两位补0
    NSString *minuteStr = str_minute.length < 2 ? [NSString stringWithFormat:@"0%@",str_minute]:str_minute;
    NSString *secondStr = str_second.length < 2 ? [NSString stringWithFormat:@"0%@",str_second]:str_second;

    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
    return format_time;
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
