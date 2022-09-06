//
//  JHVideoPlayViewController.m
//  TaodangpuAuction
//
//  Created by jiangchao on 2019/1/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHVideoPlayViewController.h"
#import "NELivePlayerControlView.h"
#import "JHVideoPlayControlView.h"
#import "JHAppraisalContentView.h"
#import "CommentTableViewCell.h"
#import "CommentToolView.h"
#import <IQKeyboardManager.h>
@interface JHVideoPlayViewController ()<UITableViewDelegate,UITableViewDataSource,JHVideoPlayControlViewProtocol,UIGestureRecognizerDelegate>
{
    UIView *  headerView;
     UIView * footerView;
    JHVideoPlayControlView* controlView;
    UIView  * playerContainerView;
    JHAppraisalContentView * reportView;
    float cellHeight;
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) CommentToolView* commentToolView;
@end

@implementation JHVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setHeaderView];
     [self setFooterView];
     [self.view addSubview:self.homeTable];
    NSString * url= @"http://jdvodvhvbqmbg.vod.126.net/jdvodvhvbqmbg/6236996316-50692110057738-0.flv";
   //  NSString * url=@"http://pl5lydwij.bkt.clouddn.com/appraise_414.mp4";
     [self startPlay:url inView:playerContainerView andControlView:controlView];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
    tap.delegate=self;
    [self.homeTable  addGestureRecognizer:tap];
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
    
    return  YES;
    
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
- (void)setHeaderView
{
    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    
    playerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-100)];
    playerContainerView.backgroundColor = [UIColor blackColor];
    [headerView addSubview:playerContainerView];
   
    controlView = [[JHVideoPlayControlView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-100)];
    controlView.delegate=self;
    [headerView addSubview:controlView];
    
    reportView = [[JHAppraisalContentView alloc] init];
    [headerView addSubview:reportView];
    [reportView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(playerContainerView.mas_bottom);
        make.left.right.equalTo(headerView);
    }];

      [reportView layoutIfNeeded];
       headerView.frame=CGRectMake(0, 0, SCREEN_WIDTH,reportView.contentView.frame.size.height+playerContainerView.frame.size.height);
    
}

- (void)setFooterView
{
    footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    footerView.userInteractionEnabled=YES;
    
     UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
     button.frame=CGRectMake(20, 0, 100, 50);
     [button setImage:[UIImage imageNamed:@"appraisal_video_message"] forState:UIControlStateNormal];//
    [button setTitle:@"说点什么吧" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBtnComment:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[CommHelp toUIColorByStr:@"#666666"] forState:UIControlStateNormal];
     button.titleLabel.font=[UIFont systemFontOfSize:13];
    [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    [footerView addSubview:button];

}
#pragma mark =============== setter ===============
-(UITableView*)homeTable{
   

    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)                                      style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.tableHeaderView = headerView;
         _homeTable.tableFooterView = footerView;
        _homeTable.estimatedRowHeight = 0;
        _homeTable.estimatedSectionFooterHeight = 0;
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _homeTable;
}
-(CommentToolView *)commentToolView{
    
    if (!_commentToolView) {
        _commentToolView=[[CommentToolView alloc]initWithFrame:CGRectMake(0,ScreenH, ScreenW, 50)];
    }
    return _commentToolView;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 10;
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
         cellHeight=[cell getAutoCellHeight];
         return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 10;
    }
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
#pragma mark =============== JHVideoPlayControlViewProtocol ===============
- (void)controlViewOnClickShare:(JHVideoPlayControlView *)controlView{


}
- (void)controlViewOnClickLike:(JHVideoPlayControlView *)controlView{

}
-(void)onClickBtnComment:(UIButton*)sender{
    
    if (!_commentToolView) {
        [self.view addSubview:self.commentToolView];
    }
     [self.commentToolView becomeFirstRes];
}


- (void)dealloc
{
   
    
}
@end
