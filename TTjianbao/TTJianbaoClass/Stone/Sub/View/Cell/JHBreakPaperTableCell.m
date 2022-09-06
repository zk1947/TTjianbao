//
//  JHBreakPaperTableCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBreakPaperTableCell.h"
#import "JHUIFactory.h"
#import "JHMainLiveSmartModel.h"
@implementation JHBreakPaperTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeUI];

    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
       if (self) {
           [self makeUI];
       }
       return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    self.paperNumLabel = [JHUIFactory createJHLabelWithTitle:@"寄售" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft preTitle:@"折叠单1"];

    [self.contentView addSubview:self.paperNumLabel];
    self.priceLabel = [JHUIFactory createJHLabelWithTitle:@"1234" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft preTitle:@"购入金额："];
    
    [self.contentView addSubview:self.priceLabel];
    
    JHCustomLine *line = [JHUIFactory createLine];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
        make.trailing.equalTo(self);
        make.leading.equalTo(self).offset(10);
    }];
    
    [self.paperNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(@5);
           make.leading.equalTo(@10);
       }];
       
       [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.paperNumLabel.mas_bottom).offset(3);
           make.leading.equalTo(self.paperNumLabel);
           make.bottom.offset(-10);
       }];
    
    
}


- (void)setModel:(JHMainLiveSplitDetailModel *)model {
    self.paperNumLabel.preTitle = [NSString stringWithFormat:@"拆单%zd：", self.tag];
    self.paperNumLabel.text = model.splitModeName;
    [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",model.purchasePrice] font:[UIFont fontWithName:kFontBoldDIN size:15] color:HEXCOLOR(0xFC4200)];
}
@end
