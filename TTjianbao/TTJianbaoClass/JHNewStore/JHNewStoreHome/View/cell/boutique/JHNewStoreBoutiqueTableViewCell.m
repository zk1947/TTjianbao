//
//  JHNewStoreBoutiqueTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreBoutiqueTableViewCell.h"
#import "UIView+JHGradient.h"
#import "JHNewStoreHomeTagView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHNewStoreHomeModel.h"
#import "TTjianbao.h"
//#import "JHStoreHelp.h"
#import "YDCountDown.h"
#import "CommHelp.h"
#import <UIImage+webP.h>
#import "JHNewStoreHomeReport.h"


typedef NS_ENUM(NSInteger, JHNewStoreBoutiqueBtnStatus) {
    JHNewStoreBoutiqueBtnStatus_buyNow = 0,    /// 立即购买
    JHNewStoreBoutiqueBtnStatus_reminder,      /// 开售提醒
    JHNewStoreBoutiqueBtnStatus_hasReminder,   /// 已设置提醒
};

/// 商品
@interface JHNewStoreBoutiqueGoodsCollectionCell :UICollectionViewCell
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel     *statusPriceLabel;
@property (nonatomic, strong) UILabel     *redPriceLabel;
@property (nonatomic, strong) UILabel     *grayPriceLabel;
- (void)setViewModel:(id)viewModel;
- (void)statusPriceLabelShow:(BOOL)isShow;
@end

@implementation JHNewStoreBoutiqueGoodsCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (CGFloat)cellWidth {
    return (ScreenWidth - 22.f*2.f - 6.f*2.f)/3.f;
}

- (void)setupViews {
    
    UIView *backView             = [[UIView alloc] init];
    backView.backgroundColor     = HEXCOLOR(0xFFFFFF);
    backView.layer.cornerRadius  = 5.f;
    backView.layer.masksToBounds = YES;
    backView.layer.borderWidth   = 0.5f;
    backView.layer.borderColor   = HEXCOLOR(0xEDEDED).CGColor;
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _posterImageView = [[UIImageView alloc] init];
    _posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    _posterImageView.clipsToBounds = YES;
    [backView addSubview:_posterImageView];
    [_posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(backView);
        make.width.height.mas_equalTo([self cellWidth]);
    }];
    
    _statusPriceLabel                 = [[UILabel alloc] init];
    _statusPriceLabel.textColor       = HEXCOLOR(0xFFFFFF);
    _statusPriceLabel.font            = [UIFont fontWithName:kFontNormal size:10.f];
    _statusPriceLabel.text            = @"专场价";
    _statusPriceLabel.layer.cornerRadius = 2.f;
    _statusPriceLabel.layer.masksToBounds = YES;
    _statusPriceLabel.textAlignment   = NSTextAlignmentCenter;
