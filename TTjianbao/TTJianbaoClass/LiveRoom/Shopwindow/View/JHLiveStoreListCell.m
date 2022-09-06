//
//  JHLiveStoreListCell.m
//  TTjianbao
//
//  Created by YJ on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHShopwindowRequest.h"
#import "JHSaleGoodsAddView.h"
#import "JHOrderConfirmViewController.h"
#import "JHLiveStoreListCell.h"
#import "JHUIFactory.h"
#import "UIView+JHGradient.h"
#import "JHShopwindowGoodsListModel.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>

@interface JHLiveStoreListCell ()
@property (nonatomic,assign) JHLiveStoreListCellType cellType;
@property (nonatomic,strong) UIImageView * goodsPicImageV;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * priceLabel;
@property (nonatomic,strong) UILabel * numCornerLabel;

//用户button
@property (nonatomic,strong) UIButton * consultAnchorBtn;   //咨询主播
@property (nonatomic,strong) UIButton * buyBtn;             //购买
@property (nonatomic,strong) UIButton * goPayBtn;           //去支付

//主播上架button
@property (nonatomic,strong) UIButton * downBtn;           //下架
@property (nonatomic,strong) UIButton * saleDelBtn;           //上架商品删除

//主播历史button
@property (nonatomic,strong) UIButton * deleteBtn;         //删除
@property (nonatomic,strong) UIButton * upBtn;             //上架

//通用
@property (nonatomic,strong) UIButton * waitPayBtn;         //待支付
@property (nonatomic,strong) UIButton * soldBtn;            //已售
@property (nonatomic,strong) UIButton * editBtn;            //编辑

@property (nonatomic, strong) JHShopwindowGoodsListModel *model;

@end

@implementation JHLiveStoreListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellType:(JHLiveStoreListCellType)type{
        if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
            self.cellType = type;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [self creatCellSubView];
        }
    return self;
}

- (void)creatCellSubView{
    self.goodsPicImageV = [JHUIFactory createCircleImageViewWithRadius:8];
    
    [self.contentView addSubview:self.goodsPicImageV];
    [self.goodsPicImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(110);
    }];
    @weakify(self);
    [self.goodsPicImageV jh_addTapGesture:^{
        @strongify(self);
        [self previewPicture];
    }];
    
    self.numCornerLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0xFFFFFF) font:JHFont(11) textAlignment:NSTextAlignmentCenter];
    self.numCornerLabel.backgroundColor = RGBA(0, 0, 0, 0.7);
    self.numCornerLabel.frame = CGRectMake(0, 0, 23, 16);
    [self.goodsPicImageV addSubview:self.numCornerLabel];
//    [self.numCornerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(23, 16));
//    }];
//    self.numCornerLabel.layer.cornerRadius = 8;
//    self.numCornerLabel.layer.masksToBounds = YES;
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.numCornerLabel.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
    cornerRadiusLayer.frame = self.numCornerLabel.frame;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    self.numCornerLabel.layer.mask = cornerRadiusLayer;
    
    
    self.titleLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0x333333) font:JHFont(14) textAlignment:NSTextAlignmentLeft];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsPicImageV.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(11);
        make.height.mas_equalTo(42);
    }];
    
    self.priceLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0xFC4200) font:JHFont(18) textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsPicImageV.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        make.height.mas_equalTo(24);
    }];
    
    //创建底部按钮
    [self creatUIButton];
    
    JHCustomLine *bottomLine = [[JHCustomLine alloc] init];
    bottomLine.color = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setCellDataModel:(JHShopwindowGoodsListModel *)goodsModel andIndexPath:(NSIndexPath *)indexPath{
    _model = goodsModel;
    [self.goodsPicImageV jhSetImageWithURL:[NSURL URLWithString:goodsModel.listImage ? : @""] placeholder:kDefaultCoverImage];
    self.numCornerLabel.text = [NSString stringWithFormat:@"%@",goodsModel.sort];
    self.titleLabel.text = goodsModel.title;
    self.priceLabel.attributedText = [goodsModel.priceWrapper showPrice];
    
    if (self.cellType == JHLiveStoreListCellTypeUserList) {
        //goodsStatus 1：等待购买；2:待支付；3:已售
        [self.goPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.buyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        [self.consultAnchorBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.buyBtn).offset(-80);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.soldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        if (goodsModel.goodsStatus == 2) {
            [self.goPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(79, 30));
            }];
        }else if(goodsModel.goodsStatus == 1){
            [self.buyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            
            [self.consultAnchorBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.buyBtn).offset(-70);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(79, 30));
            }];
            
        }else if(goodsModel.goodsStatus == 3){
            [self.soldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
        
    }else if(self.cellType == JHLiveStoreListCellTypeSalerList_UP){ //已上架列表按钮状态
        //goodsStatus 商品状态(1：等待购买；2:待支付；3:已售)
        //onlineFlag  在线标志(1:上架；2下架) ,
        [self.soldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.downBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.waitPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];

        [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        if (goodsModel.goodsStatus == 1) {
            [self.downBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-80);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }else if (goodsModel.goodsStatus == 2){
            [self.waitPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(76, 30));
            }];
        }else if (goodsModel.goodsStatus == 3){
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            [self.soldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-80);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
        
        
    }else if(self.cellType == JHLiveStoreListCellTypeSalerList_Histroy){ //历史列表按钮状态
        
        //goodsStatus 商品状态(1：等待购买；2:待支付；3:已售)
        //onlineFlag  在线标志(1:上架；2下架) ,
        
        [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        [self.upBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.waitPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.soldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        if (goodsModel.goodsStatus == 1) {
            
            [self.upBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-80);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-150);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            
        }else if (goodsModel.goodsStatus == 2){
            [self.waitPayBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.size.mas_equalTo(CGSizeMake(70, 30));
            }];
            
        }else if (goodsModel.goodsStatus == 3){
            [self.soldBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
            [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-80);
                make.size.mas_equalTo(CGSizeMake(60, 30));
            }];
        }
    }
}


