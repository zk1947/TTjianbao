//
//  JHNewStoreHomeGoodsCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "TTjianbao.h"
#import "JHStoreHelp.h"
#import "JHNewStoreHomeTagView.h"
#import "UIView+JHGradient.h"
#import "JHNewStoreHomeModel.h"
//#import "UILabel+JHAutoSetLineNumbers.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "UILabel+edgeInsets.h"
#import "JHC2CGoodsListModel.h"
#import "JHMyCompeteCountdownView.h"
#import "JHRushPurChaseViewController.h"


@interface JHNewStoreHomeGoodsCollectionViewCell ()

@property (nonatomic, strong) UILabel               *statusPriceLabel;/// 专场价标签
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) JHNewStoreHomeTagView *tagView;
@property (nonatomic, strong) UILabel               *redPriceLabel;
@property (nonatomic, strong) UILabel               *grayPriceLabel;
@property (nonatomic, strong) UIImageView           *videoIcon;/// 是否有视频标识
@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIImageView           *specialBackImageView; /// 专场背景图
@property (nonatomic, strong) UILabel               *specialLable;
@property (nonatomic, strong) UIImageView           *specialImageView;
@property (nonatomic, strong) UILabel               *noGoodsLabel; /// 已抢光
@property (nonatomic, strong) UILabel               *haveChanceToBuyLabel; /// 还有机会可以抢
@property (nonatomic, strong) UILabel               *auctionCountLabel; /// 拍卖出价次数
@property (nonatomic, strong) JHMyCompeteCountdownView *countdownView; /// 倒计时视图
@end

@implementation JHNewStoreHomeGoodsCollectionViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self makeLayout];
    }
    return self;
}

