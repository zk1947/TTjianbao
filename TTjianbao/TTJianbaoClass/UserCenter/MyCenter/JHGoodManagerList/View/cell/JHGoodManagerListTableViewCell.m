//
//  JHGoodManagerListTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/8/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListTableViewCell.h"
#import "JHGoodManagerListInfoAlertView.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"
#import "JHGoodManagerListBusiness.h"
#import "JHBusinessPublishGoodsController.h"
#import "JHContendRecordListAlert.h"
#import "JHGoodManagerSingleton.h"
#import "YDCountDown.h"
#import "UIButton+LXExpandBtn.h"

@interface JHGoodManagerListButtonsItemCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
- (void)setViewModel:(NSString *)viewModel;
@end
@implementation JHGoodManagerListButtonsItemCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *backView = [[UIView alloc] init];
    backView.layer.cornerRadius  = 15.f;
    backView.layer.masksToBounds = YES;
    backView.layer.borderWidth   = 0.5f;
    backView.layer.borderColor   = HEXCOLOR(0xBDBFC2).CGColor;
    backView.backgroundColor     = HEXCOLOR(0xFFFFFF);
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f));
        make.height.mas_equalTo(30.f);
    }];
    
    _titleLabel               = [[UILabel alloc] init];
    _titleLabel.textColor     = HEXCOLOR(0x333333);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [backView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(16.f);
        make.right.equalTo(backView.mas_right).offset(-16.f);
        make.height.mas_equalTo(30.f);
        make.bottom.equalTo(backView.mas_bottom);
    }];
}

- (void)setViewModel:(NSString *)viewModel {
    self.titleLabel.text = NONNULL_STR(viewModel);
    [self.contentView setTransform:CGAffineTransformMakeScale(-1,1)];
}

@end





@interface JHGoodManagerListTableViewCell ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UILabel                *goodNumLabel;
@property (nonatomic, strong) UIButton               *ccopyBtn;
@property (nonatomic, strong) UILabel                *statusLabel;
@property (nonatomic, strong) UIView                 *lineView;
@property (nonatomic, strong) UIImageView            *goodImageView;
@property (nonatomic, strong) UILabel                *onlyOneSignLabel;
@property (nonatomic, strong) UILabel                *goodNameLabel;
/// 一口价相关
@property (nonatomic, strong) UILabel                *sendOnceReservedLabel;/// 库存
@property (nonatomic, strong) UILabel                *sendOnceSellMoneyLabel;/// 售价
@property (nonatomic, strong) UILabel                *timeLabel;/// 发布时间
@property (nonatomic, strong) UILabel                *reasonLabel;/// 审核原因
@property (nonatomic, strong) UICollectionView       *buttonCollectionView;/// 按钮
@property (nonatomic, strong) NSMutableArray         *buttonArray;/// 按钮数组
/// 拍卖相关
@property (nonatomic, strong) UILabel                *auctionStartMoneyLabel;/// 起拍价格
@property (nonatomic, strong) UILabel                *finishTimeLabel;/// 距离结束时间
@property (nonatomic, strong) JHGoodManagerListModel *listItemModel;
@property (nonatomic, strong) YDCountDown            *countDown;
@end


@implementation JHGoodManagerListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_countDown) {
            _countDown = [[YDCountDown alloc] init];
        }
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttonArray;
}

