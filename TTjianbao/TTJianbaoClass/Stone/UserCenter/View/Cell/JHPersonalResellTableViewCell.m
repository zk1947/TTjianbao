//
//  JHPersonalResellTableViewCell.m
//  TTjianbao
//
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPersonalResellTableViewCell.h"
#import "JHPurchaseStoneModel.h"

@interface JHPersonalResellTableViewCell ()
{
    JHPersonalResellSubPageType pageType;
    //已售 header
    UIImageView* headerImage; //用户image
    UILabel* headerName; //用户name
    UILabel* headerStatus; //商品状态
    //button
    UIButton* yellowBtn; //最右边
    UIButton* editOrDetailBtn;
    UIButton* deleteBtn;
}
@end

@implementation JHPersonalResellTableViewCell

- (instancetype)initWithPageStyle:(JHPersonalResellSubPageType)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        pageType = style;
        //新增样式:已售
        [self drawHeaderViewWithStyle];
        //修改老样式
        [self.idLabel setHidden:YES];
        self.descpLabel.font = JHMediumFont(14);
        self.descpLabel.numberOfLines = 2;
        self.descpLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.descpLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ctxImage);
            make.left.mas_equalTo(self.ctxImage.mas_right).offset(10);
            make.right.mas_equalTo(self.background).offset(-8);
        }];
        self.priceLabel.font = JHDINBoldFont(18);
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.descpLabel);
            make.bottom.mas_equalTo(self.ctxImage).offset(-14);
        }];
        //新增button
        yellowBtn = [self makeButton];
        [yellowBtn addTarget:self action:@selector(pressYellowBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.background addSubview:yellowBtn];
        [yellowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(10);
            make.right.equalTo(self.background).offset(-10);
            make.bottom.equalTo(self.background).offset(-10);
            make.size.mas_equalTo(CGSizeMake(84, 30));
        }];
        
        editOrDetailBtn = [self makeButton];
        editOrDetailBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        editOrDetailBtn.layer.borderWidth = 0.5;
        editOrDetailBtn.backgroundColor = HEXCOLOR(0xFFFFFF);
        [self.background addSubview:editOrDetailBtn];
        [editOrDetailBtn addTarget:self action:@selector(pressEditOrDetailBtn) forControlEvents:UIControlEventTouchUpInside];
        [editOrDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(yellowBtn.mas_left).offset(-6);
            make.bottom.equalTo(yellowBtn);
            make.size.equalTo(yellowBtn);
        }];
        
        deleteBtn = [self makeButton];
        deleteBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        deleteBtn.layer.borderWidth = 0.5;
        deleteBtn.backgroundColor = HEXCOLOR(0xFFFFFF);
        [self.background addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(pressDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(editOrDetailBtn.mas_left).offset(-6);
            make.bottom.equalTo(editOrDetailBtn);
            make.size.equalTo(editOrDetailBtn);
        }];
        
        [self drawSubviewWithStyle];
    }
    
    return self;
}

- (UIButton*)makeButton
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = JHFont(13);
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.backgroundColor = kGlobalThemeColor;
    btn.layer.cornerRadius = 15;
    btn.layer.masksToBounds = YES;
    return btn;
}

- (void)drawHeaderViewWithStyle
{
    if(pageType == JHPersonalResellSubPageTypeSold)
    {
        headerImage = [UIImageView new];
        headerImage.contentMode = UIViewContentModeScaleAspectFill;
        headerImage.layer.cornerRadius = 8;
        headerImage.layer.masksToBounds = YES;
        [self.background addSubview:headerImage];
        [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.background).offset(11);
            make.size.mas_equalTo(16);
        }];

        headerName = [UILabel new];
        headerName.font = JHFont(12);
        headerName.textColor = HEXCOLOR(0x333333);
        headerName.textAlignment = NSTextAlignmentLeft;
        [self.background addSubview:headerName];
        [headerName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerImage);
            make.left.mas_equalTo(headerImage.mas_right).offset(5);
        }];
        
        headerStatus = [UILabel new];
        headerStatus.font = JHFont(12);
        headerStatus.textColor = HEXCOLOR(0x333333);
        headerStatus.textAlignment = NSTextAlignmentLeft;
        [self.background addSubview:headerStatus];
        [headerStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerImage);
            make.right.mas_equalTo(self.background).offset(-10);
        }];
        
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerImage.mas_bottom).offset(10);
            make.left.equalTo(self.background).offset(10);
            make.right.equalTo(self.background).offset(0);
            make.height.mas_equalTo(1);
        }];
        self.bottomLine.color = HEXCOLORA(0xF0F0F0, 1);
        [self.bottomLine setHidden:NO];
        
        [self.ctxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bottomLine.mas_bottom).offset(10);
            make.left.equalTo(self.bottomLine);
            make.size.mas_equalTo(90);
        }];
    }
}

