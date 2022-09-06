//
//  JHLinkSwichTipsView.m
//  TTjianbao
//
//  Created by apple on 2020/12/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLinkSwichTipsView.h"

@implementation JHLinkSwichTipsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linkSwichTipsImage"]];
    [self addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(47, 55));
    }];
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 0;
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    shadow.shadowOffset =CGSizeMake(0,1);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"点击切换窗口" attributes: @{NSFontAttributeName: JHFont(12),NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: shadow}];
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_bottom).offset(3);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
@end
