//
//  JHMyPriceTableViewCell.m
//  TTjianbao
//  
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMyPriceTableViewCell.h"
#import "JHUIFactory.h"
#import "JHMyPriceListModel.h"

@implementation JHMyPriceTableViewCell
{
    JHCellThemeType themeType;
    UIView* myPriceView;
    UILabel* myPriceLabel;
    UIImageView* okOrRefuseImg;
    UIButton* statusBtn;
    UILabel* retainTimeLabel;
    UILabel* retainTimeTag;
}

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
        //设置边线
        myPriceView.backgroundColor = kCellThemeClearColor;
        myPriceView.layer.borderWidth = 1;
        myPriceView.layer.borderColor = HEXCOLORA(0xFFFFFF, 0.1).CGColor;
        
        self.idLabel.textColor = HEXCOLORA(0xFFFFFF, 0.8);
        self.descpLabel.textColor = HEXCOLORA(0xFFFFFF, 0.8);
        self.priceLabel.textColor = HEXCOLOR(0xFFFFFF);
        myPriceLabel.textColor = HEXCOLOR(0xFFFFFF);
        retainTimeLabel.textColor = HEXCOLOR(0xFFFFFF);
        
        [self.bottomLine setHidden:NO];
        [self.background mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
        }];
        //回血直播间,约束重置(坐标变小)
        [self.ctxImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.background).offset(10);
            make.size.mas_equalTo(67);
        }];
        
        [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.ctxImage);
            make.size.mas_equalTo(21);
        }];
        
        [self.sawLabel setHidden:NO];
        
        self.idLabel.font = JHMediumFont(14);
        [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ctxImage).offset(-1);
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(9);
        }];
        
        self.descpLabel.font = JHMediumFont(14);
        [self.descpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.idLabel.mas_bottom).offset(2);
            make.left.equalTo(self.idLabel);
        }];
        
        self.priceLabel.font = JHBoldFont(17);
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(9);
            make.top.mas_equalTo(self.descpLabel.mas_bottom).offset(3);
        }];
    }
}

- (void)drawSubviews
{
    myPriceView = [UIView new];
    myPriceView.backgroundColor = HEXCOLOR(0xF8F8F8);
    myPriceView.layer.cornerRadius = 20;
    [self.background addSubview:myPriceView];
    [myPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(11);
        make.left.equalTo(self.background).offset(10);
        make.right.equalTo(self.background).offset(-10);
        make.height.mas_offset(40);
    }];
    
    myPriceLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0x333333) font:JHFont(14) textAlignment:NSTextAlignmentLeft preTitle:@"我的出价：￥"];
    [myPriceView addSubview:myPriceLabel];
    [myPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myPriceView).offset(11);
        make.top.equalTo(myPriceView).offset(10);
        make.bottom.equalTo(myPriceView).offset(-10);
    }];
    
    statusBtn = [JHUIFactory createThemeBtnWithTitle:@"重新出价" cornerRadius:15 target:self action:@selector(pressStatusButton)];
    statusBtn.titleLabel.font = JHFont(12);
    [myPriceView addSubview:statusBtn];
    [statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(myPriceView).offset(-8);
        make.top.equalTo(myPriceView).offset(5);
        make.size.mas_equalTo(CGSizeMake(81, 30));
    }];
    
    okOrRefuseImg = [JHUIFactory createImageView];
    [myPriceView addSubview:okOrRefuseImg];
    [okOrRefuseImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myPriceView).offset(0);
        make.right.mas_equalTo(statusBtn.mas_left).offset(-16);
        make.size.mas_equalTo(40);
    }];
    
    retainTimeLabel = [JHUIFactory createLabelWithTitle:@"00:00:00" titleColor:HEXCOLOR(0xFC4200) font:JHFont(12) textAlignment:NSTextAlignmentRight];
    [self.background addSubview:retainTimeLabel];
    [retainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myPriceView.mas_bottom).offset(6);
        make.right.equalTo(myPriceView);
        make.height.mas_equalTo(17);
    }];
    
    retainTimeTag = [JHUIFactory createLabelWithTitle:@"剩余支付时间：" titleColor:HEXCOLOR(0x999999) font:JHFont(10) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:retainTimeTag];
    [retainTimeTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myPriceView.mas_bottom).offset(8);
        make.right.mas_equalTo(retainTimeLabel.mas_left).offset(1);
        make.height.mas_equalTo(14);
    }];
}

- (void)setRetainTimeText:(NSString *)retainTimeText
{
    if(retainTimeText)
    {
        retainTimeLabel.text = retainTimeText;
        [retainTimeLabel setHidden:NO];
    }
    else
        [retainTimeLabel setHidden:YES];
}

- (void)updateCell:(JHMyPriceListModel*)model
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    self.cellModel = model;
    [self.ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];
    self.sawLabel.text = [NSString stringWithFormat:@"%@热度", model.seekCount ?:@"0"];
    self.idLabel.text = model.goodsCode;
    self.descpLabel.text = model.goodsTitle;
    self.priceLabel.text = model.salePrice;
    
    myPriceLabel.text = model.offerDetail.offerPrice;
    [retainTimeLabel setHidden:YES];
    [retainTimeTag setHidden:YES];
    [statusBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    //出价状态 1-出价中，2-待支付尾款 4-已拒绝
    if(model.offerDetail.offerState == 1)
    {
        okOrRefuseImg.image = [UIImage imageNamed:@"icon_none"];
        [statusBtn setTitle:@"取消出价" forState:UIControlStateNormal];
        statusBtn.layer.borderColor = kGlobalThemeColor.CGColor;
        statusBtn.layer.borderWidth = 1;
        statusBtn.backgroundColor = [UIColor clearColor];
        statusBtn.enabled = YES;
        if(themeType == JHCellThemeTypeClearColor)
            [statusBtn setTitleColor:HEXCOLOR(0xfee100) forState:UIControlStateNormal];
    }
    else if(model.offerDetail.offerState == 2)
    {
        okOrRefuseImg.image = [UIImage imageNamed:@"icon_stone_agree"];
        [statusBtn setTitle:@"支付尾款" forState:UIControlStateNormal];
        statusBtn.backgroundColor = kGlobalThemeColor;
//        retainTimeLabel.text = model.offerDetail.expireTime;
        [retainTimeLabel setHidden:NO];
        [retainTimeTag setHidden:NO];
        statusBtn.enabled = YES;
    }
    else  if(model.offerDetail.offerState == 4)
    {
        okOrRefuseImg.image = [UIImage imageNamed:@"icon_stone_reject"];
        [statusBtn setTitle:@"重新出价" forState:UIControlStateNormal];
        statusBtn.backgroundColor = kGlobalThemeColor;
        statusBtn.enabled = YES;
    }
    else  if(model.offerDetail.offerState == 7 || model.offerDetail.offerState == 8)
    {
        okOrRefuseImg.image = [UIImage imageNamed:@""];
        [statusBtn setTitle:@"已失效" forState:UIControlStateNormal];
        statusBtn.backgroundColor = RGB(232, 232, 232);
        statusBtn.enabled = NO;
    }
    else
    {
        //nothing???
    }
}

#pragma mark -
- (void)pressStatusButton
{
    JHMyPriceListModel* model = self.cellModel;
    RequestType type = RequestTypeRePutPrice;
    if(model.offerDetail.offerState == 1)
    {
        type = RequestTypeCancelPrice;
    }
    else if(model.offerDetail.offerState == 2)
    {
        type = RequestTypeWillPrice;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:type dataModel:self.cellModel indexPath:self.indexPath];
    }
}

@end
