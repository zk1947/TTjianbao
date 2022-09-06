//
//  JHMROnSaleTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMROnSaleTableViewCell.h"

@implementation JHMROnSaleTableViewCell
{
    UIImageView* offerPriceImage; //n人出价前 ￥图标
    UILabel* offerPriceLabel;
    UILabel* goodIdLabel; //货架号
    UIButton* editBtn;
    UIButton* explainBtn; //讲解中
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawSubviews];
    }
    
    return self;
}

- (void)drawSubviews
{
    goodIdLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"货架："];
    [self.background addSubview:goodIdLabel];
    [goodIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.background).offset(13);
        make.right.equalTo(self.background).offset(-10);
        make.height.mas_equalTo(17);
    }];
    
    offerPriceImage = [JHUIFactory createImageView];
    [self.background addSubview:offerPriceImage];
    [offerPriceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.saleLabel);
        make.left.mas_equalTo(self.saleLabel.mas_right).offset(8);
        make.size.mas_equalTo(12);
    }];
    
    offerPriceLabel = [JHUIFactory createLabelWithTitle:@"0人出价" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:offerPriceLabel];
    [offerPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saleLabel);
        make.left.mas_equalTo(offerPriceImage.mas_right).offset(4);
        make.height.mas_equalTo(17);
    }];
    
    //更新与image间距：20~15
    [self.headerIcon1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(15);
    }];
}

- (void)setupSubviewsByType:(JHMROnSaleCellType)type
{
    if(JHMROnSaleCellTypeToSee == type)
    {
        editBtn = [JHUIFactory createThemeBtnWithTitle:@"通知宝友" cornerRadius:30/2.0 target:self action:@selector(pressNotifyButton)];
        editBtn.titleLabel.font =JHFont(12);
        [self.background addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.background).offset(-10);
            make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(74, 30));
        }];
    }
    else
    {//编辑和讲解中
        editBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"编辑" cornerRadius:30/2.0 target:self action:@selector(pressEditButton)];
        editBtn.titleLabel.font =JHFont(12);
        [self.background addSubview:editBtn];
        
        if (JHMROnSaleCellTypeSaleTab == type)
        {
            //讲解中
            explainBtn = [JHUIFactory createThemeBtnWithTitle:@"开始讲解" cornerRadius:30/2.0 target:self action:@selector(pressExplainButton)];
            explainBtn.titleLabel.font =JHFont(12);
            [self.background addSubview:explainBtn];
            [explainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.background).offset(-10);
                make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(74, 30));
            }];
            
            [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(explainBtn.mas_left).offset(-14);
                make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
        else
        {
            [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.background).offset(-10);
                make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
    }
}

- (void)updateCell:(JHUCOnSaleListModel*)model
{
    //set other subviews
    self.cellModel = model;
    [self setCellDataModel:model];

    offerPriceImage.image = [UIImage imageNamed:@"img_offer_price"];//model.buyerImg];
    offerPriceLabel.text = [NSString stringWithFormat:@"%@人出价", model.offerCount ? : @"0"];
    goodIdLabel.text = model.depositoryLocationCode ? :@"";
    if(model.explainingFlag == 0)
    {
        explainBtn.backgroundColor = kGlobalThemeColor;
        explainBtn.layer.borderWidth = 0;
        [explainBtn setTitle:model.buttonTxt ? : @"开始讲解" forState:UIControlStateNormal];
    }
    else
    {
        explainBtn.backgroundColor = HEXCOLOR(0xffffff);
        explainBtn.layer.borderColor = kGlobalThemeColor.CGColor;
        explainBtn.layer.borderWidth = 1;
        [explainBtn setTitle:model.buttonTxt ? : @"停止讲解" forState:UIControlStateNormal];
    }
}

#pragma mark - events
- (void)pressEditButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:RequestTypeEdit dataModel:self.cellModel indexPath:self.sd_indexPath];
    }
}

- (void)pressExplainButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:tableViewCell:)]) {
        [self.delegate pressButtonType:RequestTypeExplain tableViewCell:self];
    }
}

- (void)pressNotifyButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:RequestTypeNotificationUser dataModel:self.cellModel indexPath:self.sd_indexPath];
    }
}

@end
