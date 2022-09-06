//
//  JHPushOrderView.m
//  TTjianbao
//
//  Created by apple on 2020/1/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import <SVProgressHUD.h>
#import "JHPushOrderView.h"
#import "EnlargedImage.h"
#import "JHCollectionViewLeftAlignedLayout.h"
#import "JHPushOrderCouponCell.h"
#import "UIView+NTES.h"
#import "JHWebViewController.h"
#import "JHOrderConfirmViewController.h"
#import "TTjianbaoBussiness.h"

@interface JHPushOrderView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UIImageView *headerImage;

@property (nonatomic, strong) UIImageView *customizeIcon;

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) UIView *whiteView;

@property (nonatomic, assign) BOOL agree;

@end

@implementation JHPushOrderView

-(void)dealloc
{
    [JHUserStatistics noteEventType:kUPEventTypeReSaleLiveRoomSendOrder params:@{JHUPEventKey : JHUPEventKeyEnd}];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.1);
        [self addselfSubViews];
        [JHUserStatistics noteEventType:kUPEventTypeReSaleLiveRoomSendOrder params:@{JHUPEventKey : JHUPEventKeyBegin}];
    }
    return self;
}

-(void)addselfSubViews
{
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:4];
    _whiteView = whiteView;
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(260.f);
    }];
    
    UIButton *button = [UIButton jh_buttonWithImage:@"icon_alert_close" target:self action:@selector(hiddenAlert) addToSuperView:self];
    button.backgroundColor = RGB(51, 51, 51);
    [button jh_cornerRadius:13.5];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView.mas_right);
        make.centerY.equalTo(whiteView.mas_top);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    _headerImage = [UIImageView jh_imageViewAddToSuperview:self];
    [_headerImage jh_cornerRadius:3];
    [_headerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)]];
    _headerImage.userInteractionEnabled = YES;
    [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(whiteView).offset(10.f);
        make.right.equalTo(whiteView).offset(-10.f);
        make.height.mas_equalTo(240.f);
    }];
    
    _customizeIcon=[[UIImageView alloc]init];
    [_customizeIcon jh_cornerRadius:14 rectCorner:UIRectCornerTopRight | UIRectCornerBottomRight bounds:CGRectMake(0, 0, 80, 28)];
    _customizeIcon.backgroundColor = kColorMain;
    [_headerImage addSubview:_customizeIcon];
    [_customizeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerImage).offset(10);
        make.left.equalTo(_headerImage).offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 28));
    }];
    UILabel * descLabel = [UILabel new];
    descLabel.font = [UIFont fontWithName:kFontNormal size:12];
    descLabel.textColor = HEXCOLOR(0x333333);
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    descLabel.text = @"定制轻加工";
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_customizeIcon addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_customizeIcon).offset(0);
    }];
    _customizeIcon.hidden = YES;
    
    _priceLabel = [UILabel jh_labelWithText:@"￥0.0" font:24 textColor:RGB(255, 66, 0) textAlignment:0 addToSuperView:whiteView];
    _priceLabel.font = JHDINBoldFont(24);
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage);
        make.top.equalTo(self.headerImage.mas_bottom).offset(15.f);
    }];
    
    _titleLabel = [UILabel jh_labelWithBoldFont:13 textColor:RGB(51, 51, 51) addToSuperView:whiteView];
    _titleLabel.text = @"天然和田老玉手镯优质油润白玉手镯天然和田老玉手镯优质油润白玉手镯";
    _titleLabel.numberOfLines = 0;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headerImage);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(12.f);
    }];
}

-(void)setModel:(OrderMode *)model
{
    if(_model)
    {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self addselfSubViews];
    }
        
    _model = model;
    
    [self.headerImage jh_setImageWithUrl:self.model.goodsUrl];
    
    self.priceLabel.attributedText = [self getPriceAttributedString];
    
    self.titleLabel.text = self.model.goodsTitle;
    
    [self updateUI];
}

