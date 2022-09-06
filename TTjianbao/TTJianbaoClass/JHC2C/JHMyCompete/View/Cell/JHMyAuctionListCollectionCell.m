//
//  JHMyAuctionListCollectionCell.m
//  TTjianbao
//
//  Created by zk on 2021/9/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyAuctionListCollectionCell.h"
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
#import "TTJianBaoColor.h"
#import "JHMyCompeteViewModel.h"

@interface JHMyAuctionListCollectionCell ()

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
/// 立即付款
@property (nonatomic, strong) UIButton *immediatePaymentButton;
@property (nonatomic, strong) UIView *timeBgView;
///拍品的状态（领先，成交，出局）
@property (nonatomic, strong) UILabel *stateLable;

@end

@implementation JHMyAuctionListCollectionCell

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
    
    if (!_stateLable) {
    _stateLable = [[UILabel alloc]init];
    _stateLable.layer.cornerRadius = 30.0f;
    _stateLable.layer.masksToBounds = YES;
    _stateLable.textAlignment = NSTextAlignmentCenter;
    _stateLable.font = JHFont(14);
    _stateLable.textColor = HEXCOLOR(0xFFFFFF);
    _stateLable.numberOfLines = 2;
    [_stateLable setHidden:YES];
    [self.contentView addSubview:_stateLable];
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
        _titleLabel                      = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:14] textColor:kColor333];
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
        _lineView.backgroundColor        = [UIColor clearColor];//HEXCOLOR(0xE8E8E8);
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
    
    if (!_timeBgView) {
    _timeBgView = [UIView new];
    _timeBgView.backgroundColor = HEXCOLORA(0xFF6A00, 0.8);
    [self.contentView addSubview:_timeBgView];
    }
    
    if (!_countdownView) {
        _countdownView = [[JHMyCompeteCountdownView alloc]init];
        [_countdownView dealTextAlent];
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
    
    [_stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(60, 60));
        make.center.equalTo(self.imgView);
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
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(31.f);
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
        
    [_timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.imgView);
        make.height.mas_offset(26);
    }];
    
    [_countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.goodsImgView);
        make.left.mas_equalTo(10);
        make.bottom.equalTo(self.imgView);
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
    if (self.curData.showType == 0) { /// 新人 - 跳转h5
        if (self.goToBoutiqueDetailClickBlock) {
            self.goToBoutiqueDetailClickBlock(YES, [NSString stringWithFormat:@"%ld",self.curData.showId], self.curData.showName);
        }
        [JHRouterManager pushWebViewWithUrl:self.curData.showUrl title:@"" controller:JHRootController];
    } else if (self.curData.showType == 1) {
        if (self.goToBoutiqueDetailClickBlock) {
            self.goToBoutiqueDetailClickBlock(NO, [NSString stringWithFormat:@"%ld",self.curData.showId], self.curData.showName);
        }
    } else {
        if (self.goToBoutiqueDetailClickBlock) {
            self.goToBoutiqueDetailClickBlock(NO, [NSString stringWithFormat:@"%ld",self.curData.showId], self.curData.showName);
        }
    }
}

