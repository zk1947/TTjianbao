//
//  JHMessageOrderTransportViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2020/2/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageOrderTransportViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "JHLine.h"

@interface JHMessageOrderTransportViewCell ()

@property (strong, nonatomic)  UIImageView* avatar; //头像
@property (strong, nonatomic)  UIImageView* productImg; //商品图片
@property (strong, nonatomic)  UILabel* sellerName; //卖家名称
@property (strong, nonatomic)  UILabel* title; //订单title
@property (strong, nonatomic)  UILabel* desc; //订单描述
@property (strong, nonatomic)  UILabel* orderNum; //订单号
@property (strong, nonatomic)  UIView* subBgView; //「子背景」商品图片+订单描述+订单号
@end

@implementation JHMessageOrderTransportViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawHeadview]; //分割线以上
        [self drawCenterview]; //分割线及订单title
        [self drawSubview]; //分割线以上
    }
    
    return self;
}

- (void)drawHeadview
{
    _avatar=[[UIImageView alloc]init];
    _avatar.layer.masksToBounds =YES;
    _avatar.layer.cornerRadius = 12.5;
    [self.backgroundsView addSubview:_avatar];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backgroundsView).offset(10);
        make.size.mas_equalTo(25);
    }];
    
    _sellerName=[[UILabel alloc]init];
    _sellerName.font=JHFont(13);
    _sellerName.textColor=HEXCOLOR(0x333333);
    _sellerName.numberOfLines = 1;
    _sellerName.textAlignment = NSTextAlignmentLeft;
    _sellerName.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.backgroundsView addSubview:_sellerName];
    [_sellerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_avatar.mas_right).offset(6);
        make.right.equalTo(self.backgroundsView).offset(-10);
        make.height.offset(13);
        make.centerY.equalTo(_avatar);
    }];
}

- (void)drawCenterview
{
    //分割线
    JHCustomLine* line = [JHCustomLine new];
    [self.backgroundsView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatar.mas_bottom).offset(10.5);
        make.left.equalTo(self.backgroundsView).offset(10);
        make.right.equalTo(self.backgroundsView).offset(-10);
        make.height.offset(0.5);
    }];
    //订单title
    _title=[[UILabel alloc]init];
    _title.font=JHFont(16);
    _title.textColor=HEXCOLOR(0x333333);
    _title.numberOfLines = 1;
    _title.textAlignment = NSTextAlignmentLeft;
    _title.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.backgroundsView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(16);
        make.top.equalTo(line).offset(10);
        make.left.equalTo(self.backgroundsView).offset(10.5);
        make.right.equalTo(self.backgroundsView).offset(-10);
    }];
}

- (void)drawSubview
{
    //子背景
    _subBgView = [UIView new];
    _subBgView.backgroundColor = HEXCOLOR(0xFAFAFA);
    [self.backgroundsView addSubview:_subBgView];
    [_subBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_title.mas_bottom).offset(10);
        make.left.equalTo(self.backgroundsView).offset(10);
        make.right.equalTo(self.backgroundsView).offset(-10);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(self.backgroundsView).offset(-10);
    }];
    
    _productImg=[[UIImageView alloc]init];
    _productImg.layer.masksToBounds =YES;
    [_productImg jh_cornerRadius:8 rectCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft bounds:CGRectMake(0, 0, 60, 60)];
    [_subBgView addSubview:_productImg];
    [_productImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(_subBgView);
        make.size.offset(60);
    }];
    
    _desc=[[UILabel alloc]init];
    _desc.font=JHFont(13);
    _desc.textColor=HEXCOLOR(0x666666);
    _desc.textAlignment = NSTextAlignmentLeft;
    _desc.lineBreakMode = NSLineBreakByTruncatingTail;
    _desc.numberOfLines = 1;
    [_subBgView addSubview:_desc];
    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_subBgView).offset(14);
        make.left.mas_equalTo(_productImg.mas_right).offset(10);
        make.right.equalTo(_subBgView).offset(-10);
        make.height.mas_equalTo(13);
    }];
    
    _orderNum=[[UILabel alloc]init];
    _orderNum.font=JHFont(13);
    _orderNum.textColor=HEXCOLOR(0x666666);
    _orderNum.textAlignment = NSTextAlignmentLeft;
    _orderNum.lineBreakMode = NSLineBreakByTruncatingTail;
    _orderNum.numberOfLines = 1;
    [_subBgView addSubview:_orderNum];
    [_orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_desc.mas_bottom).offset(9.5);
        make.left.right.equalTo(_desc);
        make.height.mas_equalTo(13);
    }];
}

- (void)updateData:(JHMsgSubListOrderTransportModel*)model
{
    [_avatar jhSetImageWithURL:[NSURL URLWithString:model.ext.sellerIcon] placeholder:kDefaultAvatarImage];

    [_productImg jhSetImageWithURL:[NSURL URLWithString:model.ext.coverImg] placeholder:kDefaultCoverImage];

    _sellerName.text = model.ext.sellerName;
    _title.text = model.title;
    _desc.text = model.body;
    _orderNum.text = model.ext.orderCode;//订单号
}

@end
