//
//  JHMyCompeteCollectionViewCell.m
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteCollectionViewCell.h"
#import "JHMyCompeteCountdownView.h"
#import "JHMyCompeteGoodsTagView.h"
#import "JHMyCompeteWantToView.h"
#import "TTJianBaoColor.h"
#import "JHMyCompeteModel.h"
#import "LKDBUtils.h"
#import "JHStoreHelp.h"
#import "JHC2CProductDetailController.h"
#import "JHMyCompeteViewModel.h"

@interface JHMyCompeteCollectionViewCell ()
/////商品图
//@property (nonatomic, strong) UIImageView *goodsImgView;
///鉴定标签
@property (nonatomic, strong) UIImageView *identifyTagImgView;
///视频标签
@property (nonatomic, strong) UIImageView *videoImgView;
///拍品的状态（领先，成交，出局）
@property (nonatomic, strong) UILabel *stateLable;
/// 倒计时视图
@property (nonatomic, strong) JHMyCompeteCountdownView *countdownView;

@property (nonatomic, strong) UIView *timeBgView;

///拍卖中标签
@property (nonatomic, strong) UILabel *auctionLabel;
///商品标题
@property (nonatomic, strong) UILabel *goodsTitleLabel;
///商品标签
@property (nonatomic, strong) JHMyCompeteGoodsTagView *goodsTagView;
///价格
@property (nonatomic, strong) UILabel *redPriceLabel;
///出价人数
@property (nonatomic, strong) UILabel *bidNumLabel;
// 底部想要
//@property (nonatomic, strong) JHMyCompeteWantToView *wantToView;
/// 立即付款
@property (nonatomic, strong) UIButton *immediatePaymentButton;

@end

@implementation JHMyCompeteCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.layer.cornerRadius = 5.f;
        self.contentView.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
        
        [self p_drawSubViews];
        [self p_layoutUI];
    }
    return self;
}

- (void)p_drawSubViews {
    
    _goodsImgView = [[UIImageView alloc]init];
    _goodsImgView.image = [UIImage imageNamed:@"jh_newStore_type_defaulticon"];
    [self.contentView addSubview:_goodsImgView];
    
    _identifyTagImgView = [[UIImageView alloc]init];
    _identifyTagImgView.image = JHImageNamed(@"c2c_goods_gongyipin_icon");
    [self.contentView addSubview:_identifyTagImgView];
    
    _videoImgView = [[UIImageView alloc]init];
    _videoImgView.image = JHImageNamed(@"jh_newStore_hasVideo");
    _videoImgView.hidden = YES;
    [self.contentView addSubview:_videoImgView];
    
    _stateLable = [[UILabel alloc]init];
    _stateLable.layer.cornerRadius = 30.0f;
    _stateLable.layer.masksToBounds = YES;
    _stateLable.textAlignment = NSTextAlignmentCenter;
    _stateLable.font = JHFont(14);
    _stateLable.textColor = HEXCOLOR(0xFFFFFF);
    _stateLable.numberOfLines = 2;
    [_stateLable setHidden:YES];
    [self.contentView addSubview:_stateLable];
    
    _timeBgView = [UIView new];
    _timeBgView.backgroundColor = HEXCOLORA(0xFF6A00, 0.8);
    [self.contentView addSubview:_timeBgView];
    
    _countdownView = [[JHMyCompeteCountdownView alloc]init];
    [_countdownView dealTextAlent];
    [self.contentView addSubview:_countdownView];
    
    _goodsTitleLabel = [[UILabel alloc]init];
    _goodsTitleLabel.font = [UIFont fontWithName:kFontNormal size:14];
    _goodsTitleLabel.textColor = HEXCOLOR(0x333333);
    _goodsTitleLabel.numberOfLines = 2;
    [self.contentView addSubview:_goodsTitleLabel];
    
    _auctionLabel = [[UILabel alloc]init];
    _auctionLabel.font = JHFont(11);
    _auctionLabel.textColor = HEXCOLOR(0x222222);
    _auctionLabel.text = @"拍卖中";
    _auctionLabel.backgroundColor = HEXCOLOR(0xFFD70F);
    _auctionLabel.textAlignment = NSTextAlignmentCenter;
    _auctionLabel.hidden = YES;
    [_auctionLabel jh_cornerRadius:2];
    [self.contentView addSubview:_auctionLabel];
    
    _redPriceLabel = [[UILabel alloc] init];
    _redPriceLabel.font = JHDINBoldFont(18);
    _redPriceLabel.textColor = HEXCOLOR(0xF23730);
    _redPriceLabel.text = @"¥123456789";
    [_redPriceLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _redPriceLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_redPriceLabel];
    
    _bidNumLabel = [[UILabel alloc] init];
    _bidNumLabel.font = JHFont(10);
    _bidNumLabel.textColor = HEXCOLOR(0x999999);
    [_bidNumLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    _bidNumLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_bidNumLabel];
    
    
}