//咨询主播
- (void)pressConsultAnchorEnter{
    if(_clickButtonTypeBlock)
    {
        _clickButtonTypeBlock(1);
    }
}
//去支付
- (void)pressGoPayEnter{
    if(_clickButtonTypeBlock)
    {
        _clickButtonTypeBlock(2);
    }
}

//购买
- (void)pressBuyEnter{
    if(_clickButtonTypeBlock)
    {
        _clickButtonTypeBlock(3);
    }
}

//待支付
- (void)pressWaitPayEnter{
//    if(_clickButtonTypeBlock)
//    {
//        _clickButtonTypeBlock(3,_model);
//    }
}

//已售
- (void)pressSoldEnter{
    
}

//编辑
- (void)pressEditEnter{
    if(_clickButtonTypeBlock)
    {
        _clickButtonTypeBlock(4);
    }
}

//（删除）下架
- (void)pressDownEnter{
    if(_clickButtonTypeBlock)
    {
        _clickButtonTypeBlock(5);
    }
}
//删除
- (void)pressDeleteEnter{
    if(_clickButtonTypeBlock)
    {
        if (self.cellType == JHLiveStoreListCellTypeSalerList_UP)
            _clickButtonTypeBlock(8);
        else
            _clickButtonTypeBlock(6);
    }
}

//上架
- (void)pressUpEnter{
    if(_clickButtonTypeBlock)
    {
        _clickButtonTypeBlock(7);
    }
}

- (void)creatUIButton{
    self.soldBtn = [JHUIFactory createThemeBtnWithTitle:@"已售" cornerRadius:15 target:self action:@selector(pressSoldEnter)];
    self.soldBtn.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.soldBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    self.soldBtn.titleLabel.font = JHFont(12);
    [self.contentView addSubview:self.soldBtn];
    [self.soldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-11);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    
    if (self.cellType == JHLiveStoreListCellTypeUserList) {
        self.buyBtn = [JHUIFactory createThemeBtnWithTitle:@"购买" cornerRadius:15 target:self action:@selector(pressBuyEnter)];
        self.buyBtn.titleLabel.font = JHFont(12);
        [self.contentView addSubview:self.buyBtn];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        [self.buyBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        
        self.consultAnchorBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"咨询主播" cornerRadius:15 target:self action:@selector(pressConsultAnchorEnter)];
        self.consultAnchorBtn.titleLabel.font = JHFont(12);
        self.consultAnchorBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        [self.contentView addSubview:self.consultAnchorBtn];
        [self.consultAnchorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.buyBtn).offset(-70);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(79, 30));
        }];
        
        self.goPayBtn = [JHUIFactory createThemeBtnWithTitle:@"去支付" cornerRadius:15 target:self action:@selector(pressGoPayEnter)];
        self.goPayBtn.titleLabel.font = JHFont(12);
        [self.contentView addSubview:self.goPayBtn];
        [self.goPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [self.goPayBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }else{
        self.waitPayBtn = [JHUIFactory createThemeBtnWithTitle:@"待支付" cornerRadius:15 target:self action:@selector(pressWaitPayEnter)];
        self.waitPayBtn.backgroundColor = HEXCOLOR(0xEEEEEE);
        [self.waitPayBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        self.waitPayBtn.titleLabel.font = JHFont(12);
        [self.contentView addSubview:self.waitPayBtn];
        [self.waitPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        self.editBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"编辑" cornerRadius:15 target:self action:@selector(pressEditEnter)];
        self.editBtn.titleLabel.font = JHFont(12);
        self.editBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        [self.contentView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        self.deleteBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"删除" cornerRadius:15 target:self action:@selector(pressDeleteEnter)];
        self.deleteBtn.titleLabel.font = JHFont(12);
        self.deleteBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-11);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        if (self.cellType == JHLiveStoreListCellTypeSalerList_UP) {
            //（下架）
            self.downBtn = [JHUIFactory createThemeBtnWithTitle:@"下架" cornerRadius:15 target:self action:@selector(pressDownEnter)];
            self.downBtn.titleLabel.font = JHFont(12);
            [self.contentView addSubview:self.downBtn];
            [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [self.downBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            
        }else if (self.cellType == JHLiveStoreListCellTypeSalerList_Histroy){
            
            
            self.upBtn = [JHUIFactory createThemeBtnWithTitle:@"上架" cornerRadius:15 target:self action:@selector(pressUpEnter)];
            self.upBtn.titleLabel.font = JHFont(12);
            [self.contentView addSubview:self.upBtn];
            [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-11);
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [self.upBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        }
    }
}

- (void)previewPicture{
    
    GKPhoto *photo = [GKPhoto new];
    photo.url = [NSURL URLWithString:self.model.listImage];
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:@[photo] currentIndex:0];
    browser.isStatusBarShow = YES;
    browser.isScreenRotateDisabled = YES;
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:JHRootController.currentViewController];
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
