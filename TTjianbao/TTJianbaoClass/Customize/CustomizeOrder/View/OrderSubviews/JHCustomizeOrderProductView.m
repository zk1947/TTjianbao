//
//  JHCustomizeOrderProductView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderProductView.h"
#import "JHCustomizeOrderIndicateView.h"
#import "JHCustomerDescInProcessViewController.h"
#import "JHCustomizeCheckStuffDetailViewController.h"
#import "YYControl.h"
@interface JHCustomizeOrderProductView ()
{
    UIImageView * circleIcon;
}
@property (strong, nonatomic)  UIImageView *sallerHeadImage;
@property (strong, nonatomic)  YYAnimatedImageView *liveGifView;
@property (strong, nonatomic)  UILabel *sallerName;
@property (strong, nonatomic)  UIImageView *productImage;
//@property (strong, nonatomic)  UILabel *customizeClass;
@property (strong, nonatomic)  UILabel *productTitle;
@property(nonatomic,strong) UIView *productContentView;
@property(nonatomic,strong) UIView *customizeDetailInfoView;
@property (strong, nonatomic)  UIImageView *customizeImage;
@property(nonatomic,strong) UILabel * customizeNameLabel;
@end
@implementation JHCustomizeOrderProductView

-(void)setSubViews{
    
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailInfo:)]];
    
    
    
    circleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
    circleIcon.hidden = YES;
    [self addSubview:circleIcon];
    [circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.size.mas_equalTo(CGSizeMake(33, 33));
        make.left.equalTo(self).offset(5);
    }];
    
    _sallerHeadImage=[[UIImageView alloc]initWithImage:kDefaultAvatarImage];
    _sallerHeadImage.layer.masksToBounds =YES;
    _sallerHeadImage.layer.cornerRadius =14;
    _sallerHeadImage.userInteractionEnabled=YES;
    [_sallerHeadImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap:)]];
    [self addSubview:_sallerHeadImage];
    
    [_sallerHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(circleIcon);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data];
    _liveGifView = [[YYAnimatedImageView alloc] initWithImage:image];
    _liveGifView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_liveGifView];
    _liveGifView.hidden = YES;
    
    [_liveGifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(circleIcon);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    _sallerName=[[UILabel alloc]init];
    _sallerName.text=@"";
    _sallerName.font=[UIFont fontWithName:kFontMedium size:15];
    _sallerName.backgroundColor=[UIColor clearColor];
    _sallerName.textColor=kColor333;
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
    _customizeNameLabel.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _customizeNameLabel.text = @"认证定制师";
    _customizeNameLabel.font=[UIFont systemFontOfSize:13];
    [self addSubview:_customizeNameLabel];
    
    [ _customizeNameLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sallerHeadImage);
        make.left.equalTo(_customizeImage.mas_right).offset(5);
    }];
    
    JHCustomLine *line = [JHUIFactory createLine];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sallerName.mas_bottom).offset(10);
        make.height.equalTo(@1);
        make.left.offset(5);
        make.right.offset(0);
        
    }];
    
    _customizeDetailInfoView = [[UIView alloc]init];
    [self addSubview:_customizeDetailInfoView];
    
    _productContentView=[[UIView alloc]init];
    [self addSubview:_productContentView];
    
    [_productContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sallerHeadImage.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.right.equalTo(_customizeDetailInfoView.mas_left);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [_customizeDetailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.equalTo(@0);
        make.top.equalTo(_productContentView).offset(0);
        make.bottom.equalTo(_productContentView).offset(0);
    }];
    
    _productImage=[[UIImageView alloc]initWithImage:nil];
    _productImage.contentMode = UIViewContentModeScaleAspectFill;
    _productImage.layer.masksToBounds=YES;
    _productImage.layer.cornerRadius =8;
    _productImage.userInteractionEnabled=YES;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    [_productImage addGestureRecognizer:tapGesture];
    [_productContentView addSubview:_productImage];
    
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productContentView).offset(5);
        make.left.equalTo(@5);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.bottom.equalTo(_productContentView).offset(0);
    }];
    
    _productTitle=[[UILabel alloc]init];
    _productTitle.text=@"";
    _productTitle.font=[UIFont systemFontOfSize:14];
    _productTitle.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _productTitle.numberOfLines = 2;
    _productTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _productTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [_productContentView addSubview:_productTitle];
    
    [_productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_productImage).offset(0);
        make.left.equalTo(_productImage.mas_right).offset(5);
        make.right.equalTo(_productContentView.mas_right).offset(-5);
    }];
//    _customizeClass=[[UILabel alloc]init];
//    _customizeClass.text=@"";
//    _customizeClass.font=[UIFont fontWithName:kFontNormal size:13.f];
//    _customizeClass.textColor=[CommHelp toUIColorByStr:@"#333333"];
//    _customizeClass.numberOfLines = 1;
//    _customizeClass.textAlignment = UIControlContentHorizontalAlignmentCenter;
//    _customizeClass.lineBreakMode = NSLineBreakByWordWrapping;
//    [_productContentView addSubview:_customizeClass];
//
//    [_customizeClass mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_productTitle.mas_bottom).offset(10);
//        make.left.equalTo(_productTitle);
//    }];
    
    _customizeImage.hidden = YES;
    _customizeNameLabel.hidden = YES;
}
-(void)setOrderMode:(JHCustomizeOrderModel *)orderMode{
    
    _orderMode=orderMode;
    [_sallerHeadImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.buyerImg] placeholder:kDefaultAvatarImage];
    _sallerName.text=_orderMode.buyerName;
    [_productImage jhSetImageWithURL:[NSURL URLWithString: ThumbSmallByOrginal(_orderMode.goodsUrl)] placeholder:kDefaultCoverImage];
    _productTitle.text=_orderMode.goodsTitle;
    [UILabel changeLineSpaceForLabel:_productTitle WithSpace:3];
