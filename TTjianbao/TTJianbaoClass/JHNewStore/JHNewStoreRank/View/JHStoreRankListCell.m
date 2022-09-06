//
//  JHStoreRankListCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreRankListCell.h"
#import "JHStoreGoodsView.h"
#import "UIImageView+WebCache.h"
#import "JHStoreRankListModel.h"
#import "JHStoreRankListViewModel.h"
#import "SVProgressHUD.h"
#import "JHNewShopDetailViewController.h"

#define cellWidth (ScreenW - 44.f - 12 * 3) / 4

@interface JHStoreRankListCell()
/** 背景View*/
@property (nonatomic, strong) UIView *backView;
/** 排名logo*/
@property (nonatomic, strong) UIImageView *rankImageView;
/** 排名数字*/
@property (nonatomic, strong) UILabel *rankLabel;
/** 头像*/
@property (nonatomic, strong) YYAnimatedImageView *iconImageView;
/** 店铺名字*/
@property (nonatomic, strong) UILabel *storeNameLabel;
/** 粉丝数量*/
@property (nonatomic, strong) UILabel *fansCountLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
/** 好评度*/
@property (nonatomic, strong) UILabel *highPraiseLabel;
/** 关注按钮*/
@property (nonatomic, strong) UIButton *followButton;
/** 进入店铺*/
@property (nonatomic, strong) UIButton *enterStoreButton;
/** slogan*/
@property (nonatomic, strong) UIView *sloganView;
/** 左引号*/
@property (nonatomic, strong) UIImageView *leftMarksImageView;
/** 标语*/
@property (nonatomic, strong) UILabel *sloganLabel;
/** 右引号*/
@property (nonatomic, strong) UIImageView *rightMarksImageView;
/** 店铺商品*/
@property (nonatomic, strong) JHStoreGoodsView *goodsView;
@end
@implementation JHStoreRankListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHStoreRankListModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.shopLogoImg] placeholderImage:[UIImage imageNamed:@"newStore_default_avatar_placehold"]];
    self.storeNameLabel.text = model.shopName;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%@粉丝", model.followNum];
    self.highPraiseLabel.text = [NSString stringWithFormat:@"%.2f%%好评度", model.orderGrades.doubleValue * 100];
    self.followButton.selected = model.followed.boolValue;
    self.sloganLabel.text =  model.shopDesc;
    self.goodsView.goodsArray = model.productList;
    
    if (model.shopDesc.length == 0) {
        [self.sloganView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else {
        [self.sloganView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
        }];
    }
    
    if (model.productList.count > 0) {
        [self.goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(cellWidth + 60 + 10);
        }];
    }else {
        [self.goodsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    self.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    switch (indexPath.row) {
        case 0:
            self.rankImageView.image = [UIImage imageNamed:@"jh_newStore_rank_one"];
            break;
        case 1:
            self.rankImageView.image = [UIImage imageNamed:@"jh_newStore_rank_two"];
            break;
        case 2:
            self.rankImageView.image = [UIImage imageNamed:@"jh_newStore_rank_three"];
            break;
        default:
            self.rankImageView.image = [UIImage imageNamed:@"jh_newStore_rank_four"];
            break;
    }
}

// 关注
- (void)followButtonClickAction:(UIButton *)sender {
    if (IS_LOGIN) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"shopId"] = self.model.storeId;
        params[@"type"] = self.followButton.selected ? @"0" : @"1";
        [SVProgressHUD show];
        self.followButton.enabled = NO;
        [JHStoreRankListViewModel followStoreRequest:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
            [SVProgressHUD dismiss];
            self.followButton.enabled = YES;
            if (!error) {
                self.followButton.selected = !self.followButton.selected;
                JHTOAST(self.followButton.selected ? @"关注成功~" : @"取消关注成功~");
                self.model.followed = self.followButton.selected ? @"1" : @"0";
                self.model.followNum = [NSString stringWithFormat:@"%ld", self.followButton.selected ? self.model.followNum.integerValue + 1 : self.model.followNum.integerValue - 1];
                self.fansCountLabel.text = [NSString stringWithFormat:@"%@粉丝", self.model.followNum];
            }else {
                 
            }
        }];
    }
}

