//
//  JHRecyleRowLabelView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyleRowLabelView.h"

@interface JHRecyleRowLabelView ()
@property (nonatomic, strong) CAShapeLayer *shaperLayer;
@end

@implementation JHRecyleRowLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(10);
    }];
}

-(void)setTipsbackColor:(UIColor *)tipsbackColor {
    self.shaperLayer.fillColor = tipsbackColor.CGColor;
    self.tipsLabel.backgroundColor = tipsbackColor;
}

- (void)drawArrowWithPoint:(CGFloat )beginPointX {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(beginPointX, 10)];
    [path addLineToPoint:CGPointMake(beginPointX + 12, 0)];
    [path addLineToPoint:CGPointMake(beginPointX + 24, 10)];
    [path closePath];
    self.shaperLayer = [CAShapeLayer new];
    self.shaperLayer.fillColor = HEXCOLORA(0xffd70f, 0.1).CGColor;
    self.shaperLayer.path = path.CGPath;
    [self.layer addSublayer:self.shaperLayer];
}

- (YYLabel *)tipsLabel {
    if (_tipsLabel == nil) {
        _tipsLabel = [[YYLabel alloc] init];
        _tipsLabel.textColor = HEXCOLOR(0x666666);
        _tipsLabel.font = [UIFont fontWithName:kFontMedium size:12];
        _tipsLabel.text = @"";
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textContainerInset = UIEdgeInsetsMake(6, 8, 6, 8);
        _tipsLabel.preferredMaxLayoutWidth = kScreenWidth - 20 - 16;  //20外边距  16内边距
        _tipsLabel.backgroundColor = HEXCOLORA(0xffd70f, 0.1);
        _tipsLabel.layer.cornerRadius = 4;
        _tipsLabel.clipsToBounds = YES;
    }
    return _tipsLabel;
}
@end
