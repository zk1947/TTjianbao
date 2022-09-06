//
//  JHVideoPlayViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/9.
//  Copyright © 2019 Netease. All rights reserved.
#import "JHAppraisalDetailViewController.h"
#import "NELivePlayerControlView.h"
#import "JHVideoPlayControlView.h"
#import "JHAppraisalContentView.h"
#import "CommentTableViewCell.h"
#import "CommentToolView.h"
#import <IQKeyboardManager.h>
#import "UMengManager.h"
#import "NTESLivePlayerViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHAudienceApplyConnectView.h"
#import "NTESLiveManager.h"
#import "JHAppraisalDetailTopView.h"
#import "JHBaseOperationView.h"
#import "ChannelMode.h"

#define pagesize 10
typedef void (^successBlock)(void);
@interface JHAppraisalDetailViewController ()<UITableViewDelegate,UITableViewDataSource,JHVideoPlayControlViewProtocol,UIGestureRecognizerDelegate,CommentToolViewDelegate,JHAppraisalContentViewDelegate>
{
     UIView *  headerView;
     UIView * footerView;
    JHVideoPlayControlView* controlView;
    JHAppraisalContentView * reportView;
   
    UIView  * playerContainerView;
    float cellHeight;
     NSInteger PageNum;
     NSString * videoUrl;
     NSString * appraiseId;
     NSString * recordId;
    JHRefreshNormalFooter *footer;
    
    UILabel *lb;
}

@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) CommentToolView* commentToolView;
@property(nonatomic,strong) NSMutableArray* appraisalCommentModes;
@property(nonatomic,strong) AppraisalDetailMode* appraisalDetail;
@property(nonatomic,strong)  JHAppraisalDetailTopView  *appraisalTopView;
@property(nonatomic,assign) NSTimeInterval beginTime;
@property(nonatomic,assign) NSTimeInterval videoAllDuration;

@end

@implementation JHAppraisalDetailViewController
@synthesize appraiseId;

- (instancetype)initWithAppraisalId:(NSString *)appraisalId{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.appraiseId=appraisalId;
    }
    return self;
}

- (void)controlViewOnClickQuit:(NELivePlayerControlView *)controlView {
    NSLog(@"[NELivePlayer Demo] 点击退出");
    self.videoAllDuration = self.player.duration;
    [super controlViewOnClickQuit:controlView];
}

