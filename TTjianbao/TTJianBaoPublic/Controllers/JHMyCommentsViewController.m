//
//  JHMyCommentsViewController.m
//  TTjianbao
//
//  Created by YJ on 2021/1/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCommentsViewController.h"
#import "JHCommentListTableViewCell.h"
#import "JHUserInfoApiManager.h"
#import "JHWebViewController.h"
#import "UIView+Blank.h"
#import "JHSQManager.h"
#import "JHSQApiManager.h"
#import "JHMessageSubView.h"
#import "JHMessageCommentTableViewCell.h"
#import "JHMsgSubListLikeCommentModel.h"
#import "JHMsgSubListModel.h"
#import "JHMessageSubListHeaderView.h"
#import "JHMsgSubListNormalModel.h"
#import "JHMsgSubListAnnounceModel.h"
#import "CommentToolView.h"
#import "JHMessageSubListData.h"
#import "TTJianBaoColor.h"
#import "JHEasyInputTextView.h"

@interface JHMyCommentsViewController ()<UITableViewDelegate, UITableViewDataSource ,JHMessageSubviewDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, assign) NSInteger page;
///是否是第一次请求
@property (nonatomic, assign) BOOL isFirstRequst, isLoading;
@property (nonatomic, strong) NSMutableArray<JHMsgSubListShowModel*>* sortedArrayByDate;
@property (strong, nonatomic) NSMutableArray *nakeArray;
@property (assign, nonatomic) NSInteger pageIndex;
@property (copy, nonatomic) NSString *lastId;
@property (nonatomic, strong) JHMessageSubListData* sublistData;
@property (nonatomic, strong) NSIndexPath *toCommentIndexPath; //将要对这条帖子进行评论

@end

@implementation JHMyCommentsViewController

#pragma mark - CommentToolViewDelegate

- (NSIndexPath*)indexPathFromCell:(UITableViewCell*)cell
{
    return [self.tableView indexPathForCell:cell];
}

- (void)refreshCellIndexPath:(NSIndexPath*)indexPath isDelete:(BOOL)isDelete
{
    NSArray* indexPaths = [NSArray arrayWithObject:indexPath];
    if(isDelete)
    {
        [self.sortedArrayByDate[indexPath.section].groupArray removeObjectAtIndex:indexPath.row];
        if(self.sortedArrayByDate[indexPath.section].groupArray.count == 0)
        {
            [self.sortedArrayByDate removeObjectAtIndex:indexPath.section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    self.lastId = @"";
    self.pageIndex = 0;
    
    [self createTableView];
    [self refreshData];
}

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFirstRequst = YES;
        _isLoading = NO;
    }
    return self;
}

- (void)createTableView {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = kColorF5F6FA;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tableFooterView = [UIView new];
    table.delegate = self;
    table.dataSource = self;
    table.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,ScreenW,0.01f)];
    [self.view addSubview:table];
    _contentTableView = table;

    [table registerClass:[JHMessageCommentTableViewCell class] forCellReuseIdentifier:kCommentListIdentifer];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    @weakify(self);
    table.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}

#pragma mark - UITableViewDelegate / UITableViewSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedArrayByDate.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedArrayByDate[section].groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHMessagesTableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMessageCommentTableViewCell class])];
    if(!cell)
    {
        cell = [[JHMessageCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMessageCommentTableViewCell class])];
        JH_WEAK(self)
        ((JHMessageCommentTableViewCell*)cell).actionEvents = ^(NSNumber* type, id data) {
            JH_STRONG(self)
            self.toCommentIndexPath = indexPath;
            [self messageSubviewEvent:[type integerValue] data:data];
            
            if ([type integerValue] == JHMsgSubEventsTypeCommentLike)
            {
                //点赞
                [self sendlikeRequestWith];
            }
        };
    }

    [cell changeCellStyle:YES];
    
    JHMsgSubListModel* model = [self currentCellModel:indexPath];
    [cell updateData:model];
    
    return cell;
}
- (void)sendlikeRequestWith
{
    JHMsgSubListLikeCommentModel *model = self.commentArray[self.toCommentIndexPath.section];
    if (model.articleContent.isLike)
    {
        //已点赞
        NSLog(@"已点赞");
    }
    else
    {
        //未点赞
        NSLog(@"未点赞");
    }
//    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/like/%ld/%@/%ld"),
//                    (long)model.articleContent.itemType, model.articleContent.itemId, (long)model.articleContent.likeNum];
//    [Growing track:@"like" withVariable:@{@"value":@(1)}];
//    [HttpRequestTool postWithURL:url  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject)
//    {
//    } failureBlock:^(RequestModel *respondObject)
//    {
//        [UITipView showTipStr:respondObject.message];
//    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHMsgSubListModel* model = [self currentCellModel:indexPath];
   //页面跳转
    [self messageSubviewEvent:JHMsgSubEventsTypeOpenPage data:model];
    //埋点
    [self messageSubviewEvent:JHMsgSubEventsTypeGrowing data:model];
}

