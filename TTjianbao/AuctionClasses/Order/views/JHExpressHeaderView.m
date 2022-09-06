//
//  JHExpressHeaderView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHExpressHeaderView.h"
#import "TTjianbaoHeader.h"

@interface JHExpressHeaderView ()
@property (nonatomic, strong)NSMutableArray<UILabel *> *labelArray;
@property (nonatomic, strong)UIImageView *statusImageView;

@end

@implementation JHExpressHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor clearColor];
        [self setUpSubViews];
    }
    return self;
}

-(void)setUpSubViews{
    
    UIView *content = [[UIView alloc]init];
    content.backgroundColor = HEXCOLOR(0x424242);
    [self addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(90);
    }];
    
    _statusImageView=[[UIImageView alloc]init];
    _statusImageView.image=[UIImage imageNamed:@""];
    _statusImageView.contentMode=UIViewContentModeScaleAspectFit;
    [content addSubview:_statusImageView];
    
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(content);
    }];
}
-(void)setExpressStep:(JHExpressStepType)expressStep{
    
    _expressStep = expressStep;
    if (_expressStep == JHExpressStepTypeSellerSend) {
        _statusImageView.image=[UIImage imageNamed:@"orderExpress_header_icon1"];
    }
    else  if (_expressStep == JHExpressStepTypePlatAppraise) {
        _statusImageView.image=[UIImage imageNamed:@"orderExpress_header_icon2"];
    }
    else if (_expressStep == JHExpressStepTypePlatSend){
        _statusImageView.image=[UIImage imageNamed:@"orderExpress_header_icon3"];
    }
}
@end
