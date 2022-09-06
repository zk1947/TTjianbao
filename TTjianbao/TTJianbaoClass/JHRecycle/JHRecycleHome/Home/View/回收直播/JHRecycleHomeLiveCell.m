//
//  JHRecycleHomeLiveCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeLiveCell.h"
#import "JHRecycleHomeLiveCollectionViewCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHRecycleHomeLiveViewController.h"
#import "JHRecycleItemViewModel.h"
#import "NTESAudienceLiveViewController.h"
#import <MBProgressHUD.h>
#import "JHPageControl.h"
#import "GKCycleScrollView.h"
#import "GKPageControl.h"
#import "PageControl/TAPageControl.h"
#import "JHMallRecommendBannarCell.h"

@interface JHRecycleHomeLiveCell ()<UICollectionViewDelegate, UICollectionViewDataSource,GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) GKCycleScrollView *cycleView;
@property (nonatomic, weak) JHPageControl *pageControl;

@end

@implementation JHRecycleHomeLiveCell

#pragma mark  - UI
- (void)configUI{
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.backView).offset(12);
    }];
    [self.backView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.centerY.equalTo(self.titleLabel);

    }];
    //更多
    [self.backView addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.backView).offset(-18);
    }];
    
  //  [self cycleView];
    
    [self.backView addSubview:self.cycleView];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(46);
        make.left.right.equalTo(self.backView);
        make.height.mas_equalTo(219);
    }];
    
    
    [self.backView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-8);
        make.size.mas_equalTo(CGSizeMake(ScreenW, 4));
    }];
   // [self pageControl];
    [self.cycleView reloadData];
    
//    [self.backView addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backView).offset(46);
//        make.left.right.equalTo(self.backView);
//        make.height.mas_equalTo(219);
//    }];
    
    
    
}

#pragma mark  - LoadData
- (void)bindViewModel:(id)dataModel{
    [self.dataArray removeAllObjects];

    JHRecycleItemViewModel *itemViewModel = dataModel;
    [self.dataArray addObjectsFromArray:itemViewModel.dataModel];
    
   // [self.collectionView reloadData];
    self.pageControl.numberOfPages = self.dataArray.count;
    self.pageControl.hidden = self.dataArray.count <= 1;
    
    [self.cycleView reloadData];
}


