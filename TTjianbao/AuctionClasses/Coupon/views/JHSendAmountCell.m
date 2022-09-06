//
//  JHSendAmountCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/29.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHSendAmountCell.h"
#import "CoponPackageMode.h"

@implementation JHSendAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (_model) {
        if ([_model.ruleType isEqualToString:@"B"]) {
            if (selected) {
                self.selectedView.hidden = NO;
                self.bgView.image = [UIImage imageNamed:@"bg_red_selected"];
            }else {
                self.selectedView.hidden = YES;
                self.bgView.image = [UIImage imageNamed:@"bg_red_normal"];
                
            }

        }else {
            if (selected) {
                self.selectedView.hidden = NO;
                self.bgView.image = [UIImage imageNamed:@"bg_yellow_selected"];
            }else {
                self.selectedView.hidden = YES;
                self.bgView.image = [UIImage imageNamed:@"bg_yellow_normal"];
                
            }

        }
        
    }
}

- (void)setModel:(CoponPackageMode *)model {
    _model = model;
    if ([model.ruleType isEqualToString:@"B"]) {
        self.amountLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
        self.desString.text = model.name;
        self.desc.hidden = YES;
        self.toCenterHeight.constant = 0;
        self.bgView.image = [UIImage imageNamed:@"bg_yellow_normal"];
        self.iconImage.image = [UIImage imageNamed:@"icon_red_pocket"];
        
    }else {
        self.amountLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
        self.desString.text = model.name;
        self.desc.text = model.remark;
        self.desc.hidden = NO;
        self.toCenterHeight.constant = -10;
        self.bgView.image = [UIImage imageNamed:@"bg_red_normal"];
        self.iconImage.image = [UIImage imageNamed:@"icon_coupon_pocket"];

    }
    
}

@end
