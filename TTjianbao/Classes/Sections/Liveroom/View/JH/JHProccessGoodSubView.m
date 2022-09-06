//
//  JHProccessGoodSubView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHProccessGoodSubView.h"
#import "JHLine.h"
#import "UIImageView+JHWebImage.h"

#define kProccessGoodSubViewHeight 100 //ui定义
#define kLineHeight 1
#define kLineX 10
#define kFontSize 13
#define kFontExtSize 10
#define kLineColor HEXCOLOR(0xEEEEEE)
#define kTextColor HEXCOLOR(0x333333)
#define kTextExtColor HEXCOLOR(0x999999)
#define kBackgroundColor [UIColor whiteColor]

@interface JHProccessGoodSubView ()

@property (nonatomic, strong) UILabel* orderNum;
@property (nonatomic, strong) UILabel* orderStatus;
@property (nonatomic, strong) UILabel* contents;
@property (nonatomic, strong) UILabel* dateTime;
@property (nonatomic, strong) UILabel* price;
@property (nonatomic, strong) UIImageView* image;
@end

@implementation JHProccessGoodSubView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, ScreenW - 52*2, kProccessGoodSubViewHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = kBackgroundColor;
    }
    return self;
}

- (void)setData:(OrderMode*)model
{
    [self drawSubview];
    self.orderNum.text = [NSString stringWithFormat:@"订单号：%@", model.orderCode ? : @""];
    self.orderStatus.text = @"待发货";
    if (model.goodsImg.length>0) {
        [self.image jhSetImageWithURL:[NSURL URLWithString:model.goodsImg]];
    }else {
        [self.image jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl]];
    }
    self.contents.text = model.goodsTitle;
    self.dateTime.text = model.orderCreateTime;
    self.price.text = [NSString stringWithFormat:@"¥%@",model.originOrderPrice];
}

- (void)drawSubview
{
    //首行横线
    JHCustomLine* topLine = [[JHCustomLine alloc] initWithFrame:CGRectMake(kLineX, 0, self.width - kLineX * 2, kLineHeight) andColor:kLineColor];
    [self addSubview:topLine];
    
    //以订单状态为参考
    [self addSubview:self.orderStatus];
    [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-17);//右侧17
        make.top.equalTo(self).offset(kLineHeight+4);//与line间距4
        make.height.mas_equalTo(18);//固定18
        make.width.mas_equalTo(39);//固定39
    }];
    
    [self addSubview:self.orderNum];
    [self.orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kLineX);
        make.top.equalTo(self.orderStatus);
        make.height.equalTo(self.orderStatus);
    }];
    
    [self addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNum);
        make.top.mas_equalTo(self.orderNum.mas_bottom).offset(10);
        make.width.height.mas_equalTo(55);
    }];

    [self addSubview:self.contents];
    [self.contents mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.image.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-18);//右侧18
        make.top.equalTo(self.image);
    }];

    [self addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contents.mas_bottom).offset(7);
        make.right.equalTo(self.orderStatus);
        make.height.mas_equalTo(15);
    }];
    self.price.textAlignment = NSTextAlignmentRight;

    [self addSubview:self.dateTime];
    [self.dateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contents);
        make.top.mas_equalTo(self.contents.mas_bottom).offset(9);
        make.height.mas_equalTo(14);
    }];
    
    //末行横线
    JHCustomLine* endLine = [[JHCustomLine alloc] initWithFrame:CGRectMake(kLineX, self.height - kLineHeight, self.width - kLineX * 2, kLineHeight) andColor:kLineColor];
    [self addSubview:endLine];
}

//订单号
- (UILabel*)orderNum
{
    if(!_orderNum)
    {
        _orderNum = [self makeLabel];
    }
    return _orderNum;
}

//订单状态
- (UILabel*)orderStatus
{
    if(!_orderStatus)
    {
        _orderStatus = [self makeLabel];
    }
    return _orderStatus;
}

//订单内容
- (UILabel*)contents
{
    if(!_contents)
    {
        _contents = [self makeLabel];
        _contents.numberOfLines = 2;
        _contents.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contents;
}

//订单时间
- (UILabel*)dateTime
{
    if(!_dateTime)
    {
        _dateTime = [self makeLabel];
        _dateTime.textColor = kTextExtColor;
        _dateTime.font = [UIFont fontWithName:kFontMedium size:kFontExtSize];
    }
    return _dateTime;
}

//订单价格
- (UILabel*)price
{
    if(!_price)
    {
        _price = [self makeLabel];
    }
    return _price;
}

- (UIImageView*)image
{
    if(!_image)
    {
        _image =[[UIImageView alloc] init];
        _image.backgroundColor = kBackgroundColor;
    }
    return _image;
}

#pragma create label
- (UILabel*) makeLabel
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = kBackgroundColor;
    label.textColor = kTextColor;
    label.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    label.textAlignment = NSTextAlignmentLeft;
    
    return label;
}

@end