- (void)setupViews {
    /// 商品编码
    _goodNumLabel               = [[UILabel alloc] init];
    _goodNumLabel.textColor     = HEXCOLOR(0x333333);
    _goodNumLabel.textAlignment = NSTextAlignmentLeft;
    _goodNumLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _goodNumLabel.text          = @"商品编码：";
    [self.contentView addSubview:_goodNumLabel];
    [_goodNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    /// 复制按钮
    _ccopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ccopyBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:11.f];
    [_ccopyBtn setTitle:@"复制" forState:UIControlStateNormal];
    [_ccopyBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_ccopyBtn addTarget:self action:@selector(ccopyBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _ccopyBtn.layer.cornerRadius  = 7.39f;
    _ccopyBtn.layer.masksToBounds = YES;
    _ccopyBtn.layer.borderWidth   = 0.5f;
    _ccopyBtn.layer.borderColor   = HEXCOLOR(0xFEE100).CGColor;
    _ccopyBtn.backgroundColor     = HEXCOLORA(0xFEE100, 0.2f);
    _ccopyBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-5.f, -5.f, -5.f, -5.f);
    [self.contentView addSubview:_ccopyBtn];
    [_ccopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodNumLabel.mas_right).offset(7.f);
        make.centerY.equalTo(self.goodNumLabel.mas_centerY);
        make.width.mas_equalTo(35.f);
        make.height.mas_equalTo(15.f);
    }];
    
    /// 状态
    _statusLabel               = [[UILabel alloc] init];
    _statusLabel.textColor     = HEXCOLOR(0xFF4200);
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodNumLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
    }];
    
    /// 横划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0xF0F0F0);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.top.equalTo(self.goodNumLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(1.f);
    }];
    
    /// 商品图
    _goodImageView = [[UIImageView alloc] init];
    _goodImageView.image = [UIImage imageNamed:@"newStore_detail_shopProduct_Placeholder"];
    _goodImageView.layer.cornerRadius  = 4.f;
    _goodImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_goodImageView];
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.lineView.mas_bottom).offset(7.f);
        make.width.height.mas_equalTo(75.f);
    }];
    
    
    /// 孤品标识
    _onlyOneSignLabel                     = [[UILabel alloc] init];
    _onlyOneSignLabel.textColor           = HEXCOLOR(0xFFFFFF);
    _onlyOneSignLabel.textAlignment       = NSTextAlignmentCenter;
    _onlyOneSignLabel.font                = [UIFont fontWithName:kFontNormal size:12.f];
    _onlyOneSignLabel.text                = @"孤品";
    _onlyOneSignLabel.layer.cornerRadius  = 2.f;
    _onlyOneSignLabel.layer.masksToBounds = YES;
    _onlyOneSignLabel.backgroundColor     = HEXCOLOR(0xA3783F);
    [self.contentView addSubview:_onlyOneSignLabel];
    [_onlyOneSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodImageView.mas_bottom).offset(-5.f);
        make.left.equalTo(self.goodImageView.mas_left).offset(5.f);
        make.width.mas_equalTo(28.f);
        make.height.mas_equalTo(15.f);
    }];
    
    /// 商品名称
    _goodNameLabel               = [[UILabel alloc] init];
    _goodNameLabel.textColor     = HEXCOLOR(0x333333);
    _goodNameLabel.textAlignment = NSTextAlignmentLeft;
    _goodNameLabel.font          = [UIFont fontWithName:kFontMedium size:14.f];
    [self.contentView addSubview:_goodNameLabel];
    [_goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(9.f);
        make.left.equalTo(self.goodImageView.mas_right).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(20.f);
    }];
    
    
    /// 一口价
    /// 库存
    _sendOnceReservedLabel               = [[UILabel alloc] init];
    _sendOnceReservedLabel.textColor     = HEXCOLOR(0x999999);
    _sendOnceReservedLabel.textAlignment = NSTextAlignmentLeft;
    _sendOnceReservedLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _sendOnceReservedLabel.text          = @"库存：";
    [self.contentView addSubview:_sendOnceReservedLabel];
    [_sendOnceReservedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodImageView.mas_centerY);
        make.left.equalTo(self.goodImageView.mas_right).offset(10.f);
    }];
    
    
    /// 售价
    _sendOnceSellMoneyLabel               = [[UILabel alloc] init];
    _sendOnceSellMoneyLabel.textColor     = HEXCOLOR(0x999999);
    _sendOnceSellMoneyLabel.textAlignment = NSTextAlignmentLeft;
    _sendOnceSellMoneyLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _sendOnceSellMoneyLabel.text          = @"售价：";
    [self.contentView addSubview:_sendOnceSellMoneyLabel];
    [_sendOnceSellMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goodImageView.mas_centerY);
        make.left.equalTo(self.sendOnceReservedLabel.mas_right).offset(20.f);
    }];
    
    
    /// 拍卖
    /// 起拍价
    _auctionStartMoneyLabel               = [[UILabel alloc] init];
    _auctionStartMoneyLabel.textColor     = HEXCOLOR(0x999999);
    _auctionStartMoneyLabel.textAlignment = NSTextAlignmentLeft;
    _auctionStartMoneyLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _auctionStartMoneyLabel.text          = @"起拍价：";
    [self.contentView addSubview:_auctionStartMoneyLabel];
    [_auctionStartMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodNameLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.goodNameLabel.mas_left);
        make.height.mas_equalTo(17.f);
    }];
        
    /// 拍卖 - 距离结束时间
    _finishTimeLabel               = [[UILabel alloc] init];
    _finishTimeLabel.textColor     = HEXCOLOR(0x999999);
    _finishTimeLabel.textAlignment = NSTextAlignmentLeft;
    _finishTimeLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_finishTimeLabel];
    [_finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.auctionStartMoneyLabel.mas_bottom).offset(8.f);
        make.left.equalTo(self.goodNameLabel.mas_left);
        make.height.mas_equalTo(17.f);
    }];
    
    /// 发布时间
    _timeLabel               = [[UILabel alloc] init];
    _timeLabel.textColor     = HEXCOLOR(0x999999);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _timeLabel.text          = @"发布时间：";
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.finishTimeLabel.mas_bottom).offset(8.f);
        make.left.equalTo(self.goodImageView.mas_right).offset(10.f);
        make.height.mas_equalTo(17.f);
    }];
    
    
    /// 禁售原因
    _reasonLabel                     = [[UILabel alloc] init];
    _reasonLabel.textColor           = HEXCOLOR(0x999999);
    _reasonLabel.textAlignment       = NSTextAlignmentLeft;
    _reasonLabel.font                = [UIFont fontWithName:kFontNormal size:12.f];
    _reasonLabel.layer.cornerRadius  = 2.f;
    _reasonLabel.layer.masksToBounds = YES;
    _reasonLabel.backgroundColor     = HEXCOLOR(0xFFFAF2);
    [self.contentView addSubview:_reasonLabel];
    [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(12.f);
        make.left.equalTo(self.goodImageView.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.height.mas_equalTo(29.f);
    }];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 6.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.estimatedItemSize = CGSizeMake(68.f, 30.f);
    _buttonCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 20.f, 31.f) collectionViewLayout:flowLayout];
    _buttonCollectionView.delegate = self;
    _buttonCollectionView.dataSource = self;
    _buttonCollectionView.backgroundColor = HEXCOLOR(0xFFFFFF);
    _buttonCollectionView.showsHorizontalScrollIndicator = NO;
    /// 从右向左排列
    _buttonCollectionView.transform = CGAffineTransformMakeScale(-1,1);
    [_buttonCollectionView registerClass:[JHGoodManagerListButtonsItemCollectionViewCell class] forCellWithReuseIdentifier:@"JHGoodManagerListButtonsItemCollectionViewCell"];
    [self.contentView addSubview:_buttonCollectionView];
    [_buttonCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reasonLabel.mas_bottom).offset(10.f);
        make.right.equalTo(self.contentView.mas_right).offset(-10.f);
        make.left.equalTo(self.contentView.mas_left);
        make.height.mas_equalTo(31.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];

}