- (void)configUI {
    
    self.contentView.layer.cornerRadius = 5.f;
    self.contentView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);

    if (!_imgView) {
        _imgView                         = [UIImageView new];
        _imgView.clipsToBounds           = YES;
        _imgView.contentMode             = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
    }
    
    if (!_haveChanceToBuyLabel) {
        _haveChanceToBuyLabel                     = [[UILabel alloc] init];
        _haveChanceToBuyLabel.backgroundColor     = HEXCOLORA(0x000000,0.6f);
        _haveChanceToBuyLabel.textAlignment       = NSTextAlignmentLeft;
        _haveChanceToBuyLabel.textColor           = HEXCOLOR(0xFFFFFF);
        _haveChanceToBuyLabel.numberOfLines       = 2;
        _haveChanceToBuyLabel.font                = [UIFont fontWithName:kFontNormal size:11.f];
        _haveChanceToBuyLabel.edgeInsets          = UIEdgeInsetsMake(0, 8, 0, 8);
        _haveChanceToBuyLabel.hidden              = YES;
        [self.contentView addSubview:_haveChanceToBuyLabel];
    }

    if (!_statusPriceLabel) {
        _statusPriceLabel                     = [[UILabel alloc] init];
        _statusPriceLabel.textColor           = HEXCOLOR(0xFFFFFF);
        _statusPriceLabel.font                = [UIFont fontWithName:kFontNormal size:10.f];
        _statusPriceLabel.textAlignment       = NSTextAlignmentCenter;
        _statusPriceLabel.layer.cornerRadius  = 2.f;
        _statusPriceLabel.layer.masksToBounds = YES;
        [_statusPriceLabel jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFF0400), HEXCOLOR(0xFF6E00)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        _statusPriceLabel.hidden              = YES;
        [self.contentView addSubview:_statusPriceLabel];
    }

    if (!_videoIcon) {
        _videoIcon                       = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStore_hasVideo"]];
        [_imgView addSubview:_videoIcon];
    }

    if (!_titleLabel) {
        _titleLabel                      = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:13] textColor:kColor333];
        _titleLabel.numberOfLines        = 2;
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_tagView) {
        _tagView                         = [[JHNewStoreHomeTagView alloc] init];
        [self.contentView addSubview:_tagView];
    }

    if (!_redPriceLabel) {
        _redPriceLabel                   = [[UILabel alloc] init];
        _redPriceLabel.textColor         = HEXCOLOR(0xF23730);
        _redPriceLabel.font              = [UIFont fontWithName:kFontBoldDIN size:18.f];
        [self.contentView addSubview:_redPriceLabel];
    }

    if (!_grayPriceLabel) {
        _grayPriceLabel                  = [[UILabel alloc] init];
        _grayPriceLabel.textColor        = HEXCOLOR(0x999999);
        _grayPriceLabel.font             = [UIFont fontWithName:kFontNormal size:10.f];
        [self.contentView addSubview:_grayPriceLabel];
    }
    
    /// 出价次数
    if (!_auctionCountLabel) {
        _auctionCountLabel                  = [[UILabel alloc] init];
        _auctionCountLabel.textColor        = HEXCOLOR(0x999999);
        _auctionCountLabel.font             = [UIFont fontWithName:kFontNormal size:10.f];
        [self.contentView addSubview:_auctionCountLabel];
    }

    if (!_lineView) {
        _lineView                        = [[UIView alloc] init];
        _lineView.backgroundColor        = HEXCOLOR(0xE8E8E8);
        [self.contentView addSubview:_lineView];
    }

    if (!_specialBackImageView) {
        _specialBackImageView            = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStore_specBackImg"]];
        [self.contentView addSubview:_specialBackImageView];
    }
    
    if (!_specialLable) {
        _specialLable = [[UILabel alloc] init];
        _specialLable.textColor           = HEXCOLOR(0xB9855D);
        _specialLable.font = [UIFont fontWithName:kFontNormal size:12.f];
        _specialLable.lineBreakMode = NSLineBreakByTruncatingTail;
        _specialLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_specialLable];
    }
    
    if (!_specialImageView) {
        _specialImageView            = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStoreHomeMore"]];
        [self.contentView addSubview:_specialImageView];
    }

    if (!_noGoodsLabel) {
        _noGoodsLabel                     = [[UILabel alloc] init];
        _noGoodsLabel.backgroundColor     = HEXCOLORA(0x000000,0.5f);
        _noGoodsLabel.layer.cornerRadius  = 30.f;
        _noGoodsLabel.layer.masksToBounds = YES;
        _noGoodsLabel.textAlignment       = NSTextAlignmentCenter;
        _noGoodsLabel.textColor           = HEXCOLOR(0xFFFFFF);
        _noGoodsLabel.font                = [UIFont fontWithName:kFontNormal size:14.f];
        _noGoodsLabel.hidden              = YES;
        [self.contentView addSubview:_noGoodsLabel];
    }
    
    if (!_countdownView) {
        _countdownView = [[JHMyCompeteCountdownView alloc]init];
        [self.contentView addSubview:_countdownView];
    }
    
}

