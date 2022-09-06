//
//  JHC2CGoodsCollectionViewCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CGoodsCollectionViewCell.h"
#import "UILabel+edgeInsets.h"
#import "JHStoreHelp.h"

@interface JHC2CGoodsCollectionViewCell ()

///已售出标签
@property (nonatomic, strong) UILabel *soldOutLabel;
///鉴定标签
@property (nonatomic, strong) UIImageView *identifyTagImgView;
///视频标签
@property (nonatomic, strong) UIImageView *videoImgView;
///商品标题
@property (nonatomic, strong) UILabel *goodsTitleLabel;
///拍卖中标签
@property (nonatomic, strong) UILabel *auctionLabel;
///商品标签
@property (nonatomic, strong) UIView *goodsTagView;
///价格
@property (nonatomic, strong) UILabel *redPriceLabel;
///出价人数
@property (nonatomic, strong) UILabel *bidNumLabel;
///用户头像
@property (nonatomic, strong) UIImageView *userImgView;
///用户名称
@property (nonatomic, strong) UILabel *userNameLabel;
///想要人数
@property (nonatomic, strong) UILabel *wantNumLable;

@property (nonatomic, strong) NSMutableArray *tagsArray;
@end

@implementation JHC2CGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI{
    //商品图片
    [self.contentView addSubview:self.goodsImgView];
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_offset(100);
    }];
    //已售出
    [self.goodsImgView addSubview:self.soldOutLabel];
    [self.soldOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.goodsImgView);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];
    //鉴定标签
    [self.contentView addSubview:self.identifyTagImgView];
    [self.identifyTagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView);
        make.left.equalTo(self.goodsImgView).offset(5);
        make.width.mas_offset(22);
    }];
    //视频标签
    [self.contentView addSubview:self.videoImgView];
    [self.videoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView).offset(10);
        make.right.equalTo(self.goodsImgView).offset(-10);
        make.size.mas_offset(CGSizeMake(25, 25));
    }];
    //拍卖中标签
    [self.contentView addSubview:self.auctionLabel];
    [self.auctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(8);
        make.size.mas_offset(CGSizeMake(41, 16));
    }];
    //商品标题
    [self.contentView addSubview:self.goodsTitleLabel];
    [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    //商品标签
    [self.contentView addSubview:self.goodsTagView];
    [self.goodsTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(0);
    }];
    
    //价格
    [self.contentView addSubview:self.redPriceLabel];
    [self.redPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(8);
    }];
    //出价次数
    [self.contentView addSubview:self.bidNumLabel];
    [self.bidNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.redPriceLabel);
        make.left.equalTo(self.redPriceLabel.mas_right).offset(4);
    }];

    
    //用户头像
    [self.contentView addSubview:self.userImgView];
    [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redPriceLabel.mas_bottom).offset(11);
        make.left.equalTo(self.contentView).offset(8);
        make.size.mas_offset(CGSizeMake(12, 12));
    }];
    //用户名称等
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userImgView);
        make.left.equalTo(self.userImgView.mas_right).offset(3);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    //想要人数
    [self.contentView addSubview:self.wantNumLable];
    [self.wantNumLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userImgView);
        make.right.equalTo(self.contentView).offset(-8);
    }];


}

