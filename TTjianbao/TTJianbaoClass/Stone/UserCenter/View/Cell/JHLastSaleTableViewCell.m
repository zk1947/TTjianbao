//
//  JHLastSaleTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHLastSaleTableViewCell.h"
#import "JHUIFactory.h"
#import "JHBackUpLoadManage.h"
#import "JHUnionSignView.h"
#import "JHUnionSignSalePopView.h"
#import "JHUnionSignSaleInviteSignModel.h"

@implementation JHLastSaleTableViewCell
{
    UIImageView* ctxImage;  //内容，左边image
    UIImageView* playImage; //ctxImage上面的播放图标，表示视频
    UILabel* idLabel;
    UILabel* descpLabel;
    UILabel* priceLabel;
    UILabel* goodIdLabel; //货架号
    UIButton* printCodeBtn; //打印商品码
    UIButton* cutOrderBtn; //拆单
    UIButton* processBtn;   //加工
    UIButton* resaleBtn;    //寄售
    UIButton* sendBackBtn;  //寄回
    //分开定义：避免太多判断
    UIButton* editBtn;   //编辑
    UIButton* onShelfBtn; //上架
    UIButton* reShelfBtn; //上架失败重试+icon
    UILabel* shelvingLabel; //上架状态:上架中...
    //data model
    JHLastSaleGoodsModel* dataModel;
    JHLastSaleCellType cellType;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawLastSaleviews];
    }
    
    return self;
}

- (void)drawLastSaleviews
{
    ctxImage = [JHUIFactory createImageView];
    [self.background addSubview:ctxImage];
    [ctxImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.background).offset(10);
        make.size.mas_equalTo(90);
    }];
    
    playImage = [JHUIFactory createImageView];
    playImage.userInteractionEnabled = NO;
    playImage.image = [UIImage imageNamed:@"stone_video_play"];
    [ctxImage addSubview:playImage];
    [playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(ctxImage);
        make.size.mas_equalTo(23);
    }];
    
    idLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft preTitle:@"编号："];
    [self.background addSubview:idLabel];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ctxImage).offset(14);
        make.left.mas_equalTo(ctxImage.mas_right).offset(10);
    }];
    
    goodIdLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(12) textAlignment:NSTextAlignmentLeft preTitle:@"货架："];
    [self.background addSubview:goodIdLabel];
    [goodIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idLabel).offset(1);
        make.right.equalTo(self.background).offset(-10);
    }];
    
    descpLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:descpLabel];
    descpLabel.numberOfLines = 2;
    descpLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [descpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ctxImage).offset(37);
        make.left.mas_equalTo(ctxImage.mas_right).offset(10);
        make.right.equalTo(self.background).offset(-14);
    }];
    
    priceLabel = [JHUIFactory createJHLabelWithTitle:@"0.00" titleColor:HEXCOLOR(0xFC4200) font:JHFont(15) textAlignment:NSTextAlignmentLeft preTitle:@"￥"];
    [self.background addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descpLabel);
        make.top.mas_equalTo(descpLabel.mas_bottom).offset(5);
    }];
}

- (void)setupSubviewsByType:(JHLastSaleCellType)type
{
    cellType = type;
    [playImage setHidden:NO];
    if(JHLastSaleCellTypeWillSale == type || type == JHLastSaleCellTypeWillSaleFromUserCenter)
    {
        [self drawWillSaleButton];
        
        if(JHLastSaleCellTypeWillSaleFromUserCenter == type)
        {
            [goodIdLabel setHidden:YES];
        }
    }
    else
    {
        if(JHLastSaleCellTypeBuyer == type)
        {
            [playImage setHidden:YES];
            [idLabel setHidden:YES];
            [goodIdLabel setHidden:YES];
            [descpLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ctxImage).offset(25);
            }];
        }
        //个人中心类型不需要按钮
        if(JHLastSaleCellTypeFromUserCenter != type)
            [self drawOtherButton];
    }
    
    [self drawPrintButton:type];
}

