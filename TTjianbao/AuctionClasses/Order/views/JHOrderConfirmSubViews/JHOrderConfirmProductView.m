//
//  JHOrderConfirmProductView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderConfirmProductView.h"
#import "JHShopHomeController.h"
#import "YYLabel.h"
@interface JHOrderConfirmProductView ()
{
    UIView * tagView;
}
@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  UILabel *sallerName;
@property (strong, nonatomic)  UILabel *orderCategory;
@property (strong, nonatomic)  UILabel *flashOrderSignLabel;
@property (strong, nonatomic)  UIImageView *productImage;
@property (strong, nonatomic)  YYLabel *productPrice;
@property (strong, nonatomic)  YYLabel *productTitle;
@property (strong, nonatomic)  UIImageView *customizeImage;
@property(nonatomic,strong) UILabel * customizeNameLabel;
@property(nonatomic,strong) UILabel * tagLabel;
@end

@implementation JHOrderConfirmProductView
-(void)setSubViews{
    
    tagView=[UIView new];
    tagView.layer.borderColor = kColorMainRed.CGColor;
    tagView.layer.borderWidth = 1.0;
    tagView.layer.cornerRadius = 4;
    tagView.layer.masksToBounds = YES;
    [self addSubview:tagView];
    
    tagView.hidden=YES;
    
    _orderCategory                        = [[UILabel alloc]init];
    _orderCategory.text                   = @"";
    _orderCategory.font                   = [UIFont systemFontOfSize:10];
    _orderCategory.backgroundColor        = [UIColor clearColor];
    _orderCategory.textColor              = kColorMainRed;
    _orderCategory.numberOfLines          = 1;
    _orderCategory.textAlignment          = UIControlContentHorizontalAlignmentCenter;
    _orderCategory.lineBreakMode          = NSLineBreakByWordWrapping;
    _orderCategory.lineBreakMode          = NSLineBreakByTruncatingTail;
    _orderCategory.userInteractionEnabled = YES;
    [tagView addSubview:_orderCategory];
    [_orderCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.center.equalTo(tagView);
    }];
    
    _sallerHeadImage=[[UIImageView alloc]initWithImage:kDefaultAvatarImage];
    _sallerHeadImage.layer.masksToBounds =YES;
    _sallerHeadImage.layer.cornerRadius =14;
    _sallerHeadImage.userInteractionEnabled=YES;
    [_sallerHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
    [self addSubview:_sallerHeadImage];
    
    
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.height.offset(16);
        make.centerY.equalTo(_sallerHeadImage);
    }];
    
    /// 闪购标识
    _flashOrderSignLabel                        = [[UILabel alloc]init];
    _flashOrderSignLabel.text                   = @"闪";
    _flashOrderSignLabel.font                   = [UIFont systemFontOfSize:10];
    _flashOrderSignLabel.backgroundColor        = [UIColor clearColor];
    _flashOrderSignLabel.textColor              = HEXCOLOR(0xFF9F40);
    _flashOrderSignLabel.numberOfLines          = 1;
    _flashOrderSignLabel.textAlignment          = NSTextAlignmentCenter;
    _flashOrderSignLabel.lineBreakMode          = NSLineBreakByWordWrapping;
    _flashOrderSignLabel.lineBreakMode          = NSLineBreakByTruncatingTail;
    _flashOrderSignLabel.userInteractionEnabled = YES;
    _flashOrderSignLabel.layer.borderWidth      = 1.0;
    _flashOrderSignLabel.layer.borderColor      = HEXCOLOR(0xFF9900).CGColor;
    _flashOrderSignLabel.layer.cornerRadius     = 4;
    _flashOrderSignLabel.layer.masksToBounds    = YES;
    _flashOrderSignLabel.hidden                 = YES;
    [self addSubview:_flashOrderSignLabel];
    [_flashOrderSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagView.mas_right).offset(0.f);
        make.centerY.equalTo(tagView.mas_centerY);
        make.width.mas_equalTo(0.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [_sallerHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.left.equalTo(self.flashOrderSignLabel.mas_right).offset(9.f);
    }];
    
    [self addSubview:self.tagLabel];
    
    _sallerName=[[UILabel alloc]init];
    _sallerName.text=@"";
    _sallerName.font=[UIFont systemFontOfSize:13];
    _sallerName.backgroundColor=[UIColor clearColor];
    _sallerName.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _sallerName.numberOfLines = 1;
    _sallerName.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _sallerName.lineBreakMode = NSLineBreakByTruncatingTail;
    _sallerName.userInteractionEnabled=YES;
    [_sallerName addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
    [self addSubview:_sallerName];
    
    [_sallerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sallerHeadImage);
        make.left.equalTo(_sallerHeadImage.mas_right).offset(10);
    }];
    
    
    _customizeImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"customize_authen_icon"]];
    _customizeImage.layer.masksToBounds =YES;
    _customizeImage.layer.cornerRadius =8;
    _customizeImage.userInteractionEnabled=YES;
    [_customizeImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
    [self addSubview:_customizeImage];
    
    [_customizeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sallerHeadImage);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(_sallerName.mas_right).offset(5);
    }];
    
    _customizeNameLabel = [[UILabel alloc] init];
    _customizeNameLabel.numberOfLines =1;
    _customizeNameLabel.textAlignment = NSTextAlignmentRight;
    _customizeNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _customizeNameLabel.textColor=kColor999;
    _customizeNameLabel.text = @"认证定制师";
    _customizeNameLabel.font=[UIFont fontWithName:kFontNormal size:11];
    [self addSubview:_customizeNameLabel];
    
    [_customizeNameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sallerHeadImage);
        make.left.equalTo(_customizeImage.mas_right).offset(5);
    }];
    
    JHCustomLine *line = [JHUIFactory createLine];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sallerHeadImage.mas_bottom).offset(5);
        make.height.equalTo(@1);
        make.left.offset(5);
        make.right.offset(0);
        
    }];
    
    _productImage=[[UIImageView alloc]initWithImage:nil];
    [self addSubview:_productImage];
    _productImage.contentMode = UIViewContentModeScaleAspectFill;
    _productImage.layer.masksToBounds=YES;
    _productImage.userInteractionEnabled=YES;
    _productImage.layer.cornerRadius =8;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    [_productImage addGestureRecognizer:tapGesture];
    
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(self).offset(-10);
    }];
    
    
    _productTitle=[[YYLabel alloc]init];
    _productTitle.text=@"";
    _productTitle.font=[UIFont fontWithName:kFontNormal size:13];
    _productTitle.textColor=kColor333;
    _productTitle.numberOfLines = 2;
    _productTitle.textAlignment = NSTextAlignmentLeft;
    _productTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    //这个属性必须设置，多行才有效
    _productTitle.preferredMaxLayoutWidth = ScreenW -110;
    [self addSubview:_productTitle];
    
    [_productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_productImage).offset(-10);
        make.left.equalTo(_productImage.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
    _productPrice=[[YYLabel alloc]init];
    _productPrice.text=@"";
    _productPrice.font=[UIFont fontWithName:kFontBoldDIN size:15.f];
    _productPrice.textColor=kColor333;
    _productPrice.numberOfLines = 1;
    _productPrice.textAlignment = NSTextAlignmentCenter;
    _productPrice.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_productPrice];
    
    [_productPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productTitle.mas_bottom).offset(5);
        make.left.equalTo(_productTitle);
    }];
    
    _customizeImage.hidden = YES;
    _customizeNameLabel.hidden = YES;
    
}