#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel params:(NSDictionary* _Nullable )parmas{
    JHC2CProductBeanListModel *goodsListModel = dataModel;
    self.goodsListModel = goodsListModel;
    //商品图
    [self.goodsImgView jh_setImageWithUrl:goodsListModel.images.medium placeHolder:@"newStore_hoder_image"];
    [self.goodsImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(goodsListModel.images.goodsImgHeight);
    }];
    
    //商品售卖状态
    if (goodsListModel.productSellStatus > 0) {
        self.soldOutLabel.hidden = NO;
        self.soldOutLabel.text = goodsListModel.productSellStatus == 1 ? @"已下架" : @"已售出";
    }else{
        self.soldOutLabel.hidden = YES;
    }
    
    //鉴定标签
    if (goodsListModel.appraisalReportResult.length > 0) {
        self.identifyTagImgView.hidden = NO;
        NSString *identifyTagImg = @"";
        if ([goodsListModel.appraisalReportResult integerValue] == 0) {
            identifyTagImg = @"c2c_goods_zhen_icon";
        }else if ([goodsListModel.appraisalReportResult integerValue] == 1){
            identifyTagImg = @"c2c_goods_fang_icon";
        }else if ([goodsListModel.appraisalReportResult integerValue] == 2){
            identifyTagImg = @"c2c_goods_yi_icon";
        }else{
            identifyTagImg = @"c2c_goods_gongyipin_icon";
        }
        self.identifyTagImgView.image = JHImageNamed(identifyTagImg);
    } else {
        self.identifyTagImgView.hidden = YES;
    }
    
    //视频标识
    self.videoImgView.hidden = isEmpty(goodsListModel.videoUrl);
    
    //拍卖标识
    self.auctionLabel.hidden = goodsListModel.auctionStatus == 1 ? NO : YES;
    
    //商品名称
    NSString *nullStr = @"          ";//拍卖中占位空格
    if (self.auctionLabel.hidden) {
        nullStr = @"";
    }
    if (goodsListModel.productDesc.length > 0) {
        self.goodsTitleLabel.text = [NSString stringWithFormat:@"%@%@", nullStr, goodsListModel.productDesc];
    }else{
        self.goodsTitleLabel.text = @"";
    }
   
    
    //包邮 即将结拍
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray arrayWithCapacity:0];
    }
    [_tagsArray removeAllObjects];
    if (goodsListModel.needFreight == 0) {
        [_tagsArray addObject:@"包邮"];
    }
    if (goodsListModel.auctionEndStatus == 1) {
        [_tagsArray addObject:@"即将截拍"];
    }
    [self.goodsTagView removeAllSubviews];
    UILabel *firstLabel;
    for (int i = 0; i < _tagsArray.count; i++) {
        UILabel *goodsTagLabel = [[UILabel alloc] init];
        goodsTagLabel.font = JHFont(10);
        goodsTagLabel.textColor = HEXCOLOR(0xF23730);
        goodsTagLabel.text = _tagsArray[i];
        [goodsTagLabel jh_cornerRadius:1.0 borderColor:HEXCOLOR(0xF23730) borderWidth:0.5];
        goodsTagLabel.edgeInsets = UIEdgeInsetsMake(1, 4, 1, 4);
        [self.goodsTagView addSubview:goodsTagLabel];
        [goodsTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsTagView);
            if (i == 0) {
                make.left.equalTo(self.goodsTagView).offset(8);
            }else {
                make.left.equalTo(firstLabel.mas_right).offset(6);
            }
        }];
        firstLabel = goodsTagLabel;
    }
    
    //价格
    self.redPriceLabel.text = goodsListModel.price;
    [JHStoreHelp setPrice:isEmpty(self.redPriceLabel.text)?@"--":self.redPriceLabel.text prefixFont:JHFont(11) prefixColor:HEXCOLOR(0xF23730) forLabel:self.redPriceLabel];
    
   
    //价格处是否一行显示
    if (!goodsListModel.isOnelineOfMoney) {
        [self.redPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
            make.left.equalTo(self.contentView).offset(8);
            make.right.equalTo(self.contentView).offset(-8);

        }];
        self.bidNumLabel.text = @"";
    } else {
        [self.redPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
            make.left.equalTo(self.contentView).offset(8);
        }];
        //出价次数
        if ([goodsListModel.num floatValue] > 0) {
            if ([goodsListModel.num floatValue] > 9999) {
                self.bidNumLabel.text = [NSString stringWithFormat:@"已出价%.1fw次",[goodsListModel.num floatValue]/10000];
            }else{
                self.bidNumLabel.text = [NSString stringWithFormat:@"已出价%@次",goodsListModel.num];
            }
        }else{
            self.bidNumLabel.text = @"";
        }
    }
    //一口价不显示出价次数
    if (goodsListModel.productType.length > 0) {
        self.bidNumLabel.hidden = [goodsListModel.productType integerValue] == 0 ? YES : NO;
    }
    if (_tagsArray.count > 0) {
        if (goodsListModel.productDesc.length > 0) {
            //标签
            [self.goodsTagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
                make.height.mas_offset(16);
            }];
            //价格
            [self.redPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6+9+16);
            }];
        }else{
            //标签
            [self.goodsTagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsImgView.mas_bottom).offset(6);
                make.height.mas_offset(16);
            }];
            //价格
            [self.redPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsImgView.mas_bottom).offset(6+9+16);
            }];
        }
    }else{
        [self.goodsTagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        if (goodsListModel.productDesc.length > 0) {
            //价格
            [self.redPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
            }];
        }else{
            //价格
            [self.redPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodsImgView.mas_bottom).offset(6);
            }];
        }
    }
    

    //用户信息
    [self.userImgView jhSetImageWithURL:[NSURL URLWithString:goodsListModel.img] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
    self.userNameLabel.text = goodsListModel.name.length > 5 ? [NSString stringWithFormat:@"%@…",[goodsListModel.name substringToIndex:5]] : goodsListModel.name;
    if ([goodsListModel.wantCount floatValue] > 9999) {
        self.wantNumLable.text = [NSString stringWithFormat:@"%.1fw人想要",[goodsListModel.wantCount floatValue]/10000];
    }else{
        self.wantNumLable.text = [NSString stringWithFormat:@"%@人想要",goodsListModel.wantCount];
    }
    
    //用户信息处是否一行显示
    if (!goodsListModel.isOnelineOfUserInfo) {
        //想要人数
        self.wantNumLable.hidden = YES;
    } else {
        self.wantNumLable.hidden = NO;
    }
    
}