/// 复制
- (void)ccopyBtnClickAction:(UIButton *)btn {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (!isEmpty(self.listItemModel.productSn)) {
        [pasteboard setString:self.listItemModel.productSn];
        [UITipView showTipStr:@"复制成功"];
    } else {
        [UITipView showTipStr:@"复制失败"];
    }
}

#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.buttonArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodManagerListButtonsItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHGoodManagerListButtonsItemCollectionViewCell" forIndexPath:indexPath];
    [cell setViewModel:self.buttonArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = self.buttonArray[indexPath.row];
    if ([str isEqualToString:@"上架"]) {
        if (self.listItemModel.productType == JHGoodManagerListRequestProductType_Auction) {
            JHGoodManagerListInfoAlertView *alert = [[JHGoodManagerListInfoAlertView alloc]
                                                     initWithTitle:@"确认上架商品信息"
                                                     cancleBtnTitle:@"取消"
                                                     sureBtnTitle:@"确认上架"
                                                     itemModel:self.listItemModel];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                JHGoodManagerListItemPutOnRequestModel *putOnModel = [[JHGoodManagerListItemPutOnRequestModel alloc] init];
                putOnModel.productId                               = self.listItemModel.goodId;
                putOnModel.productType                             = JHGoodManagerListRequestProductType_Auction;
                
                /// 拍卖上架
                /// 起拍价
                if (!isEmpty([JHGoodManagerSingleton shared].startAuctionPrice)) {
                    putOnModel.startPrice = [JHGoodManagerSingleton shared].startAuctionPrice;
                } else {
                    [UITipView showTipStr:@"请输入起拍价"];
                    return;
                }
                
                /// 加价幅度
                if (!isEmpty([JHGoodManagerSingleton shared].addAuctionPrice)) {
                    putOnModel.bidIncrement = [JHGoodManagerSingleton shared].addAuctionPrice;
                } else {
                    [UITipView showTipStr:@"请输入加价幅度"];
                    return;
                }
                
                /// 保证金
                if (!isEmpty([JHGoodManagerSingleton shared].sureMoney)) {
                    putOnModel.earnestMoney = [JHGoodManagerSingleton shared].sureMoney;
                } else {
                    putOnModel.earnestMoney = nil;
                }
                
                if ([[JHGoodManagerSingleton shared].putOnType isEqualToString:@"0"]) {
                    /// 立即上架
                    putOnModel.productStatus = 0;
                    if (!isEmpty([JHGoodManagerSingleton shared].auctionDuration)) {
                        putOnModel.auctionLastTime = [JHGoodManagerSingleton shared].auctionDuration;
                    } else {
                        [UITipView showTipStr:@"请选择持续时间"];
                        return;
                    }
                }
                
                if ([[JHGoodManagerSingleton shared].putOnType isEqualToString:@"3"]) {
                    /// 指定时间上架
                    putOnModel.productStatus = 3;
                    if (!isEmpty([JHGoodManagerSingleton shared].auctionStartTime)) {
                        putOnModel.auctionStartTime = [JHGoodManagerSingleton shared].auctionStartTime;
                    } else {
                        [UITipView showTipStr:@"请选择开始时间"];
                        return;
                    }
                    
                    if (!isEmpty([JHGoodManagerSingleton shared].auctionDuration)) {
                        putOnModel.auctionLastTime = [JHGoodManagerSingleton shared].auctionDuration;
                    } else {
                        [UITipView showTipStr:@"请选择持续时间"];
                        return;
                    }
                }
                [JHGoodManagerListBusiness putOnGood:putOnModel Completion:^(NSError * _Nullable error) {
                    @strongify(self);
                    if (!error) {
                        [[UIApplication sharedApplication].keyWindow makeToast:@"操作成功！" duration:0.7f position:CSToastPositionCenter];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST——ONLYNAV" object:nil];
                        if ([JHGoodManagerSingleton shared].navProductStatus == JHGoodManagerListRequestProductStatus_ALL) {
                            [self changeGoodOnly];
                        } else {
                            [self endingStatus];
                        }
                    } else {
                        [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:0.7f position:CSToastPositionCenter];
                    }

                }];
            };
        } else {
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"确认上架该商品吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                JHGoodManagerListItemPutOnRequestModel *putOnModel = [[JHGoodManagerListItemPutOnRequestModel alloc] init];
                putOnModel.productId                               = self.listItemModel.goodId;
                putOnModel.productType                             = JHGoodManagerListRequestProductType_OnePrice;
                [JHGoodManagerListBusiness putOnGood:putOnModel Completion:^(NSError * _Nullable error) {
                    @strongify(self);
                    if (!error) {
                        [[UIApplication sharedApplication].keyWindow makeToast:@"操作成功！" duration:0.7f position:CSToastPositionCenter];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST——ONLYNAV" object:nil];
                        if ([JHGoodManagerSingleton shared].navProductStatus == JHGoodManagerListRequestProductStatus_ALL) {
                            [self changeGoodOnly];
                        } else {
                            [self endingStatus];
                        }
                    } else {
                        [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:0.7f position:CSToastPositionCenter];
                    }

                }];
            };
        }
    } else if ([str isEqualToString:@"编辑"]) {
        JHBusinessPublishGoodsController *vc = [[JHBusinessPublishGoodsController alloc] initWithPublishProductId:self.listItemModel.goodId];
        @weakify(self);
        vc.successBlock = ^(int productStatus) {
            @strongify(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST——ONLYNAV" object:nil];
            if ([JHGoodManagerSingleton shared].navProductStatus == JHGoodManagerListRequestProductStatus_ALL) {
                [self changeGoodOnly];
            } else if ([JHGoodManagerSingleton shared].navProductStatus == productStatus) {
                [self changeGoodOnly];
            } else {
                [self endingStatus];
            }
        };
        [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    } else if ([str isEqualToString:@"删除"]) {
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"确认删除该商品吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        @weakify(self);
        alert.handle = ^{
            @strongify(self);
            [JHGoodManagerListBusiness deleteGood:self.listItemModel.goodId Completion:^(NSError * _Nullable error) {
                @strongify(self);
                if (!error) {
                    [[UIApplication sharedApplication].keyWindow makeToast:@"操作成功！" duration:0.7f position:CSToastPositionCenter];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST——ONLYNAV" object:nil];
                    [self endingStatus];
                } else {
                    [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:0.7f position:CSToastPositionCenter];
                }
            }];
        };
    } else if ([str isEqualToString:@"下架"]) {
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"确认下架该商品吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        @weakify(self);
        alert.handle = ^{
            @strongify(self);
            [JHGoodManagerListBusiness goodOffTheShelf:self.listItemModel.goodId Completion:^(NSError * _Nullable error) {
                @strongify(self);
                if (!error) {
                    [[UIApplication sharedApplication].keyWindow makeToast:@"操作成功！" duration:0.7f position:CSToastPositionCenter];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST——ONLYNAV" object:nil];
                    if ([JHGoodManagerSingleton shared].navProductStatus == JHGoodManagerListRequestProductStatus_ALL) {
                        [self changeGoodOnly];
                    } else {
                        [self endingStatus];
                    }
                } else {
                    [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:0.7f position:CSToastPositionCenter];
                }
            }];
        };
        
    } else if ([str isEqualToString:@"查看竞价记录"]) {
        JHContendRecordListAlert *vc = [[JHContendRecordListAlert alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-116, 313)];
        vc.productID = self.listItemModel.auctionSn;
        [vc showAlert];
    }
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)endingStatus {
    UITableViewCell *cell = (UITableViewCell *)[[self.goodNumLabel superview] superview];
    NSIndexPath     *path = [[self tableView] indexPathForCell:cell];
    if (path) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST——REMOVECELL" object:path];
    }
}