- (void)dealloc {
    JHBuryPointVideoInfoModel *model = [[JHBuryPointVideoInfoModel alloc] init];
    model.video_id = self.appraisalDetail.recordId;
    model.live_id = self.appraisalDetail.originRecordId;
    model.video_type = 1;
//    model.from = self.from;
    model.time =  [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] videoOutBuryWithModel:model];


    VideoExtendModel *m = [JHGrowingIO videoExtendModel:self.appraisalDetail];
    NSInteger dur = 0;
    if (self.beginTime > 0) {
        dur = time(NULL)-self.beginTime;
    }
    m.duration = @(dur).stringValue;
    m.playOver = dur>=self.videoAllDuration;

    [JHGrowingIO trackEventId:JHtrackvideo_detail_duration variables:[m mj_keyValues]];

    NSLog(@"JHAppraisalDetailViewController  dealloc");

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self setHeaderView];
    [self setFooterView];
    [self.view addSubview:self.homeTable];
    [self.view addSubview:self.appraisalTopView];
    [self.view addSubview:self.commentToolView];
   
    self.commentToolView.alpha=0;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
    tap.delegate=self;
    [self.homeTable  addGestureRecognizer:tap];
   
    __weak typeof(self) weakSelf = self;
    self.homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self requsetInfo];
    self.beginTime = time(NULL);
 
}
-(void)requsetInfo{
    
    [self requestApprailsalDetail:^{
        
        [self startPlay: self.appraisalDetail.pullUrl inView:playerContainerView andControlView:controlView];
        recordId= self.appraisalDetail.recordId;
        [controlView setAppraisalDetail:self.appraisalDetail];
        [reportView setAppraisalDetail:self.appraisalDetail];
        [_appraisalTopView setAppraisalDetail:self.appraisalDetail];
        [self refreshHeaderViewHeight];
        [self loadNewData];
        
        JHBuryPointVideoInfoModel *model = [[JHBuryPointVideoInfoModel alloc] init];
        model.video_id = self.appraisalDetail.recordId;
        model.live_id = self.appraisalDetail.originRecordId;
        
        NSString *from = @"";
        if (self.from == 2) {
            from = JHLiveFromanchorIdentifyRecord;
        }else if (self.from == 3) {
            from = JHLiveFromorderReportDetail;
        }else if (self.from == 4) {
            from = JHLiveFromaudienceIdentifyRecord;

        }
        model.video_type = 1;
        model.from = from;
        model.time =  [[CommHelp getNowTimeTimestampMS] integerValue];
        [[JHBuryPointOperator shareInstance] videoInBuryWithModel:model];
        
        VideoExtendModel *m = [JHGrowingIO videoExtendModel:self.appraisalDetail];
        [JHGrowingIO trackEventId:JHtrackvideo_detail_in variables:[m mj_keyValues]];
        
    }];
    
}
-(void)loadNewData{

     PageNum=0;
     [self requestCommentList];
}
-(void)loadMoreData{
    
    PageNum++;
    [self requestCommentList];
}
-(void)requestApprailsalDetail:(JHFinishBlock)complete{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/appraiseRecord/detail/authoptional?appraiseId=%@"),appraiseId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
         self.appraisalDetail=[AppraisalDetailMode mj_objectWithKeyValues: respondObject.data];
        
         complete();
       
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];
       [SVProgressHUD show];
}
-(void)requestCommentList{
    if (!recordId) {
        return;
    }
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/comment/authoptional/list?productId=%@&pageNo=%ld&pageSize=%ld"),recordId,PageNum,pagesize];
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        [self endRefresh];
        [self handleDataWithArr:respondObject.data];
        [self refreshHeaderViewHeight];
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [ApprailsalCommentMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
         self.appraisalCommentModes = [NSMutableArray arrayWithArray:arr];
    }else {
         [self.appraisalCommentModes addObjectsFromArray:arr];
       
    }
    [self.homeTable reloadData];
    
    if ([arr count]<pagesize) {
         self.homeTable.mj_footer.hidden=YES;
        if (arr.count == 0){
             lb.text = @"- 暂无评论 -";
        }
        else{
            lb.text = @"- 我是有底线的 -";
        }
    }
    else{
        self.homeTable.mj_footer.hidden=NO;
    }
}
- (void)endRefresh {
    [self.homeTable.mj_footer endRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
  
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    // 输出点击的view的类名
     NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
        return NO;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIControl"]) {
        return NO;
    }
    
    return  YES;

}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
- (void)setHeaderView
{
    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];

    playerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-60)];
    playerContainerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:playerContainerView];

    controlView = [[JHVideoPlayControlView alloc] initWithFrame:playerContainerView.frame];
    controlView.delegate=self;
    [headerView addSubview:controlView];
    
    reportView = [[JHAppraisalContentView alloc] init];
    reportView.delegate=self;
    [headerView addSubview:reportView];
    [reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(playerContainerView.mas_bottom);
        make.left.right.equalTo(headerView);
    }];

      [self refreshHeaderViewHeight];
    
}
- (void)setFooterView
{
    
    footerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
    footerView.backgroundColor=[UIColor whiteColor];
    lb = [[UILabel alloc ]initWithFrame:CGRectMake(0, 30, ScreenW , 30)];
    lb.text = @"";
    lb.font=[UIFont systemFontOfSize:13];
    lb.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    lb.numberOfLines = 1;
    lb.textAlignment = UIControlContentHorizontalAlignmentLeft;
    lb.textColor = [UIColor lightGrayColor];
    [footerView addSubview:lb];

}
#pragma mark =============== setter ===============
-(UITableView*)homeTable{
   
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenW, ScreenH)                                      style:UITableViewStyleGrouped];
         _homeTable.delegate=self;
         _homeTable.dataSource=self;
         _homeTable.alwaysBounceVertical=YES;
         _homeTable.scrollEnabled=YES;
        _homeTable.tableHeaderView = headerView;
        _homeTable.tableFooterView=footerView;
         _homeTable.estimatedRowHeight = 50;
//         _homeTable.estimatedSectionFooterHeight = 0;
        _homeTable.contentInset=UIEdgeInsetsMake(0, 0,0, 0);
         _homeTable.backgroundColor=[UIColor whiteColor];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _homeTable;
}
-(CommentToolView *)commentToolView{
    
    if (!_commentToolView) {
        _commentToolView=[[CommentToolView alloc]initWithFrame:CGRectMake(0, ScreenH-50, ScreenW, 50)];
        _commentToolView.delegate=self;
    }
    return _commentToolView;
}
-(JHAppraisalDetailTopView*)appraisalTopView{
    
    if (!_appraisalTopView) {
          _appraisalTopView=[[JHAppraisalDetailTopView alloc]initWithFrame:CGRectMake(0,0, ScreenW,UI.statusBarHeight+64)];
          _appraisalTopView.delegate=self;
    }
      return _appraisalTopView;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
     [self.view endEditing:YES];
    NSLog(@"%lf",scrollView.contentOffset.y);
    self.appraisalTopView.topImageAlpha=scrollView.contentOffset.y/ScreenH;
    if (scrollView.contentOffset.y>=80) {
        self.homeTable.frame=CGRectMake(0,0, ScreenW, ScreenH-50);
         self.commentToolView.alpha=1;
    }
    else{
       self.homeTable.frame=CGRectMake(0,0, ScreenW, ScreenH);
         self.commentToolView.alpha=0;
    }
  
}
#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
      return self.appraisalCommentModes.count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    CommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        [cell setAppraisalReportComment:self.appraisalCommentModes[indexPath.section]];
    
