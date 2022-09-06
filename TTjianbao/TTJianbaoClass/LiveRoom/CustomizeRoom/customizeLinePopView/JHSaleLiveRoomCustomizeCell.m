//
//  JHSaleLiveRoomCustomizeCell.m
//  TTjianbao
//
//  Created by apple on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSaleLiveRoomCustomizeCell.h"
#import "JHUIFactory.h"
#import "UIView+JHGradient.h"
@implementation JHSaleLiveRoomCustomizeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
        if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [self creatCellSubView];
        }
    return self;
}

- (void)creatCellSubView{

    self.imageV = [[UIImageView alloc] init];
    self.imageV.layer.cornerRadius = 4;
    self.imageV.layer.masksToBounds = YES;
    [self.contentView addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 5, 0));
    }];
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = JHMediumFont(10);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000, 0), HEXCOLORA(0x000000, 1)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(40, 0, 5, 0));
    }];
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