- (void)changeGoodOnly {
    UITableViewCell *cell = (UITableViewCell *)[[self.goodNumLabel superview] superview];
    NSIndexPath     *path = [[self tableView] indexPathForCell:cell];
    if (path) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JHGOODMANAGERLISTSHOULDREQUEST——CHANGEGOODCELL" object:path];
    }
}

- (JHGoodManagerListModel *)listItemModel {
    if (!_listItemModel) {
        _listItemModel = [[JHGoodManagerListModel alloc] init];
    }
    return _listItemModel;
}


- (void)setViewModel:(JHGoodManagerListModel *)viewModel {
    self.listItemModel = viewModel;
    [self.countDown destoryTimer];
    /// 商品编码
    if (!isEmpty(viewModel.productSn)) {
        self.goodNumLabel.text  = [NSString stringWithFormat:@"商品编码：%@",viewModel.productSn];
    }
    /// 商品状态
    self.statusLabel.text = NONNULL_STR(viewModel.productStatusStr);
    /// 商品图片
    JHGoodManagerListImageModel *imgModel = viewModel.mainImageUrls[0];
    [self.goodImageView jhSetImageWithURL:[NSURL URLWithString:imgModel.medium] placeholder:[UIImage imageNamed:@"newStore_detail_shopProduct_Placeholder"]];
    /// 孤品标识
    if (viewModel.uniqueStatus == JHGoodManagerListGoodUniqueStatus_OnlyOne) {
        self.onlyOneSignLabel.hidden = NO;
    } else {
        self.onlyOneSignLabel.hidden = YES;
    }
    /// 商品名称
    self.goodNameLabel.text = NONNULL_STR(viewModel.productName);
    if (viewModel.productType == JHGoodManagerListRequestProductType_OnePrice) {
        /// 一口价 - 库存
        self.sendOnceReservedLabel.text       = [NSString stringWithFormat:@"库存：%ld",(long)viewModel.sellStock];
        /// 一口价 - 售价
        self.sendOnceSellMoneyLabel.attributedText = [self setRedMoney:@"售价：" money:isEmpty(viewModel.priceYuan)?@"0":viewModel.priceYuan];
       
        self.sendOnceReservedLabel.hidden     = NO;
        self.sendOnceSellMoneyLabel.hidden    = NO;

        self.auctionStartMoneyLabel.hidden    = YES;
        
        [self.finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.auctionStartMoneyLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0.f);
        }];
        self.finishTimeLabel.hidden = YES;

        /// 发布时间
        self.timeLabel.text   = [NSString stringWithFormat:@"发布时间：%@",NONNULL_STR(viewModel.createTime)];
        
        
    } else if (viewModel.productType == JHGoodManagerListRequestProductType_Auction) {
        /// 拍卖 - 起拍价
        self.auctionStartMoneyLabel.attributedText = [self setRedMoney:@"起拍价：" money:isEmpty(viewModel.startPriceYuan)?@"0":viewModel.startPriceYuan];

        self.auctionStartMoneyLabel.hidden    = NO;
        self.sendOnceReservedLabel.hidden     = YES;
        self.sendOnceSellMoneyLabel.hidden    = YES;
        
        /// 拍卖 - 结束倒计时
        self.finishTimeLabel.hidden = NO;
        self.finishTimeLabel.attributedText = nil;
        self.finishTimeLabel.text = nil;
        
        if (viewModel.countdownTimeMillis >0) {
            /// 当前时间 = 结束时间 - 剩余时间
            long nowTime = [viewModel.auctionEndTime longValue] - viewModel.countdownTimeMillis/1000;
            [self countDownInfo:nowTime end:[viewModel.auctionEndTime longValue]];
            [self.finishTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.auctionStartMoneyLabel.mas_bottom).offset(8.f);
                make.height.mas_equalTo(17.f);
            }];
        } else {
            self.finishTimeLabel.text   = @"";
            [self.finishTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.auctionStartMoneyLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }

        if (!isEmpty(viewModel.createTime)) {
            /// 发布时间
            self.timeLabel.text = [NSString stringWithFormat:@"发布时间：%@",viewModel.createTime];
            [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.finishTimeLabel.mas_bottom).offset(8.f);
                make.height.mas_equalTo(17.f);
            }];
        } else {
            self.timeLabel.text = @"";
            [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.finishTimeLabel.mas_bottom).offset(8.f);
                make.height.mas_equalTo(17.f);
            }];
        }
    }
    
    /// 先判断拒绝，无拒绝就判断禁售原因
    if (!isEmpty(viewModel.refuseReason)) {
        self.reasonLabel.text = [NSString stringWithFormat:@"  商品违规：%@",viewModel.refuseReason];
        [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(12.f);
            make.height.mas_equalTo(29.f);
        }];
    } else {
        /// 判断禁售
        if (!isEmpty(viewModel.forbidSellReason)) {
            self.reasonLabel.text = [NSString stringWithFormat:@"  禁售原因：%@",viewModel.forbidSellReason];
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeLabel.mas_bottom).offset(12.f);
                make.height.mas_equalTo(29.f);
            }];
        } else {
            self.reasonLabel.text = @"";
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
    }

    /// 按钮数组
    [self.buttonArray removeAllObjects];
    if (viewModel.viewAuctionRecordFlag) {
        [self.buttonArray addObject: @"查看竞价记录"];
    }
    if (viewModel.downProductFlag) {
        [self.buttonArray addObject: @"下架"];
    }
    if (viewModel.upProductFlag) {
        [self.buttonArray addObject: @"上架"];
    }
    if (viewModel.updateFlag) {
        [self.buttonArray addObject: @"编辑"];
    }
    if (viewModel.deleteFlag) {
        [self.buttonArray addObject: @"删除"];
    }
    [self.buttonCollectionView reloadData];
}


