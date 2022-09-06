//
//  JHRankingTableViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRankingTableViewCell.h"
#import "JHLiveRoomPKModel.h"
#import "TTjianbaoMarcoUI.h"
#import "CommHelp.h"
#import "UIImageView+JHWebImage.h"

@interface JHRankingTableViewCell()
@property(nonatomic,strong)UILabel *rankLabel;
@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *rightLabel;
@property(nonatomic,strong)UIView *statusBackView;
@end

@implementation JHRankingTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatCellView];
    }
    return self;
}

-(void)creatCellView{
    self.rankLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.rankLabel];
    self.rankLabel.textColor = HEXCOLOR(0x999999);
    self.rankLabel.font = JHDINBoldFont(18);
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(39, 21));
    }];
    
    self.headerImage = [[UIImageView alloc] init];
//    self.headerImage.backgroundColor = [UIColor grayColor];
    self.headerImage.layer.cornerRadius = 25;
    self.headerImage.clipsToBounds = YES;
    [self.contentView addSubview:self.headerImage];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(self.rankLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    self.statusBackView = [[UIView alloc] init];
    self.statusBackView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    self.statusBackView.layer.cornerRadius = 8;
    [self.contentView addSubview:self.statusBackView];
    
    [self.statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(46, 16));
        make.top.mas_equalTo(self.headerImage.mas_bottom).offset(-10);
        make.centerX.mas_equalTo(self.headerImage.mas_centerX);
    }];
    
    UIImageView *playingImage = [[UIImageView alloc]init];
    playingImage.contentMode = UIViewContentModeScaleAspectFit;
    playingImage.image = [UIImage imageNamed:@"icon_buy_living"];
    [self.statusBackView addSubview:playingImage];
    [playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusBackView);
        make.left.equalTo(self.statusBackView).offset(4);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];
    UILabel * status = [[UILabel alloc]init];
    status.text = @"直播中";
    status.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
    status.textColor = [CommHelp toUIColorByStr:@"#ffffff"];
    status.textAlignment = UIControlContentHorizontalAlignmentCenter;
    status.lineBreakMode = NSLineBreakByWordWrapping;
    [self.statusBackView addSubview:status];
    
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusBackView);
        make.left.equalTo(playingImage.mas_right).offset(4);
    }];
    
    
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    
    self.titleLabel.textColor = HEXCOLOR(0x333333);
    self.titleLabel.font = JHFont(15);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenW-160, 21));
    }];
    
    self.rightLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.rightLabel];
    
    self.rightLabel.textColor = HEXCOLOR(0xFF4200);
    self.rightLabel.font = JHFont(13);
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-18);
        make.size.mas_equalTo(CGSizeMake(60, 21));
    }];
}
-(void)resetCellView:(JHLiveRoomPKInfoModel *)model andIsIncrease:(BOOL)isIncrease{
    self.rankLabel.text = model.ranking;
    [self.headerImage jhSetImageWithURL:[NSURL URLWithString:model.img ? : @""] placeholder:kDefaultAvatarImage];
    self.titleLabel.text = model.name;
    if ([model.isOpen boolValue]) {
        self.statusBackView.hidden = NO;
    }else{
        self.statusBackView.hidden = YES;
    }
    if (isIncrease && model.increase.length>0) {
        self.rightLabel.font = JHMediumFont(13);
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.increase];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        if ([model.increase integerValue]>0) {
            self.rightLabel.textColor = HEXCOLOR(0xFF4200);
            attch.image = [UIImage imageNamed:@"up_arrows_red"];
            attch.bounds = CGRectMake(0, -2, 9, 12);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
        }else if ([model.increase integerValue] == 0){
            self.rightLabel.textColor = HEXCOLOR(0xFEE100);
            attch.image = [UIImage imageNamed:@"flat_arrows_yellow"];
            attch.bounds = CGRectMake(0, 0, 15, 2);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:string];
        }else{
           self.rightLabel.textColor = HEXCOLOR(0x4AF936);
            attch.image = [UIImage imageNamed:@"down_arrows_green"];
            attch.bounds = CGRectMake(0, -2, 9, 12);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:string];
        }
        self.rightLabel.attributedText = attri;
    }else{
        self.rightLabel.textColor = HEXCOLOR(0xFF4200);
        self.rightLabel.font = JHFont(13);
        self.rightLabel.text = model.score;
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