-(void)updateUI
{
    
    
    UIView *lastView = self.titleLabel;
    BOOL isHaveCoupon = NO;//是否有优惠
    
    if(self.model.subtractPrice.floatValue > 0)
    {
        isHaveCoupon = YES;
        
        NSString *subtractPrice = [NSString stringWithFormat:@" 约为你省￥%@ ",PRICE_FLOAT_TO_STRING([self.model.subtractPrice floatValue])];
        UILabel *priceDescLabel = [UILabel jh_labelWithText:subtractPrice font:11 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self.whiteView];
        priceDescLabel.backgroundColor = RGB(255, 66, 0);
        [priceDescLabel jh_cornerRadius:2];
        [priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.mas_right).offset(5.f);
            make.centerY.equalTo(self.priceLabel);
            make.height.mas_equalTo(16);
            make.right.lessThanOrEqualTo(self.headerImage);
        }];
    }
    
    if (self.model.couponValueList.count > 0) {
        
        UIView *lineView = [UIView jh_viewWithColor:RGB(238, 238, 238) addToSuperview:self.whiteView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headerImage);
            make.height.mas_equalTo(1);
            make.top.equalTo(_titleLabel.mas_bottom).offset(12);
        }];
        
        JHCollectionViewLeftAlignedLayout *flowLayout = [[JHCollectionViewLeftAlignedLayout alloc]init];
        flowLayout.estimatedItemSize  = CGSizeMake(100, 13);
        flowLayout.minimumLineSpacing = 5.0;
        flowLayout.minimumInteritemSpacing = 5.0;
        UICollectionView *collectionView  = [[UICollectionView alloc]
                                initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.scrollEnabled = NO;
        [self.whiteView addSubview:collectionView];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[JHPushOrderCouponCell class] forCellWithReuseIdentifier:[JHPushOrderCouponCell cellIdentifier]];
        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headerImage);
            make.top.equalTo(lineView.mas_bottom).offset(12.f);
            make.height.mas_equalTo(15);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(collectionView.contentSize.height);
            }];
        });
        
        lastView = collectionView;
    }
    
    if ([self.model.channelCategory isEqualToString:@"roughOrder"])
    {//原石订单
        UIImageView *tipsImage = [UIImageView jh_imageViewWithImage:@"push_order_tip" addToSuperview:self.whiteView];
        [tipsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(15.f);
            make.left.equalTo(self.whiteView).offset(10.f);
            make.size.mas_equalTo(CGSizeMake(14.f, 14.f));
        }];
        
        UILabel *tipLabel = [UILabel jh_labelWithText:@"" font:12 textColor:RGB(102, 102, 102) textAlignment:0 addToSuperView:self.whiteView];
        tipLabel.numberOfLines = 2;
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipsImage.mas_right).offset(3);
            make.top.equalTo(tipsImage);
            make.right.equalTo(self.whiteView).offset(-33);
        }];
        lastView = tipLabel;
        
        UIView *buyButton = nil;
        if (self.model.overAmountFlag) {
            tipLabel.text = @"原石消费已超额，无法继续支付，若想提升等级额度";
            NSString *orderPrice = [NSString stringWithFormat:@"实付约￥%@ ",PRICE_FLOAT_TO_STRING([self.model.price floatValue])];
            if (isHaveCoupon) {
                buyButton = [self creatButtonViewWithTopText:@"重新评估收藏等级" centerText:nil bottomText:orderPrice];
            }
            else
            {
                buyButton = [self creatButtonViewWithTopText:nil centerText:@"重新评估收藏等级" bottomText:nil];
            }
            [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.headerImage);
                make.height.mas_equalTo(40.f);
                make.top.equalTo(lastView.mas_bottom).offset(15.f);
                make.bottom.equalTo(self.whiteView).offset(-15.f);
            }];
            
        }else {
            tipLabel.text = @"原石购买不退不换，购买需谨慎";
            NSString *orderPrice = [NSString stringWithFormat:@"实付约￥%@ ",PRICE_FLOAT_TO_STRING([self.model.price floatValue])];
            if (isHaveCoupon) {
                buyButton = [self creatButtonViewWithTopText:@"已知风险，领券购买" centerText:nil bottomText:orderPrice];
            }
            else
            {
                buyButton = [self creatButtonViewWithTopText:nil centerText:@"已知风险，去支付" bottomText:nil];
            }
            [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.headerImage);
                make.height.mas_equalTo(40.f);
                make.top.equalTo(lastView.mas_bottom).offset(15.f);
            }];
            
            [self creatProtocolWithView:buyButton];
        }
    }
    else {
        NSString *orderPrice = isHaveCoupon ? [NSString stringWithFormat:@"实付约￥%@ 领券购买",PRICE_FLOAT_TO_STRING([self.model.price floatValue])] : @"去支付";
        UIView *buyButton = [self creatButtonViewWithTopText:nil centerText:orderPrice bottomText:nil];
        [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headerImage);
            make.height.mas_equalTo(40.f);
            make.top.equalTo(lastView.mas_bottom).offset(15.f);
          
        }];
        //关联定制提示文案
         //TODO jiang 等ui出来调字号 颜色
        UILabel * descLabel = [UILabel new];
        descLabel.font = [UIFont fontWithName:kFontNormal size:12];
        descLabel.textColor = HEXCOLOR(0x999999);
        descLabel.textAlignment = NSTextAlignmentLeft;
        descLabel.numberOfLines = 0;
        descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.whiteView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyButton.mas_bottom).offset(0);
            make.bottom.equalTo(self.whiteView).offset(-15.f);
            make.left.equalTo(self.whiteView).offset(10.f);
            make.right.equalTo(self.whiteView).offset(-10.f);
        }];
        
        if (self.model.customizeType) {
            _customizeIcon.hidden = NO;
            if (self.model.customizeTypeOrderRemark) {
                descLabel.text = self.model.customizeTypeOrderRemark;
                [descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(buyButton.mas_bottom).offset(10);
                }];
            }
        }
    }
}

#pragma mark --------------- collectionView ---------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (self.model.couponValueList ? self.model.couponValueList.count : 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JHPushOrderCouponCell *cell = [JHPushOrderCouponCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    if (indexPath.item < self.model.couponValueList.count) {
         NSString *desc = self.model.couponValueList[indexPath.item];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@",desc];
    }
    return cell;
}

