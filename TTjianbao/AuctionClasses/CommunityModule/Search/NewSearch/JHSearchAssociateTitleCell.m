//
//  JHSearchAssociateTitleCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchAssociateTitleCell.h"

@interface JHSearchAssociateTitleCell ()
@property(nonatomic,strong)UIImageView * hearderImage;
@property(nonatomic,strong)UILabel * titleLabel;
@end

@implementation JHSearchAssociateTitleCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//
        [self creatCellContentView];
    }
    return self;
}
-(void)creatCellContentView{
    
    self.hearderImage = [[UIImageView alloc] init];
    self.hearderImage.image = [UIImage imageNamed:@"dis_glasses"];
    [self.contentView addSubview:self.hearderImage];
    
    [self.hearderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 16));
        }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = HEXCOLOR(0x333333);
    self.titleLabel.font = JHFont(13);
    [self.contentView addSubview:_titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hearderImage.mas_right).offset(10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView).offset(-12);
    }];;
//    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(16, cellHeight-0.5, kUIScreenWidth-16, 0.5)];
//    line.backgroundColor = kLightBackGroupColor;
//    [self.contentView addSubview:line];
}
- (void)setcellWithKey:(NSString *)key  andSearchkey:(NSString *)searchkey{
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:key];
    NSRange range = [key rangeOfString:searchkey];
    [attrStr addAttribute:NSForegroundColorAttributeName
                          value:HEXCOLOR(0xFEA100)
                          range:range];
    
    self.titleLabel.attributedText = attrStr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
