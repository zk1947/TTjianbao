//
//  JHTakeOutRecordCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHTakeOutRecordCell.h"

@implementation JHTakeOutRecordCell

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
    if (_model) {
        self.titleLab.text = [NSString stringWithFormat:@"￥%@", model.changeAmount];
        self.timeLabel.text = model.createDate;
        self.stateLabel.textColor = HEXCOLOR(0x666666);

        if ([model.status isEqualToString:@"withdrawRequest"]) {
            self.stateLabel.text = @"处理中";
            self.stateLabel.textColor = HEXCOLOR(0xFDA100);
        }else if ([model.status isEqualToString:@"withdrawPass"]) {
            self.stateLabel.text = @"成功";

        }else if ([model.status isEqualToString:@"withdrawReject"]) {
            self.stateLabel.text = @"失败";

        }else {
            self.stateLabel.text = model.status;

        }
    }
    
}
@end