#pragma mark  - Action
- (void)clickMoreBtnAction:(UIButton *)sender{
    JHRecycleHomeLiveViewController *liveVC = [[JHRecycleHomeLiveViewController alloc] init];
    [JHRootController.currentViewController.navigationController pushViewController:liveVC animated:YES];
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSeeMore" params:@{
        @"more_type":@"recycle",
        @"page_position":@"recycleHome"
    } type:JHStatisticsTypeSensors];
}
//#pragma mark  - 代理
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataArray.count;
//}
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    JHRecycleHomeLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHRecycleHomeLiveCollectionViewCell class]) forIndexPath:indexPath];
//
//    JHHomeRecycleLiveListModel *liveListModel = self.dataArray[indexPath.row];
//    [cell bindViewModel:liveListModel params:nil];
//
//    return cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    JHHomeRecycleLiveListModel *liveListModel = self.dataArray[indexPath.row];
//    //crash判空处理,目前逻辑,如果异常不进直播间
//    if (liveListModel.liveId.length > 0) {
//        [self getDetail:liveListModel.liveId];
//
//        [JHAllStatistics jh_allStatisticsWithEventId:@"clickLiveRoom" params:@{
//            @"channel_local_id":liveListModel.liveId,
//            @"live_type":@"recycle",
//            @"page_position":@"recycleHome"
//        } type:JHStatisticsTypeSensors];
//    }
//
//
//}
- (void)getDetail:(NSString *)selectLiveRoomId {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoomId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        channel.first_channel = @"回收";
        if ([channel.status integerValue] == 2){
           NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
           vc.channel = channel;
           vc.coverUrl = channel.coverImg;
           vc.fromString = @"回收首页";
           [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }else{
           NSString *string = nil;
           if (channel.status.integerValue == 1) {
               string = channel.lastVideoUrl;
           }
           NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
           vc.channel = channel;
           vc.coverUrl = channel.coverImg;
           vc.fromString = @"回收首页";
           [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
       
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
       
    }];
}
#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.dataArray.count;
}
- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    JHRecycleHomeLiveCollectionViewCell *cell = (JHRecycleHomeLiveCollectionViewCell *)[cycleScrollView dequeueReusableCell];
    
    
    if (!cell) {
        cell = [JHRecycleHomeLiveCollectionViewCell new];
    }
    if(index < self.dataArray.count) {
      //  cell.model = self.dataArray[index];
    }
    JHHomeRecycleLiveListModel *liveListModel = self.dataArray[index];
    [cell bindViewModel:liveListModel params:nil];
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    CGFloat height = 210;
    CGFloat width = 210;
    return CGSizeMake(ceilf(width) + 12, floorf(height));
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didScrollCellToIndex:(NSInteger)index {
    [self.pageControl setCurrentPage:index];
}
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didEndDecelerating:(UIScrollView *)scrollView{
}
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView willBeginDragging:(UIScrollView *)scrollView {
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index {
    NSLog(@"点击第%ld个广告",(long)index);
        JHHomeRecycleLiveListModel *liveListModel = self.dataArray[index];
        //crash判空处理,目前逻辑,如果异常不进直播间
        if (liveListModel.liveId.length > 0) {
            [self getDetail:liveListModel.liveId];
    
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickLiveRoom" params:@{
                @"channel_local_id":liveListModel.liveId,
                @"live_type":@"recycle",
                @"page_position":@"recycleHome"
            } type:JHStatisticsTypeSensors];
        }
    
    
}

#pragma mark  - 懒加载
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 9;
        flowLayout.itemSize = CGSizeMake(150, 219);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _collectionView.backgroundColor = UIColor.whiteColor;
        
        [_collectionView registerClass:[JHRecycleHomeLiveCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHRecycleHomeLiveCollectionViewCell class])];

    }
    return _collectionView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        _titleLabel.text = @"直播回收";
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.textColor = HEXCOLOR(0x222222);
        _subTitleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _subTitleLabel.text = @"/ 与回收商连麦实时聊价";
    }
    return _subTitleLabel;
}
- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_moreButton setImage:[UIImage imageNamed:@"recycle_homeMore_right_icon"] forState:UIControlStateNormal];
        [_moreButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        [_moreButton addTarget:self action:@selector(clickMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreButton;
}
- (GKCycleScrollView *)cycleView {
    if (!_cycleView) {
        // 缩放样式：Masonry布局，自定义尺寸，无限轮播
        GKCycleScrollView *cycleView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, (ScreenW*210/375))];
        cycleView.backgroundColor = [UIColor clearColor];
        cycleView.dataSource = self;
        cycleView.delegate = self;
        cycleView.minimumCellAlpha = 0.0;
        cycleView.leftRightMargin = 10.0f;
        cycleView.leadMargin = 10.f;
        cycleView.topBottomMargin = 11.0f;
        cycleView.isAutoScroll = YES;
        cycleView.autoScrollTime = 3.f;
        _cycleView = cycleView;
    }
    return _cycleView;
}

///分页指示器
- (JHPageControl *)pageControl {
    if (!_pageControl) {
        JHPageControl *pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW,4)];
        pageControl.numberOfPages = 0; //点的总个数
        pageControl.pointSize = 4;
        pageControl.otherMultiple = 1; //其他点w是h的倍数(圆点)
        pageControl.currentMultiple = 3; //选中点的宽度是高度的倍数(设置长条形状)
        pageControl.otherColor = HEXCOLORA(0x565656, .5f); //非选中点的颜色
        pageControl.currentColor = HEXCOLOR(0xFFD70F); //选中点的颜色
        pageControl.pointSpacing = 4.;
        _pageControl = pageControl;
       
    }
    return _pageControl;
}


@end