//         cellHeight=[cell getAutoCellHeight];
    
        return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 1;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==[self.appraisalCommentModes count]-1) {
        return 1;
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer =[[UIView alloc]init];
    footer.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return footer;
}

-(void)refreshHeaderViewHeight{
    
    [reportView layoutIfNeeded];
    headerView.frame=CGRectMake(0, 0, ScreenW,reportView.contentView.frame.size.height+playerContainerView.frame.size.height);
   _homeTable.tableHeaderView = headerView;
    
}-(void)onClickBtnComment:(UIButton*)sender{
    
    [  self.commentToolView.commentTextField becomeFirstResponder];
}

#pragma mark =============== JHVideoPlayControlViewProtocol ===============
- (void)controlViewOnClickShare:(JHVideoPlayControlView *)controlView{

    NSLog(@"%@",self.appraisalDetail.videoUrl);
    if ([self isLgoin]) {
        NSString *stringURL = [OBJ_TO_STRING([UMengManager shareInstance].shareVideoUrl) stringByAppendingString:OBJ_TO_STRING(self.appraisalDetail.appraiseId)];
        //@"来看大神的鉴定一对一鉴定视频，珠宝，翡翠，玉石"
        stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"&type=1"]];
//    [[UMengManager shareInstance] showShareWithTarget:nil title:ShareOrderReportTitle text:ShareOrderReportText thumbUrl:nil webURL:stringURL type:ShareObjectTypeAppraiseVideo object:self.appraisalDetail.recordId];
        JHShareInfo* info = [JHShareInfo new];
        info.title = ShareOrderReportTitle;
        info.desc = ShareOrderReportText;
        info.shareType = ShareObjectTypeAppraiseVideo;
        info.url = stringURL;
        [JHBaseOperationView showShareView:info objectFlag:self.appraisalDetail.recordId]; //TODO:Umeng share
    }
}

- (void)controlViewOnClickLike:(JHVideoPlayControlView *)controlView isLike:(BOOL)like{

     if ([self isLgoin]) {
         
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/video/auth/viewerChangeStatusNew?channelRecordId=%@&status=%@"),recordId,like?@"1":@"0"];
      [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [_appraisalTopView setIsLike:like];
          
          [self requestApprailsalDetail:^{
              
              recordId= self.appraisalDetail.recordId;
              [controlView setAppraisalDetail:self.appraisalDetail];
              [reportView setAppraisalDetail:self.appraisalDetail];
              [_appraisalTopView setAppraisalDetail:self.appraisalDetail];
              [self refreshHeaderViewHeight];
              
          }];
        
    } failureBlock:^(RequestModel *respondObject) {
         [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];
     [SVProgressHUD show];
     }
}
- (void)controlViewOnClickHeadImage:(JHVideoPlayControlView *)controlView{
    
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(self.appraisalDetail.appraiser.channel)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        [NTESLiveManager sharedInstance].orientation = NIMVideoOrientationDefault;
        [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
        [NTESLiveManager sharedInstance].role = NTESLiveRoleAudience;
        
        if ([channel.status integerValue]==2)
        {
            
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.channel=channel;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
            
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:nil];
            vc.channel = channel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
    [SVProgressHUD show];
    
}
#pragma mark =============== CommentToolViewDelegate ===============
- (void)OnClickComment:(NSString *)string{

     [self dismissKeyboard];
    if ([self isLgoin]) {
      
        NSDictionary * parameters=@{@"productId":self.appraisalDetail.recordId,
                                    @"remarks":string
                                    };
        
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/comment/auth/add") Parameters:parameters requestSerializerType:RequestSerializerTypeJson
                        successBlock:^(RequestModel *respondObject) {
                            
                            [SVProgressHUD dismiss];
                            [self requestApprailsalDetail:^{
                                recordId= self.appraisalDetail.recordId;
                                [controlView setAppraisalDetail:self.appraisalDetail];
                                [reportView setAppraisalDetail:self.appraisalDetail];
                                [_appraisalTopView setAppraisalDetail:self.appraisalDetail];
                                [self refreshHeaderViewHeight];
                                
                            }];
                            self.commentToolView.commentTextField.text = @"";
                            [self loadNewData];
                            
                        } failureBlock:^(RequestModel *respondObject) {
                            
                            [SVProgressHUD dismiss];
                            [self.view makeToast:respondObject.message duration:2.0 position:CSToastPositionCenter];
                        }];
        
        [SVProgressHUD show];
    }
   
}

#pragma mark =============== JHAppraisalContentViewDelegate ===============
- (void)pressCare:(UIButton*)button{
     if ([self isLgoin]) {
         
    NSLog(@"%@",self.appraisalDetail.appraiser.viewId);
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":self.appraisalDetail.appraiser.viewId,@"status":@(!button.selected)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [reportView setIsCare:!button.selected];
       
    } failureBlock:^(RequestModel *respondObject) {
          [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message];
    }];
    
       [SVProgressHUD show];
         
    }
}

-(BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
            }
        }];
        
        return  NO;
    }
    
     return  YES;
}

@end
