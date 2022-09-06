//
//  JHOrderCommentManngeViewController.m
//  TTjianbao
//
//  Created by jiang on 2019/8/1.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderCommentManngeViewController.h"
#import "JHAudienceCommentTableViewCell.h"
#import "CommentToolView.h"
#import "IQKeyboardManager.h"
#import "NTESTextInputView.h"
#import "JHCommentHeaderTagView.h"
#import "JHAudienceCommentMode.h"
#import "TTjianbaoBussiness.h"
#import "JHWebViewController.h"

#define pagesize 10
#define spaceTop  0
@interface JHOrderCommentManngeViewController ()<UITableViewDelegate,UITableViewDataSource,CommentToolViewDelegate,NTESTextInputViewDelegate>
{
      NSInteger PageNum;
       CGFloat _keyBoradHeight;
         JHCommentHeaderTagView *  tableHeaderView;
}
@property(nonatomic,strong) NSMutableArray* audienceCommentModes;
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) CommentToolView* commentToolView;
@property(nonatomic,strong) NTESTextInputView* textInputView;
@property(nonatomic,assign)   NSInteger selectIndex;
@property(nonatomic,strong)    NSString * tagCode;
@property(nonatomic,strong) NSMutableArray<CommentTagMode*>* searchTagModes;
@end

@implementation JHOrderCommentManngeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
    self.title = @"买家评价";
//    [self.navbar setTitle:@"买家评价"];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.tagCode=@"all";
    [self.view addSubview:self.homeTable];
    [self setHeaderView];
    [self loadNewData];
    [self requestTags];
    [self.view addSubview:self.textInputView];
   // [self.view addSubview:self.commentToolView];
//    [self.commentToolView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(50);
//        make.bottom.offset(0);
//        make.left.right.equalTo(self.view);
//    }];
    
    UITapGestureRecognizer*tableTap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
  //  tableTap.delegate=self;
    [self.homeTable  addGestureRecognizer:tableTap];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