- (void)messageSubviewEvent:(JHMsgSubEventsType)type data:(id)data
{
    switch (type)
    {
        case JHMsgSubEventsTypeReload:
        default:
            {
            }
            break;
        case JHMsgSubEventsTypeOpenPage:
            {
                JHMsgSubListNormalModel* normalModel = (JHMsgSubListNormalModel*)data;
                if([kMsgSublistTypeCommon isEqualToString: @"comment"])
                {
                    //web page:平台公告
//                    if([normalModel isKindOfClass:[JHMsgSubListAnnounceModel class]])
//                        [self openWebPageController:(JHMsgSubListAnnounceModel*)data];
                }
                else if([normalModel isKindOfClass:[JHMsgSubListNormalModel class]]
                        || [normalModel isKindOfClass:[JHMsgSubListAnnounceModel class]])
                {
                    id keyValues = [normalModel.target mj_keyValues];
                    [JHRootController handleMessageModel:keyValues from:JHLiveFromInteractMessage];
                }
                else
                {
                    [self enterWebPostDetail:data isJumpComment:NO]; //这种比较特殊,社区评论和点赞落地
                }
            }
            break;
        
        case JHMsgSubEventsTypeOpenWeb:
            {
                //[self openWebPageController:(JHMsgSubListAnnounceModel*)data];
            }
            break;
        
        case JHMsgSubEventsTypeForumCare:
            {
                //[self pressForumCare:(NSIndexPath*)data];
            }
            break;
            
        case JHMsgSubEventsTypeHeadImage:
            {
                //[self pressForumHeadImage:(NSIndexPath*)data];
            }
            break;
            
        case JHMsgSubEventsTypeGrowing:
            {
                JHMsgSubListModel* model = (JHMsgSubListModel*)data;
                [JHGrowingIO trackPublicEventId:JHTrackMsgCenterListClick paramDict:@{@"type":@"comment" ? : @"", @"thirdType":model.thirdType ? : @"", @"title":model.title ? : @""}];
            }
            break;
            
        case JHMsgSubEventsTypeCommentEnterArticle:
            {
//                __weak NSIndexPath* indexPath = [self.msgList indexPathFromCell: (UITableViewCell*)data];
//                [self enterPostDetail:indexPath];
            }
            break;
            
        case JHMsgSubEventsTypeCommentDelete:
            {

            }
            break;
            
        case JHMsgSubEventsTypeCommentLike:
            {
                //点赞
//                JH_WEAK(self)
//                __weak NSIndexPath* indexPath = [self.msgList indexPathFromCell: (UITableViewCell*)data];
//                [self.sublistData requestLikeData:(NSIndexPath*)indexPath action:^(id obj) {
//                    JH_STRONG(self)
//                    [self.msgList refreshCellIndexPath:indexPath isDelete:NO];
//                }];
            }
            break;
            
        case JHMsgSubEventsTypeCommentComment:
            {
                if(1)
                {
                    //弹出评论框
                    [self showInputTextView];
                }
                else
                {
//                    JH_WEAK(self)
//                    __weak NSIndexPath* indexPath = [self.msgList indexPathFromCell: (UITableViewCell*)data];
//                    [self.sublistData requestCommentData:(NSIndexPath*)indexPath action:^(id obj) {
//                        JH_STRONG(self)
//                        [self.msgList refreshCellIndexPath:indexPath isDelete:NO];
//                    }];
                }
                [JHGrowingIO trackPublicEventId:@"msg_community_answer_click"];
            }
            break;
    }
}

- (void)showInputTextView
{
    //JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3];
    JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:(NSInteger)10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
    easyView.showLimitNum = YES;
    [JHKeyWindow addSubview:easyView];
    [easyView show];
    @weakify(easyView);
    [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
        @strongify(easyView);
        [easyView endEditing:YES];
        [self didSendText:inputInfos];
    }];
}

