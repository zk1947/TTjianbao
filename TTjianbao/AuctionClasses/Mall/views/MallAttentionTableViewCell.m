//
//  MallAttentionTableViewCell.m
//  TTjianbao
//
//  Created by jiang on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "MallAttentionTableViewCell.h"
#import "MallAttentionCollectionViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"
#import "MBProgressHUD.h"
#import "JHCustomerInfoController.h"

@interface  MallAttentionTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)  UICollectionView *collectionView;

@end

@implementation MallAttentionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor=[CommHelp  toUIColorByStr:@"#F5F6FA"];
        
        UIView *back = [[UIView alloc] init];
        back.layer.cornerRadius = 4;
        back.layer.masksToBounds = YES;
        back.backgroundColor = [CommHelp  toUIColorByStr:@"#ffffff"];
        [self.contentView addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.offset(10);
            make.right.offset(-10);
        }];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [CommHelp  toUIColorByStr:@"#ffffff"];
        label.font = [UIFont fontWithName:kFontMedium size:15];
        label.text = @"我的关注";
        label.textColor = kColor333;
        [back addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.offset(10);
            make.right.offset(-10);
            make.height.offset(30);
        }];
        
        [back addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            // make.edges.equalTo(self);
            make.top.equalTo(label.mas_bottom);
            make.bottom.equalTo(back);
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#ffffff"];
        //   flowLayout.sectionInset = UIEdgeInsetsMake(0,10, 0,10);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[MallAttentionCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MallAttentionCollectionViewCell class])];
        
    }
    return _collectionView;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.attentionModes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallAttentionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MallAttentionCollectionViewCell class]) forIndexPath:indexPath];
    [cell setLiveRoomMode:self.attentionModes[indexPath.row]];
        return cell;
}

#pragma mark FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75, 90);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
      JHLiveRoomMode  * mode  =self.attentionModes[indexPath.row];
  //    [JHRootController EnterLiveRoom:mode.ID];
    //做判断
    if([mode.canCustomize isEqualToString:@"1"]){
        if(mode.status.intValue == 2){
            [self getLiveRoomDetail:mode];
        }else{
            //定制直播间跳定制主页(原石回血未统计)
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = mode.roomId;
            vc.anchorId = mode.anchorId;
            vc.channelLocalId = mode.channelLocalId;
            vc.fromSource = @"";
            [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self getLiveRoomDetail:mode];
    }
}
-(void)setAttentionModes:(NSMutableArray<JHLiveRoomMode *> *)attentionModes{
    
    _attentionModes=attentionModes;
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
            NSMutableArray * channelArr=[self.attentionModes mutableCopy];
            for (JHLiveRoomMode * mode in self.attentionModes) {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
