//
//  JHMallGroupConditionController.m
//  TTjianbao
//
//  Created by apple on 2020/3/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallGroupConditionController.h"
#import "JHMallGroupListViewModel.h"
#import "JHMallTableViewCell.h"
#import "JHMallLittleCollectionViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "ChannelMode.h"
#import "MBProgressHUD.h"
#import "UIScrollView+JHEmpty.h"
#import "JHMallSmallCollectionViewCell.h"
#import "JHCustomerInfoController.h"

#define BigCellRate (394./250.f)
#define LittleCellRate (192./250.f)

@interface JHMallGroupConditionController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) JHMallGroupListViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHMallGroupConditionController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (self.type==1) {
        [self.collectionView.mj_header setHidden:YES];
        [self.collectionView.mj_footer setHidden:YES];
        self.jhTitleLabel.text=@"我的足迹";
        [self.collectionView reloadData];
    }
    else{
        [self.collectionView.mj_header beginRefreshing];
    }
    
//    if (![JH_VERSION_SWITCH isEqualToString:@"1"]){
//         [self creatButton];
//    }
}

#pragma mark --------------- method ---------------
-(void)creatButton
{
    UIButton *button = [UIButton jh_buttonWithImage:@"icon_mall_change_big" target:self action:@selector(changeCellType:) addToSuperView:self.view];
    [button setImage:[UIImage imageNamed:@"icon_mall_change_small"] forState:UIControlStateSelected];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-70-UI.tabBarHeight);
        make.right.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(39,39));
    }];
}

#pragma mark --------------- action ---------------
-(void)changeCellType:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.viewModel.isShowBigImage = sender.selected;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.isShowBigImage) {
        JHMallTableViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallTableViewCell class]) forIndexPath:indexPath];
        if(indexPath.item < self.viewModel.dataArray.count)
        {
            cell.liveRoomMode = self.viewModel.dataArray[indexPath.row];
        }
        return cell;
    }else {
        
        if ([JH_VERSION_SWITCH isEqualToString:@"1"]) {
            JHMallLittleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
                   if(indexPath.item < self.viewModel.dataArray.count)
                   {
                       cell.liveRoomMode = self.viewModel.dataArray[indexPath.row];
                   }
                   return cell;
        }
        else{
            JHMallSmallCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallSmallCollectionViewCell class]) forIndexPath:indexPath];
            if(indexPath.item < self.viewModel.dataArray.count)
            {
                cell.liveRoomMode = self.viewModel.dataArray[indexPath.row];
            }
            return cell;
        
       }
    }

}

#pragma mark - UICollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.isShowBigImage) {
        CGFloat w = (ScreenW - 10);
        return CGSizeMake(w, w/BigCellRate);
        
    }else {
        CGFloat w = (ScreenW - 25)/2.;
        
        return CGSizeMake(w, w/LittleCellRate);
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHLiveRoomMode *selectLiveRoom = self.viewModel.dataArray[indexPath.row];
    __block NSInteger currentSelectIndex = indexPath.row;
    
    //做判断是否是定制师
    if([selectLiveRoom.canCustomize isEqualToString:@"1"] && selectLiveRoom.status.intValue != 2){
        //定制直播间跳定制主页(直播购物)
        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
        vc.roomId = selectLiveRoom.roomId;
        vc.anchorId = selectLiveRoom.anchorId;
        vc.channelLocalId = selectLiveRoom.channelLocalId;
        vc.fromSource = @"page_create";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoom.ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        
        if ([channel.status integerValue] == 2)
        {
            
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel = channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            vc.fromString = JHLiveFromhomeMarket;

            currentSelectIndex = 0;
            NSMutableArray * channelArr = [self.viewModel.dataArray mutableCopy];
            for (JHLiveRoomMode * mode in self.viewModel.dataArray) {
                if ([mode.status integerValue] != 2) {
                    [channelArr removeObject:mode];
                }
            }
            [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.ID isEqual:channel.channelLocalId]) {
                    currentSelectIndex = idx;
                    * stop=YES;
                }
            }];
            
            vc.currentSelectIndex = currentSelectIndex;
            vc.channeArr = channelArr;
            vc.PageNum = self.viewModel.pageIndex;
            vc.groupId = self.viewModel.groupIdListStr;
            vc.groupIds = self.viewModel.groupIdListStr;
            
            if (self.type==1) {
                   vc.listFromType=JHGestureChangeLiveRoomFromWatchTrackList;
               }
               else{
                  vc.listFromType=JHGestureChangeLiveRoomFromMallConditionList;
               }
           
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
            
            NSString *string = nil;
            if (channel.status.integerValue == 1) {
                string = channel.lastVideoUrl;
            }
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
            vc.channel = channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.fromString = JHLiveFromhomeMarket;

            [self.navigationController pushViewController:vc animated:YES];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
}

#pragma mark --------------- get ---------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = self.viewModel.isShowBigImage?10:5;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 5, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        }];
     
        [_collectionView registerClass:[JHMallTableViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallTableViewCell class])];
        [_collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
        [_collectionView registerClass:[JHMallSmallCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallSmallCollectionViewCell class])];
        @weakify(self);
        [_collectionView jh_headerWithRefreshingBlock:^{
            @strongify(self);
            self.viewModel.pageIndex = 0;
            [self.viewModel.requestCommand execute:@1];
        } footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel.requestCommand execute:@1];
        }];
    }
    return _collectionView;
}

-(JHMallGroupListViewModel *)viewModel
{
    if(!_viewModel){
        _viewModel = [JHMallGroupListViewModel new];
        _viewModel.groupIdArray = self.groupIdArray;
        _viewModel.pageIndex = 0;
        _viewModel.pageSize = 10;
        _viewModel.isShowBigImage = NO;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.collectionView jh_endRefreshing];
            [self.collectionView jh_reloadDataWithEmputyView];
        }];
    }
    return _viewModel;
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    self.viewModel.dataArray = [_dataArray mutableCopy];
}
@end
