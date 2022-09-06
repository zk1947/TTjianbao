//
//  JHOrderSortTableViewCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/18.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHOrderSortTableViewCell.h"
#import "UserInfoRequestManager.h"
#import "NSString+AttributedString.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoKeyword.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHOrderSortTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.backView.layer.cornerRadius = 4;
    self.backView.layer.masksToBounds = NO;
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backView.layer.shadowOffset = CGSizeZero;
    self.backView.layer.shadowOpacity = 0.1;
    self.backView.layer.shadowRadius = 4;
    //    self.backView.layer.shouldRasterize = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.buyerIcon.layer.cornerRadius = 10;
    self.buyerIcon.layer.masksToBounds = YES;
    
    self.coverImage.layer.cornerRadius = 2;
    self.coverImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


- (void)setModel:(JHRankingNewModel *)model {
    _model = model;
    NSArray *colors = @[HEXCOLOR(0xFF0000),HEXCOLOR(0x3D4349),HEXCOLOR(0x624029)];
    if (self.tag<3) {
        [self.sortImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rank_sort_%ld", self.tag+1]]];
        self.sortLabel.textColor = colors[self.tag];
    }else {
        [self.sortImage setImage:[UIImage imageNamed:@"rank_sort_4"]];
        self.sortLabel.textColor = HEXCOLOR(0xffffff);
    }
    self.sortLabel.text = @(self.tag+1).stringValue;

    self.scoreDes.text = model.overshoot;
    NSString *score = [NSString stringWithFormat:@"%.2f",model.scoreAverage];
    self.scoreLabel.attributedText = [[NSString stringWithFormat:@"%@分",score] attributedSubString:[score substringFromIndex:score.length-3] subString:@"分" font:[UIFont fontWithName:kFontBoldDIN size:27] color:HEXCOLOR(0xFF0000) sfont:[UIFont fontWithName:@"PingFangSC-Semibold" size:21] scolor:HEXCOLOR(0xFF0000) allColor:HEXCOLOR(0xFF0000) allfont:[UIFont fontWithName:kFontBoldDIN size:36]];
    [self.coverImage jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(model.videoCoverImg)] placeholder:kDefaultCoverImage];
    self.videoTitleLabel.text = model.reportGoodsName;
    [self.buyerIcon jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(model.buyerImg)] placeholder:kDefaultAvatarImage];
    self.buyerLabel.text = model.buyerName;
    self.anchorLabel.text = [NSString stringWithFormat:@"鉴定师：%@",model.anchorName];
    self.priceLabel.text = [NSString stringWithFormat:@"成交价格：¥%@",model.originOrderPrice?:@""];
//    self.scoreRare.text = [NSString stringWithFormat:@"%.2f", model.scoreRare];
//    self.scoreCost.text =  [NSString stringWithFormat:@"%.2f", model.scoreCost];
//    self.scoreCraft.text =  [NSString stringWithFormat:@"%.2f", model.scoreCraft];
//    self.scoreHedging.text =  [NSString stringWithFormat:@"%.2f", model.scoreHedging];
    
}
@end
