//
//  JHSeckillPageViewController.m
//  TTjianbao
//
//  Created by jiang on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSeckillPageViewController.h"
#import "JHSeckillPageView.h"
#import "JHStoreApiManager.h"
#import "HttpRequestTool.h"
#import "JHSQModel.h"
#import "JHBaseOperationView.h"

@interface JHSeckillPageViewController ()
{
    JHSeckillPageView* pageView;
   
}
@property (nonatomic, strong) NSArray <JHSecKillTitleMode*>* tabTitleArray;
@property (nonatomic, strong)  JHSecKillHeaderMode* headerMode;
@property (nonatomic, strong) JHShareInfo *share_info;//分享的模型属性
@end

@implementation JHSeckillPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    [self requsetCateList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///用户画像埋点：秒杀列表页停留时长开始
    [JHUserStatistics noteEventType:kUPEventTypeMallFlashSaleListBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///用户画像埋点：秒杀列表页停留时长结束
    [JHUserStatistics noteEventType:kUPEventTypeMallFlashSaleListBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd}];
}

- (void)requsetCateList
{
     [JHStoreApiManager getSeckillCateList:^(RequestModel *respondObject, NSError *error) {
    if (!error) {
        self.tabTitleArray=[JHSecKillTitleMode mj_objectArrayWithKeyValuesArray:respondObject.data[@"sk_tabs"]];
         self.headerMode=[JHSecKillHeaderMode mj_objectWithKeyValues:respondObject.data[@"sc_info"]];
        self.share_info=[JHShareInfo mj_objectWithKeyValues:respondObject.data[@"share_info"]];
        [self loadPageView];
        
        }
    }];
}
-(void)loadPageView{
    
    __block  NSInteger index=0;
    
    [self.tabTitleArray enumerateObjectsUsingBlock:^(JHSecKillTitleMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSTimeInterval nowTime=[[CommHelp getNowTimetampBySyncServeTime] doubleValue]/1000;
//        if (nowTime>=obj.online_at&&nowTime<obj.offline_at ) {
//            index=idx;
//            * stop=YES;
//        }
        if (obj.is_selected) {
              index=idx;
             * stop=YES;
        }
    }];
    
     pageView.tabTitleArray=self.tabTitleArray;
     pageView.selectedIndex = index;
     [pageView initSubviews];
     [pageView setHeaderMode:self.headerMode];
    
}
#pragma mark - subviews
- (void)initSubviews
{
    pageView = [[JHSeckillPageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.view addSubview: pageView];
    [self.view bringSubviewToFront:self.jhNavView];
    self.jhNavView.backgroundColor = [UIColor clearColor];
    self.title = JHLocalizedString(@"currentSeckill");
    [self initRightButtonWithImageName:@"report_icon_share" action:@selector(shareAction)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
//    [self setupToolBarWithTitle:JHLocalizedString(@"currentSeckill")];
//    self.navbar.ImageView.backgroundColor=[UIColor clearColor];
//    [self.navbar addrightBtn:@"" withImage:[UIImage imageNamed:@"report_icon_share"] withHImage:[UIImage imageNamed:@"report_icon_share"] withFrame:CGRectMake(ScreenW-44,0,44,44)];
//       [self.navbar.rightBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
   
   // self.jhNavView.backgroundColor = [UIColor clearColor];
    
}
- (void)shareAction {
    NSLog(@"分享");
//    NSString *titleStr =@"今日秒杀，超值宝物开抢即秒！";
//    NSString *descStr = @"精选宝物，超值尖货，天天鉴宝最具魔性的限时促销栏目。数量有限，赶紧来抢！";
//   // NSString *imgStr = @"";
//    NSString *urlStr = H5_BASE_STRING(@"/jianhuo/app/shopSeckill/shopSeckill.html?");
//    [[UMengManager shareInstance] showShareWithTarget:nil
//                                                title:self.share_info.title
//                                                 text:self.share_info.desc
//                                             thumbUrl:nil
//                                               webURL:self.share_info.url
//                                                 type:ShareObjectTypeStoreGoodsDetail
//                                               object:nil];
    JHShareInfo* info = [JHShareInfo new];
    info.title = self.share_info.title;
    info.desc = self.share_info.desc;
    info.shareType = ShareObjectTypeStoreGoodsDetail;
    info.url = self.share_info.url;
    [JHBaseOperationView showShareView:info objectFlag:nil]; //TODO:Umeng share
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}

@end