- (void)drawSubviewWithStyle
{
    switch (pageType)
    {
        case JHPersonalResellSubPageTypeShelve:
        default:
        {
            [yellowBtn setTitle:@"下架" forState:UIControlStateNormal];
            [editOrDetailBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [deleteBtn setHidden:YES];
        }
            break;
            
        case JHPersonalResellSubPageTypeWaitShelve:
        {
            [yellowBtn setTitle:@"上架" forState:UIControlStateNormal];
            [editOrDetailBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        }
            break;
            
        case JHPersonalResellSubPageTypeSold:
        {
            [yellowBtn setTitle:@"发货" forState:UIControlStateNormal];
            [editOrDetailBtn setTitle:@"订单详情" forState:UIControlStateNormal];
            [deleteBtn setHidden:YES];
        }
            break;
    }
}

- (void)updateCell:(JHPersonalResellListModel*)model
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    self.cellModel = model;
    //已售
    [headerImage jhSetImageWithURL:[NSURL URLWithString:model.buyerImg ? : @""] placeholder:kDefaultAvatarImage];
    headerName.text = model.buyerName;
    headerStatus.text = [JHPurchaseStoneModel typeFromOrderStatus:model.orderStatus] ? : model.workorderDesc;
    //其他
    if(model.showVideo)
    {
        [self.playImage setHidden:NO];
    }
    else
    {
        [self.playImage setHidden:YES];
    }
    [self.ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];///网络图片
    self.descpLabel.text = model.goodsTitle;
    self.priceLabel.text = model.salePrice;
    if(JHPersonalResellSubPageTypeSold == pageType)
    {
        if([model.orderStatus isEqualToString:@"waitsellersend"])
        {
            [yellowBtn setHidden:NO];
            [editOrDetailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(yellowBtn.mas_left).offset(-6);
                make.bottom.equalTo(yellowBtn);
                make.size.equalTo(yellowBtn);
            }];
        }
        else
        {
            [yellowBtn setHidden:YES];
            [editOrDetailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(10);
                make.right.equalTo(self.background).offset(-10);
                make.bottom.equalTo(self.background).offset(-10);
                make.size.mas_equalTo(CGSizeMake(84, 30));
            }];
        }
    }
}

#pragma mark - event
- (void)pressYellowBtn
{//上架、下架、发货
    if([self.mDelegate respondsToSelector:@selector(pressButtonType:tableViewCell:)])
    {
        if(pageType == JHPersonalResellSubPageTypeShelve)
        {
            [self.mDelegate pressButtonType:JHPersonalResellCellActiveTypeUnshelve tableViewCell:self];
        }
        else if(pageType == JHPersonalResellSubPageTypeWaitShelve)
        {
            [self.mDelegate pressButtonType:JHPersonalResellCellActiveTypeShelve tableViewCell:self];
        }
        else if(pageType == JHPersonalResellSubPageTypeSold)
        {
            [self.mDelegate pressButtonType:JHPersonalResellCellActiveTypeSend tableViewCell:self];
        }
    }
}
//编辑及订单详情
- (void)pressEditOrDetailBtn
{
    if([self.mDelegate respondsToSelector:@selector(pressButtonType:tableViewCell:)])
    {
        if(pageType == JHPersonalResellSubPageTypeSold)
        {
            [self.mDelegate pressButtonType:JHPersonalResellCellActiveTypeDetail tableViewCell:self];
        }
        else
        {
            [self.mDelegate pressButtonType:JHPersonalResellCellActiveTypeEdit tableViewCell:self];
        }
    }
}

- (void)pressDeleteBtn
{
    if([self.mDelegate respondsToSelector:@selector(pressButtonType:tableViewCell:)])
    {
        [self.mDelegate pressButtonType:JHPersonalResellCellActiveTypeDelete tableViewCell:self];
    }
}

@end