//    _statusPriceLabel.hidden          = YES;
    [_statusPriceLabel jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFF0400), HEXCOLOR(0xFF6E00)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [backView addSubview:_statusPriceLabel];
    [_statusPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.posterImageView.mas_bottom);
        make.left.equalTo(backView.mas_left).offset(6.f);
        make.width.mas_equalTo(36.f);
        make.height.mas_equalTo(14.f);
    }];
    
    _redPriceLabel                 = [[UILabel alloc] init];
    _redPriceLabel.textColor       = HEXCOLOR(0xF23730);
    _redPriceLabel.font            = [UIFont fontWithName:kFontBoldDIN size:18.f];
    [backView addSubview:_redPriceLabel];
    [_redPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(6.f);
        make.top.equalTo(self.posterImageView.mas_bottom).offset(12.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _grayPriceLabel                 = [[UILabel alloc] init];
    _grayPriceLabel.textColor       = HEXCOLOR(0x999999);
    _grayPriceLabel.font            = [UIFont fontWithName:kFontNormal size:9.f];
    [backView addSubview:_grayPriceLabel];
    [_grayPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redPriceLabel.mas_right).offset(1.f);
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
    
    UIView *shadowView = [self shadowView:CGRectMake(11.f, 5, [self cellWidth]-8.f, [self cellWidth] + 38.f -8.f)];
    [self.contentView insertSubview:shadowView belowSubview:backView];
}

// 阴影
- (UIView *)shadowView:(CGRect)frame {
    UIView * shadowView            = [[UIView alloc] initWithFrame:frame];
    shadowView.backgroundColor     = HEXCOLOR(0xF3F4F8);
    shadowView.layer.cornerRadius  = 10.f;
    shadowView.layer.shadowOpacity = 1.f;// 阴影透明度
    shadowView.layer.shadowColor   = HEXCOLOR(0xF3F4F8).CGColor;// 阴影的颜色 COLOR_HEX(0xF3F4F8)
    shadowView.layer.shadowOffset  = CGSizeMake(5, 5);// 阴影的范围
    shadowView.layer.shadowRadius  = 5.f;// 阴影扩散的范围控制
    CGPathRef path                 = [UIBezierPath bezierPathWithRect:shadowView.bounds].CGPath;
    [shadowView.layer setShadowPath:path];
    return shadowView;
}

- (void)setViewModel:(id)viewModel {
    JHNewStoreHomeBoutiqueShowListProductList *model = [JHNewStoreHomeBoutiqueShowListProductList cast:viewModel];
    [self.posterImageView jhSetImageWithURL:[NSURL URLWithString:model.coverUrl] placeholder:kDefaultNewStoreCoverImage];

    NSString *newPriceStrRed  = [NSString stringWithFormat:@"￥%@",model.showPrice];
    NSString *newPriceStrGray = [NSString stringWithFormat:@"￥%@",model.price];
    CGSize size1 = [self calculationTextWidthWith:newPriceStrRed font:[UIFont fontWithName:kFontBoldDIN size:18.f]];
    CGSize size2 = [self calculationTextWidthWith:newPriceStrGray font:[UIFont fontWithName:kFontNormal size:9.f]];

    if (size1.width+size2.width > [self cellWidth]) {
        self.grayPriceLabel.hidden = YES;
    } else {
        self.grayPriceLabel.hidden = NO;
    }
    /// 灰色价格
    self.grayPriceLabel.text = [NSString stringWithFormat:@"￥%@",isEmpty(model.price)?@"--":model.price];
    
    if (model.showType == 2) {
        self.grayPriceLabel.hidden = YES;
        
        if ([model.auctionCount integerValue] >0) {
            self.statusPriceLabel.hidden = NO;
            NSString *showStatusPriceStr = @"";
            if (model.auctionCount.length >3) {
                showStatusPriceStr = [NSString stringWithFormat:@"已出价%@...次",[model.auctionCount substringWithRange:NSMakeRange(0, 3)]];
                [self.statusPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(75.f);
                }];
            } else {
                showStatusPriceStr = [NSString stringWithFormat:@"已出价%@次",model.auctionCount];
                [self.statusPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(58.f);
                }];
            }
            self.statusPriceLabel.text = showStatusPriceStr;
            self.redPriceLabel.attributedText = [self redPriceLabelStr:[NSString stringWithFormat:@"%@",isEmpty(model.showPrice)?@"--":model.showPrice] needEnd:NO];
        } else {
            self.statusPriceLabel.hidden = YES;
            self.statusPriceLabel.text = @"";
            self.redPriceLabel.attributedText = [self redPriceLabelStr:[NSString stringWithFormat:@"%@",isEmpty(model.showPrice)?@"--":model.showPrice] needEnd:YES];
            [self.statusPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(58.f);
            }];
        }
        self.statusPriceLabel.textColor = HEXCOLOR(0x222222);
        self.statusPriceLabel.backgroundColor = HEXCOLOR(0xFFD70F);
    } else {
        self.grayPriceLabel.hidden = NO;
        if (model.showType == 0) {
            self.statusPriceLabel.text = @"新人价";
        } else {
            self.statusPriceLabel.text = @"专场";
        }
        
        self.redPriceLabel.attributedText = [self redPriceLabelStr:[NSString stringWithFormat:@"%@",isEmpty(model.showPrice)?@"--":model.showPrice] needEnd:NO];
        
        self.statusPriceLabel.textColor = HEXCOLOR(0xFFFFFF);
//        self.statusPriceLabel.backgroundColor = nil;
        [self.statusPriceLabel jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFF0400), HEXCOLOR(0xFF6E00)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [self.statusPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(36.f);
        }];
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
    CGSize width = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return width;
}

