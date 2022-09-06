//
//  JHMessageSubListController.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageSubListController.h"
#import "JHMessageSubView.h"
#import "JHGemmologistViewController.h"
#import "JHWebViewController.h"
#import "JHSQManager.h"
#import "CommentToolView.h"
#import "JHCustomerInfoController.h"
#import "JHUserInfoViewController.h"
#import "JHC2CProductDetailController.h"

@interface JHMessageSubListController () <JHMessageSubviewDelegate, CommentToolViewDelegate>
{
    NSTimeInterval beginShowTime;
}
@property (nonatomic, copy) NSString* pageType;
@property (nonatomic, copy) NSString* showTitle;
@property (nonatomic, strong) JHMessageSubView* msgList;
@property (nonatomic, strong) JHMessageSubListData* sublistData;
@property (nonatomic, strong) UIButton* commentToolBackgroundView;
@property (nonatomic, strong) CommentToolView* commentToolView;
@property (nonatomic, strong) UITableViewCell* currentTableViewCell;

@property (nonatomic, assign) BOOL isAppear;

@end

@implementation JHMessageSubListController

-(void)dealloc
{
    NSLog(@"JHMessageSubListController~~");
    NSLog(@"%@*************被释放",[self class])
}

- (id)initWithTitle:(NSString*)title pageType:(NSString*)type
{
    self = [super init];
    if (self)
    {
        self.showTitle = title ? : @"分类";
        self.pageType = type;
        [JHNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadOneData]; //优先请求
    
    self.view.backgroundColor = kColorF5F6FA;
//    [self setupToolBarWithTitle:self.showTitle];
    self.title = self.showTitle;
    //显示list
    [self.view addSubview:self.msgList];
    
    if([kMsgSublistTypeLike isEqualToString: self.pageType])
    {//清理点赞
        [self.sublistData requestClearLike:^(id obj) {

        }];
    }
    else if([kMsgSublistTypeComment isEqualToString: self.pageType])
    {//清理评论
        [self.sublistData requestClearComment:^(id obj) {

        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    beginShowTime = [[NSDate date] timeIntervalSince1970];
    _isAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self trackPageShowTime];
    _isAppear = NO;
}

- (JHMessageSubView *)msgList
{
    if(!_msgList)
    {
        _msgList = [[JHMessageSubView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight,ScreenW , ScreenH-UI.statusAndNavBarHeight) pageType:self.pageType];
        _msgList.delegate = self;
    }
    return _msgList;
}

- (void)endRefresh
{
    [self.msgList endTableRefresh];
}

- (UIButton*)commentToolBackgroundView
{
    if(!_commentToolBackgroundView)
    {
        _commentToolBackgroundView = [UIButton new];
        _commentToolBackgroundView.frame = self.view.frame;
        _commentToolBackgroundView.backgroundColor = HEXCOLORA(0x0, 0.1);
        [_commentToolBackgroundView addTarget:self action:@selector(dismissCommentToolView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentToolBackgroundView;
}

- (CommentToolView*)commentToolView
{
    if (!_commentToolView)
    {
        _commentToolView = [[CommentToolView alloc] initWithFrame:CGRectMake(0, ScreenH, self.view.width, 50)];
        _commentToolView.delegate = self;
        _commentToolView.commentTextField.placeholder = @"精彩评论将被优先展示~";
        self.currentTableViewCell = nil;
    }
    return _commentToolView;
}

- (void)dismissCommentToolView
{
    self.currentTableViewCell = nil;
    [_commentToolView removeFromSuperview];
    _commentToolView.delegate = nil;
    _commentToolView = nil;
    [_commentToolBackgroundView removeFromSuperview];
    _commentToolBackgroundView = nil;
}

- (void)showCommentToolView
{
    [JHKeyWindow addSubview:self.commentToolBackgroundView];
    [self.commentToolBackgroundView addSubview:self.commentToolView];
    [self.commentToolView.commentTextField becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(_isAppear)
    {
        CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        //键盘弹起时间
        CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration: duration animations:^{
            self.commentToolView.frame = CGRectMake(0, ScreenH - keyboardHeight, self.view.width, 50);
        }];
    }
    
}

#pragma mark - 请求数据
- (JHMessageSubListData *)sublistData
{
    if(!_sublistData)
    {
        _sublistData = [JHMessageSubListData new];
    }
    return _sublistData;
}

- (void)loadOneData
{
    self.sublistData.pageIndex = 0;
    [SVProgressHUD show];
    [self requestListData];
}

- (void)loadMoreData
{
    self.sublistData.pageIndex ++;
    [self requestListData];
}

- (void)requestListData
{
    [self.sublistData requestByPageType:self.pageType finish:^(NSString *errorMsg) {
        [SVProgressHUD dismiss];
        if(errorMsg)
        {
            [self endRefresh];
            [self.view makeToast:errorMsg duration:1.0 position:CSToastPositionCenter];
        }
        else
        {
            [self.msgList refreshShowData:self.sublistData.sortedArrayByDate];
            [self.msgList refreshJHMsgSubListLikeCommentModelData:self.sublistData.list];
        }
    }];
}

#pragma mark - CommentToolViewDelegate
- (void)OnClickComment:(NSString *)string
{
    static int maxLength = 200;
    if (string.length > maxLength)
    {
        [UITipView showTipStr:[NSString stringWithFormat:@"不能超过%ld字", (long)maxLength]];
        return;
    }
    JH_WEAK(self)
    __weak NSIndexPath* indexPath = [self.msgList indexPathFromCell: self.currentTableViewCell];
    [self.sublistData requestCommentData:(NSIndexPath*)indexPath content:string action:^(id obj) {
        JH_STRONG(self)
        [self.msgList refreshCellIndexPath:indexPath isDelete:NO];
    }];
    
    //隐藏评论框
    [self dismissCommentToolView];
}

#pragma mark - event delegate
- (void) messageSubviewEvents:(JHMsgSubEventsType)type data:(id)data
{
    switch (type)
    {
        case JHMsgSubEventsTypeReload:
        default:
            {
                if(data)
                    [self loadMoreData];
                else
                    [self loadOneData];
            }
            break;
        case JHMsgSubEventsTypeOpenPage:
            {
                JHMsgSubListNormalModel* normalModel = (JHMsgSubListNormalModel*)data;
                if([kMsgSublistTypeCommon isEqualToString: self.pageType])
                {//web page:平台公告
                    if([normalModel isKindOfClass:[JHMsgSubListAnnounceModel class]])
                        [self openWebPageController:(JHMsgSubListAnnounceModel*)data];
                }
                else if([normalModel isKindOfClass:[JHMsgSubListNormalModel class]]
                        || [normalModel isKindOfClass:[JHMsgSubListAnnounceModel class]])
                {
                    id keyValues = [normalModel.target mj_keyValues];
                    [JHRootController handleMessageModel:keyValues from:JHLiveFromInteractMessage];
                }
                else
                {
                    if([data isKindOfClass:[JHMsgSubListLikeCommentModel class]]){
                        JHMsgSubListLikeCommentModel *comModel = (JHMsgSubListLikeCommentModel *)data;
                        if (comModel.article.item_type == 100) {//跳c2c商品详情页
                            JHC2CProductDetailController *vc = [JHC2CProductDetailController new];
                            vc.productId = comModel.articleContent.origin_id;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{//跳帖子详情页
                            [self enterWebPostDetail:data isJumpComment:NO]; //这种比较特殊,社区评论和点赞落地
                        }
                    }
                }
            }
            break;
        
        case JHMsgSubEventsTypeOpenWeb:
            {
                [self openWebPageController:(JHMsgSubListAnnounceModel*)data];
            }
            break;
        
        case JHMsgSubEventsTypeForumCare:
            {
                [self pressForumCare:(NSIndexPath*)data];
            }
            break;
            
        case JHMsgSubEventsTypeHeadImage:
            {
                [self pressForumHeadImage:(NSIndexPath*)data];
            }
            break;
            
        case JHMsgSubEventsTypeGrowing:
            {
                JHMsgSubListModel* model = (JHMsgSubListModel*)data;
                [JHGrowingIO trackPublicEventId:JHTrackMsgCenterListClick paramDict:@{@"type":self.pageType ? : @"", @"thirdType":model.thirdType ? : @"", @"title":model.title ? : @""}];
            }
            break;
            
        case JHMsgSubEventsTypeCommentEnterArticle:
            {
                __weak NSIndexPath* indexPath = [self.msgList indexPathFromCell: (UITableViewCell*)data];
                [self enterPostDetail:indexPath];
            }
            break;
            
        case JHMsgSubEventsTypeCommentDelete:
            {
                JH_WEAK(self)
                __weak NSIndexPath* indexPath = [self.msgList indexPathFromCell: (UITableViewCell*)data];
                [self.sublistData deleteCommentData:indexPath action:^(NSString* msg) {
                    JH_STRONG(self)
                    if(msg)
                    {
                        [SVProgressHUD showErrorWithStatus:msg];
                    }
                    else
                    {
                        [self.msgList refreshCellIndexPath:indexPath isDelete:YES];
                    }
                }];
            }
            break;
            
        case JHMsgSubEventsTypeCommentLike:
            {
                JH_WEAK(self)
                __weak NSIndexPath* indexPath = [self.msgList indexPathFromCell: (UITableViewCell*)data];
                [self.sublistData requestLikeData:(NSIndexPath*)indexPath action:^(id obj) {
                    JH_STRONG(self)
                    [self.msgList refreshCellIndexPath:indexPath isDelete:NO];
                }];
            }
            break;
            
        case JHMsgSubEventsTypeCommentComment:
            {
                if(1)
                {
                    //[self showCommentToolView];
                    //self.currentTableViewCell = (UITableViewCell*)data;
                }
                else
                {
                    JH_WEAK(self)
                    __weak NSIndexPath* indexPath = [self.msgList indexPathFromCell: (UITableViewCell*)data];
                    [self.sublistData requestCommentData:(NSIndexPath*)indexPath action:^(id obj) {
                        JH_STRONG(self)
                        [self.msgList refreshCellIndexPath:indexPath isDelete:NO];
                    }];
                }
                [JHGrowingIO trackPublicEventId:@"msg_community_answer_click"];
            }
            break;
            
        case JHMsgSubEventsTypePersonPage:
            {//跳转用户主页
                JHMsgSubListLikeCommentModel *comModel = (JHMsgSubListLikeCommentModel *)data;
                if (!isEmpty(comModel.article.publisher.user_id)) {
                    JHUserInfoViewController *vc = [[JHUserInfoViewController alloc] init];
                    vc.userId = comModel.article.publisher.user_id;
                    [self.navigationController pushViewController:vc animated:true];
                }
            }
            break;
    }
}

- (void)openWebPageController:(JHMsgSubListAnnounceModel*)announce
{
    //类型不匹配直接return,防止crash
    if(![announce isKindOfClass:[JHMsgSubListAnnounceModel class]])
        return;
    //公告类型 1: 平台公告「announce_common」
    if ([announce.thirdType isEqualToString:kMsgSublistTypeActivity])
    {
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.urlString = [NSString stringWithFormat:@"%@?customerId=%@",announce.href,[UserInfoRequestManager sharedInstance].user.customerId?:@""];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([announce.thirdType isEqualToString:kMsgSublistTypeCommon])
    {
        JH_WEAK(self)
        [SVProgressHUD show];
        [self.sublistData queryAnnounceContentById:announce.mId finish:^(id respData, NSString *errorMsg) {
            [SVProgressHUD dismiss];
            JH_STRONG(self)
            if (!errorMsg)
            {
                if([respData length] > 0)
                {
                    JHWebViewController *vc = [[JHWebViewController alloc] init];
                    vc.htmlString = respData;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"]; //服务端没有数据时,加个提示
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:errorMsg];
            }
        }];
    }
}
//需要调精准评论区
- (void)enterPostDetail:(NSIndexPath*)indexPath
{
    if(indexPath.section < self.sublistData.sortedArrayByDate.count &&
       indexPath.row < self.sublistData.sortedArrayByDate[indexPath.section].groupArray.count)
    {
        JHMsgSubListLikeCommentModel* data = (JHMsgSubListLikeCommentModel*)(self.sublistData.sortedArrayByDate[indexPath.section].groupArray[indexPath.row]);
        [self enterWebPostDetail:data isJumpComment:YES];
    }
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

- (void)pressForumHeadImage:(NSIndexPath*)indexpath
{
    [SVProgressHUD show];
    [self.sublistData getUserBridge:indexpath response:^(id respData, NSString *uId) {
        [SVProgressHUD dismiss];

        if(respData && uId) //success
        {
            NSString* userRole = (NSString*)respData;
            if ([userRole isEqualToString:@"1"]) //主播
            {
                JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
                vc.anchorId = uId;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([userRole isEqualToString:@"9"]) { // 定制师主页
                JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
                vc.channelLocalId = uId;
                vc.fromSource = @"businessliveplay";
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                ///跳转到个人主页界面
                [JHRootController enterUserInfoPage:uId from:@""];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)pressForumCare:(NSIndexPath*)indexpath
{
    [SVProgressHUD show];
    [self.sublistData followUserWithIndexpath:indexpath finish:^(NSString *errorMsg) {
        [SVProgressHUD dismiss];
        if(errorMsg)
        {
            [SVProgressHUD dismiss];
            [UITipView showTipStr:errorMsg];
        }
        else
        {
            [self.msgList refreshShowData:self.sublistData.sortedArrayByDate];
        }
    }];
    [JHGrowingIO trackPublicEventId:JHTrackMsgCenterListAttenttionAlertClick];
}

//页面停留时间
- (void)trackPageShowTime
{
    NSTimeInterval endShowTime = [[NSDate date] timeIntervalSince1970];
    NSString *duration = [NSString stringWithFormat:@"%.f", endShowTime - beginShowTime];
    [JHGrowingIO trackPublicEventId:JHTrackMsgCenterListDuration paramDict:@{@"type":self.pageType ? : @"", @"duration":duration}];
}

@end
