//
//  JHPurchaseTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPurchaseTableViewCell.h"
#import "JHUIFactory.h"
#import "OrderMode.h"

@interface JHPurchaseTableViewCell ()

@property (nonatomic, strong) UIImageView* playImage;
@property (nonatomic, strong) UILabel* typeLabel;
@property (nonatomic, strong) UILabel* orderLabel;
@property (nonatomic, strong) UILabel* statusLabel;
@property (nonatomic, strong) UILabel* goodCodeLabel;
@property (nonatomic, strong) UILabel* descLabel;
@property (nonatomic, strong) UILabel* priceLabel;
//子类需要个性化定制
@property (nonatomic, strong) UIImageView* buyerImg;
@property (nonatomic, strong) UILabel* buyerLabel;
@property (nonatomic, strong) UIImageView* sellerImg;
@property (nonatomic, strong) UILabel* sellerLabel;
@property (nonatomic, strong) UILabel* depositoryLabel;//货架号
@property (nonatomic, strong) UIButton* resellButton;
@end

@implementation JHPurchaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//        [self setupSubviews];//外面调用
    }
    
    return self;
}

- (void)setupSubviews:(JHStonePageType)pageType
{
    //根据type展示或隐藏
    self.typeLabel = [JHUIFactory createLabelWithTitle:@"寄回" titleColor:HEXCOLOR(0xFC4200) font:JHFont(10) textAlignment:NSTextAlignmentCenter];
    self.typeLabel.layer.cornerRadius = 2;
    self.typeLabel.layer.masksToBounds = YES;
    self.typeLabel.layer.borderColor = HEXCOLOR(0xFC4200).CGColor;
    self.typeLabel.layer.borderWidth = 0.5;
    [self.background addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(10);
        make.top.equalTo(self.background).offset(12);
        make.size.mas_equalTo(CGSizeMake(38, 16));
    }];
    //订单号：99993299
    self.orderLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x666666) font:JHMediumFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"订单号："];
    [self.background addSubview:self.orderLabel];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right).offset(6);
        make.top.equalTo(self.background).offset(12);
    }];
    
    self.statusLabel = [JHUIFactory createLabelWithTitle:@"待平台发货" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(11) textAlignment:NSTextAlignmentRight];
    [self.background addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-17);
        make.top.equalTo(self.background).offset(12);
    }];
    
    self.ctxImage = [JHUIButton buttonWithType:UIButtonTypeCustom];
    self.ctxImage.layer.cornerRadius = 4.0;
    [self.ctxImage addTarget:self action:@selector(pressImage) forControlEvents:UIControlEventTouchUpInside];
    [self.background addSubview:self.ctxImage];
    [self.ctxImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.background).offset(11);
        make.top.mas_equalTo(self.orderLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(75);
    }];
    
    self.playImage = [JHUIFactory createImageView];
    self.playImage.userInteractionEnabled = NO;
    self.playImage.image = [UIImage imageNamed:@"stone_video_play"];
    [self.ctxImage addSubview:self.playImage];
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.ctxImage);
        make.size.mas_equalTo(20);
    }];
    
    self.goodCodeLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(13) textAlignment:NSTextAlignmentLeft preTitle:@"编号："];
    [self.background addSubview:self.goodCodeLabel];
    [self.goodCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ctxImage.mas_right).offset(10);
        make.top.equalTo(self.ctxImage).offset(7);
    }];
    [self.goodCodeLabel setHidden:YES];
    
    self.descLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:self.descLabel];
    if(pageType == JHStonePageTypePurchase)
    {
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodCodeLabel.mas_bottom).offset(2);
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(10);
        }];
    }
    else
    {
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ctxImage).offset(5);//上面间距
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(10);
        }];
    }
    
    self.priceLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHBoldFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self.background addSubview:self.priceLabel];
    if(pageType == JHStonePageTypePurchase)
    {
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.descLabel.mas_bottom).offset(2);
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(8);
        }];
    }
    else
    {
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                   make.top.mas_equalTo(self.descLabel.mas_bottom).offset(5);//上面间距
                   make.left.mas_equalTo(self.ctxImage.mas_right).offset(8);
               }];
    }
    if(pageType == JHStonePageTypeStoneOrder)
    {
        UILabel* buyerTag = [JHUIFactory createLabelWithTitle:@"买家：" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
        [self.background addSubview:buyerTag];
        [buyerTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(10);
        }];
        
        self.buyerImg = [JHUIFactory createImageView];
        self.buyerImg.userInteractionEnabled = NO;
        [self.background addSubview:self.buyerImg];
        [self.buyerImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyerTag).offset(2);
            make.left.mas_equalTo(buyerTag.mas_right);
            make.size.mas_equalTo(12);
        }];
        
        self.buyerLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
        [self.background addSubview:self.buyerLabel];
        [self.buyerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyerTag);
            make.left.mas_equalTo(self.buyerImg.mas_right).offset(2);
        }];
        
        JHCustomLine* line = [JHUIFactory createLine];
        [self.background addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buyerImg);
            make.left.mas_equalTo(self.buyerLabel.mas_right).mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(1, 12));
        }];
        
        UILabel* salerTag = [JHUIFactory createLabelWithTitle:@"卖家：" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
        [self.background addSubview:salerTag];
        [salerTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyerTag);
            make.left.mas_equalTo(line.mas_right).offset(5);
        }];
        
        self.sellerImg = [JHUIFactory createImageView];
        self.sellerImg.userInteractionEnabled = NO;
        [self.background addSubview:self.sellerImg];
        [self.sellerImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(salerTag).offset(2);
            make.left.mas_equalTo(salerTag.mas_right);
            make.size.mas_equalTo(12);
        }];
        
        self.sellerLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
        [self.background addSubview:self.sellerLabel];
        [self.sellerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(salerTag);
            make.left.mas_equalTo(self.sellerImg.mas_right).offset(2);
        }];
    }
    else if(pageType == JHStonePageTypeSendOrder)
    {
        UILabel* buyerTag = [JHUIFactory createLabelWithTitle:@"买家：" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
        [self.background addSubview:buyerTag];
        [buyerTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(10);
        }];
        
        self.buyerImg = [JHUIFactory createImageView];
        self.buyerImg.userInteractionEnabled = NO;
        [self.background addSubview:self.buyerImg];
        [self.buyerImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyerTag).offset(2);
            make.left.mas_equalTo(buyerTag.mas_right);
            make.size.mas_equalTo(12);
        }];
        
        self.buyerLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
        [self.background addSubview:self.buyerLabel];
        [self.buyerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buyerTag);
            make.left.mas_equalTo(self.buyerImg.mas_right).offset(2);
        }];
        
        JHCustomLine* line = [JHUIFactory createLine];
        [self.background addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buyerImg);
            make.left.mas_equalTo(self.buyerLabel.mas_right).mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(1, 12));
        }];
        
        self.depositoryLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"货架："];
        [self.background addSubview:self.depositoryLabel];
        [self.depositoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buyerLabel);
            make.left.mas_equalTo(line.mas_right).offset(5);
        }];
    }
}

