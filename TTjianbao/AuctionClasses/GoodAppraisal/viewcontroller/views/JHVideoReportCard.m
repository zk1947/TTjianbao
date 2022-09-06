//
//  JHVideoReportCard.m
//  TTjianbao
//
//  Created by yaoyao on 2019/4/15.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHVideoReportCard.h"
#import "CommHelp.h"
#import "UIImageView+JHWebImage.h"
#import "UserInfoRequestManager.h"

@interface JHVideoReportCard () {
}

@end

@implementation JHVideoReportCard
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];

    self.gestView = self.backView;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    self.backView.layer.mask = maskLayer;

}

- (IBAction)closeSelf:(id)sender {
    [self hiddenAlert];
}

- (void)blankAction {
    
}

- (void)setModel:(JHRecorderModel *)model {
    _model = model;
    if (!_model) {
        return;
    }
    self.nickLabel.text = [NSString stringWithFormat:@"【宝友】%@", _model.name?:@""];
    [self.avatar jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(_model.icon)] placeholder:kDefaultAvatarImage];

    
    if (!_model.appraisePriceStr) {
        _model.appraisePriceStr = @"0";
    }
        
    if (model.result) {
        if ([CommHelp isAvailablePrice:model.appraisePrice]) {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.appraisePrice];
        } else {
            if ([CommHelp isAvailablePrice:model.appraisePriceStr]) {
                self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.appraisePriceStr];
            } else {
                self.priceLabel.text = @"暂无估价";
            }
        }
    } else {
        self.priceLabel.text = @"暂无估价";
    }
    
    
    self.anchorLabel.text = _model.anchorName;
    self.timeLabel.text = _model.createDate;

    if (model.result == 0) {
        self.trueOrFalseLabel.text = @"鉴定为假";
        self.trueOrFalseImage.image = [UIImage imageNamed:@"img_video_report_false"];
        self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }else if(model.result == 1){
        self.trueOrFalseLabel.text = @"鉴定为真";
        self.trueOrFalseImage.image = [UIImage imageNamed:@"img_video_report_true"];
        self.priceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:14];
    }else{
        self.trueOrFalseLabel.text = @"部分为真";
        self.trueOrFalseImage.image = [UIImage imageNamed:@""];
        self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    self.desLabel.text = _model.content;
    _trueOrFalseImage.hidden = NO;
    
}


@end
