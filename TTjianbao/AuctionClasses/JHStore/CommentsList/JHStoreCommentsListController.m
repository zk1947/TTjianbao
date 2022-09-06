//
//  JHStoreCommentsListController.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/19.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreCommentsListController.h"
#import "JHAudienceCommentTableViewCell.h"
#import "CommentToolView.h"
#import "UMengManager.h"
#import "NTESLivePlayerViewController.h"
#import "JHAudienceApplyConnectView.h"
#import "NTESLiveManager.h"
#import "JHAppraisalDetailTopView.h"
#import "NTESAudienceLiveViewController.h"
#import "JHCommentHeaderTagView.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"
#import "JHWebViewController.h"

#define pagesize 10
typedef void (^successBlock)(void);


@interface JHStoreCommentsListController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate >
{
    UIView *  headerView;
    JHCommentHeaderTagView *  tableHeaderView;
    UIView * footerView;
    float cellHeight;
    NSInteger PageNum;
    NSString * appraisalID;
    JHRefreshNormalFooter *footer;
    UILabel *lb;
    
    
}
@property(nonatomic,strong) UITableView* commentTableView;
@property(nonatomic,strong) NSMutableArray* commentArray;
@property(nonatomic,strong) NSMutableArray<CommentTagMode*>* searchTagModes;
@property(nonatomic,strong) UILabel* commentCountLabel;
@property(nonatomic,strong) UILabel* goodCommentLabel;
@property(nonatomic,strong)  UIView * contentView;
@property(nonatomic,strong)  ChannelMode * channelMode;
@property(nonatomic,strong)    NSString * tagCode;

@end

@implementation JHStoreCommentsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self createTableView];
    [self setFooterView];
    self.tagCode=@"all";
    [self loadData];
}

- (void)configNav {
//    [self initToolsBar];
    self.title = @"全部评价";
//    [self.navbar setTitle:@"全部评价"];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createTableView {
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.alwaysBounceVertical=YES;
    _commentTableView.scrollEnabled=YES;
    _commentTableView.bounces=YES;
    _commentTableView.estimatedRowHeight = 100;
    _commentTableView.contentInset=UIEdgeInsetsMake(0, 0,0, 0);
    _commentTableView.backgroundColor=[UIColor whiteColor];
    [_commentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _commentTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_commentTableView];
    [_commentTableView registerClass:[JHAudienceCommentTableViewCell class] forCellReuseIdentifier:@"JHAudienceCommentTableViewCell"];
    
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(UI.statusAndNavBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.offset(-UI.bottomSafeAreaHeight);
    }];
    
    JH_WEAK(self)
    self.commentTableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        JH_STRONG(self)
        [self loadMoreData];
    }];
    [self.commentTableView.mj_footer setHidden:YES];
}

- (void)loadData{
    [self loadNewData];
}
-(void)loadNewData{
    PageNum=0;
    [self requestCommentList];
}
-(void)loadMoreData{
    PageNum++;
    [self requestCommentList];
}

-(void)requestCommentList{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/list?sellerCustomerId=%@&&pageNo=%ld&pageSize=%ld&tagCode=%@"), self.sellerCustomerId,PageNum,pagesize,self.tagCode];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self handleDataWithArr:respondObject.data[@"datas"]];
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [JHAudienceCommentMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.commentArray = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.commentArray addObjectsFromArray:arr];
        
    }
    [self.commentTableView reloadData];
    
    if ([arr count]<pagesize) {
        self.commentTableView.mj_footer.hidden=YES;
        if (arr.count == 0&&self.commentArray.count==0){
            lb.text = @"- 暂无评论 -";
        }
        else{
            lb.text = @"— 已显示全部评论 —";
        }
    }
    else{
        self.commentTableView.mj_footer.hidden=NO;
    }
}
- (void)endRefresh {
    [self.commentTableView.mj_footer endRefreshing];
}
- (void)setFooterView {
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
    _commentTableView.tableFooterView=footerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    NSLog(@"%lf",scrollView.contentOffset.y);
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"JHAudienceCommentTableViewCell";
    JHAudienceCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.accessoryType=UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAudienceCommentMode:self.commentArray[indexPath.section]];
    [cell setCellIndex:indexPath.section];
    JH_WEAK(self)
    cell.cellClick = ^(UIButton *button, BOOL isLaud, NSInteger index) {
        JH_STRONG(self)
        if (button.tag==1) {
            JHAudienceCommentMode *mode = [self.commentArray objectAtIndex:index];
            if ( [self isKindOfClass: [NTESAudienceLiveViewController class]]) {
                NTESAudienceLiveViewController * vc=(NTESAudienceLiveViewController*)self;
                vc.needShutDown=YES;
            }
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), mode.orderId];
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
            
        }
        if (button.tag==2) {
            [self clickIndex:index isLaud:isLaud];
        }
    };
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==[self.commentArray count]-1) {
        return 1;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer =[[UIView alloc]init];
    footer.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return footer;
}

- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud {
    if ([self isLgoin]) {
        JHAudienceCommentMode * mode=[self.commentArray objectAtIndex:index];
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/auth/laud?commentId=%@&status=%@"),mode.Id,laud?@"0":@"1"];
        [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            mode.isLaud=!laud;
            int count=[mode.laudTimes intValue];
            if (!laud) {
                count=count+1;
                mode.laudTimes=[NSString stringWithFormat:@"%d",count];
            }
            else{
                count=count-1;
                mode.laudTimes=[NSString stringWithFormat:@"%d",count];
            }
            
            JHAudienceCommentTableViewCell *cell =(JHAudienceCommentTableViewCell*) [self.commentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
            [cell reloadCell:mode];
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [UITipView showTipStr:respondObject.message];
        }];
        //  [SVProgressHUD show];
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

- (void)dealloc
{
    NSLog(@"dealloc");
}


@end