- (void)drawWillSaleButton
{
    onShelfBtn = [JHUIFactory createThemeBtnWithTitle:@"上架" cornerRadius:30/2.0 target:self action:@selector(pressOnShelfButton)];
    onShelfBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:onShelfBtn];
    [onShelfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-10);
        make.top.mas_equalTo(ctxImage.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    reShelfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reShelfBtn.backgroundColor = HEXCOLORA(0xFFFFFF, 1);
    [reShelfBtn setTitle:@"上架失败，点击继续上架" forState:UIControlStateNormal];
    reShelfBtn.titleLabel.font =JHFont(12);
    [reShelfBtn setTitleColor:HEXCOLORA(0x666666, 1) forState:UIControlStateNormal];
    [reShelfBtn setImage:[UIImage imageNamed:@"resale_stone_retry"] forState:UIControlStateNormal];
    [reShelfBtn setTitleEdgeInsets:UIEdgeInsetsMake(3, -35, 2, 0)];
    [reShelfBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 132, 1, 0)];
    [self.background addSubview:reShelfBtn];
    [reShelfBtn addTarget:self action:@selector(pressOnShelfButton) forControlEvents:UIControlEventTouchUpInside];
    [reShelfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-10);
        make.bottom.equalTo(self.background).offset(-15);
        make.height.mas_equalTo(17);
    }];
    [reShelfBtn setHidden:YES];
    
    shelvingLabel = [JHUIFactory createLabelWithTitle:@"上架中..." titleColor:HEXCOLORA(0x666666, 1) font:JHFont(12) textAlignment:NSTextAlignmentRight];
    [self.background addSubview:shelvingLabel];
    [shelvingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.background).offset(-15);
        make.height.mas_equalTo(17);
    }];
    [shelvingLabel setHidden:YES];
}

- (void)drawPrintButton:(JHLastSaleCellType)type
{
    //JHLastSaleCellTypeBuyer JHLastSaleCellTypeWillSale JHLastSaleCellTypeWillSaleFromUserCenter
    printCodeBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"打印商品码" cornerRadius:30/2.0 target:self action:@selector(pressPrintCodeButton)];
    printCodeBtn.titleLabel.font =JHFont(12);
    [printCodeBtn setHidden:YES];
    [self.background addSubview:printCodeBtn];
    if(JHLastSaleCellTypeBuyer == type)
    {
        [printCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.background).offset(-10);
            make.top.mas_equalTo(ctxImage.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(83, 30));
        }];
    }
    else if(JHLastSaleCellTypeWillSale == type || JHLastSaleCellTypeWillSaleFromUserCenter == type)
    {
        [printCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(onShelfBtn.mas_left).offset(-10);
            make.top.mas_equalTo(ctxImage.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(83, 30));
        }];
    }
}

- (void)drawOtherButton
{
    cutOrderBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"拆单" cornerRadius:30/2.0 target:self action:@selector(pressCutOrderButton)];
    cutOrderBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:cutOrderBtn];
    [cutOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-10);
        make.top.mas_equalTo(ctxImage.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    processBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"加工" cornerRadius:30/2.0 target:self action:@selector(pressProcessButton)];
    processBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:processBtn];
    [processBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cutOrderBtn.mas_left).offset(-10);
        make.top.equalTo(cutOrderBtn);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    resaleBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"寄售" cornerRadius:30/2.0 target:self action:@selector(pressResaleButton)];
    resaleBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:resaleBtn];
    [resaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(processBtn.mas_left).offset(-10);
        make.top.equalTo(processBtn);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    sendBackBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"寄回" cornerRadius:30/2.0 target:self action:@selector(pressSendBackButton)];
    sendBackBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:sendBackBtn];
    [sendBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(resaleBtn.mas_left).offset(-10);
        make.top.equalTo(resaleBtn);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
}

- (void)updateCell:(JHLastSaleGoodsModel*)model
{
    dataModel = model;//保存数据
    
    [ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];

    idLabel.text = model.goodsCode;
    descpLabel.text = model.goodsTitle;
    if(model.dealPrice) {
        priceLabel.text = [NSString stringWithFormat:@"%@", model.dealPrice]; //最近售出
    }else if(model.salePrice) {
        priceLabel.text = [NSString stringWithFormat:@"%@", model.salePrice]; //待上架
    } else if(model.purchasePrice) {
        priceLabel.text = [NSString stringWithFormat:@"%@", model.purchasePrice];
    }
    goodIdLabel.text = model.depositoryLocationCode;
    
    [self showShelfAndPrintState:model];
    [self showButtonState:model];
}

- (void)showShelfAndPrintState:(JHLastSaleGoodsModel*)model
{
    if(JHLastSaleCellTypeWillSale == cellType || cellType == JHLastSaleCellTypeWillSaleFromUserCenter)
    {
        [printCodeBtn setHidden:NO]; //可以与上架按钮共存
        
        JHShelvShowStatus status = model.shelfState;
        if(status == JHShelvShowStatusShelveButton)
        {
            [onShelfBtn setHidden:NO];
            [reShelfBtn setHidden:YES];
            [shelvingLabel setHidden:YES];
            
            [printCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                     make.right.equalTo(onShelfBtn.mas_left).offset(-10);
                     make.top.mas_equalTo(ctxImage.mas_bottom).offset(10);
                     make.size.mas_equalTo(CGSizeMake(83, 30));
                 }];
        }
        else if(status == JHShelvShowStatusShelveing)
        {
            [onShelfBtn setHidden:YES];
            [shelvingLabel setHidden:NO];
            [reShelfBtn setHidden:YES];
            
            [printCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                     make.right.equalTo(shelvingLabel.mas_left).offset(-10);
                     make.top.mas_equalTo(ctxImage.mas_bottom).offset(10);
                     make.size.mas_equalTo(CGSizeMake(83, 30));
                 }];
        }
        else if(status == JHShelvShowStatusShelveFail)
        {
            [onShelfBtn setHidden:YES];
            [shelvingLabel setHidden:YES];
            [reShelfBtn setHidden:NO];
            
            [printCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                     make.right.equalTo(reShelfBtn.mas_left).offset(-10);
                     make.top.mas_equalTo(ctxImage.mas_bottom).offset(10);
                     make.size.mas_equalTo(CGSizeMake(83, 30));
                 }];
        }
        else if(status == JHShelvShowStatusSuccess)
        {
            //再外面处理数据
        }
    }
    else if(model.printButton == 1)
    {
        [printCodeBtn setHidden:NO]; //可以与上架按钮共存
    }
    else
    {
        [printCodeBtn setHidden:YES]; //上架按钮隐藏
    }
}

