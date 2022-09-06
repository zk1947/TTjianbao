//
//  JHStonePinMoneyTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStonePinMoneyTableViewCell.h"
#import "JHUIFactory.h"

@implementation JHStonePinMoneyTableViewCell
{
    UILabel* titleLabel;
    UILabel* moneyLabel;
    UILabel* timeLabel;
    UILabel* orderCodeLabel;
    UILabel *descabel;
    UIButton *moreBtn;
}

 - (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self drawSubviews];
    }
    
    return self;
}

- (void)drawSubviews
{
    self.contentView .backgroundColor = HEXCOLOR(0xf8f8f8);
    UIView * backView = [[UIView alloc]init];
    backView .backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8;
    backView.clipsToBounds = YES;
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    titleLabel = [JHUIFactory createLabelWithTitle:@"提交" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(15) textAlignment:NSTextAlignmentLeft];
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView).offset(8);
        make.left.equalTo(backView).offset(15);
//        make.height.mas_equalTo(18);
    }];
    
    moneyLabel = [JHUIFactory createLabelWithTitle:@"+0.00" titleColor:HEXCOLOR(0xfc4200) font:JHMediumFont(15) textAlignment:NSTextAlignmentRight];
    [backView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel).offset(0);
        make.right.equalTo(backView).offset(-15);
      //  make.height.mas_equalTo(21);
        make.left.equalTo(titleLabel.mas_right).offset(5);
    }];
    
    orderCodeLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [backView addSubview:orderCodeLabel];
    [orderCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(titleLabel);
      //  make.height.mas_equalTo(14);
    }];
    
    timeLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [backView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderCodeLabel).offset(0);
        make.right.equalTo(backView).offset(-15);
      //  make.height.mas_equalTo(14);
    }];
    
//    JHCustomLine* line = [JHUIFactory createLine];
//    [self.contentView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView).offset(-0.5);
//        make.left.equalTo(self.contentView).offset(15);
//        make.width.mas_equalTo(self.contentView.mas_width).offset(-15);
//        make.height.mas_equalTo(0.5);
//        make.top.equalTo(timeLabel.mas_bottom).offset(8);
//    }];
    
    descabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [backView addSubview:descabel];
    descabel.numberOfLines = 0;
    
    [descabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView).offset(-10);
        make.left.equalTo(backView).offset(15);
        make.right.equalTo(backView).offset(-30);
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
    }];
    
    moreBtn = [[UIButton alloc] init];
    [moreBtn setImage:[UIImage imageNamed:@"zijin_cell_zhankai"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"zijin_cell_shouqi"] forState:UIControlStateSelected];
    [moreBtn addTarget:self action:@selector(lookMore) forControlEvents:UIControlEventTouchUpInside];
  //  moreBtn.backgroundColor = [UIColor redColor];
    [backView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(descabel).offset(5);
        make.right.equalTo(backView).offset(-0);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
}
//- (void)updateData:(JHAccountFlowModel*)model
//{
//
//
//    if(!model)
//    {
//       DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
//       return;
//    }
//    titleLabel.text = model.goodsTitle;
//    moneyLabel.text = [NSString stringWithFormat:@"%@%@", model.sign, model.changeMoney];
//    timeLabel.text = model.flowDate;
//}
-(void)setModel:(JHAccountFlowModel *)model{
    
    _model = model;
    if(!_model)
    {
       DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
       return;
    }
    
  //  _model.remark= @"备注：提现失败增加备注说明，如有备注则展示，无备注展提现我改";
    titleLabel.text = _model.titleName?:@" ";
    orderCodeLabel.text = _model.titleDesc?:@" ";
    moneyLabel.text = [NSString stringWithFormat:@"%@ ￥%@", _model.sign, _model.changeMoney];
    timeLabel.text = _model.flowDate;
    descabel.text = _model.remark;
    
    if (!_model.remark) {
        moreBtn.hidden = YES;
        [descabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom).offset(0);
        }];
    }
    
    CGSize size = [descabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT,50) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName: descabel.font} context:nil].size;
    
  if (!_model.remark) {
        moreBtn.hidden = YES;
         descabel.numberOfLines = 1;
        [descabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom).offset(0);
        }];
    }
   else if (size.width<=ScreenW-20-15-30) {
          moreBtn.hidden = YES;
           descabel.numberOfLines = 1;
          [descabel mas_updateConstraints:^(MASConstraintMaker *make) {
              make.top.equalTo(timeLabel.mas_bottom).offset(10);
          }];
      }
    else{
         moreBtn.hidden = NO;
        [descabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom).offset(10);
        }];
    if (model.multiLine) {
        descabel.numberOfLines = 0;
        moreBtn.selected = YES;
    }
    else{
        descabel.numberOfLines = 1;
        moreBtn.selected = NO;
    }
    }
}
-(void)lookMore{

    self.buttonBlock(self.cellIndex, !self.model.multiLine);
    
}
@end
