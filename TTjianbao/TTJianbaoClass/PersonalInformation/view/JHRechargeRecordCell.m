//
//  JHRechargeRecordCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHRechargeRecordCell.h"
@interface JHRechargeRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *recordTitle;
@property (weak, nonatomic) IBOutlet UILabel *recordTime;
@property (weak, nonatomic) IBOutlet UILabel *recordDesc;
@property (weak, nonatomic) IBOutlet UILabel *recordBeanCount;

@end
@implementation JHRechargeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(JHBeanRecordModel *)model{
    
      _model=model;
     _recordTitle.text=_model.name;
     _recordDesc.text=_model.describe;
     _recordTime.text=_model.createDate;
     _recordBeanCount.text=[OBJ_TO_STRING(_model.changeType) stringByAppendingString:OBJ_TO_STRING(model.changeAmount)];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