- (void)statusPriceLabelShow:(BOOL)isShow {
//    self.statusPriceLabel.hidden = !isShow;
}

@end



@interface JHNewStoreBoutiqueGoodsView : UIView<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView                      *goodsCollectionView;
@property (nonatomic, strong) NSMutableArray                        *dataSourceArray;
@property (nonatomic, strong) JHNewStoreBoutiqueGoodsCollectionCell *cell;
@property (nonatomic,   copy) dispatch_block_t                       clickBlock;
- (void)showZhuanChangPriceName:(BOOL)isShow;
@end

@implementation JHNewStoreBoutiqueGoodsView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (CGFloat)goodsWigth {
    return (ScreenWidth - 22.f*2.f - 6.f*2.f)/3.f;
}

- (void)setupViews {
    [self addSubview:self.goodsCollectionView];
    [self.goodsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
        make.height.mas_equalTo([self goodsWigth] + 38.f);
    }];
}

- (UICollectionView *)goodsCollectionView {
    if (!_goodsCollectionView) {
        UICollectionViewFlowLayout *layout                  = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing                      = 0;
        layout.minimumLineSpacing                           = 6.f;
       /// layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
        layout.estimatedItemSize                            = CGSizeMake([self goodsWigth], [self goodsWigth] + 38.f);
        layout.scrollDirection                              = UICollectionViewScrollDirectionHorizontal;

        _goodsCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _goodsCollectionView.showsVerticalScrollIndicator   = NO;
        _goodsCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
        _goodsCollectionView.delegate                       = self;
        _goodsCollectionView.dataSource                     = self;
        _goodsCollectionView.showsHorizontalScrollIndicator = NO;
        _goodsCollectionView.contentInset                   = UIEdgeInsetsMake(0, 10.f, 0.f, 10.f);
        _goodsCollectionView.scrollEnabled                   = NO;
        _goodsCollectionView.clipsToBounds = NO;
        [_goodsCollectionView registerClass:[JHNewStoreBoutiqueGoodsCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreBoutiqueGoodsCollectionCell class])];
    }
    return _goodsCollectionView;
}

#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreBoutiqueGoodsCollectionCell class]) forIndexPath:indexPath];
    [self.cell setViewModel:self.dataSourceArray[indexPath.row]];
    return self.cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setViewModel:(id)viewModel {
    [self.dataSourceArray removeAllObjects];
    NSArray<JHNewStoreHomeBoutiqueShowListProductList *>* productList = viewModel;
    if (productList && productList.count > 0) {
        [self.dataSourceArray addObjectsFromArray:productList];
    }
    [self.goodsCollectionView reloadData];
}

- (void)showZhuanChangPriceName:(BOOL)isShow {
    [self.cell statusPriceLabelShow:isShow];
}

@end


@interface JHNewStoreBoutiqueTableViewCell ()
/// header 部分
@property (nonatomic, strong) UIImageView                  *headerBackImageView;
@property (nonatomic, strong) UILabel                      *headerNameLabel;
@property (nonatomic, strong) YYAnimatedImageView          *statusImageView;
@property (nonatomic, strong) UIButton                     *buyNowButton;
@property (nonatomic, strong) JHNewStoreHomeTagView        *tagView;
/// 内容部分
@property (nonatomic, strong) JHNewStoreBoutiqueGoodsView  *goodsView;
/// 底部部分
@property (nonatomic, strong) UILabel                      *countDownLabel;
@property (nonatomic, strong) UIButton                     *shareButton;
@property (nonatomic, strong) YDCountDown                  *countDown;
@property (nonatomic, strong) UIView                       *backView;
@property (nonatomic, assign) NSInteger                     showId;
@property (nonatomic, strong) JHNewStoreHomeShareInfoModel *shareModel;
@property (nonatomic, strong) JHNewStoreHomeBoutiqueShowListModel *showListModel;
/**
 * 专场类型 0-新人 1-普通，2-拍卖，3-普通秒杀，4-大促秒杀
 */
@property (nonatomic, assign) NSInteger                     showType;
@end

@implementation JHNewStoreBoutiqueTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_countDown) {
            _countDown = [[YDCountDown alloc] init];
        }
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.contentView.backgroundColor = HEXCOLOR(0xF5F5F8);

    _backView = [[UIView alloc] init];
    _backView.backgroundColor = HEXCOLOR(0xFFFFFF);
    _backView.layer.cornerRadius = 5.f;
    _backView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, 9, 12));
    }];
    
    /// 背景图
    _headerBackImageView = [[UIImageView alloc] init];
    _headerBackImageView.image = [UIImage imageNamed:@"jh_newStore_boutiqueBack"];
    [_backView addSubview:_headerBackImageView];
    [_headerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.backView);
        make.height.mas_equalTo(70.f);
    }];
    
        
    /// 抢购按钮
    _buyNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyNowButton.layer.cornerRadius  = 4.f;
    _buyNowButton.layer.masksToBounds = YES;
    [_buyNowButton addTarget:self action:@selector(buyNowButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_buyNowButton];
    [_buyNowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerBackImageView.mas_centerY);
        make.right.equalTo(self.backView.mas_right).offset(-11.f);
        make.width.mas_equalTo(73.f);
        make.height.mas_equalTo(26.f);
    }];
    
    /// 标题
    _headerNameLabel           = [[UILabel alloc] init];
    _headerNameLabel.textColor = HEXCOLOR(0x222222);
    _headerNameLabel.font      = [UIFont fontWithName:kFontMedium size:16.f];
    _headerNameLabel.backgroundColor = [UIColor clearColor];
    [_backView addSubview:_headerNameLabel];
    [_headerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(12.f);
        make.left.equalTo(self.backView.mas_left).offset(10.f);
        make.right.lessThanOrEqualTo(self.buyNowButton.mas_left).offset(-38.f - 5.f - 18.f - 10.f);
        make.height.mas_equalTo(22.f);
    }];
    
    /// 热卖、预告
    _statusImageView = [[YYAnimatedImageView alloc] init];
    _statusImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_backView addSubview:_statusImageView];
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerNameLabel.mas_right).offset(4.f);
        make.centerY.equalTo(self.headerNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(32.f, 16.f));
    }];
    
    /// 标签
    _tagView = [[JHNewStoreHomeTagView alloc] init];
    _tagView.backgroundColor = [UIColor clearColor];
    _tagView.tagViewNeedWidth = (ScreenW - 12.f*2 - 9.f)/2.f - 16.f - 4.f;
    _tagView.tagViewNeedHeight = 20.f;
    _tagView.tagTextFont = 11.f;
    _tagView.borderColor = HEXCOLOR(0xBD965F);
    _tagView.textColor = HEXCOLOR(0xBD965F);
    _tagView.isGoodsInfo = NO;
    _tagView.userInteractionEnabled = YES;
    [_backView addSubview:_tagView];
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerNameLabel.mas_left);
        make.top.equalTo(self.headerNameLabel.mas_bottom).offset(5.f);
        make.right.equalTo(self.buyNowButton.mas_left).offset(-10.f);
        make.height.mas_equalTo(20.f);
    }];
    
    UITapGestureRecognizer *tagViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsViewDidClicked)];
    [_tagView addGestureRecognizer:tagViewTap];


    /// 商品
    _goodsView = [[JHNewStoreBoutiqueGoodsView alloc] init];
    _goodsView.userInteractionEnabled = YES;
    [_backView addSubview:_goodsView];
    [_goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left);
        make.top.equalTo(self.headerBackImageView.mas_bottom).offset(4.f);
        make.right.equalTo(self.buyNowButton.mas_right);
        make.height.mas_equalTo([self goodsWigth] + 38.f);
    }];
    
    UITapGestureRecognizer *goodsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsViewDidClicked)];
    [_goodsView addGestureRecognizer:goodsTap];

    @weakify(self);
    _tagView.clickBlock = ^{
        @strongify(self);
        if (self.bouClickBlock) {
            self.bouClickBlock();
        }
    };
    _goodsView.clickBlock = ^{
        @strongify(self);
        if (self.bouClickBlock) {
            self.bouClickBlock();
        }
    };

    /// 分享按钮
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    _shareButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    [_shareButton setImage:[UIImage imageNamed:@"jh_newStore_homeShare"] forState:UIControlStateNormal];
    [_shareButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5.f];
    [_shareButton addTarget:self action:@selector(shareButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_shareButton];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsView.mas_bottom).offset(12.f);
        make.right.equalTo(self.backView.mas_right).offset(-10.f);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-12.f);
        make.width.mas_equalTo(50.f);
        make.height.mas_equalTo(17.f);
    }];
    
    /// 倒计时
    _countDownLabel           = [[UILabel alloc] init];
    _countDownLabel.font      = [UIFont fontWithName:kFontNormal size:12.f];
    _countDownLabel.textColor = HEXCOLOR(0x222222);
    [_backView addSubview:_countDownLabel];
    [_countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareButton.mas_centerY);
        make.left.equalTo(self.backView.mas_left).offset(10.f);
        make.right.equalTo(self.shareButton.mas_left).offset(-30.f);
        make.height.mas_equalTo(17.f);
    }];
}