- (void)setCurData:(JHMyAuctionListItemModel *)curData {
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
    
    // 商品状态
    _stateLable.hidden = [_curData auctionStatusViewHidden];
    _stateLable.attributedText = [_curData auctionStatusText];
    _stateLable.backgroundColor =  [_curData auctionStatusBackgroundColor];
    
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
            _statusPriceLabel.text = @"新人价";
            _statusPriceLabel.hidden = NO;
        } else if (curData.showType == 1) { /// 普通
            _statusPriceLabel.text = @"专场价";
            _statusPriceLabel.hidden = NO;
        } else if (curData.showType == 2) { /// 拍卖
            _statusPriceLabel.hidden = YES;
        } else {
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
//        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.titleLabel.mas_left);
//            make.right.equalTo(self.titleLabel.mas_right);
//            make.top.equalTo(self.redPriceLabel.mas_bottom).offset(0.f);
//            make.height.mas_equalTo(0.f);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8.f);
//        }];
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
    BOOL orderDeadBool = !isEmpty(_curData.orderDeadline) ? YES : NO;
    if (_curData.productAuctionStatus == 2 &&
        _curData.payExpireTime.length > 0 &&
        _curData.orderStatus < 4) {
        orderDeadBool = true;
    }else {
        orderDeadBool = false;
    }
    NSString *countDown = orderDeadBool ? _curData.payExpireTime : _curData.auctionDeadline;
    NSString *prefixTip = orderDeadBool ? @"距订单关闭:" : @"距拍卖结束:" ;
    @weakify(self);
    [self.countdownView setTheCompeteCountdownView:countDown expString:prefixTip completion:^(BOOL finished) {
        @strongify(self);
        //拍卖结束刷新单条数据、订单支付时效结束删除单条数据
        if (orderDeadBool) {
            if (self.deleteOutCellBlock) {
                self.deleteOutCellBlock(YES);
            }
        }else{
            [self performSelector:@selector(reloadCurrentCellData) afterDelay:2.5];
        }
    }];
    
    int second = [CommHelp dateRemaining:countDown];
    _timeBgView.hidden = second > 0 ? NO:YES;
    
    /// 商品售卖状态 0无状态 1 失效 2出局 3领先 4中拍 5:已结束 6:已下架 auctionStatus
    if (_curData.auctionStatus == 2 || _curData.auctionStatus == 3 || _curData.auctionStatus == 4 || _curData.auctionStatus == 7) {
        NSString *btnTitStr;
        switch (_curData.auctionStatus) {
            case 2:{
                self.immediatePaymentButton.hidden = NO;
                btnTitStr = @"立即出价";
                [self.immediatePaymentButton setTitle:btnTitStr forState:UIControlStateNormal];
            }
                break;
            case 3:{
                self.immediatePaymentButton.hidden = NO;
                btnTitStr = @"去看看";
                [self.immediatePaymentButton setTitle:btnTitStr forState:UIControlStateNormal];
            }
                break;
            case 4:{
                self.immediatePaymentButton.hidden = _curData.immediatePaymentHidden;
                btnTitStr = @"立即付款";
                [self.immediatePaymentButton setTitle:btnTitStr forState:UIControlStateNormal];
            }
                break;
            case 7:{
                self.immediatePaymentButton.hidden = NO;
                btnTitStr = @"立即出价";
                [self.immediatePaymentButton setTitle:btnTitStr forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }else{
        self.immediatePaymentButton.hidden = YES;
    }
    
}

- (NSMutableAttributedString *)redPriceLabelStr:(NSString *)str needEnd:(BOOL)needEnd {
    NSMutableAttributedString *firstAttStr = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:11.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
    }];
    NSMutableAttributedString *moneyAttStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldDIN size:18.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
    }];
    NSMutableAttributedString *endAttStr= [[NSMutableAttributedString alloc] initWithString:@"起" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldPingFang size:11.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
    }];
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    [commentString appendAttributedString:firstAttStr];
    [commentString appendAttributedString:moneyAttStr];
    if (needEnd) {
        [commentString appendAttributedString:endAttStr];
    }
    return commentString;
}

- (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font {
    return [self calculationTextWidthWithWidth:CGFLOAT_MAX string:string font:font];
}

- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

-(UIButton *)immediatePaymentButton
{
    if (!_immediatePaymentButton) {
        _immediatePaymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _immediatePaymentButton.backgroundColor = YELLOW_COLOR;
        _immediatePaymentButton.layer.borderColor = YELLOW_COLOR.CGColor;
        _immediatePaymentButton.layer.cornerRadius = 4.0f;
        _immediatePaymentButton.layer.masksToBounds = YES;
        _immediatePaymentButton.titleLabel.font = JHFont(12);
//        _immediatePaymentButton.userInteractionEnabled = NO;
        [_immediatePaymentButton setTitle:@"立即付款" forState:UIControlStateNormal];
        [_immediatePaymentButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [_immediatePaymentButton addTarget:self action:@selector(immediatePaymentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_immediatePaymentButton];
        [_immediatePaymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.mas_offset(28);
        }];
        
    }
    return _immediatePaymentButton;
}

- (void)immediatePaymentButtonAction:(UIButton *)btn{
    BOOL isPay = [btn.titleLabel.text isEqualToString:@"立即付款"] ? YES:NO;
    if (_buttonActionBlock) {
        _buttonActionBlock(_curData,isPay);
    }
}

#pragma mark -单刷数据
- (void)reloadCurrentCellData{
    NSDictionary *param = @{
        @"productId":@(_curData.productId)
    };
    @weakify(self);
    [JHMyCompeteViewModel reLoadMyAcutionStatus:param completion:^(NSError * _Nullable error, JHMyAuctionListItemModel * _Nonnull model) {
        @strongify(self);
        if (model) {
            self.curData = model;
        }
    }];
}
@end