- (void)makeLayout {
    //图片 <需要update>
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.width.mas_equalTo((ScreenW - 12.f*2 - 9.f)/2.f);
        make.height.mas_equalTo(1.f);
    }];
    
    /// 还有机会抢
    [_haveChanceToBuyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.imgView);
        make.height.mas_equalTo(50.f);
    }];
    
    /// 专场价
    [_statusPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(6.f);
        make.width.mas_equalTo(36.f);
        make.height.mas_equalTo(14.f);
    }];
    
    /// 视频标识
    [_videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(10.f);
        make.right.equalTo(self.imgView.mas_right).offset(-10.f);
        make.width.height.mas_equalTo(25.f);
    }];
    
    /// 标题
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10.f);
        make.left.equalTo(self.imgView.mas_left).offset(8.f);
        make.right.equalTo(self.imgView.mas_right).offset(-8.f);
        make.height.mas_equalTo(18.f);
    }];
    
    /// 标签
    _tagView.tagViewNeedWidth  = (ScreenW - 12.f*2 - 9.f)/2.f - 8.f*2 - 4.f;
    _tagView.tagViewNeedHeight = 14.f;
    _tagView.tagTextFont = 10.f;
    _tagView.borderColor = HEXCOLORA(0xF23730,0.5f);
    _tagView.textColor = HEXCOLOR(0xF23730);
    _tagView.isGoodsInfo = YES;
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.imgView.mas_left).offset(8.f);
        make.right.equalTo(self.imgView.mas_right).offset(-8.f);
        make.height.mas_equalTo(14.f);
    }];

    /// 价格
    [_redPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.tagView.mas_bottom).offset(6.f);
        make.height.mas_equalTo(21.f);
    }];
    
    /// 横划线价格
    [_grayPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redPriceLabel.mas_right).offset(5.f);
        make.bottom.equalTo(self.redPriceLabel.mas_bottom).offset(-2.f);
        make.height.mas_equalTo(13.f);
    }];
    
    /// 出价次数
    [_auctionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redPriceLabel.mas_right).offset(5.f);
        make.bottom.equalTo(self.redPriceLabel.mas_bottom).offset(-2.f);
        make.height.mas_equalTo(13.f);
    }];
    
    
    UIView *lineGrayView = [[UIView alloc] init];
    lineGrayView.backgroundColor = HEXCOLOR(0x999999);
    [_grayPriceLabel addSubview:lineGrayView];
    [lineGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.grayPriceLabel.mas_centerY);
        make.left.right.equalTo(self.grayPriceLabel);
        make.height.mas_equalTo(1.f);
    }];
    
    /// 分割线
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
        make.top.equalTo(self.redPriceLabel.mas_bottom).offset(8.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    /// 专场背景图
    [_specialBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(6.f);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(31.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    /// 专场按钮
    [_specialLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.lessThanOrEqualTo(self.imgView.mas_right).offset(-16.f);
        make.top.equalTo(self.lineView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    [_specialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.specialLable.mas_right).offset(5.f);
        make.centerY.equalTo(self.specialLable.mas_centerY);
        make.width.mas_equalTo(6.f);
        make.height.mas_equalTo(8.f);
    }];
    
    /// 已抢光
    [_noGoodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgView.mas_centerX);
        make.centerY.equalTo(self.imgView.mas_centerY);
        make.width.height.mas_equalTo(60.f);
    }];
    [self addTap];
    
    [_countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_imgView);
        make.height.mas_offset(26);
    }];
}

- (void)addTap {
    _specialBackImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(specialBtnDidClicked:)];
    [_specialBackImageView addGestureRecognizer:tap1];
    
    _specialLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(specialBtnDidClicked:)];
    [_specialLable addGestureRecognizer:tap2];

    _specialImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(specialBtnDidClicked:)];
    [_specialImageView addGestureRecognizer:tap3];
}

- (void)specialBtnDidClicked:(UITapGestureRecognizer *)tap {
    if (self.curData) {
        if (self.curData.showType == 0) { /// 新人 - 跳转h5
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(YES, [NSString stringWithFormat:@"%ld",self.curData.showId], self.curData.showName);
            }
            [JHRouterManager pushWebViewWithUrl:self.curData.showUrl title:@"" controller:JHRootController];
        } else if (self.curData.showType == 1) {
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(NO, [NSString stringWithFormat:@"%ld",self.curData.showId], self.curData.showName);
            }
        } else if (self.curData.showType == 3) { /// 秒杀
            JHRushPurChaseViewController *vc = [[JHRushPurChaseViewController alloc] init];
            vc.from = @"商品列表";
            [JHRootController.navigationController pushViewController:vc animated:YES];
        } else {
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(NO, [NSString stringWithFormat:@"%ld",self.curData.showId], self.curData.showName);
            }
        }
    } else if (self.goodsListModel) {
        if (self.goodsListModel.showType == 0) { /// 新人 - 跳转h5
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(YES, self.goodsListModel.showId, self.goodsListModel.showName);
            }
            [JHRouterManager pushWebViewWithUrl:self.goodsListModel.showUrl title:@"" controller:JHRootController];
        } else if (self.goodsListModel.showType == 1) {
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(NO, self.goodsListModel.showId, self.goodsListModel.showName);
            }
        } else if (self.goodsListModel.showType == 3) { /// 秒杀
            JHRushPurChaseViewController *vc = [[JHRushPurChaseViewController alloc] init];
            vc.from = @"商品列表";
            [JHRootController.navigationController pushViewController:vc animated:YES];
        } else {
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(NO, self.goodsListModel.showId, self.goodsListModel.showName);
            }
        }
    }
}

