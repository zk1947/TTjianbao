//
//  JHClaimOrderListCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/25.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHClaimOrderListCell.h"
#import "UIImageView+JHWebImage.h"
#import "NSString+AttributedString.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHClaimOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.toLeadingWidth.constant = 0;
    self.selectedImage.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    if (self.toLeadingWidth.constant == 0) {
//        
//    }else {
//        self.selectedImage.hidden = !self.selectedImage.hidden;
//        
//        if (selected) {
//            self.selectedImage.hidden = NO;
//        }else {
//            self.selectedImage.hidden = YES;
//        }
//
//    }
//    


    
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (void)setModel:(OrderMode *)model {
    _model = model;
    if (_model) {
        self.buyerLabel.text = model.buyerName;
        self.priceLabel.text = model.orderPrice;
        self.orderIdLabel.text = model.orderCode;
        if (model.expressNumber.length>=4) {
            NSMutableAttributedString *string = [model.expressNumber attributedFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:14] color:HEXCOLOR(0x222222) range:NSMakeRange(0, model.expressNumber.length)];
            [string addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xFF4200) range:NSMakeRange(model.expressNumber.length-4, 4)];
            self.expressIdLabel.attributedText = string;
            
        }else{
            self.expressIdLabel.text = model.expressNumber;
            self.expressIdLabel.textColor = HEXCOLOR(0xFF4200);
        }
        
        [self.coverImage jhSetImageWithURL:[NSURL URLWithString:model.goodsImg] placeholder:kDefaultCoverImage];
    }
}

@end
