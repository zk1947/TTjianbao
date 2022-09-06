//
//  JHFansEquityTableViewCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansEquityTableViewCell.h"

@interface JHFansEquityTableViewCell()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *arrowImage;
@end

@implementation JHFansEquityTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        [self configUI];
    }
    return self;
}
- (void)configUI{
    _titleLabel = [[UILabel alloc]init];
    
    _titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:12];
    _titleLabel.textColor = kColor333;
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fansLvArrow"]];
    [self.contentView addSubview:_arrowImage];
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 8.5));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView).offset(-3);
    }];
    _arrowImage.hidden = YES;
    
//    UIView * line = [[UIView alloc] init];
//    line.backgroundColor = HEXCOLOR(0xDDDDDD);
//    [self.contentView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//        make.right.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(0.5, 12));
//    }];
//
}
- (void)setCellWithTitle:(NSString *)title{
    _titleLabel.text = title;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        _arrowImage.hidden = NO;
        _titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:13];
        _titleLabel.textColor = HEXCOLOR(0xFF4200);
    }else{
        _arrowImage.hidden = YES;
        _titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:12];
        _titleLabel.textColor = kColor333;
    }
    // Configure the view for the selected state
}

@end
