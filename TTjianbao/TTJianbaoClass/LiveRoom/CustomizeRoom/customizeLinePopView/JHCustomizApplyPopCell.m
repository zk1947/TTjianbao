//
//  JHCustomizApplyPopCell.m
//  TTjianbao
//
//  Created by apple on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizApplyPopCell.h"
#import "JHUIFactory.h"
#import "UIView+JHGradient.h"
#import "UIImageView+WebCache.h"
#import "JHCustomizePopModel.h"
#import "JHGrowingIO.h"

@interface JHCustomizApplyPopCell ()
@property (nonatomic,strong) UIImageView * goodsPicImageV;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * catLabel;
@property (nonatomic,strong) UILabel * statusLabel;
@property (nonatomic,strong) UIButton * customizeBtn;
@property (nonatomic,copy) NSString * growingtype;//数据上报用
@property (nonatomic,strong) JHCustomizePopModel *popmodel;
@end

@implementation JHCustomizApplyPopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
        if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [self creatCellSubView];
        }
    return self;
}

- (void)creatCellSubView{
    self.goodsPicImageV = [JHUIFactory createCircleImageViewWithRadius:8];
    
    [self.contentView addSubview:self.goodsPicImageV];
    [self.goodsPicImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.size.mas_equalTo(65);
    }];
    
    self.titleLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsPicImageV.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-88);
        make.top.equalTo(self).offset(25);
        make.height.mas_equalTo(21);
    }];
    
    self.customizeBtn = [JHUIFactory createThemeBtnWithTitle:@"申请连麦" cornerRadius:15 target:self action:@selector(applyLink:)];
    self.customizeBtn.titleLabel.font = JHFont(12);
    [self.contentView addSubview:self.customizeBtn];
    [self.customizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-33);
        make.size.mas_equalTo(CGSizeMake(68, 30));
    }];
    [self.customizeBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    self.catLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.catLabel];
    [self.catLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsPicImageV.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-88);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(17);
    }];
    
    //连麦次数
    self.statusLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0xFFFFFF) font:JHFont(10) textAlignment:NSTextAlignmentCenter];
    self.statusLabel.backgroundColor = HEXCOLORA(0x000000,.4);
    [self.goodsPicImageV addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    JHCustomLine *bottomLine = [[JHCustomLine alloc] init];
    bottomLine.color = HEXCOLOR(0xF5F6FA);
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
}
- (void)setCellDataModel:(JHCustomizePopModel *)goodsModel andIndexPath:(NSIndexPath *)indexPath{
    self.popmodel = goodsModel;
    [self.goodsPicImageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsUrl] placeholderImage:kDefaultCoverImage];
    self.titleLabel.text = [NSString stringWithFormat:@"【%@】 %@",goodsModel.orderType,goodsModel.goodsTitle];
    if ([goodsModel.orderType isEqualToString:@"定制订单"]) {
        self.catLabel.textColor = HEXCOLOR(0x999999);
        self.growingtype = @"3";
    }else if([goodsModel.orderType isEqualToString:@"历史订单"]){
        self.catLabel.textColor = HEXCOLOR(0xFF4200);
        self.growingtype = @"2";
    }else{
        self.catLabel.textColor = HEXCOLOR(0x333333);
        self.growingtype = @"1";
    }
    self.catLabel.text = goodsModel.orderDesc;
    self.statusLabel.text = [NSString stringWithFormat:@"连麦%@次",goodsModel.connectCount];
    if (goodsModel.connectFlag) {
        [self.customizeBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }else{
        [self.customizeBtn jh_setGradientBackgroundWithColors:@[kColorEEE, kColorEEE] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }
    
}
- (void)applyLink:(UIButton *)sender{
    if (!self.popmodel.connectFlag) {
        [self makeToast:@"本直播间不支持此材质/类别" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"type":self.growingtype}];
    [dic addEntriesFromDictionary:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_tc_sqlm_click variables:dic];
    if (self.completeBlock) {
        self.completeBlock();
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