- (UIButton*)addSubviewsButton:(JHStonePageType)pageType
{
    self.resellButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resellButton.titleLabel.font = JHFont(13);
    [self.resellButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self.resellButton.backgroundColor = kGlobalThemeColor;
    self.resellButton.layer.cornerRadius = 15;
    self.resellButton.layer.masksToBounds = YES;
    [self.background addSubview:self.resellButton];
    [self.resellButton setHidden:YES]; //默认隐藏
    [self.resellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-10);
        make.bottom.equalTo(self.ctxImage);
        make.size.mas_equalTo(CGSizeMake(71, 30));
    }];
    return self.resellButton;
}

- (void)setCellData:(JHPurchaseStoneListModel*)model pageType:(JHStonePageType)pageType
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    if([model.goodsUrl length] > 0)
    {
        [self.ctxImage asynSetBackgroundImage:model.goodsUrl];
    }
    self.goodCodeLabel.text = model.goodsCode;
    [self.goodCodeLabel setHidden:NO];
    JHPurchaseType type = [JHPurchaseStoneModel PurchaseTypeFromState:model.transitionState];
    if(type == JHPurchaseTypeDefault)
    {
        [self.typeLabel setHidden:YES];
        [self.statusLabel setHidden:YES];
        [self.playImage setHidden:NO];
        [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(0);
        }];
    }
    else
    {
        [self.typeLabel setHidden:NO];
        [self.statusLabel setHidden:NO];
        [self.playImage setHidden:NO];
        self.typeLabel.text = [JHPurchaseStoneModel typeFromTransitionState:model.transitionState];
        [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(38, 16));
        }];
        if(type == JHPurchaseTypeSplit)
        {
            self.typeLabel.textColor = HEXCOLOR(0xFFFFFF);
            self.typeLabel.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
            self.typeLabel.backgroundColor =  HEXCOLOR(0xCCCCCC);
            self.orderLabel.textColor = HEXCOLOR(0x999999);
            self.descLabel.textColor = HEXCOLOR(0x999999);
            self.priceLabel.textColor = HEXCOLOR(0x999999);
            [self.statusLabel setHidden:YES];
        }
        else
        {
            [self.statusLabel setHidden:NO];
            self.statusLabel.text = [JHPurchaseStoneModel typeFromOrderStatus:model.orderStatus] ? : model.workorderDesc;
        }
    }
    [self.playImage setHidden:YES];//全部隐藏
    self.orderLabel.text = model.orderCode ? : @"";
    self.descLabel.text = model.goodsTitle;
    self.priceLabel.text = model.salePrice;
    if(pageType == JHStonePageTypeStoneOrder)
    {
        JHStoneOrderListModel* stoneModel = (JHStoneOrderListModel*)model;

        [self.buyerImg jhSetImageWithURL:[NSURL URLWithString:stoneModel.buyerIcon ? : @""] placeholder:kDefaultAvatarImage];
        
        [self.sellerImg jhSetImageWithURL:[NSURL URLWithString:stoneModel.sellerIcon ? : @""] placeholder:kDefaultAvatarImage];
        
        self.buyerLabel.text = stoneModel.buyerName;
        self.sellerLabel.text = stoneModel.sellerName;
        [self.goodCodeLabel setHidden:YES];
    }
    else if(pageType == JHStonePageTypeSendOrder)
    {
        JHSendOrderListModel* sendModel = (JHSendOrderListModel*)model;

        [self.buyerImg jhSetImageWithURL:[NSURL URLWithString:sendModel.buyerIcon ? : @""] placeholder:kDefaultAvatarImage];
        self.buyerLabel.text = sendModel.buyerName;
        self.depositoryLabel.text = sendModel.depositoryLocationCode;
        [self.goodCodeLabel setHidden:YES];
    }
    else //JHStonePageTypePurchase
    {//转售按钮
        [self.resellButton setHidden:model.resaleFlag == 1 ? NO : YES];
        [self.resellButton setTitle:model.resaleButtonText ? : @"转售" forState:UIControlStateNormal];
        if(model.resaleStatus == 2)
        {//置灰不可点击
            [self.resellButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            self.resellButton.backgroundColor = HEXCOLOR(0xDDDDDD);
            [self.resellButton removeTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [self.resellButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            self.resellButton.backgroundColor = kGlobalThemeColor;
            [self.resellButton addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - event
- (void)pressImage
{
    //TODO:jesse??
}

- (void)pressButton:(UIButton*)btn
{
    //TODO:jesse??
}

@end