#pragma mark --------------- action ---------------
- (void)showImage {
    if (self.model.goodsUrl) {
        [[EnlargedImage sharedInstance] enlargedImage:self.headerImage enlargedTime:0.3 images:@[self.model.goodsUrl].mutableCopy andIndex:0 result:^(NSInteger index) {
        }];
    }
}

- (void)toPayAction{
    if ([self.model.channelCategory isEqualToString:@"roughOrder"]) {//原石订单
        
        /// if ([self.model.channelCategory isEqualToString:@"roughOrder"])if (self.model.overAmountFlag)

        
        if (self.model.overAmountFlag) {
            [self reCatuAction];
            return;
        }
        else
        {
            if (!self.agree) {
                [SVProgressHUD showInfoWithStatus:@"请同意《原石交易协议》"];
                return;
            }
        }
    }
    
    JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
    vc.orderId = self.model.orderId;
    vc.fromString = JHConfirmFromOrderDialog;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [self hiddenAlert];
    
    LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
    model.orderCategory = self.model.orderCategory;
    
    [JHGrowingIO trackEventId:JHTracklive_orderreceive_paybtn variables:[model mj_keyValues]];

}

-(void)protocolAction
{
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/rockAgreement.html");
    vc.titleString = @"原石交易协议";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)reCatuAction {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/riskTtest.html");
    vc.titleString = @"风险测试";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)protocolSwitch:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.agree = sender.selected;
}

#pragma mark --------------- method ---------------
-(UIView *)creatButtonViewWithTopText:(NSString *)topText
                              centerText:(NSString *)centerText
                              bottomText:(NSString *)bottomText
{
    if(centerText)
    {
        UIButton *buyButton = [UIButton jh_buttonWithTitle:centerText fontSize:15 textColor:RGB(51, 51, 51) target:self action:@selector(toPayAction) addToSuperView:self.whiteView];
        buyButton.backgroundColor = RGB(254, 225, 0);
        [buyButton jh_cornerRadius:20.f];
        return buyButton;
    }
    else
    {
        UIView *buttonView = [UIView jh_viewWithColor:RGB(254, 225, 0) addToSuperview:self.whiteView];
        buttonView.backgroundColor = RGB(254, 225, 0);
        [buttonView jh_cornerRadius:20.f];
        [buttonView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toPayAction)]];
        UILabel *topLabel = [UILabel jh_labelWithText:topText font:13 textColor:RGB(51, 51, 51) textAlignment:1 addToSuperView:buttonView];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buttonView).offset(5);
            make.centerX.equalTo(buttonView);
        }];
        
        UILabel *bottomLabel = [UILabel jh_labelWithText:bottomText font:11 textColor:RGB(51, 51, 51) textAlignment:1 addToSuperView:buttonView];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(buttonView).offset(-4);
            make.centerX.equalTo(buttonView);
        }];
        return buttonView;
    }
}

-(void)creatProtocolWithView:(UIView *)lastView
{
    UIButton *buttonImage = [UIButton jh_buttonWithImage:@"push_order_select" target:self action:@selector(protocolSwitch:) addToSuperView:self.whiteView];
    [buttonImage setImage:[UIImage imageNamed:@"push_order_selected"] forState:UIControlStateSelected];
    buttonImage.selected = YES;
    self.agree = YES;
    UIButton *buttonTitle = [UIButton jh_buttonWithTitle:@"我已同意《原石交易协议》" fontSize:11 textColor:UIColor.blackColor target:self action:@selector(protocolAction) addToSuperView:self.whiteView];
    [buttonTitle setAttributedTitle:[self getAttributedString] forState:UIControlStateNormal];
    [buttonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteView).offset(10);
        make.top.equalTo(lastView.mas_bottom).offset(5);
        make.bottom.equalTo(self.whiteView).offset(-5);
    }];
    
    [buttonImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buttonTitle.mas_left).offset(-5);
        make.centerY.equalTo(buttonTitle);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

-(NSMutableAttributedString *)getAttributedString
{
//    NSString *string = [NSString stringWithFormat:@"￥%@",@((NSInteger)price)];
    NSString *string = @"我已同意《原石交易协议》";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHMediumFont(11), NSForegroundColorAttributeName: RGB(51, 51, 51)}];

    [attributedString addAttributes:@{NSForegroundColorAttributeName:RGB(35, 94, 150)} range:NSMakeRange(4, string.length-4)];
    
    return attributedString;
}

-(NSMutableAttributedString *)getPriceAttributedString
{
    float price = self.model.originOrderPrice.floatValue;
    
//    NSString *string = [NSString stringWithFormat:@"￥%@",@((NSInteger)price)];
    NSString *string = [NSString stringWithFormat:@"￥%@",PRICE_FLOAT_TO_STRING(price)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHBoldFont(14), NSForegroundColorAttributeName: RGB(252,66,0)}];

    [attributedString addAttributes:@{NSFontAttributeName: JHDINBoldFont(24)} range:NSMakeRange(1, string.length-1)];
    return attributedString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