#pragma mark - Action

#pragma mark - Delegate

#pragma mark - Lazy
- (UIImageView *)goodsImgView{
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImgView.clipsToBounds = YES;
    }
    return _goodsImgView;
}

- (UIImageView *)identifyTagImgView{
    if (!_identifyTagImgView) {
        _identifyTagImgView = [[UIImageView alloc] init];
    }
    return _identifyTagImgView;
}
- (UIImageView *)videoImgView{
    if (!_videoImgView) {
        _videoImgView = [[UIImageView alloc] init];
        _videoImgView.image = JHImageNamed(@"jh_newStore_hasVideo");
        _videoImgView.hidden = YES;
    }
    return _videoImgView;
}
- (UILabel *)soldOutLabel{
    if (!_soldOutLabel) {
        _soldOutLabel = [[UILabel alloc] init];
        _soldOutLabel.font = JHFont(14);
        _soldOutLabel.textColor = HEXCOLOR(0xFFFFFF);
        _soldOutLabel.backgroundColor = HEXCOLORA(0x000000, 0.5);
        _soldOutLabel.textAlignment = NSTextAlignmentCenter;
        [_soldOutLabel jh_cornerRadius:30];
        _soldOutLabel.hidden = YES;
    }
    return _soldOutLabel;
}
- (UILabel *)auctionLabel{
    if (!_auctionLabel) {
        _auctionLabel = [[UILabel alloc] init];
        _auctionLabel.font = JHFont(11);
        _auctionLabel.textColor = HEXCOLOR(0x222222);
        _auctionLabel.text = @"拍卖中";
        _auctionLabel.backgroundColor = HEXCOLOR(0xFFD70F);
        _auctionLabel.textAlignment = NSTextAlignmentCenter;
        [_auctionLabel jh_cornerRadius:2];
        _auctionLabel.hidden = YES;
    }
    return _auctionLabel;
}
- (UILabel *)goodsTitleLabel{
    if (!_goodsTitleLabel) {
        _goodsTitleLabel = [[UILabel alloc] init];
        _goodsTitleLabel.font = JHFont(14);
        _goodsTitleLabel.textColor = HEXCOLOR(0x333333);
        _goodsTitleLabel.numberOfLines = 2;
    }
    return _goodsTitleLabel;
}
- (UIView *)goodsTagView{
    if (!_goodsTagView) {
        _goodsTagView = [[UIView alloc] init];
    }
    return _goodsTagView;
}
- (UILabel *)redPriceLabel{
    if (!_redPriceLabel) {
        _redPriceLabel = [[UILabel alloc] init];
        _redPriceLabel.font = JHDINBoldFont(18);
        _redPriceLabel.textColor = HEXCOLOR(0xF23730);
    }
    return _redPriceLabel;
}

- (UILabel *)bidNumLabel{
    if (!_bidNumLabel) {
        _bidNumLabel = [[UILabel alloc] init];
        _bidNumLabel.font = JHFont(10);
        _bidNumLabel.textColor = HEXCOLOR(0x999999);
    }
    return _bidNumLabel;
}
- (UIImageView *)userImgView{
    if (!_userImgView) {
        _userImgView = [[UIImageView alloc] init];
        _userImgView.image = JHImageNamed(@"newStore_default_avatar_placehold");
        [_userImgView jh_cornerRadius:6];
    }
    return _userImgView;
}
- (UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = JHFont(10);
        _userNameLabel.textColor = HEXCOLOR(0x999999);
    }
    return _userNameLabel;
}

- (UILabel *)wantNumLable{
    if (!_wantNumLable) {
        _wantNumLable = [[UILabel alloc] init];
        _wantNumLable.font = JHFont(10);
        _wantNumLable.textColor = HEXCOLOR(0x999999);
        _wantNumLable.textAlignment = NSTextAlignmentRight;
    }
    return _wantNumLable;
}

@end
