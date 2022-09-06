//
//  JHRecycleCategoryView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/4/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  回收分类

#import "JHRecycleCategoryView.h"
#import "JHRecycleUploadTypeSeleteViewController.h"
#import "JHRecycleHomeLiveViewController.h"

@interface JHRecycleCategoryView()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end


@implementation JHRecycleCategoryView
+ (CGFloat)getRecycleHeight {
    return 158.f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
       
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}

- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.collectionView];
}

- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(12);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(4);
        make.right.mas_equalTo(-12);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHRecycleCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHRecycleCategoryCollectionViewCell class]) forIndexPath:indexPath];
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell bindViewModel:dict indexRow:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        /// 回收售卖分类
        if (IS_LOGIN) {
            JHRecycleUploadTypeSeleteViewController *goodsVC = [[JHRecycleUploadTypeSeleteViewController alloc] init];
            [JHRootController.currentViewController.navigationController pushViewController:goodsVC animated:YES];
        }
    } else {
        /// 回收直播间
        JHRecycleHomeLiveViewController *liveVC = [[JHRecycleHomeLiveViewController alloc] init];
        [JHRootController.currentViewController.navigationController pushViewController:liveVC animated:YES];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickModel" params:@{
        @"model_name":NONNULL_STR(dict[@"title"]),
        @"page_position":@"在线鉴定页"
    } type:JHStatisticsTypeSensors];
}


- (void)pushWebWithUrl : (NSString *)url {
    JHWebViewController *webVC = [[JHWebViewController alloc] init];
    webVC.urlString = url;
    webVC.titleString = @"天天鉴宝";
    webVC.isHiddenNav = YES;
    webVC.view.backgroundColor = UIColor.whiteColor;
    [JHRootController.currentViewController.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - Lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = kScreenWidth / 2;
        flowLayout.itemSize = CGSizeMake(itemWidth, 78.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = false;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[JHRecycleCategoryCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHRecycleCategoryCollectionViewCell class])];

    }
    return _collectionView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.text = @"天天回收";
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:18];
    }
    return _titleLabel;
}


- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _detailLabel.text = @" / 专业鉴定 极速成交 快速回款";
        _detailLabel.textColor = HEXCOLOR(0x222222);
        _detailLabel.font = [UIFont fontWithName:kFontNormal size:11];
    }
    return _detailLabel;
}

- (RACSubject *)reloadSubject {
    if (!_reloadSubject) {
        _reloadSubject = [RACSubject subject];
    }
    return _reloadSubject;
}



- (void)setViewModel:(JHRecycleHomeGetRecyclePlateModel *__nullable)model {
    self.titleLabel.text = NONNULL_STR(model.title);
    if (!isEmpty(model.statisticsTip)) {
        self.detailLabel.text = [NSString stringWithFormat:@"/ %@",model.statisticsTip];
    } else {
        self.detailLabel.text = @"";
    }
    
    
    [self.dataArray removeAllObjects];
    if (!model) {
        return;
    }
    NSDictionary *dic1 = @{
        @"icon":NONNULL_STR(model.imageTextIcon),
        @"iconTag":NONNULL_STR(model.imageTextIconTag),
        @"title":model.imageTextTitle,
        @"desc":model.imageTextDesc
    };
    [self.dataArray addObject:dic1];
    
    NSDictionary *dic2 = @{
        @"icon":NONNULL_STR(model.channelIcon),
        @"iconTag":NONNULL_STR(model.channelIconTag),
        @"title":model.channelTitle,
        @"desc":model.channelDesc
    };
    [self.dataArray addObject:dic2];
    
    [self.collectionView reloadData];
}

@end
