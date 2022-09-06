//
//  JHBuyPriceTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBuyPriceTableViewCell.h"
#import "JHUIFactory.h"
#import "JHBuyerPriceListModel.h"

#define kBuyPriceTag 300

@protocol JHBuyPriceSubviewDelegate <NSObject>

- (void)clickEventWithOK:(BOOL)isOK model:(JHBuyerPriceDetailModel*)model;

@end

@interface JHBuyPriceSubview : UIView
{
    JHCellThemeType themeType;
    UIImageView* headImg;
    UILabel* nameLabel; //超过4个显示
    UILabel* timeLabel;
    UILabel* priceLabel;
    UIButton* okBtn;
    UIButton* refuseBtn;
    JHBuyerPriceDetailModel* detailModel;
    UILabel* willSaleLabel;
}

@property (nonatomic, weak) id <JHBuyPriceSubviewDelegate>delegate;
@end

@implementation JHBuyPriceSubview

- (instancetype)initWithThemeType:(JHCellThemeType)type
{
    if(self = [super init])
    {
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        
        themeType = type;
        [self drawSubviews];
        
        if(themeType == JHCellThemeTypeClearColor)
        {
            self.backgroundColor = kCellThemeClearColor;
            self.layer.borderWidth = 1;
            self.layer.borderColor = HEXCOLORA(0xFFFFFF, 0.1).CGColor;
            
            nameLabel.textColor = HEXCOLOR(0xFFFFFF);
            timeLabel.textColor = HEXCOLOR(0xFFFFFF);
            priceLabel.textColor = HEXCOLOR(0xFFFFFF);
            willSaleLabel.textColor = HEXCOLOR(0xFC4200);
            [refuseBtn setTitleColor:HEXCOLOR(0xFEE100) forState:UIControlStateNormal];
        }
        else
        {
            self.backgroundColor = HEXCOLOR(0xFCFCFC);
        }
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithThemeType:JHCellThemeTypeDefault];
}

- (void)drawSubviews
{
    headImg = [JHUIFactory createImageView];
    headImg.layer.cornerRadius = 30/2.0;
    [self addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(5);
        make.size.mas_equalTo(30);
    }];
    
    nameLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.mas_equalTo(headImg.mas_right).offset(6);
        make.height.mas_offset(17);
    }];
    
    timeLabel = [JHUIFactory createLabelWithTitle:@"0分钟前" titleColor:HEXCOLOR(0x999999) font:JHFont(9) textAlignment:NSTextAlignmentLeft];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImg.mas_right).offset(5);
        make.top.mas_equalTo(nameLabel.mas_bottom);
    }];
    
    priceLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft preTitle:@"出价 ￥"];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(11);
        make.bottom.equalTo(self).offset(-11);
        make.centerX.equalTo(self);
    }];
    
    okBtn = [JHUIFactory createThemeBtnWithTitle:@"接受" cornerRadius:15 target:self action:@selector(pressOk)];
    okBtn.titleLabel.font = JHFont(12);
    [self addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(52, 30));
    }];
    
    refuseBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"拒绝" cornerRadius:15 target:self action:@selector(pressRefuse)];
    refuseBtn.titleLabel.font = JHFont(12);
    [self addSubview:refuseBtn];
    [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(okBtn);
        make.right.mas_equalTo(okBtn.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(52, 30));
    }];
    
    willSaleLabel = [JHUIFactory createLabelWithTitle:@"待支付尾款" titleColor:HEXCOLOR(0x666666) font:JHFont(12) textAlignment:NSTextAlignmentRight];
    [self addSubview:willSaleLabel];
    [willSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self).offset(11);
       make.right.equalTo(self).offset(-10);
    }];
    [willSaleLabel setHidden:YES];
}

