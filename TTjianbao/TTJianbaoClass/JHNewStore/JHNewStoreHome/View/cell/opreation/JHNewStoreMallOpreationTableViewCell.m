//
//  JHNewStoreMallOpreationTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreMallOpreationTableViewCell.h"

#import "JHMallHomeSeparateOperationView.h"
#import "JHMallModel.h"
#import "BannerMode.h"
#import "TTjianbao.h"
#import "NTESAudienceLiveViewController.h"
#import "JHNewStoreHomeReport.h"

@interface JHNewStoreMallOpreationTableViewCell ()
@property (nonatomic, strong) JHMallHomeSeparateOperationView *operateView;
@end

@implementation JHNewStoreMallOpreationTableViewCell

- (void)dealloc {
    NSLog(@"%s被释放了🔥🔥🔥🔥 ------ ", __func__);
}

- (void)setOperateModel:(JHMallOperateModel *)operateModel {
    if (!operateModel || operateModel.definiDetails.count == 0) {
        return;
    }
    _operateModel = operateModel;
    JHMallOperateImgModel *imgModel = _operateModel.definiDetails[0];
    _operateView.imageUrl = imgModel.imageUrl;
    _operateView.separateCount = _operateModel.definiDetails.count;
    [_operateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, 12, 12));
        make.height.mas_equalTo((ScreenW - 24.f)*116.f/351.f);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    JHMallHomeSeparateOperationView *optView = [[JHMallHomeSeparateOperationView alloc] init];
    [self.contentView addSubview:optView];
    _operateView = optView;
    [optView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, 0, 12));
        make.height.mas_equalTo((ScreenW - 24.f)*116.f/351.f);
    }];
    @weakify(self);
    _operateView.selectedIndex = ^(NSInteger index) {
        @strongify(self);
        if (index < self.operateModel.definiDetails.count) {
            JHMallOperateImgModel *model = self.operateModel.definiDetails[index];
            if (model.target) {
                if ([model.target.vc isEqualToString:@"JHWebViewController"]) {
                    NSString *str = model.target.params[@"urlString"];
                    [JHNewStoreHomeReport jhNewStoreHomeAdClickReport:model.detailsId ad_title:str position_sort:index];
                } else {
                    [JHNewStoreHomeReport jhNewStoreHomeAdClickReport:model.detailsId ad_title:model.target.vc position_sort:index];
                }
                [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:JHFromHomeSourceBuy];
            }
        }
    };
}

- (void)getLiveRoomDetail:(JHLiveRoomMode *)liveInfo {
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(liveInfo.ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        if ([channel.status integerValue] == 2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel = channel;
            vc.coverUrl = liveInfo.coverImg;
            vc.entrance = @"0";
            vc.PageNum = 0;
            vc.listFromType = JHGestureChangeLiveRoomFromMallGroupList;
//            [self setLiveRoomParamsForVC:vc];
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
        else  if ([channel.status integerValue] == 1 || [channel.status integerValue] == 0 || [channel.status integerValue] == 3){
            NSString *string = nil;
            if (channel.status.integerValue == 1) {
                string = channel.lastVideoUrl;
            }
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
            vc.channel = channel;
            vc.coverUrl = liveInfo.coverImg;
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
//            [self setLiveRoomParamsForVC:vc];
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
        
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [UITipView showTipStr:respondObject.message?:@"网络请求失败"];
    }];
}


@end