- (void)countDownInfo:(long)start end:(long)end {
    @weakify(self);
    [self.countDown startWithbeginTimeStamp:start
                        finishTimeStamp:end
                          completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        @strongify(self);
        
        if (self.listItemModel.countdownTimeMillis >0) {
            self.finishTimeLabel.text = nil;
            self.finishTimeLabel.attributedText = [self setCountLableInfoStr:day hour:hour minute:minute second:second];
            if (day == 0 && hour==0 && minute == 0 && second == 0) {
                ///停止定时器
                [self.countDown destoryTimer];
                [self changeGoodOnly];
            }
            
            if (!isEmpty(self.finishTimeLabel.attributedText)) {
                [self.auctionStartMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.goodNameLabel.mas_bottom).offset(8.f);
                }];
                
                [self.finishTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.auctionStartMoneyLabel.mas_bottom).offset(8.f);
                    make.height.mas_equalTo(17.f);
                }];
                
                [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.finishTimeLabel.mas_bottom).offset(8.f);
                    make.height.mas_equalTo(17.f);
                }];
            } else {
                [self.auctionStartMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.goodNameLabel.mas_bottom).offset(10.f);
                }];
                
                [self.finishTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.auctionStartMoneyLabel.mas_bottom).offset(0.f);
                    make.height.mas_equalTo(0.f);
                }];
                
                [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.finishTimeLabel.mas_bottom).offset(8.f);
                    make.height.mas_equalTo(17.f);
                }];
            }
            
        } else {
            self.finishTimeLabel.text = @"";
            self.finishTimeLabel.attributedText = nil;
            [self.auctionStartMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.goodNameLabel.mas_bottom).offset(10.f);
            }];
            [self.finishTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.auctionStartMoneyLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
            [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.finishTimeLabel.mas_bottom).offset(8.f);
                make.height.mas_equalTo(17.f);
            }];
        }
        
        /// 禁售原因
        if (!isEmpty(self.listItemModel.forbidSellReason)) {
            self.reasonLabel.text = [NSString stringWithFormat:@"  禁售原因：%@",self.listItemModel.forbidSellReason];
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeLabel.mas_bottom).offset(12.f);
                make.height.mas_equalTo(29.f);
            }];
        } else {
            self.reasonLabel.text = @"";
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.timeLabel.mas_bottom).offset(0.f);
                make.height.mas_equalTo(0.f);
            }];
        }
        
        [self setNeedsLayout];
    }];
}

