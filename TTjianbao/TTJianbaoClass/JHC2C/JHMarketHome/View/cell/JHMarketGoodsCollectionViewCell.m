//
//  JHMarketGoodsCollectionViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketGoodsCollectionViewCell.h"
#import "UILabel+edgeInsets.h"
#import "JHStoreHelp.h"

@interface JHMarketGoodsCollectionViewCell ()
///商品图
@property (nonatomic, strong) UIImageView *goodsImgView;
///鉴定标签
@property (nonatomic, strong) UIImageView *identifyTagImgView;
///商品标题
@property (nonatomic, strong) UILabel *goodsTitleLabel;
///拍卖中标签
@property (nonatomic, strong) UILabel *auctionLabel;
///商品标签
@property (nonatomic, strong) UIView *goodsTagView;

@property (nonatomic, strong) UIStackView *moneyStackView;
///价格
@property (nonatomic, strong) UILabel *redPriceLabel;
///出价人数
@property (nonatomic, strong) UILabel *bidNumLabel;
///用户头像
@property (nonatomic, strong) UIImageView *userImgView;
///用户信息
@property (nonatomic, strong) UIStackView *userStackView;
///用户名称
@property (nonatomic, strong) UILabel *userNameLable;
///想要人数
@property (nonatomic, strong) UILabel *wantNumLable;
/// 是否有视频标识
@property (nonatomic, strong) UIImageView *videoIcon;

@end

@implementation JHMarketGoodsCollectionViewCell

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
        make.height.mas_offset(180);
    }];
    //鉴定标签
    [self.contentView addSubview:self.identifyTagImgView];
    [self.identifyTagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImgView);
        make.left.equalTo(self.goodsImgView).offset(5);
        make.width.mas_offset(22);
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
        make.top.equalTo(self.goodsTitleLabel.mas_bottom).offset(9);
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(16);
    }];
    NSArray *tagsArray = @[@"包邮",@"即将截拍"];
    UILabel *firstLabel;
    for (int i = 0; i < tagsArray.count; i++) {
        UILabel *goodsTagLabel = [[UILabel alloc] init];
        goodsTagLabel.font = JHFont(10);
        goodsTagLabel.textColor = HEXCOLOR(0xF23730);
        goodsTagLabel.text = tagsArray[i];
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
    [self.contentView addSubview:self.moneyStackView];
    [self.moneyStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsTagView.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
    }];
    
    //用户头像
    [self.contentView addSubview:self.userImgView];
    [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyStackView.mas_bottom).offset(11);
        make.left.equalTo(self.contentView).offset(8);
        make.size.mas_offset(CGSizeMake(12, 12));
    }];
    //用户名称等
    [self.contentView addSubview:self.userStackView];
    [self.userStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImgView.mas_right).offset(3);
        make.centerY.equalTo(self.userImgView);
        make.right.equalTo(self.contentView).offset(-8);

    }];
    
    //视频标识
    [self.contentView addSubview:self.videoIcon];
    [self.videoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.width.height.mas_equalTo(25.f);
    }];
    
    [JHStoreHelp setNewPrice:isEmpty(self.redPriceLabel.text)?@"--":self.redPriceLabel.text forLabel:self.redPriceLabel Color:HEXCOLOR(0xF23730)];
}

#pragma mark - LoadData
- (void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
    _videoIcon.hidden = _videoUrl.length > 1 ? NO :YES;
}

#pragma mark - Lazy
- (UIImageView *)goodsImgView{
    if (!_goodsImgView) {
        _goodsImgView = [[UIImageView alloc] init];
        _goodsImgView.image = JHImageNamed(@"totalHeader_bg");
    }
    return _goodsImgView;
}

- (UIImageView *)identifyTagImgView{
    if (!_identifyTagImgView) {
        _identifyTagImgView = [[UIImageView alloc] init];
        _identifyTagImgView.image = JHImageNamed(@"c2c_goods_gongyipin_icon");
    }
    return _identifyTagImgView;
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
    }
    return _auctionLabel;
}
- (UILabel *)goodsTitleLabel{
    if (!_goodsTitleLabel) {
        _goodsTitleLabel = [[UILabel alloc] init];
        _goodsTitleLabel.font = JHFont(14);
        _goodsTitleLabel.textColor = HEXCOLOR(0x333333);
        _goodsTitleLabel.numberOfLines = 2;
        _goodsTitleLabel.text = @"          创汇时期 三彩马摆件创汇时期 三彩马摆件";//10个空格
    }
    return _goodsTitleLabel;
}
- (UIView *)goodsTagView{
    if (!_goodsTagView) {
        _goodsTagView = [[UIView alloc] init];
    }
    return _goodsTagView;
}
- (UIStackView *)moneyStackView {
    if (!_moneyStackView) {
        _moneyStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.redPriceLabel, self.bidNumLabel]];
        _moneyStackView.axis = UILayoutConstraintAxisHorizontal;;
        _moneyStackView.spacing = 4;
    }
    return _moneyStackView;
}
- (UILabel *)redPriceLabel{
    if (!_redPriceLabel) {
        _redPriceLabel = [[UILabel alloc] init];
        _redPriceLabel.font = JHDINBoldFont(18);
        _redPriceLabel.textColor = HEXCOLOR(0xF23730);
        _redPriceLabel.text = @"¥123456789";
        [_redPriceLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _redPriceLabel;
}

- (UILabel *)bidNumLabel{
    if (!_bidNumLabel) {
        _bidNumLabel = [[UILabel alloc] init];
        _bidNumLabel.font = JHFont(10);
        _bidNumLabel.textColor = HEXCOLOR(0x999999);
        _bidNumLabel.text = @"已出价999次";
        [_bidNumLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    }
    return _bidNumLabel;
}
- (UIImageView *)userImgView{
    if (!_userImgView) {
        _userImgView = [[UIImageView alloc] init];
        _userImgView.image = JHImageNamed(@"newStore_default_avatar_placehold");
    }
    return _userImgView;
}
- (UIStackView *)userStackView {
    if (!_userStackView) {
        _userStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.userNameLable, self.wantNumLable]];
        _userStackView.axis = UILayoutConstraintAxisHorizontal;;
        _userStackView.spacing = 4;
    }
    return _userStackView;
}
- (UILabel *)userNameLable{
    if (!_userNameLable) {
        _userNameLable = [[UILabel alloc] init];
        _userNameLable.font = JHFont(10);
        _userNameLable.textColor = HEXCOLOR(0x999999);
        _userNameLable.text = @"失眠先生";
        [_userNameLable setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _userNameLable;
}

- (UILabel *)wantNumLable{
    if (!_wantNumLable) {
        _wantNumLable = [[UILabel alloc] init];
        _wantNumLable.font = JHFont(10);
        _wantNumLable.textColor = HEXCOLOR(0x999999);
        _wantNumLable.text = @"2942149人想要";
        _wantNumLable.textAlignment = NSTextAlignmentRight;
        [_wantNumLable setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _wantNumLable;
}

- (UIImageView *)videoIcon{
    if (!_videoIcon) {
        _videoIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jh_newStore_hasVideo"]];
    }
    return _videoIcon;
}



@end