- (void)setCurData:(JHNewStoreHomeGoodsProductListModel *)curData {
    if (!curData) {
        return;
    }
    _curData = curData;
    /// 图片
    [_imgView jhSetImageWithURL:[NSURL URLWithString:_curData.coverImage.url]
                              placeholder:kDefaultNewStoreCoverImage];
    
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_curData.coverImage.aNewHeight);
    }];
    /// 视频图标
    _videoIcon.hidden = isEmpty(curData.videoUrl);
    /// 商品售卖状态描述 还有机会，有宝友拍下还未付款，10分钟内将解除订单
    if (!isEmpty(curData.productSellStatusDesc)) {
        _haveChanceToBuyLabel.text = NONNULL_STR(curData.productSellStatusDesc);
        _haveChanceToBuyLabel.hidden = NO;
        _noGoodsLabel.text = nil;
        _noGoodsLabel.hidden = YES;
    } else {
        _haveChanceToBuyLabel.text = nil;
        _haveChanceToBuyLabel.hidden = YES;
        // 0-在售 1-下架 2-已抢光 13可预约  14已成交  15已结束
        if (curData.productSellStatus == 1) { /// 已下架
            _noGoodsLabel.text = @"已下架";
            _noGoodsLabel.hidden = NO;
        } else if (curData.productSellStatus == 2) { /// 已抢光
            _noGoodsLabel.text = @"已抢光";
            _noGoodsLabel.hidden = NO;
        } else if (curData.productSellStatus == 14) { /// 已成交
            _noGoodsLabel.text = @"已成交";
            _noGoodsLabel.hidden = NO;
        } else if (curData.productSellStatus == 15) { /// 已结束
            _noGoodsLabel.text = @"已结束";
            _noGoodsLabel.hidden = NO;
        } else {
            _noGoodsLabel.text = nil;
            _noGoodsLabel.hidden = YES;
        }
    }
    
    if (!isEmpty(curData.productName)) {
        /// 名称
        _titleLabel.hidden = NO;
        CGSize size = [self calculationTextWidthWithWidth:((ScreenW - 12.f*2 - 9.f)/2.f - 16.f) string:curData.productName font:[UIFont fontWithName:kFontBoldDIN size:14.f]];
        if (size.height > 18.f) {
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imgView.mas_bottom).offset(10.f);
                make.height.mas_equalTo(40.f);
            }];
        } else {
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imgView.mas_bottom).offset(10.f);
                make.height.mas_equalTo(20.f);
            }];
        }
        _titleLabel.text  = curData.productName;
    } else {
        _titleLabel.text = nil;
        _titleLabel.hidden = YES;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(20.f);
        }];
    }
    
    /// 标签
    if (curData.productTagList.count >0) {
        [_tagView setViewModel:curData.productTagList];
        [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
            make.height.mas_equalTo(14.f);
        }];
    } else {
        [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    }
    
    if (curData.existShow) { /// 存在专场
        /// 是否存在专场
        _statusPriceLabel.hidden = NO;
        if (curData.showType == 0) { /// 新人
            _statusPriceLabel.text   = @"新人价";
            _statusPriceLabel.hidden = NO;
        } else if (curData.showType == 1) { /// 普通
            _statusPriceLabel.text   = @"专场价";
            _statusPriceLabel.hidden = NO;
        } else if (curData.showType == 2) { /// 拍卖
            _statusPriceLabel.text   = @"";
            _statusPriceLabel.hidden = YES;
        } else if (curData.showType == 3 || curData.showType == 4) { /// 3-普通秒杀，4-大促秒杀
            _statusPriceLabel.text   = @"秒杀价";
            _statusPriceLabel.hidden = NO;
        } else {
            _statusPriceLabel.text   = @"";
            _statusPriceLabel.hidden = YES;
        }
        
        /// 出价次数
        if (curData.productType == 1) { /// 拍卖
            if ([curData.num integerValue] >0) {
                NSString *showStatusPriceStr = @"";
                if (curData.num.length >3) {
                    showStatusPriceStr = [NSString stringWithFormat:@"已出价%@...次",[curData.num substringWithRange:NSMakeRange(0, 3)]];
                } else {
                    showStatusPriceStr = [NSString stringWithFormat:@"已出价%@次",curData.num];
                }
                _auctionCountLabel.text = showStatusPriceStr;
                _auctionCountLabel.hidden = NO;
                /// 红色价格
                _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(curData.jhShowPrice)?@"--":curData.jhShowPrice needEnd:NO];
            } else {
                _auctionCountLabel.text = @"";
                _auctionCountLabel.hidden = YES;
                /// 红色价格
                _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(curData.jhShowPrice)?@"--":curData.jhShowPrice needEnd:YES];
            }
            _grayPriceLabel.hidden = YES;
        } else {
            _auctionCountLabel.hidden = YES;
            /// 红色价格
            _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(curData.jhShowPrice)?@"--":curData.jhShowPrice needEnd:NO];
            /// 灰色价格
            NSString *newPriceStrRed  = [NSString stringWithFormat:@"￥%@",curData.jhShowPrice];
            NSString *newPriceStrGray = [NSString stringWithFormat:@"￥%@",curData.jhPrice];
            CGSize size1 = [self calculationTextWidthWith:newPriceStrRed font:[UIFont fontWithName:kFontBoldDIN size:18.f]];
            CGSize size2 = [self calculationTextWidthWith:newPriceStrGray font:[UIFont fontWithName:kFontNormal size:9.f]];
            if (size1.width+size2.width > ((ScreenW - 12.f*2 - 9.f)/2.f)) {
                _grayPriceLabel.hidden = YES;
            } else {
                _grayPriceLabel.hidden = NO;
            }
            _grayPriceLabel.text = [NSString stringWithFormat:@"￥%@",isEmpty(curData.jhPrice)?@"--":curData.jhPrice];
        }
    } else {
        _statusPriceLabel.hidden = YES;
        /// 出价次数
        if (curData.productType == 1) {
            if ([curData.num integerValue] >0) {
                NSString *showStatusPriceStr = @"";
                if (curData.num.length >3) {
                    showStatusPriceStr = [NSString stringWithFormat:@"已出价%@...次",[curData.num substringWithRange:NSMakeRange(0, 3)]];
                } else {
                    showStatusPriceStr = [NSString stringWithFormat:@"已出价%@次",curData.num];
                }
                _auctionCountLabel.text = showStatusPriceStr;
                _auctionCountLabel.hidden = NO;
                /// 红色价格
                _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(curData.jhPrice)?@"--":curData.jhPrice needEnd:NO];
            } else {
                _auctionCountLabel.text = @"";
                _auctionCountLabel.hidden = YES;
                /// 红色价格
                _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(curData.jhPrice)?@"--":curData.jhPrice needEnd:YES];
            }
        } else {
            _auctionCountLabel.hidden = YES;
            _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(curData.jhPrice)?@"--":curData.jhPrice needEnd:NO];
        }
        _grayPriceLabel.hidden = YES;
    }
    
    
    /// 专场名称
    if (!isEmpty(curData.showName)) {
        _specialLable.text = curData.showName;
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.redPriceLabel.mas_bottom).offset(8.f);
            make.height.mas_equalTo(0.5f);
        }];
        
        [_specialBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(5.f);
            make.height.mas_equalTo(31.f);
        }];
        [_specialLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(9.f);
            make.height.mas_equalTo(17.f);
        }];
        [_specialImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(8.f);
        }];
        _specialBackImageView.hidden = NO;
        _specialLable.hidden = NO;
        _specialImageView.hidden = NO;
    } else {
        _specialLable.text = @"";
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.redPriceLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8.f);
        }];
        _specialBackImageView.hidden = YES;
        _specialLable.hidden = YES;
        _specialImageView.hidden = YES;

        
        [_specialBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
        [_specialLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
        [_specialImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    }
    
    //拍卖倒计时
    if (_curData.auctionDeadTime > 0) {
        self.countdownView.hidden = NO;
        @weakify(self);
        //auctionStatus 0 待拍 1 竞拍中
        NSString *timeExpStr;
        if (_curData.auctionStatus == 0) {
            timeExpStr = @"距拍卖开始:";
            self.countdownView.backgroundColor = HEXCOLORA(0x000000, 0.5);
        }else{
            timeExpStr = @"距拍卖结束:";
            self.countdownView.backgroundColor = HEXCOLORA(0xFF6A00, 0.8);
        }
        [self.countdownView setSecandData:_curData.auctionDeadTime/1000 expString:timeExpStr completion:^(BOOL finished) {
            @strongify(self);
            //倒计时结束刷新数据
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(NO, @"-1", @"");
            }
        }];
    }else{
        self.countdownView.hidden = YES;
    }
    
}

