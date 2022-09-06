//
//  JHMallWatchTrackTableViewCell.m
//  TTjianbao
//
//  Created by jiang on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallWatchTrackTableViewCell.h"
#import "MallAttentionCollectionViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"
#import "MBProgressHUD.h"
//#import "JHMallWatchTrackCollectionViewCell.h"
#import "JHMallWatchTrackBaseCollection.h"
#import "JHCustomerInfoController.h"

#import "JHFootPrintCollectionViewCell.h"

@interface  JHMallWatchTrackTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (strong, nonatomic)  JHMallWatchTrackBaseCollection *collectionView;

@end

@implementation JHMallWatchTrackTableViewCell
+ (CGFloat)cellHeight{
    
    return 175;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[CommHelp  toUIColorByStr:@"#F5F6FA"];
        
//        UIView *back = [[UIView alloc] init];
//        back.layer.cornerRadius = 4;
//        back.layer.masksToBounds = YES;
//        back.backgroundColor = [CommHelp  toUIColorByStr:@"#ffffff"];
//        [self addSubview:back];
//        [back mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(self);
//            make.left.offset(0);
//            make.right.offset(0);
//             make.bottom.offset(0);
//        }];
        
        [self.contentView addSubview:self.collectionView];
//        self.collectionView.userInteractionEnabled = NO;
//        [self addGestureRecognizer: self.collectionView.panGestureRecognizer];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.left.offset(0);
            make.right.offset(0);
        }];
        
    }
    return self;
}

-(UICollectionView*)collectionView
{
    if (!_collectionView) {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[JHMallWatchTrackBaseCollection alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
      //  _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#ffffff"];
          _collectionView.backgroundColor=[CommHelp  toUIColorByStr:@"#F5F6FA"];
           flowLayout.sectionInset = UIEdgeInsetsMake(0,10, 0,10);
        flowLayout.minimumLineSpacing=10;
      // flowLayout.minimumInteritemSpacing=15;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
      
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
      
        /* hutao注释 */
    //[_collectionView registerClass:[JHMallWatchTrackCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallWatchTrackCollectionViewCell class])];
        
        [_collectionView registerClass:[JHFootPrintCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHFootPrintCollectionViewCell class])];
        
    }
    return _collectionView;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.watchTrackModes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /* hutao注释 */
//    JHMallWatchTrackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallWatchTrackCollectionViewCell class]) forIndexPath:indexPath];
//       cell.cellIndex=indexPath.row;
//       [cell setLiveRoomMode:self.watchTrackModes[indexPath.row]];
//        JH_WEAK(self)
//    cell.buttonClick = ^(id obj) {
//        JH_STRONG(self)
//        NSNumber * index=(NSNumber*)obj;
//        JHLiveRoomMode  *mode  =self.watchTrackModes[[index integerValue]];
//        [self didFollow:mode];
//    };
//        return cell;
    
    /* husir 添加 */
    JHFootPrintCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHFootPrintCollectionViewCell class]) forIndexPath:indexPath];
    cell.cellIndex=indexPath.row;
    [cell setLiveRoomMode:self.watchTrackModes[indexPath.row]];
    JH_WEAK(self)
    cell.buttonClick = ^(id obj)
    {
        JH_STRONG(self)
        NSNumber * index=(NSNumber*)obj;
        JHLiveRoomMode  *mode  =self.watchTrackModes[[index integerValue]];
        [self didFollow:mode];
    };
    
        return cell;

}

#pragma mark FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(124, [JHMallWatchTrackTableViewCell cellHeight]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
      JHLiveRoomMode  * mode  =self.watchTrackModes[indexPath.row];
  //    [JHRootController EnterLiveRoom:mode.ID];
    //做判断是否是定制师
    if([mode.canCustomize isEqualToString:@"1"]){
        if(mode.status.intValue == 2){
            [self getLiveRoomDetail:mode];
        }else{
            //定制直播间跳定制主页(直播购物)
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = mode.roomId;
            vc.anchorId = mode.anchorId;
            vc.channelLocalId = mode.channelLocalId;
            vc.fromSource = @"page_create";
            [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self getLiveRoomDetail:mode];
    }
}
-(void)setWatchTrackModes:(NSMutableArray<JHLiveRoomMode *> *)watchTrackModes{
    
    _watchTrackModes=watchTrackModes;
    [self.collectionView  reloadData];
}
-(void)getLiveRoomDetail:(JHLiveRoomMode*)mode{
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(mode.ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
          ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        if ([channel.status integerValue]==2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel=channel;
            vc.coverUrl = mode.coverImg;
            vc.fromString = JHLiveFromhomeMarket;

          __block   NSUInteger  currentSelectIndex=0;
            NSMutableArray * channelArr=[self.watchTrackModes mutableCopy];
            for (JHLiveRoomMode * mode in self.watchTrackModes) {
                if ([mode.status integerValue]!=2) {
                    [channelArr removeObject:mode];
                }
            }
            [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.ID isEqual:channel.channelLocalId]) {
                   currentSelectIndex=idx;
                    * stop=YES;
                }
            }];
            
            vc.currentSelectIndex=currentSelectIndex;
            vc.channeArr=channelArr;
            [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
            
            
        }
        else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
            
            NSString *string = nil;
            if (channel.status.integerValue == 1) {
                string = channel.lastVideoUrl;
            }
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
            vc.channel = channel;
            vc.coverUrl = mode.coverImg;
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.fromString = JHLiveFromhomeMarket;

            [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
        }
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        [self.viewController.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
}

- (void)didFollow:(JHLiveRoomMode*)mode{
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
        }];
        return;
    }
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":mode.anchorId,@"status":@(!mode.isFollow)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
        mode.isFollow=!mode.isFollow;
     
        if (mode.isFollow) {
              mode.recommendCount++;
          [JHKeyWindow makeToast:@"关注成功" duration:1 position:CSToastPositionCenter];
        }
        else{
            mode.recommendCount--;
           [JHKeyWindow makeToast:@"取消关注成功" duration:1 position:CSToastPositionCenter];
        }
           [self.collectionView reloadData];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self makeToast:respondObject.message];
    }];
}

@end
