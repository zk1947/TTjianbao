//
//  JHOrderAppraisalVideoViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/2/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderAppraisalVideoViewController.h"
#import "JHVideoPlayControlView.h"
#import "JHAppraisalDetailTopView.h"
#import "ASValueTrackingSlider.h"


@interface JHOrderAppraisalVideoViewController ()<JHVideoPlayControlViewProtocol>
{
    NSString * videoUrl;
}
@property(nonatomic,strong)  JHAppraisalDetailTopView  *appraisalTopView;
@property (nonatomic, strong) UISlider *videoProgress;//播放进度
@property (nonatomic, assign) NSTimeInterval beginTime;

@end

@implementation JHOrderAppraisalVideoViewController
- (instancetype)initWithStreamUrl:(NSString *)url{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    
        videoUrl=url;
    }
    return self;
}

- (void)dealloc {
    
    JHBuryPointVideoInfoModel *model = [[JHBuryPointVideoInfoModel alloc] init];
    model.video_id = self.videoId;
    model.live_id = self.liveId;
    model.video_type = 2;
    model.from = (self.from == 6) ? JHLiveFromliveRecordActivity :JHLiveFromorderReportDetail;
    model.time =  [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] videoOutBuryWithModel:model];
    
    NSInteger dur = 0;
    if (self.beginTime > 0) {
        dur = time(NULL)-self.beginTime;
    }
    model.duration = dur*1000;
    model.playOver = (dur >= self.player.duration) ? @"true":@"false";
    model.videoDuration = self.player.duration * 1000;
    [JHGrowingIO trackEventId:JHtrackvideoplay_duration variables:[model mj_keyValues]];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.beginTime = time(NULL);
    [self.view addSubview:self.appraisalTopView];
    UIView * playerContainerView=[[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:playerContainerView];
    JHVideoPlayControlView * contrllView = [[JHVideoPlayControlView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:contrllView];
    
//    [self  initToolsBar];
//    self.navbar.backgroundColor = [UIColor clearColor];
//    [self.navbar addBtn:nil withImage:[UIImage imageNamed:@"appraisal_top_close"] withHImage:[UIImage imageNamed:@"appraisal_top_close"] withFrame:CGRectMake(ScreenW-50,0,44,44)];
//    self.navbar.ImageView.backgroundColor = [UIColor clearColor];
//    [self.navbar.comBtn addTarget :self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.jhNavView];
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self initRightButtonWithImageName:@"appraisal_top_close" action:@selector(cancle)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    [self startPlay:videoUrl inView:playerContainerView andControlView:contrllView];
    
    JHBuryPointVideoInfoModel *model = [[JHBuryPointVideoInfoModel alloc] init];
    model.video_id = self.videoId;
    model.live_id = self.liveId;
    model.video_type = 2;
    model.from = (self.from == 6) ? JHLiveFromliveRecordActivity :JHLiveFromorderReportDetail;
    model.time =  [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] videoInBuryWithModel:model];
    [JHGrowingIO trackEventId:JHtrackvideoplay_in variables:[model mj_keyValues]];

}
-(void)cancle{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
