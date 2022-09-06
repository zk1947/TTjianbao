//
//  JHRankingCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/15.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHRankingCell.h"
#import "NSString+AttributedString.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHRankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = kGlobalThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JHRankingModel *)model {
    _model = model;
    self.rankLabel.text = @(model.ranking).stringValue;
    self.priceLabel.attributedText = [[NSString stringWithFormat:@"¥%@",model.priceStr] formatePriceFontSize:22 color:HEXCOLOR(0xFF4200)];
    self.anchorLabel.text = model.anchorName;
    self.nickLabel.text = model.viewerName;
    [self.coverImage jhSetImageWithURL:[NSURL URLWithString:model.videoCoverImg] placeholder:kDefaultCoverImage];
    self.titleLab.text = model.title;
    switch (model.ranking) {
        case 1:{
            self.rankImage.image = [UIImage imageNamed:@"bg_rank_first"];
            self.rankLabel.textColor = HEXCOLOR(0xFF4200);
        }
            
            break;
        case 2:{
            self.rankImage.image = [UIImage imageNamed:@"bg_rank_second"];
            self.rankLabel.textColor = HEXCOLOR(0x3D4349);
        }
            
            break;
        case 3:{
            self.rankImage.image = [UIImage imageNamed:@"bg_rank_third"];
            self.rankLabel.textColor = HEXCOLOR(0x482E1C);
        }
            
            break;

        default:
        {
            self.rankImage.image = [UIImage imageNamed:@"bg_rank_none"];
            self.rankLabel.textColor = HEXCOLOR(0xffffff);
        }
            break;
    }
}
@end
