//
//  JHStoneResaleTableViewCell.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneResaleTableViewCell.h"
#import "JHGoodResaleListModel.h"
#import "JHStoneResaleDetailview.h"

@interface JHStoneResaleTableViewCell () <JHStoneResaleDetailviewDelegate>
{
    UILabel* explainLabel;//讲解中
    UIButton* toSeeBtn;    //求看
    UIButton* bargainBtn;    //砍价
    JHStoneResaleDetailview* detailFst; //第一行
    JHStoneResaleDetailview* detailScd; //第二行
}
@end

@implementation JHStoneResaleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawSubviews];
        //主题变成:JHCellThemeTypeClearColor时,需调整
        [self resetSubview];
        //再重置
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
              make.left.mas_equalTo(self.ctxImage.mas_right).offset(11);
              make.right.mas_equalTo(self.background).offset(-85);
              make.top.mas_equalTo(self.descpLabel.mas_bottom).offset(8);
          }];
    }
    
    return self;
}

- (void)drawSubviews
{
    //从下往上,从右向左,依赖
    bargainBtn = [JHUIFactory createThemeBtnWithTitle:@"出价" cornerRadius:26/2.0 target:self action:nil];
    bargainBtn.userInteractionEnabled = NO;
    bargainBtn.titleLabel.font =JHFont(12);
    [self.background addSubview:bargainBtn];
    [bargainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.background).offset(-10);
        make.top.mas_equalTo(self.background).offset(59);
        make.size.mas_equalTo(CGSizeMake(65, 26));
    }];
    
    toSeeBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"求看" cornerRadius:26/2.0 target:self action:nil];
    toSeeBtn.titleLabel.font =JHFont(12);
    [toSeeBtn setTitleColor:HEXCOLOR(0xFEE100) forState:UIControlStateNormal];
    [toSeeBtn addTarget:self action:@selector(pressToSeeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.background addSubview:toSeeBtn];
    [toSeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bargainBtn.mas_left).offset(-10);
        make.top.mas_equalTo(bargainBtn);
        make.size.mas_equalTo(CGSizeMake(65, 26));
    }];
    
    detailFst = [JHStoneResaleDetailview new];
    [self.background addSubview:detailFst];
    [detailFst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ctxImage.mas_bottom).offset(10);
        make.left.mas_equalTo(self.background).offset(10);
        make.right.mas_equalTo(self.background).offset(-10);
        make.height.mas_equalTo(40);
    }];
    [detailFst setHidden:YES];
    
    detailScd = [JHStoneResaleDetailview new];
    [self.background addSubview:detailScd];
    [detailScd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(detailFst.mas_bottom).offset(5);
        make.left.right.height.mas_equalTo(detailFst);
    }];
    [detailScd setHidden:YES];
    
    [self.bottomLine setHidden:NO];
    
    explainLabel = [JHUIFactory createLabelWithTitle:@"讲解中" titleColor:HEXCOLOR(0xFFFFFF) font:JHFont(11) textAlignment:NSTextAlignmentCenter];
    explainLabel.backgroundColor = HEXCOLORA(0xFC4200, 1);
    explainLabel.layer.masksToBounds =YES;
    [explainLabel jh_cornerRadius:4 rectCorner:UIRectCornerTopLeft | UIRectCornerBottomRight bounds:CGRectMake(0, 0, 43, 18)];
    [self.ctxImage addSubview:explainLabel];
    [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(43);
        make.left.top.mas_equalTo(self.ctxImage);
    }];
}

- (void)updateCell:(JHGoodResaleListModel*)model
{
    if(!model)
    {
        DDLogInfo(@"%@------model is nil!!!", NSStringFromClass([self class]));
        return;
    }
    self.cellModel = model;
     //set super subviews
    [self.ctxImage jhSetImageWithURL:[NSURL URLWithString:model.goodsUrl ? : @""] placeholder:kDefaultCoverImage];////网络图片
    self.sawLabel.text = [NSString stringWithFormat:@"%@热度", model.seekCount ?:@"0"];
    self.idLabel.text = [NSString stringWithFormat:@"%@", model.goodsCode?:@""];
    self.descpLabel.text = model.goodsTitle;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", model.salePrice?:@""];
    //讲解状态
    if(model.explainingFlag)
    {
        [explainLabel setHidden: NO];
        explainLabel.text = @"讲解中";//model.buttonTxt
    }
    else
    {
        [explainLabel setHidden:YES];
    }
    //是否显示砍价按钮
    [bargainBtn setHidden:model.selfOffer==1 ? NO : YES];
    //求看按钮状态
    if(model.selfSeek)
    {
        [toSeeBtn setTitle:@"已求看" forState:UIControlStateNormal];
        toSeeBtn.layer.borderColor = HEXCOLOR(0x999999).CGColor;
        [toSeeBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    }
    else
    {
        [toSeeBtn setTitle:@"求看" forState:UIControlStateNormal];
        toSeeBtn.layer.borderColor = kGlobalThemeColor.CGColor;
        [toSeeBtn setTitleColor:HEXCOLOR(0xFEE100) forState:UIControlStateNormal];
    }
    
    if(model.isSimpleShow)
        [self.bottomLine setHidden:YES];//简化显示,不需显示下划线
    else
        [self.bottomLine setHidden:NO];
    
    NSUInteger count = [model.offerRecordList count];
    //根据data中数据条数显示subview个数
    if(count > 0)
    {
        JHGoodResaleOfferRecordModel* record = model.offerRecordList[0];
        JHStoneResaleDetailSubModel* subModel = [record convertDetailModel];
        [detailFst updateCell:subModel];
        [detailFst setHidden:NO];
        if(count > 1)
        {
            JHGoodResaleOfferRecordModel* record1 = model.offerRecordList[1];
            JHStoneResaleDetailSubModel* subModel1 = [record1 convertDetailModel];
            [detailScd updateCell:subModel1];
            [detailScd setHidden:NO];
        }
        else
        {
            [detailScd setHidden:YES];
        }
    }
    else
    {
        [detailFst setHidden:YES];
        [detailScd setHidden:YES];
    }
}

- (void)pressToSeeButton
{
    JHGoodResaleListModel* model = self.cellModel;
    if(model.selfSeek == 1)
        return;//禁止响应

    if (self.delegate && [self.delegate respondsToSelector:@selector(pressButtonType:dataModel:indexPath:)]) {
        [self.delegate pressButtonType:RequestTypeSeeSee dataModel:self.cellModel indexPath:self.indexPath];
    }
}
@end
