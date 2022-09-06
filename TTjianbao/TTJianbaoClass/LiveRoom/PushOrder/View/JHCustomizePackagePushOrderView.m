//
//  JHCustomizePackagePushOrderView.m
//  TTjianbao
//
//  Created by user on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCustomizePackagePushOrderView.h"
#import <SVProgressHUD.h>
#import "UIView+UIHelp.h"
#import "EnlargedImage.h"
#import "JHCollectionViewLeftAlignedLayout.h"
#import "JHPushOrderCouponCell.h"
#import "UIView+NTES.h"
#import "JHWebViewController.h"
#import "JHOrderConfirmViewController.h"
#import "TTjianbaoBussiness.h"
#import "UIView+JHGradient.h"


@interface JHCustomizePackagePushOrderView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,   weak) UIImageView      *headerImage;
@property (nonatomic,   weak) UILabel          *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,   weak) UIView           *whiteView;
@property (nonatomic, assign) BOOL              agree;

@property (nonatomic, strong) UILabel          *packageNameLabel;
@property (nonatomic, strong) UILabel          *descInfoLabel;
@property (nonatomic, strong) UILabel          *stuffOrderNameLabel;
@property (nonatomic,   weak) UILabel          *stuffPriceLabel;
@property (nonatomic, strong) UIButton         *stuffPayButton;

@property (nonatomic, strong) UILabel          *customizeOrderNameLabel;
@property (nonatomic,   weak) UILabel          *customizePriceLabel;
@property (nonatomic, strong) UIButton         *customizePayButton;
@end

@implementation JHCustomizePackagePushOrderView

- (void)dealloc {
    [JHUserStatistics noteEventType:kUPEventTypeReSaleLiveRoomSendOrder params:@{JHUPEventKey : JHUPEventKeyEnd}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.1);
        [self addselfSubViews];
        [JHUserStatistics noteEventType:kUPEventTypeReSaleLiveRoomSendOrder params:@{JHUPEventKey : JHUPEventKeyBegin}];
    }
    return self;
}

