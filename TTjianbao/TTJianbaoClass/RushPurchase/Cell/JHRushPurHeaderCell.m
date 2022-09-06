//
//  JHRushPurHeaderCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurHeaderCell.h"

@interface JHRushPurHeaderCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCon;
@property (weak, nonatomic) IBOutlet UILabel *bottomLbl;
@property(nonatomic, strong) CAGradientLayer * gradLayer;
@end

@implementation JHRushPurHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setItems];
    
}
- (void)prepareForReuse{
    [super prepareForReuse];
    [self.gradLayer removeFromSuperlayer];

}
- (void)refreshTitle:(NSString *)title andDesTitle:(NSString *)des{
    self.titleLbl.text = title;
    self.bottomLbl.text = des;
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.topcon.constant = 6;
        self.bottomCon.constant = 8;
        self.titleLbl.font = JHBoldFont(20);
        self.bottomLbl.font = JHFont(14);
        self.titleLbl.textColor = UIColor.whiteColor;
        self.bottomLbl.textColor = UIColor.whiteColor;
        if (!self.gradLayer) {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFF8C00).CGColor, (__bridge id)HEXCOLOR(0xFF5200).CGColor];
            gradientLayer.locations = @[@0, @1];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1.0, 1.0);
            gradientLayer.frame = self.bounds;
            self.gradLayer = gradientLayer;
        }
        [self.contentView.layer insertSublayer:self.gradLayer atIndex:0];
    }else{
        [self.gradLayer removeFromSuperlayer];
        self.topcon.constant = 5;
        self.bottomCon.constant = 5;
        self.titleLbl.font = JHBoldFont(18);
        self.bottomLbl.font = JHFont(12);
        self.titleLbl.textColor = HEXCOLOR(0x333333);
        self.bottomLbl.textColor = HEXCOLOR(0x999999);
    }
}

- (void)setItems{
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.titleLbl.textColor = HEXCOLOR(0x333333);
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradLayer.frame = self.bounds;
}
@end