-(void)setHeaderView{
    tableHeaderView=[[JHCommentHeaderTagView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    self.homeTable.tableHeaderView=tableHeaderView;
    MJWeakSelf
    tableHeaderView.finish = ^(CGFloat height) {
        __strong typeof(weakSelf) sself = weakSelf;
        sself->tableHeaderView.frame=CGRectMake(0, 0, ScreenW, height);
        weakSelf.homeTable.tableHeaderView= sself->tableHeaderView;
    };
    tableHeaderView.clickTagFinish = ^(id sender) {
        UIButton * btn=(UIButton*)sender;
        weakSelf.tagCode=weakSelf.searchTagModes[btn.tag].tagCode;
        [weakSelf loadNewData];
    };
}
-(void)loadNewData{
    
    PageNum=0;
    [self requestCommentList];
    
}
-(void)loadMoreData{
    PageNum++;
    [self requestCommentList];
}
-(void)requestTags{
        User *user = [UserInfoRequestManager sharedInstance].user;
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/countByTag?sellerCustomerId=%@&roomId=%@"), user.customerId,self.isSeller?@"":@"-1"];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.searchTagModes=[NSMutableArray array];
        self.searchTagModes = [CommentTagMode  mj_objectArrayWithKeyValuesArray:respondObject.data];
        [tableHeaderView showTagArray:self.searchTagModes];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
-(void)requestCommentList{
    
      User *user = [UserInfoRequestManager sharedInstance].user;
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/list?sellerCustomerId=%@&roomId=%@&pageNo=%ld&pageSize=%ld&tagCode=%@"), user.customerId,  self.isSeller?@"0":@"-1",PageNum,pagesize,self.tagCode];
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
        self.audienceCommentModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.audienceCommentModes addObjectsFromArray:arr];
        
    }
    [self.homeTable reloadData];
    
    if ([arr count]<pagesize) {
        self.homeTable.mj_footer.hidden=YES;
    }
    else{
        self.homeTable.mj_footer.hidden=NO;
    }
}
- (void)endRefresh {
    [self.homeTable.mj_footer endRefreshing];
}
#pragma mark - Private
- (UIView *)getTextViewFromTextInputView
{
    UITextView *view = (UITextView *)self.textInputView.textView.textView;
    return view;
//    for (UIView *view in self.textInputView.subviews) {
//        if ([view isKindOfClass:[NTESGrowingTextView class]]) {
//            for (UIView * subview in view.subviews) {
//                if ([subview isKindOfClass:[UITextView class]]) {
//                    return subview;
//                }
//            }
//        }
//    }
//    return nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
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
    return YES;
    
}
-(void)dismissKeyboard {
    
    [self.view endEditing:YES];
}

#pragma mark =============== setter ===============
-(UITableView*)homeTable{
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.bounces=YES;
        _homeTable.estimatedRowHeight = 100;
        _homeTable.contentInset=UIEdgeInsetsMake(0, 0,0, 0);
        _homeTable.backgroundColor=[UIColor whiteColor];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        JH_WEAK(self)
        _homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
         _homeTable.mj_footer.hidden=YES;
        
    }
    return _homeTable;
}
- (NTESTextInputView *)textInputView
{
    if (!_textInputView) {
        CGFloat height = 44.f;
        _textInputView = [[NTESTextInputView alloc] initWithFrame:CGRectMake(0, ScreenH, self.view.width, height)];
        _textInputView.delegate = self;
        _textInputView.ignoreCheck=YES;
        _textInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        NTESGrowingTextView *textView = _textInputView.textView;
        NSString *placeHolder = @"请输入评论内容";
        textView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:textView.font,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    }
    return _textInputView;
}
-(CommentToolView *)commentToolView{
    
    if (!_commentToolView) {
        _commentToolView=[[CommentToolView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, 50)];
        _commentToolView.top=spaceTop;
        _commentToolView.delegate=self;
        
    }
    return _commentToolView;
}
#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.audienceCommentModes.count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    JHAudienceCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHAudienceCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    [cell setAudienceCommentMode:self.audienceCommentModes[indexPath.section]];
    [cell setCellIndex:indexPath.section];
    cell.isCanReply=YES;
    JH_WEAK(self)
    cell.cellClick = ^(UIButton *button, BOOL isLaud, NSInteger index) {
        JH_STRONG(self)
        if (button.tag==1) {
            JHAudienceCommentMode * mode=[self.audienceCommentModes objectAtIndex:index];
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), mode.orderId];
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        }
        if (button.tag==2) {
          //  [self clickIndex:index isLaud:isLaud];
        }
        if (button.tag==3) {
           
            self.selectIndex=index;
             JHAudienceCommentMode * mode=[self.audienceCommentModes objectAtIndex:self.selectIndex];
            if (!mode.isReply) {
                UITextView *textview = (UITextView*)[self getTextViewFromTextInputView];
                [textview becomeFirstResponder];
            }
        }
    };
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
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==[self.audienceCommentModes count]-1) {
        return 1;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer =[[UIView alloc]init];
    footer.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return footer;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    NSDictionary *info = notification.userInfo;
    _keyBoradHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [self setChatViewLayout];
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
        _keyBoradHeight = 0;
        [self setChatViewLayout];
    
}
- (void)setChatViewLayout {
    if (_keyBoradHeight)
    {
        self.textInputView.bottom = self.view.height - _keyBoradHeight;
    }
    else
    {
         self.textInputView.top =  self.view.height;
    }
    
}
- (void)didSendText:(NSString *)text{
    
       NSLog(@"%@",text);
    if (text.length>300) {
        [self.view makeToast:@"最多300字 超出啦" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    [self dismissKeyboard ];
    
  JHAudienceCommentMode * mode=[self.audienceCommentModes objectAtIndex:self.selectIndex];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderComment/auth/reply") Parameters:@{@"commentId":mode.Id,@"reply":text,@"isReply":@(mode.isReply)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
          NSArray *arr = [CommentReplyMode mj_objectArrayWithKeyValuesArray:respondObject.data];
           mode.orderServiceComments=arr;
           mode.isReply=YES;
          [self.homeTable reloadData];
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
