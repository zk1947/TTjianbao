//
//  JHAmountRecordCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/29.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAmountRecordCell.h"
@implementation JHAmountRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(JHAmountRecordModel *)model {
    _model = model;
    _titleLab.text = model.name;
    _desLabel.text = model.describe;
    _timeLabel.text = model.createDate;
    _amoutLabel.text = [NSString stringWithFormat:@"%@ ¥%@",model.changeType,model.changeAmount];
    if ([model.changeType isEqualToString:@"+"]) {
        _amoutLabel.textColor = HEXCOLOR(0xFF4200);
    }else {
        _amoutLabel.textColor = HEXCOLOR(0x222222);

    }
}
@end