- (CGFloat)goodsWigth {
    return (ScreenWidth - 22.f*2.f - 6.f*2.f)/3.f;
}

- (void)shareButtonDidClicked:(UIButton *)sender {
    if (self.shareBlock) {
        self.shareBlock(self.shareModel);
    }
}

- (void)goodsViewDidClicked {
    if (self.bouClickBlock) {
        self.bouClickBlock();
    }
}

- (void)setViewModel:(id)viewModel {
    JHNewStoreHomeBoutiqueShowListModel *model = [JHNewStoreHomeBoutiqueShowListModel cast:viewModel];
    self.showType = model.showType;
    
    if (self.isFirstCell) {
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(6, 12, 9, 12));
        }];
    } else {
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, 9, 12));
        }];
    }
    self.showListModel = model;
    self.showId = model.showId;
    self.shareModel = model.shareInfoBean;
    self.headerNameLabel.text = NONNULL_STR(model.title);
    if (model.tags.count >0) {
        [self.tagView setViewModel:model.tags];
    } else {
        [self.tagView setViewModel:nil];
    }
    if (model.productList.count >0) {
        [self.goodsView setViewModel:model.productList];
        [self.goodsView showZhuanChangPriceName:YES]; /**!isEmpty(model.priceName)*/
        [self.goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerBackImageView.mas_bottom).offset(4.f);
            make.height.mas_equalTo([self goodsWigth] + 38.f);
        }];
    } else {
        [self.goodsView setViewModel:nil];
        [self.goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerBackImageView.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0);
        }];
    }
    [self.countDown destoryTimer];
    if (model.showStatus == 0) { /// 预告 - 无倒计时
        if (model.subscribeStatus == 0) {
            [self setBuyNowButtonStatus:JHNewStoreBoutiqueBtnStatus_reminder showType:model.showType];
        } else {
            [self setBuyNowButtonStatus:JHNewStoreBoutiqueBtnStatus_hasReminder showType:model.showType];
        }
        if (model.showType == 2) {
            self.statusImageView.image = [YYImage imageNamed:@"jh_newStore_auctionWillLogo.webp"];
            [self.statusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(56.f, 17.f));
            }];
        } else {
            self.statusImageView.image = [YYImage imageNamed:@"jhNewStore_will.webp"];
            [self.statusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(32.f, 16.f));
            }];
        }
        self.countDownLabel.attributedText = nil;
        long longTime = [model.saleStartTime longValue]/1000;
        
        if (model.showType == 2) {
            self.countDownLabel.text = [NSString stringWithFormat:@"%@ 开拍",[self startTime:longTime]];
        } else {
            self.countDownLabel.text = [NSString stringWithFormat:@"%@ 即将开始",[self startTime:longTime]];
        }
    } else if (model.showStatus == 1) { /// 热卖 - 有倒计时
        self.countDownLabel.text = nil;
        [self setBuyNowButtonStatus:JHNewStoreBoutiqueBtnStatus_buyNow showType:model.showType];
        long nowTime = [model.saleEndTime longValue]/1000 - model.remainTime/1000;
        [self countDownInfo:nowTime end:[model.saleEndTime longValue]/1000];
        if (model.showType == 2) {
            self.statusImageView.image = [YYImage imageNamed:@"jh_newStore_auctionLogo.webp"];
            [self.statusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(56.f, 17.f));
            }];
        } else {
            self.statusImageView.image = [YYImage imageNamed:@"jhNewStore_hot.webp"];
            [self.statusImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(32.f, 16.f));
            }];
        }
    } else if (model.showStatus == 2) { /// 结束
        /// 不下发
        [self endingStatus];
    }
}

