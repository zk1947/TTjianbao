//
//  JHRROnSaleTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHRROnSaleTableViewCell.h"

@implementation JHRROnSaleTableViewCell
{
    UIButton* fixPriceBtn;
    UIButton* yellowBtn;    //取消寄售或者一口价
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawSubviews];
        
        //主题变成:JHCellThemeTypeClearColor时,需调整
        [self resetSubview];
    }
    
    return self;
}

- (void)drawSubviews
{
    //从下往上,从右向左,依赖
    yellowBtn = [JHUIFactory createThemeBtnWithTitle:@"取消寄售" cornerRadius:30/2.0 target:self action:@selector(pressYellowButton:)];
    yellowBtn.tag = 1;
    yellowBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:yellowBtn];
    [yellowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-10);
        make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(-9);
        make.size.mas_equalTo(CGSizeMake(65, 26));
    }];
    
    fixPriceBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"修改价格" cornerRadius:30/2.0 target:self action:@selector(pressFixPriceBtn:)];
    fixPriceBtn.tag = 2;
    [fixPriceBtn setTitleColor:HEXCOLOR(0xFEE100) forState:UIControlStateNormal];
    fixPriceBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:fixPriceBtn];
    [fixPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(yellowBtn.mas_left).offset(-10);
        make.bottom.equalTo(yellowBtn);
        make.size.mas_equalTo(CGSizeMake(65, 26));
    }];
}

- (void)updateCell:(JHGoodResaleListModel*)model
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    self.cellModel = model;
     //set super subviews
    [self.ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];////网络图片
    self.sawLabel.text = [NSString stringWithFormat:@"%@热度", model.seekCount ?:@"0"];
    self.idLabel.text = [NSString stringWithFormat:@"%@", model.goodsCode?:@""];
    self.descpLabel.text = model.goodsTitle;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", model.salePrice?:@""];
}

#pragma mark - events
- (void)pressYellowButton:(UIButton*)button
{
    if (button.tag == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
            [self.delegate pressButtonType:RequestTypeCellCancelResale dataModel:self.cellModel indexPath:self.indexPath];
        }
    }else  if (button.tag == 2){
        if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
            [self.delegate pressButtonType:RequestTypeOnePrice dataModel:self.cellModel indexPath:self.indexPath];
        }
    }
}

- (void)pressFixPriceBtn:(UIButton*)button
{
    if(button.tag == 1)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
            [self.delegate pressButtonType:RequestTypeoOfferPrice dataModel:self.cellModel indexPath:self.indexPath];
        }
    }
    else if(button.tag == 2)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
            [self.delegate pressButtonType:RequestTypeEdit dataModel:self.cellModel indexPath:self.indexPath];
        }
    }
}

- (void)pressToSeeButton
{
    JHGoodResaleListModel* model = self.cellModel;
    if(model.selfSeek == 1)
        return;//禁止响应

    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:RequestTypeSeeSee dataModel:self.cellModel indexPath:self.indexPath];
    }
}

@end
