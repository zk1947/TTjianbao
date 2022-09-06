//
//  JHSearchRecommendLivingCell.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchRecommendLivingCell.h"
#import "UIImageView+WebCache.h"
@interface JHSearchRecommendLivingCell()
@property(nonatomic,strong)UIImageView * hearderImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;

@property(nonatomic,strong)UIImageView * sortImage;
@property(nonatomic,strong)UILabel * sortlabel;
@property (strong, nonatomic)  YYAnimatedImageView *playingImage;
@property(nonatomic,strong)UIView *livingStatusView;
@end

@implementation JHSearchRecommendLivingCell
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
    self.hearderImage.layer.cornerRadius = 3;
    self.hearderImage.clipsToBounds = YES;
    [self.contentView addSubview:self.hearderImage];
    
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
    
    self.subLabel = [[UILabel alloc] init];
    self.subLabel.textColor = HEXCOLOR(0x999999);
    self.subLabel.font = JHFont(13);
    [self.contentView addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hearderImage.mas_right).offset(8);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
            make.right.equalTo(self.contentView).offset(-12);
    }];
    
    _livingStatusView = [[UIView alloc] init];
    _livingStatusView.backgroundColor = HEXCOLOR(0xffd70f);
    [_livingStatusView jh_cornerRadius:1.0];
    [self.hearderImage addSubview:_livingStatusView];
    
    [_livingStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@6);
        make.left.equalTo(@6);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    _playingImage=[[YYAnimatedImageView alloc]init];
    _playingImage.contentMode=UIViewContentModeScaleAspectFit;
    _playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
    [self.hearderImage addSubview:_playingImage];
    [_playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.left.equalTo(@8);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
}
- (void)resetCellModel:(JHSearchRecommendLivingModel *)model andindex:(NSInteger)row{
    [self.hearderImage jh_setImageWithUrl:model.smallCoverImg];
    self.titleLabel.text = model.anchorName;
    self.subLabel.text = [NSString stringWithFormat:@"热度：%@",model.watchTotal];
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
