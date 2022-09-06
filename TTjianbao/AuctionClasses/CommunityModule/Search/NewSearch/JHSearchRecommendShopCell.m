//
//  JHSearchRecommendShopCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchRecommendShopCell.h"
@interface JHSearchRecommendShopCell()
@property(nonatomic,strong)UIImageView * hearderImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;
@property(nonatomic,strong)UIImageView * sortImage;
@property(nonatomic,strong)UILabel * sortlabel;
@property (nonatomic, strong) UIView * starView;
@end

@implementation JHSearchRecommendShopCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//
        [self creatCellContentView];
    }
    return self;
}
-(void)creatCellContentView{
    
    self.sortImage = [[UIImageView alloc] init];
    
    [self.contentView addSubview:self.sortImage];
    [self.sortImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 21));
        }];
    
    self.sortlabel = [[UILabel alloc] init];
    self.sortlabel.textColor = HEXCOLOR(0x666666);
    self.sortlabel.textAlignment = NSTextAlignmentCenter;
    self.sortlabel.font = JHMediumFont(15);
    [self.contentView addSubview:self.sortlabel];
    [self.sortlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(9);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 18));
    }];
    
    self.hearderImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.hearderImage];
    self.hearderImage.layer.cornerRadius = 3;
    self.hearderImage.clipsToBounds = YES;
    [self.hearderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(45);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(54, 54));
        }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = HEXCOLOR(0x333333);
    self.titleLabel.font = JHFont(13);
    [self.contentView addSubview:_titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hearderImage.mas_right).offset(8);
            make.top.mas_equalTo(15);
            make.right.equalTo(self.contentView).offset(-12);
    }];
    
    //评分
    [self.contentView addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.hearderImage.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(60, 10));
    }];
    
    self.subLabel = [[UILabel alloc] init];
    self.subLabel.textColor = HEXCOLOR(0xFFC241);
    self.subLabel.font = JHFont(13);
    [self.contentView addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.starView.mas_right).offset(15);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
            
    }];
}

- (void)resetCellModel:(JHSearchRecommendShopdModel *)model  andindex:(NSInteger)row{
    [self.hearderImage jh_setImageWithUrl:model.shopLogoImg];
    self.titleLabel.text = model.shopName;
    self.subLabel.text = [NSString stringWithFormat:@"%.1f",[model.comprehensiveScore floatValue]];
    self.sortlabel.text = [NSString stringWithFormat:@"%ld",row+1];
    self.sortlabel.hidden = YES;
    if (row == 0) {
        self.sortImage.image = [UIImage imageNamed:@"searchRecommenHot_1"];
    }else if(row == 1){
        self.sortImage.image = [UIImage imageNamed:@"searchRecommenHot_2"];
    }else if(row == 2){
        self.sortImage.image = [UIImage imageNamed:@"searchRecommenHot_3"];
    }else{
        self.sortImage.image = nil;
        self.sortlabel.hidden = NO;
    }
    
    //评分
    [self.starView removeAllSubviews];
    for (int i=0; i < [model.comprehensiveScore intValue]; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"newStore_star_yellow_icon"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0+i*14, 0, 10, 10);
        [self.starView addSubview:button];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UIView *)starView{
    if (!_starView) {
        _starView = [[UIView alloc]init];
    }
    return _starView;
}
@end