//时间戳变为格式时间
//- (NSString *)convertStrToTime:(NSInteger)time{
////    long long time=[timeNum lon];
//    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
////    time= time / 1000;
//    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString*timeString=[formatter stringFromDate:date];
//    return timeString;
//}


- (NSMutableAttributedString *)redPriceLabelStr:(NSString *)str needEnd:(BOOL)needEnd {
    NSMutableAttributedString *firstAttStr = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:11.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
    }];

    
    NSMutableAttributedString *moneyAttStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldDIN size:18.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
    }];

    
    NSMutableAttributedString *endAttStr= [[NSMutableAttributedString alloc] initWithString:@" 起" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldPingFang size:11.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
    }];
    
    [endAttStr addAttribute:NSBaselineOffsetAttributeName value:@(0.6f) range:NSMakeRange(0, 2)];
    
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    [commentString appendAttributedString:firstAttStr];
    [commentString appendAttributedString:moneyAttStr];
    if (needEnd) {
        [commentString appendAttributedString:endAttStr];
    }
    return commentString;
}

//这个模型是收藏里面用的
- (void)setGoodsListModel:(JHC2CProductBeanListModel *)goodsListModel {
    if (!goodsListModel) {
        return;
    }
    _goodsListModel = goodsListModel;
    /// 图片
    [_imgView jhSetImageWithURL:[NSURL URLWithString:goodsListModel.images.small]
                              placeholder:kDefaultNewStoreCoverImage];
    
    [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(goodsListModel.images.aNewHeight);
    }];
    /// 视频图标
    _videoIcon.hidden = isEmpty(goodsListModel.videoUrl);
    /// 商品售卖状态描述 还有机会，有宝友拍下还未付款，10分钟内将解除订单
    if (!isEmpty(goodsListModel.productSellStatusDesc)) {
        _haveChanceToBuyLabel.text = NONNULL_STR(goodsListModel.productSellStatusDesc);
        _haveChanceToBuyLabel.hidden = NO;
        _noGoodsLabel.text = nil;
        _noGoodsLabel.hidden = YES;
    } else {
        _haveChanceToBuyLabel.text = nil;
        _haveChanceToBuyLabel.hidden = YES;
        if (goodsListModel.productSellStatus == 1) { /// 已下架
            _noGoodsLabel.text = @"已下架";
            _noGoodsLabel.hidden = NO;
        } else if (goodsListModel.productSellStatus == 2) { /// 已抢光
            _noGoodsLabel.text = @"已抢光";
            _noGoodsLabel.hidden = NO;
        } else if (goodsListModel.productSellStatus == 14) { /// 已成交
            _noGoodsLabel.text = @"已成交";
            _noGoodsLabel.hidden = NO;
        
        } else if (goodsListModel.productSellStatus == 15) { /// 已结束
            _noGoodsLabel.text = @"已结束";
            _noGoodsLabel.hidden = NO;
        } else {
            _noGoodsLabel.text = nil;
            _noGoodsLabel.hidden = YES;
        }
    }
    
    if (!isEmpty(goodsListModel.productName)) {
        /// 名称
        _titleLabel.hidden = NO;
        CGSize size = [self calculationTextWidthWithWidth:((ScreenW - 12.f*2 - 9.f)/2.f - 16.f) string:goodsListModel.productName font:[UIFont fontWithName:kFontBoldDIN size:14.f]];
        if (size.height > 18.f) {
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imgView.mas_bottom).offset(10.f);
                make.height.mas_equalTo(40.f);
            }];
        } else {
            [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imgView.mas_bottom).offset(10.f);
                make.height.mas_equalTo(20.f);
            }];
        }
        _titleLabel.text  = goodsListModel.productName;
    } else {
        _titleLabel.text = nil;
        _titleLabel.hidden = YES;
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(20.f);
        }];
    }
    
    /// 标签
    if (goodsListModel.productTagList.count >0) {
        [_tagView setViewModel:goodsListModel.productTagList];
        [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5.f);
            make.height.mas_equalTo(14.f);
        }];
    } else {
        [_tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    }
    
    if (goodsListModel.existShow) { /// 存在专场
        /// 是否存在专场
        _statusPriceLabel.hidden = NO;
        if (goodsListModel.showType == 0) { /// 新人
            _statusPriceLabel.text   = @"新人价";
            _statusPriceLabel.hidden = NO;
        } else if (goodsListModel.showType == 1) { /// 普通
            _statusPriceLabel.text   = @"专场价";
            _statusPriceLabel.hidden = NO;
        } else if (goodsListModel.showType == 2) { /// 拍卖
            _statusPriceLabel.text   = @"";
            _statusPriceLabel.hidden = YES;
        } else if (goodsListModel.showType == 3 || goodsListModel.showType == 4) { /// 3-普通秒杀，4-大促秒杀
            _statusPriceLabel.text   = @"秒杀价";
            _statusPriceLabel.hidden = NO;
        } else {
            _statusPriceLabel.text   = @"";
            _statusPriceLabel.hidden = YES;
        }
        
        /// 出价次数
        if (goodsListModel.sellerType == 0 && [goodsListModel.productType isEqualToString:@"1"]) { /// 拍卖
            if ([goodsListModel.num integerValue] >0) {
                NSString *showStatusPriceStr = @"";
                if (goodsListModel.num.length >3) {
                    showStatusPriceStr = [NSString stringWithFormat:@"已出价%@...次",[goodsListModel.num substringWithRange:NSMakeRange(0, 3)]];
                } else {
                    showStatusPriceStr = [NSString stringWithFormat:@"已出价%@次",goodsListModel.num];
                }
                _auctionCountLabel.text = showStatusPriceStr;
                _auctionCountLabel.hidden = NO;
                /// 红色价格
                _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(goodsListModel.jhShowPrice)?@"--":goodsListModel.jhShowPrice needEnd:NO];
                
                NSString *newPriceStrRed  = [NSString stringWithFormat:@"￥%@",goodsListModel.jhShowPrice];
                NSString *newPriceStrGray = _auctionCountLabel.text;
                CGSize size1 = [self calculationTextWidthWith:newPriceStrRed font:[UIFont fontWithName:kFontBoldDIN size:18.f]];
                CGSize size2 = [self calculationTextWidthWith:newPriceStrGray font:[UIFont fontWithName:kFontNormal size:9.f]];
                if (size1.width+size2.width > ((ScreenW - 12.f*2 - 9.f)/2.f)) {
                    _auctionCountLabel.hidden = YES;
                } else {
                    _auctionCountLabel.hidden = NO;
                }
            } else {
                _auctionCountLabel.text = @"";
                _auctionCountLabel.hidden = YES;
                /// 红色价格
                _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(goodsListModel.jhShowPrice)?@"--":goodsListModel.jhShowPrice needEnd:YES];
            }
            _grayPriceLabel.hidden = YES;
        } else {
            _auctionCountLabel.hidden = YES;
            /// 红色价格
            _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(goodsListModel.jhShowPrice)?@"--":goodsListModel.jhShowPrice needEnd:NO];
            /// 灰色价格
            NSString *newPriceStrRed  = [NSString stringWithFormat:@"￥%@",goodsListModel.jhShowPrice];
            NSString *newPriceStrGray = [NSString stringWithFormat:@"￥%@",goodsListModel.jhPrice];
            CGSize size1 = [self calculationTextWidthWith:newPriceStrRed font:[UIFont fontWithName:kFontBoldDIN size:18.f]];
            CGSize size2 = [self calculationTextWidthWith:newPriceStrGray font:[UIFont fontWithName:kFontNormal size:9.f]];
            if (size1.width+size2.width > ((ScreenW - 12.f*2 - 9.f)/2.f)) {
                _grayPriceLabel.hidden = YES;
            } else {
                _grayPriceLabel.hidden = NO;
            }
            _grayPriceLabel.text = [NSString stringWithFormat:@"￥%@",isEmpty(goodsListModel.jhPrice)?@"--":goodsListModel.jhPrice];
        }
    } else {
        _statusPriceLabel.hidden = YES;
        /// 出价次数
        if ([goodsListModel.productType isEqualToString:@"1"]) {
            if ([goodsListModel.num integerValue] >0) {
                NSString *showStatusPriceStr = @"";
                if (goodsListModel.num.length >3) {
                    showStatusPriceStr = [NSString stringWithFormat:@"已出价%@...次",[goodsListModel.num substringWithRange:NSMakeRange(0, 3)]];
                } else {
                    showStatusPriceStr = [NSString stringWithFormat:@"已出价%@次",goodsListModel.num];
                }
                _auctionCountLabel.text = showStatusPriceStr;
                _auctionCountLabel.hidden = NO;
                /// 红色价格
                _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(goodsListModel.jhPrice)?@"--":goodsListModel.jhPrice needEnd:NO];
                
                NSString *newPriceStrRed  = [NSString stringWithFormat:@"￥%@",goodsListModel.jhPrice];
                NSString *newPriceStrGray = _auctionCountLabel.text;
                CGSize size1 = [self calculationTextWidthWith:newPriceStrRed font:[UIFont fontWithName:kFontBoldDIN size:18.f]];
                CGSize size2 = [self calculationTextWidthWith:newPriceStrGray font:[UIFont fontWithName:kFontNormal size:9.f]];
                if (size1.width+size2.width > ((ScreenW - 12.f*2 - 9.f)/2.f)) {
                    _auctionCountLabel.hidden = YES;
                } else {
                    _auctionCountLabel.hidden = NO;
                }
            } else {
                _auctionCountLabel.text = @"";
                _auctionCountLabel.hidden = YES;
                /// 红色价格
                _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(goodsListModel.jhPrice)?@"--":goodsListModel.jhPrice needEnd:YES];
            }
        } else {
            _auctionCountLabel.hidden = YES;
            _redPriceLabel.attributedText = [self redPriceLabelStr:isEmpty(goodsListModel.jhPrice)?@"--":goodsListModel.jhPrice needEnd:NO];
        }
        _grayPriceLabel.hidden = YES;
    }
    
    /// 专场名称
    if (!isEmpty(goodsListModel.showName)) {
        _specialLable.text = goodsListModel.showName;
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.redPriceLabel.mas_bottom).offset(8.f);
            make.height.mas_equalTo(0.5f);
        }];
        
        [_specialBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(5.f);
            make.height.mas_equalTo(31.f);
        }];
        [_specialLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(9.f);
            make.height.mas_equalTo(17.f);
        }];
        [_specialImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(8.f);
        }];
        _specialBackImageView.hidden = NO;
        _specialLable.hidden = NO;
        _specialImageView.hidden = NO;
    } else {
        _specialLable.text = @"";
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.redPriceLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8.f);
        }];
        _specialBackImageView.hidden = YES;
        _specialLable.hidden = YES;
        _specialImageView.hidden = YES;

        
        [_specialBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
        [_specialLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
        [_specialImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    }
    
    //拍卖倒计时
    if (_curData.auctionDeadTime > 0) {
        self.countdownView.hidden = NO;
        @weakify(self);
        [self.countdownView setSecandData:_curData.auctionDeadTime/1000 expString:@"距拍卖结束:" completion:^(BOOL finished) {
            @strongify(self);
            //倒计时结束刷新数据
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(NO, @"-1", @"");
            }
        }];
    }else{
        self.countdownView.hidden = YES;
    }
    
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    return [self calculationTextWidthWithWidth:CGFLOAT_MAX string:string font:font];
}

- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

@end