- (void)showButtonState:(JHLastSaleGoodsModel*)model
{
    [processBtn setHidden:NO];
    [resaleBtn setHidden:NO];
    [cutOrderBtn setHidden:NO];
    [sendBackBtn setHidden:NO];
    
    if(model.splitButton == 1)
    {
        [cutOrderBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [cutOrderBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                          make.size.mas_equalTo(CGSizeMake(50, 30));
                      }];
        [processBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cutOrderBtn.mas_left).offset(-10);
        }];
    }
    else if(model.splitButton == 2)
    {
        [cutOrderBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [cutOrderBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.size.mas_equalTo(CGSizeMake(50, 30));
               }];
        [processBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cutOrderBtn.mas_left).offset(-10);
        }];
    }
    else
    {
        [cutOrderBtn setHidden:YES];
        [cutOrderBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
        [processBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cutOrderBtn.mas_left);
        }];
    }
    
    if(model.processButton == 1)//显示可点击
    {
        [processBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [processBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [resaleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(processBtn.mas_left).offset(-10);
        }];
    }
    else if(model.processButton == 2)//显示不可点击
    {
        [processBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [processBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [resaleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(processBtn.mas_left).offset(-10);
        }];
    }
    else
    {
        [processBtn setHidden:YES];//不显示
        [processBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
        [resaleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(processBtn.mas_left);
        }];
    }
    
    if(model.saleButton == 1)
    {
        [resaleBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [resaleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [sendBackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(resaleBtn.mas_left).offset(-10);
        }];
    }
    else if(model.saleButton == 2)
    {
        [resaleBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [resaleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        [sendBackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(resaleBtn.mas_left).offset(-10);
        }];
    }
    else
    {
        [resaleBtn setHidden:YES];
        [resaleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
        [sendBackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(resaleBtn.mas_left);
        }];
    }
        
    if(model.sendButton == 1)
    {
        [sendBackBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [sendBackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
    }
    else if(model.sendButton == 2)
    {
        [sendBackBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [sendBackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
    }
    else
    {
        [sendBackBtn setHidden:YES];
    }
}

#pragma mark - events
- (void)pressBtnType:(RequestType)type
{
    if([self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)])
    {
        [self.delegate pressButtonType:type dataModel:dataModel indexPath:self.sd_indexPath];
    }
}

- (void)pressPrintCodeButton
{
    if(dataModel.printButton == 1 || JHLastSaleCellTypeWillSale == cellType || cellType == JHLastSaleCellTypeWillSaleFromUserCenter)
    {
        [self pressBtnType:RequestTypePrintGoodCode];
    }
}

- (void)pressCutOrderButton
{
    if(dataModel.splitButton == 1)
        [self pressBtnType:RequestTypeBreakPaper];
}

- (void)pressProcessButton
{
    if(dataModel.processButton == 1)
        [self pressBtnType:RequestTypeProcess];
}
    
- (void)pressResaleButton
{
    if(dataModel.saleButton == 1)
    {
        NSString *userId = dataModel.signCustomerId;
        [JHUnionSignView getUnionSignStatusWithCustomerId:userId statusBlock:^(JHUnionSignStatus status) {
            if (status == JHUnionSignStatusComplete || status == JHUnionSignStatusReviewing)
            {
                [self pressBtnType:RequestTypeResale];
            }
            else
            {
                [JHUnionSignSalePopView showUnsignCannotSaleView].activeBlock = ^(id obj) {
                    [JHUnionSignSaleInviteSignModel request:userId];
                };
            }
        }];
    }
}

- (void)pressSendBackButton
{
    if(dataModel.sendButton == 1)
        [self pressBtnType:RequestTypeSendBack];
}

- (void)pressOnShelfButton
{
    [self pressBtnType:RequestTypePutShelf];
}

- (void)pressEditButton
{
    [self pressBtnType:RequestTypeEdit];
}

@end