- (void)setDataModel:(JHBuyerPriceDetailModel*)model stoneId:(NSString*)stoneId
{
    detailModel = model;
    detailModel.stoneRestoreId = stoneId;
    
    [headImg jhSetImageWithURL:[NSURL URLWithString:model.customerImg ? : @""] placeholder:kDefaultAvatarImage];
    
    nameLabel.text = model.customerName;
    timeLabel.text = [CommHelp timeForJHShowTime:model.offerTime];
    priceLabel.text = model.offerPrice;
    /*用户出价状态~offerCustomerStatus:
     * 1 原石-正在支付，用户-非被接受的用户 ; 按钮显示，置灰
     * 2 原石-正在支付，用户-被接受的用户 ; 按钮隐藏，显示支付尾款
     * 3 原石-上架中，用户-卖家未接受未拒绝 ; 按钮显示，可用
     * 4 原石-上架中，用户-被拒绝的用户 ; 按钮显示，置灰
     */
    if([model.offerCustomerStatus isEqualToString:@"2"])//需要置灰,且隐藏按钮,显示“待支付尾款”
    {
        [willSaleLabel setHidden:NO];
        [okBtn setHidden:YES];
        [refuseBtn setHidden:YES];
    }
    else if([model.offerCustomerStatus isEqualToString:@"3"])//按钮显示，可用
    {
        [willSaleLabel setHidden:YES];
        [okBtn setHidden:NO];
        [refuseBtn setHidden:NO];
        [okBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        if(themeType == JHCellThemeTypeClearColor)
            [refuseBtn setTitleColor:HEXCOLOR(0xFEE100) forState:UIControlStateNormal];
        else
            [refuseBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        okBtn.backgroundColor = kGlobalThemeColor;
        refuseBtn.layer.borderColor = kGlobalThemeColor.CGColor;
        refuseBtn.layer.borderWidth = 1;
    }
    else//需要置灰
    {
        [willSaleLabel setHidden:YES];
        [okBtn setHidden:NO];
        [refuseBtn setHidden:NO];
        [okBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [refuseBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        okBtn.backgroundColor = HEXCOLOR(0xEEEEEE);
        refuseBtn.backgroundColor = HEXCOLOR(0xEEEEEE);
        refuseBtn.layer.borderColor = HEXCOLOR(0xEEEEEE).CGColor;
        refuseBtn.layer.borderWidth = 0;
    }
}
// 1 原石-正在支付，用户-非被接受的用户 或者 4 原石-上架中，用户-被拒绝的用户 ; 按钮显示，置灰
- (BOOL)clickInvalid
{
    if([detailModel.offerCustomerStatus isEqualToString:@"1"] || [detailModel.offerCustomerStatus isEqualToString:@"4"])
        return YES;
    return NO;
}

#pragma mark - event
- (void)pressOk
{
    if([self clickInvalid])//需要置灰,点击无效
        return;
    if([self.delegate respondsToSelector:@selector(clickEventWithOK:model:)])
        [self.delegate clickEventWithOK:YES model:detailModel];
}

- (void)pressRefuse
{
    if([self clickInvalid])//需要置灰,点击无效
        return;
    if([self.delegate respondsToSelector:@selector(clickEventWithOK:model:)])
        [self.delegate clickEventWithOK:NO model:detailModel];
}

@end

@interface JHBuyPriceTableViewCell () <JHBuyPriceSubviewDelegate>
{
    JHCellThemeType themeType;
    JHBuyPriceSubview* subOneview;
    JHBuyPriceSubview* subTwoview;
    JHBuyPriceSubview* subThxview;
}
@end

@implementation JHBuyPriceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
//        [self drawSubviews];
    }
    
    return self;
}

- (void)setCellThemeType:(JHCellThemeType)type
{
    themeType = type;
    [self drawSubviews];
    if(type == JHCellThemeTypeClearColor)
    {
        self.backgroundColor = kCellThemeClearColor;
        self.background.backgroundColor = kCellThemeClearColor;
        
        self.idLabel.textColor = HEXCOLORA(0xFFFFFF, 0.8);
        self.descpLabel.textColor = HEXCOLORA(0xFFFFFF, 0.8);
        self.priceLabel.textColor = HEXCOLOR(0xFFFFFF);
        
        [self.bottomLine setHidden:NO];
        [self.background mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
        }];
        
        //回血直播间,约束重置(坐标变小)
        [self.ctxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.background).offset(10);
            make.size.mas_equalTo(67);
        }];
        
        [self.playImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.ctxImage);
            make.size.mas_equalTo(21);
        }];
        
        [self.sawLabel setHidden:NO];
        
        self.idLabel.font = JHMediumFont(14);
        [self.idLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ctxImage).offset(-1);
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(9);
        }];
        
        self.descpLabel.font = JHMediumFont(14);
        [self.descpLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.idLabel.mas_bottom).offset(2);
            make.left.equalTo(self.idLabel);
        }];
        
        self.priceLabel.font = JHBoldFont(17);
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(9);
            make.top.mas_equalTo(self.descpLabel.mas_bottom).offset(3);
        }];
    }
}

