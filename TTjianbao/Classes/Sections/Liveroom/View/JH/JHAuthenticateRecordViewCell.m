//
//  JHAuthenticateRecordViewCell.m
//  TTjianbao
//
//  Created by Donto on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAuthenticateRecordViewCell.h"
#import "UIColor+YYAdd.h"
#import "UIImageView+JHWebImage.h"

@interface JHAuthenticateRecordViewCell ()

@property (nonatomic, strong) UIImageView *authenImageView;
@property (nonatomic, strong) UILabel *trueFalseLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) CAGradientLayer *trueGradientLayer;
@end

@implementation JHAuthenticateRecordViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContents];
        [self initBottomViews];
    }
    return self;
}

- (void)initContents {
    UIImageView *authenImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    authenImageView.layer.cornerRadius = 4.5;
    authenImageView.layer.masksToBounds = YES;
    _authenImageView = authenImageView;
    
    UILabel *trueFalseLabel = [[UILabel alloc]initWithFrame:CGRectMake(-11.5, 7, 73.5, 23)];
    trueFalseLabel.layer.masksToBounds = YES;
    trueFalseLabel.textColor = UIColor.whiteColor;
    trueFalseLabel.font = [UIFont systemFontOfSize:10.6 weight:UIFontWeightMedium];
    trueFalseLabel.textAlignment = NSTextAlignmentCenter;
    _trueFalseLabel = trueFalseLabel;
    
    [authenImageView.layer addSublayer:self.trueGradientLayer];
    [self.contentView addSubview:authenImageView];
    [authenImageView addSubview:trueFalseLabel];

}

- (void)initBottomViews {
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 27, self.frame.size.width, 27)];
    
    UIImageView *bottomBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 27)];
    bottomBgImageView.image = [UIImage imageNamed:@"jh_img_record_bg"];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 6, self.frame.size.width/2.0 - 5, 23)];
    priceLabel.textColor = UIColor.whiteColor;
    priceLabel.font = [UIFont systemFontOfSize:11.76 weight:UIFontWeightMedium];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel = priceLabel;
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0, 6, self.frame.size.width/2.0 - 5, 23)];
    timeLabel.textColor = [UIColor colorWithRGB:0X999999];
    timeLabel.font = [UIFont systemFontOfSize:11.76 weight:UIFontWeightMedium];
    timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel = timeLabel;
    
    [bottomView addSubview:bottomBgImageView];
    [bottomView addSubview:priceLabel];
    [bottomView addSubview:timeLabel];
    [self.contentView addSubview:bottomView];

}

- (void)setModel:(JHAnchorRecordListModel *)model {
    _timeLabel.text = model.appraiseDateFormat;
    _priceLabel.text = [NSString stringWithFormat:@"%@元",model.price];
    [_authenImageView jhSetImageWithURL:[NSURL URLWithString:model.coverImg] placeholder:nil];
    _trueFalseLabel.hidden = self.trueGradientLayer.hidden = NO;
    if(model.result.intValue == 1) {
        _trueFalseLabel.text = @"  鉴定为真";
        self.trueGradientLayer.colors = @[(__bridge id)[UIColor colorWithRGB:0XFF8900].CGColor, (__bridge id)[UIColor colorWithRGB:0XF9A800].CGColor];
    }
    else if(model.result.intValue == 0) {
        _trueFalseLabel.text = @"  鉴定为假";
        self.trueGradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7].CGColor, (__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7].CGColor];
        
    }
    else {
        _trueFalseLabel.hidden = self.trueGradientLayer.hidden = YES;
    }

}

#pragma mark -- Getter
- (CAGradientLayer *)trueGradientLayer {
    if (!_trueGradientLayer) {
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = self.trueFalseLabel.frame;
        gl.startPoint = CGPointMake(0.2, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);
        gl.cornerRadius = 11.5;
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:137/255.0 blue:0/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:249/255.0 green:168/255.0 blue:0/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0.0f), @(1.0f)];
        _trueGradientLayer = gl;
    }
    
    return _trueGradientLayer;
    
}
@end