-(void)addselfSubViews {
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:4];
    _whiteView = whiteView;
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self.mas_left).offset(57.f);
        make.right.equalTo(self.mas_right).offset(-57.f);
    }];
    
    _packageNameLabel           = [[UILabel alloc] init];
    _packageNameLabel.textColor = HEXCOLOR(0x333333);
    _packageNameLabel.font      = [UIFont fontWithName:kFontMedium size:15.f];
    _packageNameLabel.text      = @"定制套餐";
    [self addSubview:_packageNameLabel];
    [_packageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView.mas_top).offset(15.f);
        make.centerX.equalTo(whiteView.mas_centerX);
        make.height.mas_equalTo(21.f);
    }];
       
    
    UIButton *button = [UIButton jh_buttonWithImage:@"orderPopView_closeIcon" target:self action:@selector(hiddenAlert) addToSuperView:self];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView.mas_top).offset(5.f);
        make.right.equalTo(self.whiteView.mas_right).offset(-5.f);
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
    }];
    
    _descInfoLabel               = [[UILabel alloc] init];
    _descInfoLabel.textColor     = HEXCOLOR(0x999999);
    _descInfoLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _descInfoLabel.numberOfLines = 2;
    [self addSubview:_descInfoLabel];
    [_descInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.packageNameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.whiteView.mas_left).offset(10.f);
        make.right.equalTo(self.whiteView.mas_right).offset(-10.f);
        make.height.mas_equalTo(34.f);
    }];
    
    _headerImage = [UIImageView jh_imageViewAddToSuperview:self];
    [_headerImage jh_cornerRadius:3];
    [_headerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)]];
    _headerImage.userInteractionEnabled = YES;
    [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descInfoLabel.mas_bottom).offset(5.f);
        make.left.equalTo(whiteView).offset(10.f);
        make.right.equalTo(whiteView).offset(-10.f);
        make.height.mas_equalTo(240.f);
    }];
    

    /// 原料订单
    UILabel *firstOrderNumLabel            = [[UILabel alloc] init];
    firstOrderNumLabel.textColor           = HEXCOLOR(0x333333);
    firstOrderNumLabel.font                = [UIFont fontWithName:kFontBoldPingFang size:12.f];
    firstOrderNumLabel.text                = @"1";
    firstOrderNumLabel.backgroundColor     = HEXCOLOR(0xFFD70F);
    firstOrderNumLabel.layer.cornerRadius  = 7.5f;
    firstOrderNumLabel.layer.masksToBounds = YES;
    firstOrderNumLabel.textAlignment       = NSTextAlignmentCenter;
    [whiteView addSubview:firstOrderNumLabel];
    [firstOrderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImage.mas_bottom).offset(12.f);
        make.left.equalTo(self.headerImage.mas_left);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
    
    UILabel *stuffOrderLabel = [[UILabel alloc] init];
    stuffOrderLabel.textColor     = HEXCOLOR(0x333333);
    stuffOrderLabel.font          = [UIFont fontWithName:kFontBoldPingFang size:14.f];
    stuffOrderLabel.text          = @"原料订单";
    [whiteView addSubview:stuffOrderLabel];
    [stuffOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstOrderNumLabel.mas_centerY);
        make.left.equalTo(firstOrderNumLabel.mas_right).offset(3.f);
        make.height.mas_equalTo(20.f);
    }];
    
    
    _stuffOrderNameLabel = [[UILabel alloc] init];
    _stuffOrderNameLabel.textColor     = HEXCOLOR(0x333333);
    _stuffOrderNameLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [whiteView addSubview:_stuffOrderNameLabel];
    [_stuffOrderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stuffOrderLabel.mas_bottom).offset(5.f);
        make.left.equalTo(stuffOrderLabel.mas_left);
        make.right.equalTo(self.whiteView.mas_right).offset(-10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    _stuffPriceLabel = [UILabel jh_labelWithText:@"￥0.0" font:24 textColor:RGB(255, 66, 0) textAlignment:0 addToSuperView:whiteView];
    _stuffPriceLabel.font = JHDINBoldFont(24);
    _stuffPriceLabel.adjustsFontSizeToFitWidth = YES;
    [_stuffPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stuffOrderNameLabel.mas_left);
        make.top.equalTo(self.stuffOrderNameLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(24.f);
    }];
    
    [self.whiteView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stuffOrderNameLabel.mas_left);
        make.right.equalTo(self.headerImage.mas_right);
        make.top.equalTo(self.stuffPriceLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(16.f);
    }];
    
    
    _stuffPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stuffPayButton addTarget:self action:@selector(stuffPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stuffPayButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [_stuffPayButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _stuffPayButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.f];
    [_stuffPayButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    _stuffPayButton.layer.cornerRadius = 19;
    _stuffPayButton.layer.masksToBounds = YES;
    [self.whiteView addSubview:_stuffPayButton];
    [_stuffPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stuffOrderNameLabel.mas_left);
        make.right.equalTo(self.whiteView.mas_right).offset(-10.f);
        make.top.equalTo(self.collectionView.mas_bottom).offset(15.f);
        make.height.mas_equalTo(38.f);
    }];
    
    
    UIView *yellowLineView = [[UIView alloc] init];
    yellowLineView.backgroundColor = HEXCOLOR(0xFFD70F);
    [self.whiteView addSubview:yellowLineView];
    [yellowLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstOrderNumLabel.mas_bottom);
        make.centerX.equalTo(firstOrderNumLabel.mas_centerX);
        make.bottom.equalTo(self.stuffPayButton.mas_top);
        make.width.mas_equalTo(2.f);
    }];
    

    /// 定制订单
    UILabel *secondOrderNumLabel            = [[UILabel alloc] init];
    secondOrderNumLabel.textColor           = HEXCOLOR(0x999999);
    secondOrderNumLabel.font                = [UIFont fontWithName:kFontBoldPingFang size:12.f];
    secondOrderNumLabel.text                = @"2";
    secondOrderNumLabel.backgroundColor     = HEXCOLOR(0xEEEEEE);
    secondOrderNumLabel.layer.cornerRadius  = 7.5f;
    secondOrderNumLabel.layer.masksToBounds = YES;
    secondOrderNumLabel.textAlignment       = NSTextAlignmentCenter;
    [self.whiteView addSubview:secondOrderNumLabel];
    [secondOrderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stuffPayButton.mas_bottom).offset(23.f);
        make.left.equalTo(self.headerImage.mas_left);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
    
    UIView *grayLineView = [[UIView alloc] init];
    grayLineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.whiteView addSubview:grayLineView];
    [grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yellowLineView.mas_bottom);
        make.centerX.equalTo(yellowLineView.mas_centerX);
        make.bottom.equalTo(secondOrderNumLabel.mas_top);
        make.width.mas_equalTo(2.f);
    }];
    
    UILabel *customizeOrderLabel = [[UILabel alloc] init];
    customizeOrderLabel.textColor     = HEXCOLOR(0x999999);
    customizeOrderLabel.font          = [UIFont fontWithName:kFontBoldPingFang size:14.f];
    customizeOrderLabel.text          = @"定制订单";
    [self.whiteView addSubview:customizeOrderLabel];
    [customizeOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secondOrderNumLabel.mas_centerY);
        make.left.equalTo(secondOrderNumLabel.mas_right).offset(3.f);
        make.height.mas_equalTo(20.f);
    }];
        
    _customizeOrderNameLabel = [[UILabel alloc] init];
    _customizeOrderNameLabel.textColor     = HEXCOLOR(0x999999);
    _customizeOrderNameLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.whiteView addSubview:_customizeOrderNameLabel];
    [_customizeOrderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customizeOrderLabel.mas_bottom).offset(5.f);
        make.right.equalTo(self.whiteView.mas_right).offset(-10.f);
        make.left.equalTo(customizeOrderLabel.mas_left);
        make.height.mas_equalTo(17.f);
    }];
    
    _customizePriceLabel = [UILabel jh_labelWithText:@"￥0.0" font:24 textColor:RGB(255, 66, 0) textAlignment:0 addToSuperView:whiteView];
    _customizePriceLabel.font = JHDINBoldFont(24);
    _customizePriceLabel.adjustsFontSizeToFitWidth = YES;
    [_customizePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stuffOrderNameLabel.mas_left);
        make.top.equalTo(self.customizeOrderNameLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(24.f);
    }];
    
    
    _customizePayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customizePayButton setTitle:@"待支付" forState:UIControlStateNormal];
    [_customizePayButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    _customizePayButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.f];
    _customizePayButton.layer.cornerRadius = 19;
    _customizePayButton.layer.masksToBounds = YES;
    _customizePayButton.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.whiteView addSubview:_customizePayButton];
    [_customizePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.customizeOrderNameLabel.mas_left);
        make.right.equalTo(self.whiteView.mas_right).offset(-10.f);
        make.top.equalTo(self.customizePriceLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo(38.f);
        make.bottom.equalTo(self.whiteView.mas_bottom).offset(-15.f);
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JHCollectionViewLeftAlignedLayout *flowLayout = [[JHCollectionViewLeftAlignedLayout alloc]init];
        flowLayout.estimatedItemSize  = CGSizeMake(100, 13);
        flowLayout.minimumLineSpacing = 5.0;
        flowLayout.minimumInteritemSpacing = 5.0;
        _collectionView = [[UICollectionView alloc]
                                initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JHPushOrderCouponCell class] forCellWithReuseIdentifier:[JHPushOrderCouponCell cellIdentifier]];
    }
    return _collectionView;
}