- (void)p_layoutUI{
//    [super layoutSubviews];
    
    [_goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_offset(180);
    }];
    
    [_identifyTagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView);
        make.left.equalTo(self.goodsImgView).offset(5);
        make.width.mas_offset(22);
    }];
    
    [_videoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView).offset(10);
        make.right.equalTo(self.goodsImgView).offset(-10);
        make.size.mas_offset(CGSizeMake(25, 25));
    }];
    
    [_stateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(60, 60));
        make.center.equalTo(self.goodsImgView);
    }];
    
    [_timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.goodsImgView);
        make.height.mas_offset(26);
    }];
    
    [_countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.goodsImgView);
        make.left.mas_equalTo(10);
        make.bottom.equalTo(self.goodsImgView);
        make.height.mas_offset(26);
            
    }];
    
    [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    
    [_auctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView.mas_bottom).offset(9);
        make.left.equalTo(self.contentView).offset(8);
        make.size.mas_offset(CGSizeMake(41, 16));
    }];
    
    [self.redPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsTagView.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(8);
        make.height.mas_offset(22);
    }];
    
    [self.bidNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.redPriceLabel);
        make.left.mas_greaterThanOrEqualTo(self.redPriceLabel.mas_right).offset(4);
//        make.right.equalTo(self.contentView).offset(-8);
        make.height.mas_offset(22);
    }];
}

- (void)setMyCompeteModel:(JHMyCompeteModel *)myCompeteModel {
    if (!myCompeteModel) {
        return;
    }
    _myCompeteModel = myCompeteModel;
    // 商品状态
    _stateLable.hidden = [myCompeteModel auctionStatusViewHidden];
    _stateLable.attributedText = [myCompeteModel auctionStatusText];
    _stateLable.backgroundColor =  [myCompeteModel auctionStatusBackgroundColor];
    // 鉴定
    _identifyTagImgView.image = [UIImage imageNamed:[myCompeteModel appraisalPictureName]];
    _identifyTagImgView.hidden = isEmpty([myCompeteModel appraisalPictureName]) ? YES : NO;
   
    // 商品
    [_goodsImgView jhSetImageWithURL:[NSURL URLWithString:myCompeteModel.coverImage.url]
                              placeholder:kDefaultNewStoreCoverImage];
    [_goodsImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(myCompeteModel.coverImage.aNewHeight);
    }];
    
    _videoImgView.hidden = isEmpty(myCompeteModel.videoUrl);
    
    BOOL orderDeadBool = !isEmpty(myCompeteModel.orderDeadline) ? YES : NO;

    if (myCompeteModel.productAuctionStatus == 2 &&
        myCompeteModel.payExpireTime.length > 0 &&
        myCompeteModel.orderStatus < 4) {
        orderDeadBool = true;
    }else {
        orderDeadBool = false;
    }
    
    NSString *countDown = orderDeadBool ? myCompeteModel.payExpireTime : myCompeteModel.auctionDeadline;
    NSString *prefixTip = orderDeadBool ? @"距订单关闭:" : @"距拍卖结束:" ;
    @weakify(self);
    [self.countdownView setTheCompeteCountdownView:countDown expString:prefixTip completion:^(BOOL finished) {
        @strongify(self);
        //倒计时结束刷新单条数据
        [self reloadCurrentCellData];
    }];
    
    int second = [CommHelp dateRemaining:countDown];
    _timeBgView.hidden = second > 0 ? NO:YES;
    
    // title