- (void)countDownInfo:(long)start end:(long)end {
    @weakify(self);
    [self.countDown startWithbeginTimeStamp:start
                        finishTimeStamp:end
                          completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        @strongify(self);
        if (self.showListModel.showStatus == 0) { /// 预告 - 无倒计时
            self.countDownLabel.attributedText = nil;
            long longTime = [self.showListModel.saleStartTime longValue]/1000;
            if (self.showListModel.showType == 2) {
                self.countDownLabel.text = [NSString stringWithFormat:@"%@ 开拍",[self startTime:longTime]];
            } else {
                self.countDownLabel.text = [NSString stringWithFormat:@"%@ 即将开始",[self startTime:longTime]];
            }
        } else {
            self.countDownLabel.text = nil;
            self.countDownLabel.attributedText = [self setCountLableInfoStr:day hour:hour minute:minute second:second];
            self.showListModel.remainTime = self.showListModel.remainTime - 1000;            
            if (day == 0 && hour==0 && minute == 0 && second == 0) {
                ///停止定时器
                [self.countDown destoryTimer];
                [self endingStatus];
            }
        }
        [self setNeedsLayout];
    }];
}

- (NSMutableAttributedString *)setCountLableInfoStr:(NSInteger)day
                                               hour:(NSInteger)hour
                                             minute:(NSInteger)minute
                                             second:(NSInteger)second {
    NSMutableAttributedString *endAttStr = [[NSMutableAttributedString alloc] initWithString:@"距结束" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x999999)
    }];
    NSMutableAttributedString *dayAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld ",(long)day] attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldDIN size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x222222)
    }];
    NSMutableAttributedString *endAttStr1 = [[NSMutableAttributedString alloc] initWithString:@"天" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x999999)
    }];
    NSMutableAttributedString *hourAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld ",(long)hour] attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldDIN size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x222222)
    }];
    NSMutableAttributedString *endAttStr2 = [[NSMutableAttributedString alloc] initWithString:@"小时" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x999999)
    }];
    NSMutableAttributedString *minuteAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld ",(long)minute] attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldDIN size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x222222)
    }];
    NSMutableAttributedString *endAttStr3 = [[NSMutableAttributedString alloc] initWithString:@"分" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x999999)
    }];
    NSMutableAttributedString *secondAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld ",(long)second] attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldDIN size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x222222)
    }];
    NSMutableAttributedString *endAttStr4 = [[NSMutableAttributedString alloc] initWithString:@"秒" attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x999999)
    }];
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    [commentString appendAttributedString:endAttStr];
    [commentString appendAttributedString:dayAttStr];
    [commentString appendAttributedString:endAttStr1];
    [commentString appendAttributedString:hourAttStr];
    [commentString appendAttributedString:endAttStr2];
    [commentString appendAttributedString:minuteAttStr];
    [commentString appendAttributedString:endAttStr3];
    [commentString appendAttributedString:secondAttStr];
    [commentString appendAttributedString:endAttStr4];
    return commentString;
}


- (NSString *)startTime:(long)saleStartTime {
    NSString *str = [CommHelp timestampSwitchTimeMonthDayAndhour:saleStartTime];
    return str;
}

- (void)buyNowButtonDidClicked:(UIButton *)sender {
    if ([self.buyNowButton.titleLabel.text isEqualToString:@"立即抢购"] || [self.buyNowButton.titleLabel.text isEqualToString:@"立即抢拍"]) {
        if (self.bouClickBlock) {
            self.bouClickBlock();
        }
        return;
    }
    if ([self isLogin]) {
        [JHNewStoreHomeReport jhNewStoreHomeBoutiqueWillActiveClickReport:self.showListModel.title zc_id:[NSString stringWithFormat:@"%ld",self.showListModel.showId]];
        @weakify(self);
        [self setBuyTimeAnswerMe:^(NSError * _Nullable error) {
            @strongify(self);
            if (error) {
                [JHKeyWindow makeToast:@"设置失败，请稍后重试" duration:0.7f position:CSToastPositionCenter];
                [self setBuyNowButtonStatus:JHNewStoreBoutiqueBtnStatus_reminder showType:self.showType];
            } else {
                if ([self.buyNowButton.titleLabel.text isEqualToString:@"开拍提醒"]) {
                    [JHKeyWindow makeToast:@"开拍提醒设置成功~" duration:0.7f position:CSToastPositionCenter];
                } else {
                    [JHKeyWindow makeToast:@"开售提醒设置成功~" duration:0.7f position:CSToastPositionCenter];
                }
                [self setBuyNowButtonStatus:JHNewStoreBoutiqueBtnStatus_hasReminder showType:self.showType];
            }
        }];
    }
}

