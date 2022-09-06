//
//  JHUCOnSaleTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHUCOnSaleTableViewCell.h"
#import "JHBubbleWindow.h"

@implementation JHUCOnSaleTableViewCell
{
    UILabel* headLabel;
    UILabel* statusLabel;
    UIButton* cancelBtn;
    UIButton* fixPriceBtn;
    UIButton* enterBtn;
    JHBubbleWindow * bubble;
}

- (void)dealloc
{
    [bubble removeFromSuperview];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawSubviews];
    }
    
    return self;
}

- (void)drawSubviews
{
    [self.headImage setHidden:NO];
    [self.headImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.background).offset(10);
        make.size.mas_equalTo(16);
    }];
    
    headLabel = [JHUIFactory createLabelWithTitle:@"回血直播间：" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(12) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).offset(5);
        make.top.equalTo(self.background).offset(9);
        make.height.mas_equalTo(17);
    }];
    
    statusLabel = [JHUIFactory createLabelWithTitle:@"已上架" titleColor:HEXCOLOR(0x333333) font:JHFont(10) textAlignment:NSTextAlignmentLeft];
    [self.background addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-11);
        make.top.equalTo(self.background).offset(8);
    }];
    
    enterBtn = [JHUIFactory createThemeBtnWithTitle:@"进入直播间" cornerRadius:30/2.0 target:self action:@selector(pressEnter)];
    enterBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-10);
        make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(86, 30));
    }];
    
    fixPriceBtn = [JHUIFactory createThemeBtnWithTitle:@"修改价格" cornerRadius:30/2.0 target:self action:@selector(pressFixPrice)];
    fixPriceBtn.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
    fixPriceBtn.layer.borderWidth = 2;
    fixPriceBtn.backgroundColor = HEXCOLOR(0xFFFFFF);
    fixPriceBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:fixPriceBtn];
    [fixPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(enterBtn.mas_left).offset(-10);
        make.bottom.equalTo(enterBtn);
        make.size.mas_equalTo(CGSizeMake(78, 30));
    }];
    
    UIButton* moreBtn = [JHUIFactory createThemeBtnWithTitle:@"" cornerRadius:30/2.0 target:self action:@selector(pressMore)];
    moreBtn.backgroundColor = [UIColor clearColor];
    [self.background addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fixPriceBtn.mas_top);
        make.right.mas_equalTo(fixPriceBtn.mas_left).offset(-15);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    JHCustomLine* pointLine = [[JHCustomLine alloc] initWithFrame:CGRectZero andColor:HEXCOLOR(0xCCCCCC) isSolid:NO];
    pointLine.userInteractionEnabled = NO;
    pointLine.dashWidth = 7;
    pointLine.solidWidth = 2;
    [moreBtn addSubview:pointLine];
    [pointLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(moreBtn.mas_top).offset(12);
        make.right.mas_equalTo(moreBtn.mas_right);
        make.height.mas_equalTo(6);
        make.width.mas_equalTo(32);
    }];
}

- (void)showBubble:(BOOL)isShow
{
    if(!bubble)
    {
        bubble = [[JHBubbleWindow alloc]init];
        [self.window addSubview:bubble];
        JH_WEAK(self)
        [bubble setText:@"取消寄售" click:^(id sender) {
            JH_STRONG(self)
            [self pressCancel];
            [self->bubble setHidden:YES];
        }];
    }

    [bubble setHidden:!isShow];
    if(isShow)
    {
        [bubble.bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(fixPriceBtn.mas_left).offset(-3);
                make.top.mas_equalTo(fixPriceBtn.mas_bottom);
            }];
    }
}

- (void)updateCell:(JHUCOnSaleListModel*)model
{
    if(!model)
   {
       DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
       return;
   }
    self.cellModel = model;

    [self.headImage jhSetImageWithURL:[NSURL URLWithString:model.anchorIcon ? : @""] placeholder:kDefaultAvatarImage];//网络图片
    
    headLabel.text = model.channelTitle;
    statusLabel.text = [JHUCOnSaleListModel convertFronSaleState:model.saleState];//@"已上架";
    //set other subviews
    [self setCellDataModel:model];
}

#pragma mark - event
- (void)pressEnter
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:RequestTypeEnterLive dataModel:self.cellModel indexPath:self.indexPath];
    }
}

- (void)pressFixPrice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:RequestTypeEdit dataModel:self.cellModel indexPath:self.indexPath];
    }
}

- (void)pressMore
{
    [self showBubble:YES];
}

- (void)pressCancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:RequestTypeCellCancelResale dataModel:self.cellModel indexPath:self.indexPath];
    }
}

@end
