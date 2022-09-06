//
//  JHStoneDetailBidderCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDetailBidderCell.h"
#import "JHStoneResaleDetailview.h"
#import "CStoneDetailModel.h"
@interface JHStoneDetailBidderCell ()

@property (nonatomic, strong) JHStoneResaleDetailview *cellView;

@end

@implementation JHStoneDetailBidderCell

-(void)addSelfSubViews
{
    _cellView = [JHStoneResaleDetailview new];
    [self.contentView addSubview:_cellView];
    [_cellView jh_cornerRadius:20.f borderColor:RGB(238, 238, 238) borderWidth:1];
    _cellView.backgroundColor = RGB(252, 252, 252);
    [_cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 10, 15));
        make.height.mas_equalTo(40.f);
    }];
    _cellView.nameLabel.textColor = RGB(51, 51, 51);
    _cellView.timeLabel.textColor = RGB(153, 153, 153);
    _cellView.priceLabel.textColor = UIColor.blackColor;
    [_cellView.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cellView);
        make.right.equalTo(self.cellView.offerStatusImg.mas_left).offset(-12);
    }];
    
}

-(void)setModel:(COfferRecordListData *)model
{
    _model = model;
    JHStoneResaleDetailSubModel *m = [JHStoneResaleDetailSubModel new];
    m.headImg     = _model.offerCustomerIcon;
    m.name        = _model.offerCustomerName;
    m.time        = _model.createTime;
    m.price       = _model.offerPrice;
    m.offerStatus = _model.offerState;
    [_cellView updateCell:m];
    
    NSString *title = PRICE_FLOAT_TO_STRING(_model.offerPrice.floatValue);
    if(_model.offerPrice.floatValue>=1000)
    {
        title = @(_model.offerPrice.integerValue).stringValue;
    }
    if (_model.offerState != 3) {
        title = @"*******";
    }
    _cellView.priceLabel.text = title;
    
    
    
    
//    priceLabel = [JHUIFactory createJHLabelWithTitle:@"*******" titleColor:HEXCOLOR(0xFFFFFF) font:JHMediumFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
}

@end