- (void)didSendText:(NSDictionary *)commentInfos {
    if ([JHSQManager needLogin]) {
        return;
    }
    
    JHMsgSubListLikeCommentModel *model = self.commentArray[self.toCommentIndexPath.section];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:commentInfos];
    [params setValue:model.articleContent.itemId forKey:@"item_id"];
    [params setValue:@(model.articleContent.itemType) forKey:@"item_type"];
    
    [self sendComment:params];
}

- (void)sendComment:(NSMutableDictionary *)params
{
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/user/comment") Parameters:params requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UITipView showTipStr:@"评论成功"];
                //block(commentData, NO);
            });
        });
        [SVProgressHUD dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];
    //埋点
    [Growing track:@"rate"];
}

- (void)enterWebPostDetail:(JHMsgSubListLikeCommentModel*)model isJumpComment:(BOOL)isJumpComment
{
    if([model isKindOfClass:[JHMsgSubListLikeCommentModel class]])
    {
        BOOL isComment = NO;
        BOOL isJump = isJumpComment;
        NSString* fromSource;
        if([model.pageType isEqualToString:kMsgSublistTypeComment])
        {
            isComment = YES;
            fromSource = @"messageCenterCommentList";
        }
        else //kMsgSublistTypeLike比较特殊
        {
            isComment = NO;
            if(model.replyArticle && model.replyArticle.content && model.replyArticle.publisher.name)
                isJump = YES; //点赞都是cell整个区域,so只能这么区分
            fromSource = @"messageCenterLikeList";
        }
        if(model.articleContent && model.articleContent.itemId)
        {
            [JHRouterManager pushPostDetailWithItemType:model.articleContent.itemType itemId:model.articleContent.itemId pageFrom:JHFromUndefined scrollComment:isJumpComment ? 1 : 0];
        }
        //埋点
        [JHGrowingIO trackPublicEventId:@"community_article_in" paramDict:@{@"from":fromSource, @"item_type":@(model.articleContent.itemType), @"item_id":model.articleContent.itemId ? : @"", @"comment_id":model.replyArticle.commentId ? : @""}];
    }
}

//- (void)openWebPageController:(JHMsgSubListAnnounceModel*)announce
//{
//    //类型不匹配直接return,防止crash
//    if(![announce isKindOfClass:[JHMsgSubListAnnounceModel class]])
//        return;
//    //公告类型 1: 平台公告「announce_common」
//    if ([announce.thirdType isEqualToString:kMsgSublistTypeActivity])
//    {
//        JHWebViewController *vc = [[JHWebViewController alloc] init];
//        vc.urlString = [NSString stringWithFormat:@"%@?customerId=%@",announce.href,[UserInfoRequestManager sharedInstance].user.customerId?:@""];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
//    else if ([announce.thirdType isEqualToString:kMsgSublistTypeCommon])
//    {
//        JH_WEAK(self)
//        [SVProgressHUD show];
//        [self.sublistData queryAnnounceContentById:announce.mId finish:^(id respData, NSString *errorMsg) {
//            [SVProgressHUD dismiss];
//            JH_STRONG(self)
//            if (!errorMsg)
//            {
//                if([respData length] > 0)
//                {
//                    JHWebViewController *vc = [[JHWebViewController alloc] init];
//                    vc.htmlString = respData;
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//                else
//                {
//                    [SVProgressHUD showErrorWithStatus:@"暂无数据"]; //服务端没有数据时,加个提示
//                }
//            }
//            else
//            {
//                [SVProgressHUD showErrorWithStatus:errorMsg];
//            }
//        }];
//    }
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (void)refreshData {
    if (!_isFirstRequst) {
        return;
    }
    _isFirstRequst = NO;
    _isLoading = YES;
    self.page = 1;
    [self loadData:YES];
}

- (void)loadMoreData {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    self.page ++;
    [self loadData:NO];
}