- (void)drawSubviews
{
    subOneview = [[JHBuyPriceSubview alloc] initWithThemeType:themeType];
    subOneview.delegate = self;
    subOneview.tag = kBuyPriceTag + 0;
    [self.background addSubview:subOneview];
    [subOneview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(11);
        make.left.equalTo(self.background).offset(5);
        make.right.equalTo(self.background).offset(-5);
        make.height.mas_equalTo(40);
    }];
    [subOneview setHidden:YES];
    
    subTwoview = [[JHBuyPriceSubview alloc] initWithThemeType:themeType];
    subTwoview.delegate = self;
    subTwoview.tag = kBuyPriceTag + 1;
    [self.background addSubview:subTwoview];
    [subTwoview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subOneview.mas_bottom).offset(10);
        make.left.right.equalTo(subOneview);
        make.height.equalTo(subOneview);
    }];
    [subTwoview setHidden:YES];
    
    subThxview = [[JHBuyPriceSubview alloc] initWithThemeType:themeType];
    subThxview.delegate = self;
    subThxview.tag = kBuyPriceTag + 2;
    [self.background addSubview:subThxview];
    [subThxview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subTwoview.mas_bottom).offset(10);
        make.left.right.equalTo(subTwoview);
        make.height.equalTo(subTwoview);
    }];
    [subThxview setHidden:YES];
}

- (void)updateCell:(JHBuyerPriceModel*)model
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    self.cellModel = model;

    [self.ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];////网络图片
    self.sawLabel.text = [NSString stringWithFormat:@"%@热度", model.seekCount ?:@"0"];
    self.idLabel.text = model.goodsCode;
    self.descpLabel.text = model.goodsTitle;
    self.priceLabel.text = model.salePrice;
    
    [self clearSubviews];//清理一下，避免复用时重复
    //根据data中数据条数显示subview个数，默认创建三个，提高流畅度
    NSArray* detailArr = model.customerOfferList;
    NSInteger count = [detailArr count];
    if(count > 0)
    {
        [subOneview setDataModel:detailArr[0] stoneId:model.stoneRestoreId];
        [subOneview setHidden:NO];
    }
    if(count > 1)
    {
        [subTwoview setDataModel:detailArr[1] stoneId:model.stoneRestoreId];
        [subTwoview setHidden:NO];
    }
    if(count > 2)
    {
        [subThxview setDataModel:detailArr[2] stoneId:model.stoneRestoreId];
        [subThxview setHidden:NO];
    }
    //大于三个时，需要临时创建
    if(count > 3)
        [self showAdditionalPriceViews:model];
}

- (void)showAdditionalPriceViews:(JHBuyerPriceModel*)model
{
    NSArray* detailArr = model.customerOfferList;
    JHBuyPriceSubview* lastView = subThxview;
    JHBuyPriceSubview* additionalView;
    for (int i = 3; i < [detailArr count]; i++)
    {
        additionalView = [[JHBuyPriceSubview alloc] initWithThemeType:themeType];
        additionalView.delegate = self;
        additionalView.tag = kBuyPriceTag + i;
        [self.background addSubview:additionalView];
        [additionalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastView.mas_bottom).offset(10);
            make.left.right.equalTo(lastView);
            make.height.equalTo(lastView);
        }];
        [additionalView setDataModel:detailArr[i] stoneId:model.stoneRestoreId];
        //更新lastView
        lastView = additionalView;
    }
}

- (void)clearSubviews
{
    for (JHBuyPriceSubview* view in self.background.subviews)
    {
        if(view.tag >= kBuyPriceTag+3)
            [view removeFromSuperview];
        else if(view.tag >= kBuyPriceTag)
             [view setHidden:YES];
    }
}

#pragma mark - delegate
- (void)clickEventWithOK:(BOOL)isOK model:(JHBuyerPriceDetailModel *)model
{
    model.salePrice = ((JHBuyerPriceModel*)self.cellModel).salePrice;
    model.resaleFlag = ((JHBuyerPriceModel*)self.cellModel).resaleFlag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:isOK ? RequestTypeAgreePrice : RequestTypeRejectPrice dataModel:model indexPath:self.indexPath];
    }
}

@end

