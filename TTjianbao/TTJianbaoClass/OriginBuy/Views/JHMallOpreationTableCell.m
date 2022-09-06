//
//  JHMallOpreationTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallOpreationTableCell.h"
#import "JHMallHomeSeparateOperationView.h"
#import "JHMallModel.h"
#import "BannerMode.h"
#import "TTjianbao.h"
#import "NTESAudienceLiveViewController.h"

@interface JHMallOpreationTableCell ()

@property (nonatomic, strong) JHMallHomeSeparateOperationView *operateView;

@end

@implementation JHMallOpreationTableCell

- (void)dealloc {
    NSLog(@"%s被释放了🔥🔥🔥🔥 ------ ", __func__);
}

- (void)setOperateModel:(JHMallOperateModel *)operateModel {
    if (!operateModel) {
        return;
    }
    
    _operateModel = operateModel;
    _operateView.imageUrl = _operateModel.moreHotImgUrl;
    _operateView.separateCount = _operateModel.definiDetails.count;
    _operateView.moreHotImgProportion = _operateModel.moreHotImgProportion;
    CGFloat space = _operateModel.interSpace ? 10 : 0;
    [_operateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, space, 12));
    }];
}

+ (CGFloat)viewHeight {
    return [JHMallHomeSeparateOperationView viewSize].height + 10.;
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
    }];
    @weakify(self);
    _operateView.selectedIndex = ^(NSInteger index) {
        @strongify(self);
        if (index < self.operateModel.definiDetails.count) {
            JHMallOperateImgModel *model = self.operateModel.definiDetails[index];
            
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setValue:@(self.operateModel.definiSerial) forKey:@"position"];
            [params setValue:model.detailsId forKey:@"areaId"];
            
            [JHGrowingIO trackEventId:@"home_market_special_area1_click" variables:params];
            
            if (model.target) {
                [JHRootController toNativeVC:model.target.vc withParam:model.target.params from:JHFromHomeSourceBuy];
                NSDictionary *dict = @{
                    @"page_position" : @"源头直购首页",
                    @"spm_type" : @"首焦",
                    @"content_url" : model.target.recordComponentName ?: @"",
                };
                [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:dict type:JHStatisticsTypeSensors];
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



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