- (void)loadData:(BOOL)isRefresh
{
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)self.page];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:pageStr forKey:@"page"];
    [parameters setValue:self.lastId forKey:@"last_id"];
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/auth/user/comment/atme");
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSLog(@"@我的评论");
        //为什么这样写？？？？？？？？？？？？？？？
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray<JHMsgSubListLikeCommentModel *> *list = [JHMsgSubListLikeCommentModel convertData:respondObject.data];
            self.lastId = [NSString stringWithFormat:@"%@",[[[respondObject.data objectAtIndex:0] valueForKey:@"main"] valueForKey:@"comment_id"]];
            
           [self makeDataArray:list];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isLoading = NO;
                if (list.count > 0) {
                    [self.contentTableView.mj_footer endRefreshing];
                    [self.commentArray addObjectsFromArray:list];
                    [self.contentTableView reloadData];
                }
                else {
                    [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self showBlankView:self.commentArray.count];
            });
        });

    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        NSLog(@"error");
        [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
        [self showBlankView:self.commentArray.count];

        [UITipView showTipStr:respondObject.message];
    }];
}

//获取数据=>排序
- (void)makeDataArray:(NSArray*)arr
{
    if (self.pageIndex == 0)
        self.nakeArray = [NSMutableArray arrayWithArray:arr];
    else
        [self.nakeArray addObjectsFromArray:arr];
    //数据=>排序
    [self sortdataArray];
}
//获取数据后=>排序
- (void)sortdataArray
{
    self.sortedArrayByDate =[NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    //1聚合时间>按时间分组
    [self.nakeArray enumerateObjectsUsingBlock:^(JHMsgSubListModel *model, NSUInteger idx, BOOL *stop) {
        [timeArr addObject:model.createDate];
    }];
    NSSet *set = [NSSet setWithArray:timeArr]; //时间去重
    NSArray *userArray = [set allObjects];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    NSArray *descendingDateArr = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    //2按时间聚合,创建新数组【内含JHMsgSubListShowModel子类】
    [descendingDateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JHMsgSubListShowModel *show = [[JHMsgSubListShowModel alloc]init];
        [self.sortedArrayByDate addObject:show];
    }];
    //3新数组赋值,效率有点低了
    [self.nakeArray enumerateObjectsUsingBlock:^(JHMsgSubListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSString *str in descendingDateArr) {
            if([str isEqualToString:model.createDate]) {
                JHMsgSubListShowModel *showModel = [self.sortedArrayByDate objectAtIndex:[descendingDateArr indexOfObject:str]];
                showModel.dateTime = str;
                [showModel.groupArray addObject:model];
            }
        }
    }];
}

- (JHMsgSubListModel*)currentCellModel:(NSIndexPath*)indexPath
{
    JHMsgSubListModel* model = nil;
    if(indexPath.section >= 0 && indexPath.section < [self.sortedArrayByDate count])
    {
        model = self.sortedArrayByDate[indexPath.section].groupArray[indexPath.row];
    }
    return model;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//- (void)loadData:(BOOL)isRefresh {
//
//    NSString *lastId = @"";
//    if (self.commentArray.count > 0) {
//        JHUserInfoCommentModel *model = [self.commentArray lastObject];
//        lastId = model.mainInfo.comment_id;
//    }
//    @weakify(self);
//
//    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)self.page];
//    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    [parameters setValue:pageStr forKey:@"page"];
//    [parameters setValue:lastId forKey:@"last_id"];
//    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/auth/user/comment/atme");
//    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject)
//    {
//        @strongify(self);
//        NSLog(@"@我的评论---%@",respondObject.data);
//        //为什么这样写？？？？？ 那就这样copy吧
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            NSArray<JHUserInfoCommentModel *> *list = [NSArray modelArrayWithClass:[JHUserInfoCommentModel class] json:respondObject.data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.isLoading = NO;
//                if (list.count > 0) {
//                    [self.contentTableView.mj_footer endRefreshing];
//                    [self.commentArray addObjectsFromArray:list];
//                    [self.contentTableView reloadData];
//                }
//                else {
//                    [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
//                }
//                [self showBlankView:self.commentArray.count];
//            });
//
//        });
//
//    } failureBlock:^(RequestModel * _Nullable respondObject)
//    {
//        NSLog(@"error");
//        [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
//        [self showBlankView:self.commentArray.count];
//
//        [UITipView showTipStr:respondObject.message];
//    }];
//}

- (void)showBlankView:(NSInteger)count {
    if (count == 0) {
        [self showDefaultImageWithView:self.view];
    }
}

#pragma mark -
#pragma mark - 分页逻辑

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.contentTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}
- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
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