- (void)setModel:(OrderMode *)model {
    if (_model) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self addselfSubViews];
    }
        
    _model = model;
    [self.headerImage jh_setImageWithUrl:self.model.goodsUrl];
    [self updateUI];
    self.descInfoLabel.text       = NONNULL_STR(model.customizePackageExplain);
    self.stuffOrderNameLabel.text = NONNULL_STR(model.goodsTitle);
    self.customizeOrderNameLabel.text = NONNULL_STR(model.customizeOrder.goodsTitle);
    self.stuffPriceLabel.attributedText = [self getPriceAttributedString:model.originOrderPrice];
    self.customizePriceLabel.attributedText = [self getPriceAttributedString:model.customizeOrder.originOrderPrice];
}

- (void)updateUI {
    BOOL isHaveCoupon = NO;//是否有优惠
    if (self.model.subtractPrice.floatValue > 0) {
        isHaveCoupon = YES;
        NSString *subtractPrice = [NSString stringWithFormat:@" 约为你省￥%@ ",PRICE_FLOAT_TO_STRING([self.model.subtractPrice floatValue])];
        UILabel *priceDescLabel = [UILabel jh_labelWithText:subtractPrice font:11 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:self.whiteView];
        priceDescLabel.backgroundColor = RGB(255, 66, 0);
        [priceDescLabel jh_cornerRadius:2];
        [priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stuffPriceLabel.mas_right).offset(5.f);
            make.centerY.equalTo(self.stuffPriceLabel);
            make.height.mas_equalTo(16);
            make.right.lessThanOrEqualTo(self.headerImage);
        }];
    }
    
    if (self.model.couponValueList.count > 0) {
        [self.collectionView reloadData];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stuffPriceLabel.mas_bottom).offset(5.f);
            make.height.mas_equalTo(16.f);
        }];
    } else {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stuffPriceLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    }
    
    NSString *orderPrice = isHaveCoupon ? [NSString stringWithFormat:@"确认支付￥%@",PRICE_FLOAT_TO_STRING([self.model.price floatValue])] : [NSString stringWithFormat:@"确认支付￥%@",PRICE_FLOAT_TO_STRING([self.model.originOrderPrice floatValue])];
    [self.stuffPayButton setTitle:orderPrice forState:UIControlStateNormal];
}

- (NSMutableAttributedString *)getPriceAttributedString:(NSString *)oPrice {
    float price = [oPrice floatValue];
    NSString *string = [NSString stringWithFormat:@"￥%@",PRICE_FLOAT_TO_STRING(price)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes: @{NSFontAttributeName:JHBoldFont(14), NSForegroundColorAttributeName: RGB(252,66,0)}];
    [attributedString addAttributes:@{NSFontAttributeName: JHDINBoldFont(24)} range:NSMakeRange(1, string.length-1)];
    return attributedString;
}



#pragma mark --------------- action ---------------
- (void)showImage {
    if (self.model.goodsUrl) {
        [[EnlargedImage sharedInstance] enlargedImage:self.headerImage enlargedTime:0.3 images:@[self.model.goodsUrl].mutableCopy andIndex:0 result:^(NSInteger index) {
        }];
    }
}

- (void)stuffPayButtonClick:(UIButton *)sender {
    JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
    vc.orderId = self.model.orderId;
    vc.fromString = JHConfirmFromOrderDialog;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [self hiddenAlert];
    LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
    model.orderCategory = self.model.orderCategory;
    [JHGrowingIO trackEventId:JHTracklive_orderreceive_paybtn variables:[model mj_keyValues]];
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


@end
