//
//  JHAnchorCommentListController.m
//  TTjianbao
//
//  Created by lihui on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorCommentListController.h"
#import "JHAudienceCommentTableViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "JHCommentHeaderTagView.h"
#import "JHWebViewController.h"

#define pageSize 10

@interface JHAnchorCommentListController ()
<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    UIView *  headerView;
    UIView * footerView;
    JHRefreshNormalFooter *footer;
    UILabel *lb;
    JHCommentHeaderTagView *tableHeaderView;
}

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property(nonatomic,strong) UITableView *commentTableView;
@property(nonatomic,strong) NSMutableArray *commentArray;
@property(nonatomic,strong) NSMutableArray <CommentTagMode*>*searchTagModes;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,copy) NSString *tagCode;

@property(nonatomic,assign) BOOL isLoading, isFirstRequest;

@end

@implementation JHAnchorCommentListController

- (void)setChannel:(ChannelMode *)channel {
    _channel = channel;
    self.anchorId = _channel.anchorId;
    self.roomId = _channel.roomId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstRequest = YES;
    _isLoading = NO;
    self.tagCode = @"all";
    [self createTableView];
    [self setHeaderView];
    [self setFooterView];
    [self refreshData];
    [self requestTags];
}

- (void)createTableView {
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.alwaysBounceVertical = YES;
    _commentTableView.scrollEnabled = YES;
    _commentTableView.bounces = YES;
    _commentTableView.estimatedRowHeight = 100;
    _commentTableView.contentInset = UIEdgeInsetsMake(0, 0,0, 0);
    _commentTableView.backgroundColor = kColorF5F6FA;
    [_commentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _commentTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_commentTableView];
    [_commentTableView registerClass:[JHAudienceCommentTableViewCell class] forCellReuseIdentifier:@"JHAudienceCommentTableViewCell"];
    
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.offset(-UI.bottomSafeAreaHeight);
    }];
    
    @weakify(self);
    self.commentTableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
    [self.commentTableView.mj_footer setHidden:YES];
}

- (void)setHeaderView {
   JHCommentHeaderTagView *tableHeader = [[JHCommentHeaderTagView alloc]initWithFrame:CGRectMake(0, 1, ScreenW, 10)];
    tableHeader.backgroundColor = HEXCOLOR(0xffffff);
    _commentTableView.tableHeaderView = tableHeader;
    tableHeaderView = tableHeader;
    @weakify(self);
    __block typeof(tableHeader)blockHeader = tableHeader;
    tableHeader.finish = ^(CGFloat height) {
        @strongify(self);
        blockHeader.frame = CGRectMake(0, 1, ScreenW, height);
        if (self.commentArray.count > 0) {
            self.commentTableView.tableHeaderView = blockHeader;
        }
    };
    tableHeaderView.clickTagFinish = ^(id sender) {
        @strongify(self);
        UIButton * btn=(UIButton*)sender;
        self.tagCode = self.searchTagModes[btn.tag].tagCode;
        [self refreshData];
    };
}

- (void)setFooterView {
    footerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
    footerView.backgroundColor = kColorF5F6FA;
    lb = [[UILabel alloc ]initWithFrame:CGRectMake(0, 30, ScreenW , 30)];
    lb.font = [UIFont fontWithName:kFontNormal size:13];
    lb.text = @"";
    lb.textAlignment = UIControlContentHorizontalAlignmentLeft;
    lb.textColor = [UIColor lightGrayColor];
    [footerView addSubview:lb];
    _commentTableView.tableFooterView = footerView;
}

-(void)refreshData {
//    if (!_isFirstRequest) {
//        return;
//    }
    _isFirstRequest = NO;
    _isLoading = YES;
    self.page = 0;
    [self loadData:YES];
}
-(void)loadMoreData{
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    self.page ++;
    [self loadData:NO];
}

-(void)loadData:(BOOL)isRefresh {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/list?sellerCustomerId=%@&roomId=%@&pageNo=%ld&pageSize=%ld&tagCode=%@"), self.anchorId,self.roomId,self.page, pageSize, self.tagCode];
    NSLog(@"url :----- %@", url);
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self handleDataWithArr:respondObject.data[@"datas"]];
        });
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [JHAudienceCommentMode mj_objectArrayWithKeyValuesArray:array];
    if (self.page == 0) {
        self.commentArray = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.commentArray addObjectsFromArray:arr];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isLoading = NO;
        [self.commentTableView reloadData];
        if (arr.count < pageSize) {
            self.commentTableView.mj_footer.hidden=YES;
            if (arr.count == 0 && self.commentArray.count == 0){
                footerView.backgroundColor = kColorF5F6FA;
                [self showBlankView:0];
                lb.text = @"";
            }
            else {
                footerView.backgroundColor = [UIColor whiteColor];
                lb.text = @"— 已显示全部评论 —";
            }
       }
       else {
            self.commentTableView.mj_footer.hidden = NO;
       }
        if (self.commentArray.count > 0) {
            self.commentTableView.tableHeaderView = tableHeaderView;
        }
        else {
            self.commentTableView.tableHeaderView = nil;
        }
    });
}

-(void)requestTags {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/countByTag?sellerCustomerId=%@&roomId=%@"), self.anchorId,self.roomId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.searchTagModes=[NSMutableArray array];
        self.searchTagModes = [CommentTagMode  mj_objectArrayWithKeyValuesArray:respondObject.data];
        [tableHeaderView showTagArray:self.searchTagModes];
   
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    NSLog(@"%lf",scrollView.contentOffset.y);
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
            JHAudienceCommentMode * mode=[self.commentArray objectAtIndex:index];
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
    if (section == 0) {
        return 1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self.commentArray count]-1) {
        return 1;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]init];
    footer.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return footer;
}

- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud {
    if ([self isLgoin]) {
        JHAudienceCommentMode * mode = [self.commentArray objectAtIndex:index];
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

- (void)showBlankView:(NSInteger)count {
    if (count == 0) {
        [self showDefaultImageWithView:self.view];
    }
}

- (void)endRefresh {
    [self.commentTableView.mj_footer endRefreshing];
}

-(BOOL)isLgoin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
            }
        }];
        return  NO;
    }
    return  YES;
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.commentTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (NSMutableArray<CommentTagMode *> *)searchTagModes {
    if (!_searchTagModes) {
        _searchTagModes = [NSMutableArray array];
    }
    return _searchTagModes;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