- (NSMutableAttributedString *)setRedMoney:(NSString *)prefix
                                    money:(NSString *)money {
    NSMutableAttributedString *prefixAttStr = [[NSMutableAttributedString alloc] initWithString:prefix attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0x999999)
    }];
    
    NSMutableAttributedString *moneyAttStr = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xFF4200)
    }];
    
    NSMutableAttributedString *numAttStr = [[NSMutableAttributedString alloc] initWithString:money attributes:@{
        NSFontAttributeName:[UIFont fontWithName:kFontBoldDIN size:12.f],
        NSForegroundColorAttributeName:HEXCOLOR(0xFF4200)
    }];
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
    [commentString appendAttributedString:prefixAttStr];
    [commentString appendAttributedString:moneyAttStr];
    [commentString appendAttributedString:numAttStr];
    return commentString;
}


- (NSMutableAttributedString *)setCountLableInfoStr:(NSInteger)day
                                               hour:(NSInteger)hour
                                             minute:(NSInteger)minute
                                             second:(NSInteger)second {
    NSString *timeStr = @"";
    if (self.listItemModel.productStatus == JHGoodManagerListRequestProductStatus_PutOn) {
        timeStr = @"距结束";
    } else if (self.listItemModel.productStatus == JHGoodManagerListRequestProductStatus_Trailer) {
        timeStr = @"距开始";
    }
    NSMutableAttributedString *endAttStr = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{
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



@end