-(void)ConfigCategoryTagTitle:(JHOrderDetailMode*)mode{
    UserInfoRequestManager * manager = [UserInfoRequestManager sharedInstance];
    NSString * desc;
    if (mode.orderCategoryType!=JHOrderCategoryRestore&&
        mode.orderCategoryType!=JHOrderCategoryRestoreProcessing) {
        desc=[manager findValue:manager.dictConfigMode.AppOrderCategory byKey:mode.orderCategory];
        
    }
    else{
        desc=[manager findValue:manager.dictConfigMode.StoneRestoretransitionState byKey:[NSString stringWithFormat:@"%zd",mode.transitionState]];
    }
    
    if (!isEmpty(desc)) {
        self.orderCategory.text=desc;
         tagView.hidden = NO;
    } else {
        tagView.hidden = YES;
    }
    
    /// 闪购
    if (mode.flashIcon && !mode.isC2C) {
        _flashOrderSignLabel.hidden = NO;
        if (tagView.hidden) {
            [_flashOrderSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(10);
                make.centerY.equalTo(tagView.mas_centerY);
                make.width.mas_equalTo(16.f);
                make.height.mas_equalTo(16.f);
            }];
        } else {
            [_flashOrderSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tagView.mas_right).offset(8.f);
                make.centerY.equalTo(tagView.mas_centerY);
                make.width.mas_equalTo(16.f);
                make.height.mas_equalTo(16.f);
            }];
        }
    } else {
        _flashOrderSignLabel.hidden = YES;
        [_flashOrderSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagView.mas_right).offset(0.f);
            make.centerY.equalTo(tagView.mas_centerY);
            make.width.mas_equalTo(0.f);
            make.height.mas_equalTo(16.f);
        }];
    }

    if (isEmpty(desc) && !mode.isC2C) {
        if (!mode.flashIcon) {
            [_sallerHeadImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(10);
                make.size.mas_equalTo(CGSizeMake(16, 16));
                make.left.equalTo(self).offset(10);
            }];
        }
    }
}
-(void)setOrderMode:(JHOrderDetailMode *)orderMode {
    
    _orderMode=orderMode;
    
    if(orderMode.isC2C) {
        self.tagLabel.hidden = NO;
        if ([orderMode.orderCategory isEqualToString:@"marketAuctionOrder"]) {
            self.tagLabel.text = @"拍卖";
        }else {
            self.tagLabel.text = @"一口价";
        }
        [self.tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_sallerHeadImage);
            make.width.mas_equalTo(38);
            make.height.mas_equalTo(16);
            make.left.mas_equalTo(10);
        }];
        
        [_sallerHeadImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.size.mas_equalTo(CGSizeMake(28, 28));
            make.left.equalTo(self.tagLabel.mas_right).mas_offset(9.f);
        }];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
    /// 闪购
    if (orderMode.flashIcon) {
        _flashOrderSignLabel.hidden = NO;
        [_flashOrderSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagView.mas_right).offset(8.f);
            make.centerY.equalTo(tagView.mas_centerY);
            make.width.mas_equalTo(16.f);
            make.height.mas_equalTo(16.f);
        }];
        [_sallerHeadImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.size.mas_equalTo(CGSizeMake(28, 28));
            make.left.equalTo(self.flashOrderSignLabel.mas_right).mas_offset(10);
        }];
    } else {
        _flashOrderSignLabel.hidden = YES;
        [_flashOrderSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tagView.mas_right).offset(0.f);
            make.centerY.equalTo(tagView.mas_centerY);
            make.width.mas_equalTo(0.f);
            make.height.mas_equalTo(16.f);
        }];
    }
    
    [_sallerHeadImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.sellerImg] placeholder:kDefaultAvatarImage];
    
    [_productImage jhSetImageWithURL:[NSURL URLWithString:ThumbSmallByOrginal(_orderMode.goodsUrl)] placeholder:kDefaultCoverImage];
    if ([_orderMode.sellerName length]>10) {
        _sallerName.text = [[_orderMode.sellerName substringToIndex:10] stringByAppendingFormat:@"..."];
    }
    else{
        _sallerName.text=_orderMode.sellerName;
    }
    
    _productTitle.text=_orderMode.goodsTitle;
    
    if (_orderMode.orderCategoryType == JHOrderCategoryPersonalCustomizeOrder){
        
        [_productTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_productImage).offset(0);
            make.left.equalTo(_productImage.mas_right).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
        }];
        _customizeImage.hidden = NO;
        _customizeNameLabel.hidden = NO;
    }
    //加工服务单不显示产品价格
    else if (_orderMode.orderCategoryType!=JHOrderCategoryProcessingGoods&&
             _orderMode.orderCategoryType!=JHOrderCategoryRestoreProcessing&&
             _orderMode.orderCategoryType!=JHOrderCategoryCustomizedOrder&&
             _orderMode.orderCategoryType!=JHOrderCategoryCustomizedIntentionOrder){
        NSString * string=[@"¥ " stringByAppendingString:_orderMode.goodsPrice ?: @""];
        
        if (_orderMode.orderCategoryType == JHOrderCategoryMallOrder || _orderMode.orderCategoryType == JHOrderTypeMarketsell || _orderMode.orderCategoryType == JHOrderCategoryMarketsell){
            string=[@"¥ " stringByAppendingString:_orderMode.unitPrice?:@""];
        }
        NSRange range = [string rangeOfString:@"¥"];
        UIFont *font = [UIFont fontWithName:kFontBoldDIN size:15.f];
        if (_orderMode.isC2C) {
            font = [UIFont fontWithName:kFontNormal size:15.f];
        }
        self.productPrice.attributedText=[string attributedFont:font color:kColor333 range:range];
    }
    
    //价格标签组装到价格里
    if ([_orderMode.priceTagName length]>0) {
        [self showPriceTag];
    }
}
-(void)showPriceTag{
    
    NSDictionary *attribute =@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:11]};
    CGSize size = [self.orderMode.priceTagName boundingRectWithSize:CGSizeMake(150, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    UIView *tagView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width+10, size.height)];
    tagView.backgroundColor = kColorMainRed;
    tagView.layer.cornerRadius = 2;
    tagView.layer.masksToBounds = YES;
    
    UILabel *content=[[UILabel alloc]init];
    content.text=self.orderMode.priceTagName;
    content.font=[UIFont fontWithName:kFontNormal size:11];
    content.backgroundColor=[UIColor clearColor];
    content.textColor=kColorFFF;
    content.numberOfLines = 1;
    content.textAlignment = NSTextAlignmentLeft;
    content.lineBreakMode = NSLineBreakByTruncatingTail;
    [tagView addSubview:content];
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tagView);
    }];
    NSMutableAttributedString *contentText = [self.productPrice.attributedText mutableCopy];
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:tagView contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(tagView.width, tagView.height) alignToFont:self.productPrice.font alignment:YYTextVerticalAlignmentCenter];
    
    [contentText insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
    [contentText insertAttributedString:attachText atIndex:0];
    
    self.productPrice.attributedText = contentText;
    
}
-(void)headImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.orderMode.orderCategoryType==JHOrderCategoryMallOrder){
        return;
    }
    if (self.orderMode.orderCategoryType==JHOrderCategoryLimitedTime||
        self.orderMode.orderCategoryType==JHOrderCategoryLimitedShop) {
        ///订单确认页进入店铺埋点  暂时不要
        //        [self GIOEnterShopPage:self.orderConfirmMode.sellerCustomerId];
        JHShopHomeController *vc=[[JHShopHomeController alloc]init];
        vc.sellerId=[self.orderMode.sellerCustomerId integerValue];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
    else  if (self.orderMode.orderType ==0) {
        [JHRootController EnterLiveRoom:self.orderMode.channelLocalId fromString:JHLiveFromconfirmOrder];
    }
    else  if (self.orderMode.orderType ==1){
        ///进入个人主页界面
        [JHRootController enterUserInfoPage:self.orderMode.sellerCustomerId from:@""];
    }
}
-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (!self.orderMode.goodsUrl) {
        return;
    }
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr=[NSMutableArray arrayWithArray:@[self.orderMode.goodsUrl]];
    [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
        
    }];
}

- (UILabel *)tagLabel {
    if (_tagLabel == nil) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = HEXCOLOR(0xfc4200);
        _tagLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _tagLabel.text = @"一口价";
        _tagLabel.layer.cornerRadius = 2;
        _tagLabel.layer.borderWidth = 0.5;
        _tagLabel.layer.borderColor = HEXCOLOR(0xfc4200).CGColor;
        _tagLabel.clipsToBounds = YES;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.hidden = YES;
    }
    return _tagLabel;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
