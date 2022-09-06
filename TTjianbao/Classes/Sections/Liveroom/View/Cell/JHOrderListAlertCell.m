//
//  JHOrderListAlertCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/24.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHOrderListAlertCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHOrderListAlertCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _avatar.layer.cornerRadius = 15;
    _avatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(OrderMode *)model {
    _model = model;
    if (!model.buyerName) {
        _nickLabel.text = model.sellerName;
        [_avatar jhSetImageWithURL:[NSURL URLWithString:model.sellerImg] placeholder:kDefaultAvatarImage];

    }else {
        _nickLabel.text = model.buyerName;
        [_avatar jhSetImageWithURL:[NSURL URLWithString:model.buyerImg] placeholder:kDefaultAvatarImage];

    }
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.originOrderPrice];
    _stateLabel.text = @"";
    if ([model.orderStatus isEqualToString:@"waitpay"]) {
        _stateLabel.text=@"待付款";
    }
    else  if ([model.orderStatus isEqualToString:@"waitportalsend"]) {
        _stateLabel.text=@"平台已鉴定（待发货）";
    }
    else  if ([model.orderStatus isEqualToString:@"waitsellersend"]) {
        if (model.directDelivery) {
            _stateLabel.text=@"待发货";
        } else {
            _stateLabel.text=@"待卖家发货给平台";
        }
    }
    else  if ([model.orderStatus isEqualToString:@"waitportalappraise"]) {
        _stateLabel.text=@"待鉴定";
    }
    else  if ([model.orderStatus isEqualToString:@"portalsent"]) {
        _stateLabel.text=@"待收货";
    }
    else  if ([model.orderStatus isEqualToString:@"buyerreceived"]) {
        _stateLabel.text=@"已完成";
    }else if ([model.orderStatus isEqualToString:@"waitack"]) {
        _stateLabel.text=@"待确认";

    }  else  if ([model.orderStatus isEqualToString:@"cancel"]) {
        
        _stateLabel.text=@"订单已取消";
        
        
    }else  if ([model.orderStatus isEqualToString:@"refunding"]) {
        _stateLabel.text=@"售后中";
        
    }
    else  if ([model.orderStatus isEqualToString:@"refunded"]) {
        _stateLabel.text=@"售后完成";
        
    }

}

@end