//    _goodsTitleLabel.attributedText = myCompeteModel.attriProductDesc;
    _goodsTitleLabel.text = myCompeteModel.productDesc;
    
//    if (myCompeteModel.labels.count > 0) {
//        [self.goodsTagView reloadCompeteGoodsTagView:myCompeteModel.labels];
//    } else {
    
    if (myCompeteModel.productTagList.count > 0) {
        [self.goodsTagView reloadCompeteGoodsTagView:myCompeteModel.productTagList];
        [self.goodsTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
            make.left.right.equalTo(self.contentView).offset(8);
            make.height.mas_offset(16);
        }];
    } else {
        [self.redPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
        }];
    }
    
    /// 红色价格
    [JHStoreHelp setNewPrice:isEmpty(myCompeteModel.price)?@"--":myCompeteModel.price forLabel:_redPriceLabel Color:HEXCOLOR(0xF23730)];
    [_bidNumLabel setText:myCompeteModel.showPriceNumber];
    
    if (myCompeteModel.isOnelineOfMoney) {
        
        [self.redPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-8);
        }];
        
    }
    _bidNumLabel.hidden = myCompeteModel.isOnelineOfMoney;
    
//    self.immediatePaymentButton.hidden = myCompeteModel.immediatePaymentHidden;
//    if (myCompeteModel.wantToModel) {
//        self.wantToView.hidden = !self.immediatePaymentButton.hidden;
//        [self.wantToView setMyCompeteWantToModel:myCompeteModel.wantToModel];
//    }
    
    /// 商品售卖状态 0无状态 1 失效 2出局 3领先 4中拍 5:已结束 6:已下架 auctionStatus
    if (_myCompeteModel.auctionStatus == 2 || _myCompeteModel.auctionStatus == 3 || _myCompeteModel.auctionStatus == 4 || _myCompeteModel.auctionStatus == 7) {
        NSString *btnTitStr;
        switch (_myCompeteModel.auctionStatus) {
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
                self.immediatePaymentButton.hidden = myCompeteModel.immediatePaymentHidden;
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



#pragma mark - set/get
//- (JHMyCompeteWantToView *)wantToView
//{
//    if (!_wantToView) {
//        _wantToView = [[JHMyCompeteWantToView alloc]init];
//        [self.contentView addSubview:_wantToView];
//        [_wantToView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.contentView).offset(-10);
//            make.height.mas_offset(15);
//            make.left.right.equalTo(self.contentView);
//        }];
//    }
//    return _wantToView;
//}

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

- (JHMyCompeteGoodsTagView *)goodsTagView
{
    if (!_goodsTagView) {
        _goodsTagView = [[JHMyCompeteGoodsTagView alloc]init];
        [self.contentView addSubview:_goodsTagView];
//        [_goodsTagView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(6);
//            make.left.right.equalTo(self.contentView).offset(8);
//            make.height.mas_offset(16);
//        }];
        
    }
    return _goodsTagView;
}

- (void)immediatePaymentButtonAction:(UIButton *)btn{
    //跳转 商品详情页 待付款订单详情页
//    if ([btn.titleLabel.text isEqualToString:@"立即付款"]) {
//
//    }else{
//        JHC2CProductDetailController *detailVC = [[JHC2CProductDetailController alloc] init];
//        detailVC.productId = [NSString stringWithFormat:@"%ld",_myCompeteModel.productId];
//        [[self getCurrentVC].navigationController pushViewController:detailVC animated:YES];
//    }
    
    BOOL isPay = [btn.titleLabel.text isEqualToString:@"立即付款"] ? YES:NO;
    if (_buttonActionBlock) {
        _buttonActionBlock(_myCompeteModel,isPay);
    }
}

#pragma mark -单刷数据
- (void)reloadCurrentCellData{
//    NSDictionary *param = @{
//        @"productId":@(_myCompeteModel.productId)
//    };
//    @weakify(self);
//    [JHMyCompeteViewModel reLoadMyAcutionStatus:param completion:^(NSError * _Nullable error, JHMyCompeteModel * _Nonnull model) {
//        @strongify(self);
//        if (model) {
//            self.myCompeteModel = model;
//        }
//    }];
}

@end