// 进入店铺
- (void)enterStoreButtonClickAction:(UIButton *)sender {
    JHNewShopDetailViewController *detailVc = [[JHNewShopDetailViewController alloc] init];
    detailVc.shopId = self.model.storeId;
    [self.viewController.navigationController pushViewController:detailVc animated:YES];
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.rankImageView];
    [self.rankImageView addSubview:self.rankLabel];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.storeNameLabel];
    [self.backView addSubview:self.fansCountLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.highPraiseLabel];
    [self.backView addSubview:self.followButton];
    [self.backView addSubview:self.enterStoreButton];
    [self.backView addSubview:self.sloganView];
    [self.sloganView addSubview:self.leftMarksImageView];
    [self.sloganView addSubview:self.sloganLabel];
    [self.sloganView addSubview:self.rightMarksImageView];
    [self.backView addSubview:self.goodsView];
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(3);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(4);
        make.top.mas_equalTo(self.contentView);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(29);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rankImageView.mas_centerX);
        make.centerY.mas_equalTo(self.rankImageView.mas_centerY).offset(-2);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.top.mas_equalTo(self.backView).offset(12);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(46);
    }];
    
    [self.enterStoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView).offset(-10);
        make.top.mas_equalTo(self.backView).offset(23);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(56);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.enterStoreButton.mas_left).offset(-8);
        make.top.mas_equalTo(self.backView).offset(23);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(42);
    }];
    
    [self.storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(8);
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(3);
        make.height.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(self.followButton.mas_left).offset(-10);
    }];
    
    [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(8);
        make.top.mas_equalTo(self.storeNameLabel.mas_bottom).offset(3);
        make.height.mas_equalTo(16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fansCountLabel.mas_right).offset(6);
        make.centerY.mas_equalTo(self.fansCountLabel.mas_centerY);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(0.5);
    }];
    
    [self.highPraiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right).offset(6);
        make.top.mas_equalTo(self.fansCountLabel.mas_top);
        make.height.mas_equalTo(16);
    }];
    
    [self.sloganView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(8);
        make.height.mas_equalTo(25);
        make.right.mas_lessThanOrEqualTo(self.backView).offset(-10);
    }];
    
    [self.leftMarksImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sloganView).offset(8);
        make.top.mas_equalTo(self.sloganView).offset(7);
        make.width.height.mas_equalTo(6);
    }];
    
    [self.rightMarksImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.sloganView).offset(-8);
        make.top.mas_equalTo(self.sloganView).offset(7);
        make.width.height.mas_equalTo(6);
    }];
    
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftMarksImageView.mas_right).offset(5);
        make.right.mas_equalTo(self.rightMarksImageView.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.sloganView);
    }];
    
    [self.goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView);
        make.top.mas_equalTo(self.sloganView.mas_bottom);
        make.right.mas_equalTo(self.backView);
        make.bottom.mas_equalTo(self.backView).offset(-10);
        make.height.mas_equalTo(cellWidth + 60 + 10);
    }];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)rankImageView {
    if (_rankImageView == nil) {
        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.image = [UIImage imageNamed:@"jh_newStore_rank_one"];
    }
    return _rankImageView;
}

- (UILabel *)rankLabel {
    if (_rankLabel == nil) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = HEXCOLOR(0xffffff);
        _rankLabel.font = [UIFont fontWithName:kFontBoldDIN size:18];
        _rankLabel.text = @"";
        _rankLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rankLabel;
}

- (YYAnimatedImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[YYAnimatedImageView alloc] init];
        _iconImageView.layer.cornerRadius = 23;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)storeNameLabel {
    if (_storeNameLabel == nil) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.textColor = HEXCOLOR(0x222222);
        _storeNameLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _storeNameLabel.text = @"";
    }
    return _storeNameLabel;
}

- (UILabel *)fansCountLabel {
    if (_fansCountLabel == nil) {
        _fansCountLabel = [[UILabel alloc] init];
        _fansCountLabel.textColor = HEXCOLOR(0x666666);
        _fansCountLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _fansCountLabel.text = @"";
    }
    return _fansCountLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xdadada);
    }
    return _lineView;
}

- (UILabel *)highPraiseLabel {
    if (_highPraiseLabel == nil) {
        _highPraiseLabel = [[UILabel alloc] init];
        _highPraiseLabel.textColor = HEXCOLOR(0x666666);
        _highPraiseLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _highPraiseLabel.text = @"";
    }
    return _highPraiseLabel;
}

- (UIButton *)followButton {
    if (_followButton == nil) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton setTitle:@"关注" forState:UIControlStateNormal];
        [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
        _followButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        [_followButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_followButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateSelected];
        _followButton.layer.cornerRadius = 2;
        _followButton.layer.borderColor = HEXCOLOR(0xcccccc).CGColor;
        _followButton.layer.borderWidth = 0.5;
        _followButton.clipsToBounds = YES;
        [_followButton addTarget:self action:@selector(followButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}

- (UIButton *)enterStoreButton {
    if (_enterStoreButton == nil) {
        _enterStoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterStoreButton setTitle:@"进入店铺" forState:UIControlStateNormal];
        _enterStoreButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        [_enterStoreButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _enterStoreButton.layer.cornerRadius = 2;
        _enterStoreButton.layer.borderColor = HEXCOLOR(0xffd70f).CGColor;
        _enterStoreButton.layer.borderWidth = 0.5;
        _enterStoreButton.clipsToBounds = YES;
        _enterStoreButton.backgroundColor = HEXCOLOR(0xfffbee);
        [_enterStoreButton addTarget:self action:@selector(enterStoreButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterStoreButton;
}

- (UIView *)sloganView {
    if (_sloganView == nil) {
        _sloganView = [[UIView alloc] init];
        _sloganView.backgroundColor = HEXCOLOR(0xfffcef);
        _sloganView.layer.cornerRadius = 2;
        _sloganView.clipsToBounds = YES;
    }
    return _sloganView;
}

- (UIImageView *)leftMarksImageView {
    if (_leftMarksImageView == nil) {
        _leftMarksImageView = [[UIImageView alloc] init];
        _leftMarksImageView.image = [UIImage imageNamed:@"jh_newStore_rank_left"];
    }
    return _leftMarksImageView;
}

- (UILabel *)sloganLabel {
    if (_sloganLabel == nil) {
        _sloganLabel = [[UILabel alloc] init];
        _sloganLabel.textColor = HEXCOLOR(0xbd965f);
        _sloganLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _sloganLabel.text = @"";
    }
    return _sloganLabel;
}

- (UIImageView *)rightMarksImageView {
    if (_rightMarksImageView == nil) {
        _rightMarksImageView = [[UIImageView alloc] init];
        _rightMarksImageView.image = [UIImage imageNamed:@"jh_newStore_rank_right"];
    }
    return _rightMarksImageView;
}

- (JHStoreGoodsView *)goodsView {
    if (_goodsView == nil) {
        _goodsView = [[JHStoreGoodsView alloc] init];
    }
    return _goodsView;
}
@end