- (BOOL)isLogin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:JHRootController complete:^(BOOL result) {}];
        return  NO;
    }
    return  YES;
}

- (void)setBuyTimeAnswerMe:(void(^)(NSError *_Nullable))completion {
    NSDictionary *dict = @{
        @"showId":@(self.showId)
    };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/show/salesReminder") Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (completion) {
            completion(nil);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)endingStatus {
    UITableViewCell *cell = (UITableViewCell *)[[self.backView superview] superview];
    NSIndexPath     *path = [[self tableView] indexPathForCell:cell];
    if (path) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWSTOREREMOVECELL" object:path];
    }
}

- (void)setBuyNowButtonStatus:(JHNewStoreBoutiqueBtnStatus)status showType:(NSInteger)showType {
    switch (status) {
        case JHNewStoreBoutiqueBtnStatus_buyNow: {
            self.buyNowButton.userInteractionEnabled = YES;
            self.buyNowButton.layer.borderWidth = 0.f;
            self.buyNowButton.layer.borderColor = nil;
            if (showType == 2) {
                [self.buyNowButton setTitle:@"立即抢拍" forState:UIControlStateNormal];
                self.buyNowButton.backgroundColor = HEXCOLOR(0xFF6A00);
                [self.buyNowButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
                [self.buyNowButton setImage:[UIImage imageNamed:@"jh_newStore_homeBuyNow_Auction"] forState:UIControlStateNormal];
            } else {
                [self.buyNowButton setTitle:@"立即抢购" forState:UIControlStateNormal];
                self.buyNowButton.backgroundColor = HEXCOLOR(0xFFD70F);
                [self.buyNowButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
                [self.buyNowButton setImage:[UIImage imageNamed:@"jh_newStore_homeBuyNow"] forState:UIControlStateNormal];
            }
            self.buyNowButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
            [self.buyNowButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4.f];
        }
            break;
        case JHNewStoreBoutiqueBtnStatus_reminder: {
            self.buyNowButton.userInteractionEnabled = YES;
            self.buyNowButton.layer.borderWidth = 0.5f;
            self.buyNowButton.layer.borderColor = HEXCOLOR(0xFF6A00).CGColor;
            if (showType == 2) {
                [self.buyNowButton setTitle:@"开拍提醒" forState:UIControlStateNormal];
            } else {
                [self.buyNowButton setTitle:@"开售提醒" forState:UIControlStateNormal];
            }
            self.buyNowButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
            [self.buyNowButton setImage:nil forState:UIControlStateNormal];
            self.buyNowButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            self.buyNowButton.backgroundColor = HEXCOLOR(0xFFFFFF);
            [self.buyNowButton setTitleColor:HEXCOLOR(0xFF6A00) forState:UIControlStateNormal];
            self.buyNowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        case JHNewStoreBoutiqueBtnStatus_hasReminder: {
            self.buyNowButton.userInteractionEnabled = NO;
            self.buyNowButton.layer.borderWidth = 0.5f;
            self.buyNowButton.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
            [self.buyNowButton setTitle:@"已设提醒" forState:UIControlStateNormal];
            self.buyNowButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
            [self.buyNowButton setImage:nil forState:UIControlStateNormal];
            self.buyNowButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [self.buyNowButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            self.buyNowButton.backgroundColor = HEXCOLOR(0xFFFFFF);
            self.buyNowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
            break;
        default:
            break;
    }
}

- (void)reloadBuyBtnMess:(BOOL)hasRemind {
    if (hasRemind) {
        [self setBuyNowButtonStatus:JHNewStoreBoutiqueBtnStatus_hasReminder showType:self.showType];
    } else {
        [self setBuyNowButtonStatus:JHNewStoreBoutiqueBtnStatus_reminder showType:self.showType];
    }
}

@end
