//
//  JHNewShopCouponView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopCouponView.h"
#import "JHNewShopCouponCollectionViewCell.h"
#import "JHNewShopDetailHeaderViewModel.h"
#import "UIView+Toast.h"
#import "JHNewShopDetailInfoModel.h"

@interface JHNewShopCouponView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHNewShopDetailHeaderViewModel *shopHeaderViewModel;
@end

@implementation JHNewShopCouponView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    [self addSubview:self.collectionView];

    [self registerCellID];
    @weakify(self)
    [[RACObserve(self, couponListArray) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView reloadData];
    }];

}

- (void)registerCellID{
    [self.collectionView registerClass:[JHNewShopCouponCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewShopCouponCollectionViewCell class])];

}

#pragma mark  - 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.couponListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    JHNewShopCouponCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewShopCouponCollectionViewCell class]) forIndexPath:indexPath];
    if (self.couponListArray) {
        cell.couponListModel = self.couponListArray[indexPath.row];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];

    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
            if (result) {
                [JHNotificationCenter postNotificationName:@"kNewShopLoginSuccess" object:nil];
            }
        }];
    }else{
        JHNewShopDetailCouponListModel *couponModel = self.couponListArray[indexPath.row];
        NSDictionary *dicData = @{@"id": @([couponModel.couponId longValue]) };
        [self.shopHeaderViewModel.getCouponsCommand execute:dicData];
        
        [[self.shopHeaderViewModel.getCouponsSubject takeLast:1] subscribeNext:^(id  _Nullable x) {
            //领取成功更新当前cell显示状态
            couponModel.isReceive = @"1";
            //领取成功~
            [[UIApplication sharedApplication].keyWindow makeToast:@"领取成功~" duration:1.0 position:CSToastPositionCenter];
        }];
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"couponClick" params:@{
            @"coupon_id":couponModel.couponId,
            @"coupon_name":couponModel.name,
            @"store_from":@"店铺首页",
        } type:JHStatisticsTypeSensors];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(110, 42);
    
}


#pragma mark    - 懒加载

- (JHNewShopDetailHeaderViewModel *)shopHeaderViewModel{
    if (!_shopHeaderViewModel) {
        _shopHeaderViewModel = [[JHNewShopDetailHeaderViewModel alloc] init];
    }
    return _shopHeaderViewModel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 6;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 42) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _collectionView.backgroundColor = UIColor.clearColor;
    }
    return _collectionView;
}
-(NSArray*)couponListArray{
    if (!_couponListArray) {
        _couponListArray = [NSArray array];
    }
    return _couponListArray;
}
@end
