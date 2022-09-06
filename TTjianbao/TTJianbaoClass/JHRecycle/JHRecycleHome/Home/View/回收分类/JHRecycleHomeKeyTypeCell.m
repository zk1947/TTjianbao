//
//  JHRecycleHomeKeyTypeCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeKeyTypeCell.h"
#import "JHKeyTypeCollectionViewCell.h"
#import "JHUIFactory.h"
#import "UIView+JHGradient.h"
#import "JHRecycleItemViewModel.h"
#import "CommAlertView.h"
#import "JHQYChatManage.h"
#import "JHRecycleUploadTypeSeleteViewController.h"
#import "JHWebViewController.h"
#import "JHC2CUploadProductSuccessController.h"
#import "JHAppraisePayView.h"
#import "JHC2CSubmitVoucherController.h"
#import "JHRejectShowViewController.h"
#import "JHC2CUploadProductSuccessController.h"
#import "JHC2CSubmitVoucherController.h"
#import "JHOrderNoteView.h"

@interface JHRecycleHomeKeyTypeCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHCustomLine *lineView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation JHRecycleHomeKeyTypeCell

#pragma mark - UI
- (void)configUI{
    self.backView.layer.borderWidth = 0.5;
    self.backView.layer.borderColor = HEXCOLOR(0xEDEDED).CGColor;
    
    [self.contentView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFFFFF), HEXCOLOR(0xF5F5F8)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 0.8)];
    
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(12);
        make.top.equalTo(self.backView).offset(15);
    }];
    [self.backView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.equalTo(self.titleLabel);

    }];

    //四大回收
    [self.backView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(38);
        make.height.mas_equalTo(100);
    }];
//    //回收步骤
//    [self.backView addSubview:self.lineView];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
//        make.height.offset(0.5);
//        make.left.right.equalTo(self.backView);
//    }];
//
//    UIButton *leftBtn = [[UIButton alloc] init];
//    NSArray *titleArr = @[@"提交商品",@"顺丰取件",@"专业鉴定",@"确认报价",@"快速回款"];
//    for (int i = 0; i < titleArr.count; ++i) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
//        [btn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
//        [self.backView addSubview:btn];
//        btn.frame = CGRectMake(0, 0, (ScreenWidth-24)/titleArr.count, 20);
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom).offset(12);
//            make.size.mas_equalTo(CGSizeMake((ScreenWidth-24)/titleArr.count, 20));
//            if (i) {
//                make.left.equalTo(leftBtn.mas_right);
//            }else {
//                make.left.mas_equalTo(0);
//            }
//        }];
//        leftBtn = btn;
//        if (i < titleArr.count-1) {
//            UIImageView *img = [[UIImageView alloc] init];
//            img.image = JHImageNamed(@"recycle_triangle_icon");
//            [self.backView addSubview:img];
//            [img mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(btn);
//                make.size.mas_equalTo(CGSizeMake(6, 8));
//                make.left.equalTo(btn.mas_right).offset(-3);
//            }];
//        }
//
//    }
}

#pragma mark - LoadData
- (void)bindViewModel:(id)dataModel{
    [self.dataArray removeAllObjects];

    JHRecycleItemViewModel *itemViewModel = dataModel;
    [self.dataArray addObjectsFromArray:itemViewModel.dataModel];
    
    [self.collectionView reloadData];
}

#pragma mark - 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHKeyTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHKeyTypeCollectionViewCell class]) forIndexPath:indexPath];
    JHHomeRecycleCategoryListModel *categoryListModel = self.dataArray[indexPath.row];
    [cell bindViewModel:categoryListModel indexRow:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
//    JHAppraisePayView * payView = [[JHAppraisePayView alloc]init] ;
//    payView.orderId = @"191";
//    [JHKeyWindow addSubview:payView];
//    [payView showAlert];
//
  
    
//    JHC2CUploadProductSuccessController *vc = [JHC2CUploadProductSuccessController new];
//    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
//    return;
//    JHOrderNoteView * note=[[JHOrderNoteView alloc]init];
//    [JHKeyWindow addSubview:note];
//
//    JHC2CSubmitVoucherController *vc = [JHC2CSubmitVoucherController new];
//    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    
  //  return;
    JHHomeRecycleCategoryListModel *categoryListModel = self.dataArray[indexPath.row];

    if ([categoryListModel.code isEqualToString:@"money"]) {//钱币回收
        if (![JHRootController isLogin]) {
            @weakify(self);
            [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
                @strongify(self);
                if (result) {
                    [self.loginSuccessSubject sendNext:@YES];
                }
            }];
        }else{
            JHRecycleUploadTypeSeleteViewController *releaseVC = [[JHRecycleUploadTypeSeleteViewController alloc] init];
            [JHRootController.currentViewController.navigationController pushViewController:releaseVC animated:YES];
        }
        
//    }else if (indexPath.row == 1){//大宗钱币回收
//        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"收大宗钱币" andDesc:@"联系平台客服，为您提供大宗钱币（20个钱币以上）回收专属服务。" cancleBtnTitle:@"联系客服"];
//        [alert addCloseBtn];
//        [alert addBackGroundTap];
//        [alert setDescTextAlignment:NSTextAlignmentCenter];
//        [[UIApplication sharedApplication].keyWindow addSubview:alert];
//        alert.cancleHandle = ^{
//            [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
//        };
    }
    else{//黄金回收/钻石回收
        //判断登录，未登录跳登录
        if (![JHRootController isLogin]) {
            @weakify(self);
            [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
                @strongify(self);
                if (result) {
                    [self.loginSuccessSubject sendNext:@YES];
                }
            }];
        }else{
            JHWebViewController *webVC = [[JHWebViewController alloc] init];
            webVC.urlString = categoryListModel.url;
            webVC.titleString = @"天天鉴宝";
            webVC.isHiddenNav = YES;
            webVC.view.backgroundColor = UIColor.whiteColor;
            [JHRootController.currentViewController.navigationController pushViewController:webVC animated:YES];
        }
    }
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickModel" params:@{
        @"model_name":categoryListModel.btnDesc,
        @"page_position":@"recycleHome"
    } type:JHStatisticsTypeSensors];
}

#pragma mark - Lazy
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = (kScreenWidth - 48) / 4;
        flowLayout.itemSize = CGSizeMake(itemWidth, 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = false;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[JHKeyTypeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHKeyTypeCollectionViewCell class])];

    }
    return _collectionView;
}

- (JHCustomLine *)lineView{
    if (!_lineView) {
        _lineView = [JHUIFactory createLine];
    }
    return _lineView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        _titleLabel.text = @"图文回收";
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.textColor = HEXCOLOR(0x222222);
        _subTitleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _subTitleLabel.text = @"/ 多回收商出价，选高价卖";
    }
    return _subTitleLabel;
}
@end