//    _customizeClass.text=[@"定制类别: " stringByAppendingString:_orderMode.materialVo.customizeFeeName?:@""];
    if (_orderMode.isSeller) {
        _customizeImage.hidden = YES;
        _customizeNameLabel.hidden = YES;
        [_sallerHeadImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.buyerImg] placeholder:kDefaultAvatarImage];
        if ([_orderMode.buyerName length]>10) {
            _sallerName.text = [[_orderMode.buyerName substringToIndex:10] stringByAppendingFormat:@"..."];
        }
        else{
            _sallerName.text=_orderMode.buyerName;
        }
    }
    else{
        _customizeImage.hidden = NO;
        _customizeNameLabel.hidden = NO;
        [_sallerHeadImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.sellerImg] placeholder:kDefaultAvatarImage];
        if ([_orderMode.sellerName length]>10) {
            _sallerName.text = [[_orderMode.sellerName substringToIndex:10] stringByAppendingFormat:@"..."];
        }
        else{
            _sallerName.text=_orderMode.sellerName;
        }
    }
    if (_orderMode.liveFlag&&!_orderMode.isSeller) {
        _liveGifView.hidden = NO;
         circleIcon.hidden = NO;
    }
    else{
        _liveGifView.hidden = YES;
         circleIcon.hidden = YES;
    }
    
    [self initCustomizeDetailInfoView];
}
-(void)initCustomizeDetailInfoView{
    
    [_customizeDetailInfoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    if (self.orderMode.customizeDetailBtnFlag) {
        [_customizeDetailInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(140);
        }];
        
        JHCustomizeOrderIndicateView * indicateView = [JHCustomizeOrderIndicateView new];
        indicateView.title = @"定制详情";
        indicateView.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
        //  indicateView.backgroundColor = [UIColor yellowColor];
        indicateView.titleLabel.textColor = kColor999;
        indicateView.userInteractionEnabled = NO;
        [_customizeDetailInfoView addSubview:indicateView];
        
        [indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_customizeDetailInfoView);
            make.height.offset(25);
            make.right.equalTo(_customizeDetailInfoView).offset(-5);
            make.left.equalTo(_customizeDetailInfoView).offset(5);
        }];
        
        @weakify(self);
        indicateView.pressActionBlock = ^{
            // @strongify(self);
            
        };
        UILabel *title= [[UILabel alloc] init];
        title.numberOfLines =1;
        title.textAlignment = NSTextAlignmentRight;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.textColor=kColorFF4200;
        title.text = self.orderMode.picInfoVo.lastUpdateDesc;
        title.font=[UIFont fontWithName:kFontNormal size:10];
        [_customizeDetailInfoView addSubview:title];
        
        [ title  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(indicateView.mas_bottom).offset(5);
            make.right.equalTo(_customizeDetailInfoView).offset(-20);
        }];
    }
    else{
        [_customizeDetailInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);
        }];
    }
    
}
-(void)imageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    UIImageView * imageview=(UIImageView*)gestureRecognizer.view;
    NSMutableArray * arr;
    if (self.orderMode.goodsUrl) {
        arr=[NSMutableArray arrayWithArray:@[self.orderMode.goodsUrl]];
        [[EnlargedImage sharedInstance] enlargedImage:imageview enlargedTime:0.3 images:arr andIndex:0 result:^(NSInteger index) {
            
        }];
    }
    
}
-(void)headImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    if (self.orderMode.isSeller ) {
        return;
    }
    if (self.orderMode.orderType ==0) {
        [JHRootController EnterLiveRoom:self.orderMode.channelLocalId fromString:@"dz_order_xq_in"];
    }
    else  if (self.orderMode.orderType ==1){
        ///enter UserInfo page
        [JHRootController enterUserInfoPage:self.orderMode.sellerCustomerId from:@""];
    }
}
-(void)stoneImageTap:(UIGestureRecognizer*)gestureRecognizer{
    
    [JHRouterManager pushStoneDetailWithStoneId:self.orderMode.stoneId complete:nil];
}
-(void)detailInfo:(UIGestureRecognizer*)gestureRecognizer{
    
    //定制详情
    if (self.orderMode.customizeDetailBtnFlag) {
        JHCustomerDescInProcessViewController * vc = [JHCustomerDescInProcessViewController new];
        vc.customizeOrderId = self.orderMode.customizeOrderId;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
        
    }
    //原料详情
    else{
        JHCustomizeCheckStuffDetailViewController * vc = [JHCustomizeCheckStuffDetailViewController new];
        vc.customizeOrderId = self.orderMode.customizeOrderId;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
        
    }
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
