//
//  JHOnlineAppraiseCommentView.m
//  TTjianbao
//
//  Created by lihui on 2020/12/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineAppraiseCommentView.h"
#import "JHWebViewController.h"
#import "JHCommitViewController.h"
#import "JHOnlineAppraiseToolBar.h"
#import "JHBaseOperationView.h"
#import "JHPostMainCommentHeader.h"
#import "JHSubCommentTableCell.h"
#import "JHPostCommentFooterView.h"
#import "JHEasyInputTextView.h"
#import "JHSQApiManager.h"
#import "JHUserInfoApiManager.h"
#import "JHSQManager.h"
#import "JHPostDetailModel.h"

#define pagesize 25
#define spaceTop 200

#define kToolBarHeight  (UI.bottomSafeAreaHeight + 44)

typedef void (^successBlock)(void);

@interface JHOnlineAppraiseCommentView () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate> {
    UIView *  headerView;
    UIView * footerView;
    JHRefreshNormalFooter *footer;
    UILabel *lb;
}

@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) UILabel* commentCountLabel;
@property(nonatomic,strong)  UIView * contentView;
@property (nonatomic, strong) NSMutableArray <JHCommentModel *>*commentArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*filterIds;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger replyPage;
@property (nonatomic, strong) JHCommentModel *currentMainComment;
@property (nonatomic, strong) JHCommentModel *currentComment;
///底部工具栏
@property (nonatomic, strong) JHOnlineAppraiseToolBar *toolBar;
@end

@implementation JHOnlineAppraiseCommentView
- (NSMutableArray<NSString *> *)filterIds {
    if (!_filterIds) {
        _filterIds = [NSMutableArray array];
    }
    return _filterIds;
}
- (NSMutableArray<JHCommentModel *> *)commentArray {
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (void)setPostDetail:(JHPostDetailModel *)postDetail {
    if (!postDetail) {
        return;
    }
    _postDetail = postDetail;
    [self updateCommentCount];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.contentView];
        [self setHeaderView];
        [self setFooterView];
        [self.contentView addSubview:self.homeTable];
        [self.homeTable mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.offset(50);
              make.bottom.offset(-kToolBarHeight);
              make.left.right.equalTo(self);
        }];
        
        [self.contentView addSubview:self.toolBar];
        [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(44.);
        }];

        self.gestView = self.contentView;
        self.gestView = self.homeTable;
    }
    return self;
}

///底部评论框

- (JHOnlineAppraiseToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[JHOnlineAppraiseToolBar alloc] init];
        _toolBar.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        _toolBar.commentBlock = ^{
            @strongify(self);
            //点击评论 埋点
            NSMutableDictionary *params = [self sa_getParams];
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_edit" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            [self inputComment:YES];
        };
    }
    return _toolBar;
}

-(UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0,spaceTop, ScreenW, ScreenH - spaceTop)];
        _contentView.backgroundColor=[UIColor whiteColor];
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
    }
    return _contentView;
}
///顶部全部评论的UI
- (void)setHeaderView {
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW,50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(8,8)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headerView.bounds;
    maskLayer.path = maskPath.CGPath;
    headerView.layer.mask = maskLayer;
    [self.contentView addSubview:headerView];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorEEE;
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.equalTo(headerView);
        make.bottom.equalTo(headerView).offset(0);
    }];
    
    _commentCountLabel = [[UILabel alloc ] initWithFrame:CGRectMake(15,0, ScreenW , 50)];
    _commentCountLabel.font = [UIFont fontWithName:kFontBoldPingFang size:15.];
    _commentCountLabel.textColor = HEXCOLOR(0x333333);
    [headerView addSubview:_commentCountLabel];
    UIButton * close = [[UIButton alloc]init];
    [close setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    close.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
         make.size.mas_equalTo(CGSizeMake(35, 35));
        make.right.equalTo(headerView).offset(-15);
    }];
}
- (void)setFooterView {
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
    footerView.backgroundColor = [UIColor whiteColor];
    lb = [[UILabel alloc ]initWithFrame:CGRectMake(0, 30, ScreenW , 30)];
    lb.text = @"";
    lb.font = [UIFont fontWithName:kFontNormal size:13];
    lb.textColor = kColor333;
    lb.textAlignment = UIControlContentHorizontalAlignmentLeft;
    lb.textColor = [UIColor lightGrayColor];
    [footerView addSubview:lb];
}

- (void)refreshData {
    self.page = 1;
    self.replyPage = 2;
    [self loadData:YES];
}

-(void)loadMoreData {
    [self loadData:NO];
}

#pragma mark - 请求更多评论列表数据
- (void)loadData:(BOOL)isRefresh {
    [self beginLoading];
    //获取最后一条主评论的评论id
    NSInteger sortNum = 0;
    NSString *lastId = @"0";
    if (self.commentArray.count > 0) {
        JHCommentModel *model = self.commentArray.lastObject;
        sortNum = model.sort_num;
        lastId = model.comment_id;
    }
    
    NSString *fillterIds = self.filterIds.count > 0 ? [self.filterIds componentsJoinedByString:@","] : @"0";
    [JHSQApiManager requestPostDetailCommentListWithItemType:@(self.postDetail.item_type).stringValue itemId:self.postDetail.item_id lastId:lastId sortNum:sortNum page:self.page filterIds:fillterIds completeBlock:^(RequestModel *respObj, BOOL hasError) {
        [self endLoading];
        [self endRefresh];
        if (!hasError) {
            NSMutableArray *arr = [JHCommentModel mj_objectArrayWithKeyValuesArray:respObj.data[@"list"]];
            if (arr.count > 0) {
                [self.homeTable.mj_footer endRefreshing];
                if (isRefresh) {
                    self.commentArray = [NSMutableArray arrayWithArray:arr];
                }
                else {
                    for (JHCommentModel *model in arr) {
                        if ([model.comment_id isEqualToString:[self.commentArray.firstObject comment_id]]) {
                            [arr removeObject:model];
                            break;
                        }
                    }
                    [self.commentArray addObjectsFromArray:arr];
                }
                if (arr.count < pagesize) {
                    lb.text = @"— 已显示全部评论 —";
                }
                [self.homeTable reloadData];
                ///成功拿到数据页数＋
                self.page ++;
            }
            else {
                [self.homeTable.mj_footer endRefreshingWithNoMoreData];
            }
            [self showNoData];
        }
        else {
            [UITipView showTipStr:respObj.message ?: @"加载失败"];
        }
    }];
}

- (void)showNoData {
    if (self.commentArray.count == 0) {
        lb.text = @"- 暂无评论 -";
    }
}

#pragma mark - 请求更多回复
- (void)requestMoreSubComment:(NSInteger)section contentView:(id)contentView {
    if (![contentView isMemberOfClass:[JHPostCommentFooterView class]]) {
        return;
    }
    JHPostCommentFooterView *footer = (JHPostCommentFooterView *)contentView;
    JHCommentModel *mainComment = self.commentArray[section];
    JHCommentModel *lastReplyComment = mainComment.reply_list.lastObject;
    NSString *fillterIds = self.filterIds.count > 0 ? [self.filterIds componentsJoinedByString:@","] : @"0";
    [JHSQApiManager requestPostDetailReplyListWithCommentId:mainComment.comment_id lastId:[lastReplyComment.comment_id integerValue] page:self.replyPage filterIds:fillterIds completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            NSMutableArray *arr = [JHCommentModel mj_objectArrayWithKeyValuesArray:respObj.data[@"list"]];
            if (arr.count > 0) {
                NSMutableArray *comments = [NSMutableArray arrayWithArray:mainComment.reply_list];
                for (JHCommentModel *model in arr) {
                    if ([model.comment_id isEqualToString:[comments.firstObject comment_id]]) {
                        [arr removeObject:model];
                        break;
                    }
                }
                [comments addObjectsFromArray:arr];
                mainComment.reply_list = comments.copy;
                mainComment.remaining_reply_count -= arr.count;
                NSInteger commentCount = mainComment.remaining_reply_count > 0 ? mainComment.remaining_reply_count : 0;
                footer.commentCount = @(commentCount).stringValue;
            }
            else {
                mainComment.remaining_reply_count = 0;
                footer.commentCount = @"0";
            }
            [self.homeTable reloadData];
        }
        else {
            [UITipView showTipStr:respObj.message];
        }
    }];
}

- (void)endRefresh {
    [self.homeTable.mj_footer endRefreshing];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
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
    [self endEditing:YES];
}
#pragma mark =============== setter ===============
-(UITableView*)homeTable {
    if (!_homeTable) {
        _homeTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _homeTable.delegate = self;
        _homeTable.dataSource = self;
        _homeTable.alwaysBounceVertical = YES;
        _homeTable.scrollEnabled = YES;
        _homeTable.bounces = YES;
        _homeTable.tableFooterView = footerView;
        _homeTable.estimatedRowHeight = 50;
        _homeTable.contentInset = UIEdgeInsetsMake(0, 0,0, 0);
        _homeTable.backgroundColor = [UIColor whiteColor];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_homeTable registerClass:[JHSubCommentTableCell class] forCellReuseIdentifier:kSubCommentCellIdentifer];
        [_homeTable registerClass:[JHPostMainCommentHeader class] forCellReuseIdentifier:kCommentSectionHeader];
        UITapGestureRecognizer *tableTap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
        tableTap.delegate = self;
        [_homeTable addGestureRecognizer:tableTap];
        @weakify(self);
        _homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMoreData];
        }];
    }
    return _homeTable;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditing:YES];
    NSLog(@"%lf",scrollView.contentOffset.y);
   
}
#pragma mark - tableviewDatesource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commentArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.commentArray.count > 0) {
        JHCommentModel *model = self.commentArray[section];
        return model.reply_list.count + 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.row == 0) {
        ///主评论
        JHPostMainCommentHeader *header = [tableView dequeueReusableCellWithIdentifier:kCommentSectionHeader];
        //cell为空就创建
        header.postAuthorId = self.postDetail.publisher.user_id;
        header.indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        JHCommentModel *model = self.commentArray[indexPath.section];
        model.isDetailView = YES;
        header.mainComment = model;
        header.actionBlock = ^(NSIndexPath * _Nonnull selectIndexPath, JHPostMainCommentHeader * _Nonnull header, JHPostDetailActionType actionType) {
            @strongify(self);
            [self handleCommentActionEvent:actionType selecIndexPath:selectIndexPath contentView:header];
        };
        return header;
    }
    
    ///回复列表
    JHSubCommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubCommentCellIdentifer];
    JHCommentModel *model = self.commentArray[indexPath.section];
    cell.postAuthorId = self.postDetail.publisher.user_id;
    cell.indexPath = indexPath;
    JHCommentModel *subModel = model.reply_list[indexPath.row-1];
    model.isDetailView = YES;
    cell.commentModel = subModel;
    cell.actionBlock = ^(NSIndexPath * _Nonnull selectIndexPath, JHSubCommentTableCell * _Nonnull cell, JHPostDetailActionType actionType) {
        @strongify(self);
        [self handleCommentActionEvent:actionType selecIndexPath:selectIndexPath contentView:cell];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = kColorF5F6FA;
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    JHCommentModel *model = self.commentArray[section];
    if (model.remaining_reply_count > 0) {
        return 28.f;
    }
    
    return model.reply_list.count > 0 ? 8.f : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    JHCommentModel *model = self.commentArray[section];
    JHPostCommentFooterView *footer = [[JHPostCommentFooterView alloc] init];
    footer.footerSection = section;
    footer.commentCount = @(model.remaining_reply_count).stringValue;
    @weakify(self);
    footer.unfoldBlock = ^(NSInteger footerSection, JHPostCommentFooterView * _Nonnull f) {
        @strongify(self);
        [self requestMoreSubComment:footerSection contentView:f];
    };
    return footer;
}
- (void)show {
    self.contentView.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.bottom =  self.height;
    }];
}
- (void)dismiss {
    self.contentView.bottom =  self.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    //统计结束埋点
    if (self.hideComplete) {
        self.hideComplete();
    }
}

///处理评论列表的各种点击事件
- (void)handleCommentActionEvent:(JHPostDetailActionType)type selecIndexPath:(NSIndexPath *)indexPath contentView:(id)contentView {
    if (self.postDetail.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }
    JHCommentModel *commentInfo = self.commentArray[indexPath.section];
    BOOL isMain = [contentView isMemberOfClass:[JHPostMainCommentHeader class]];
    self.currentMainComment = commentInfo;
    self.currentComment = isMain ? self.currentMainComment : commentInfo.reply_list[indexPath.row-1];
    switch (type) {
        case JHPostDetailActionTypeLike: /// 点赞
        {
            //点赞埋点
            NSMutableDictionary *params = [self sa_getParams];
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_like" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            NSInteger itemType = self.currentComment.publisher ? 4 : 3;
            [self likeActionWithContentView:contentView itemType:itemType itemId:self.currentComment.comment_id likeNum:self.currentComment.like_num isLike:self.currentComment.is_like];
        }
            break;
        case JHPostDetailActionTypeSingleTap: /// 单击
        {
            //点击评论埋点
            NSMutableDictionary *params = [self sa_getParams];
            [params setValue:self.currentComment.publisher.user_id forKey:@"authorid"];
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_comment" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            [self inputComment:NO];
        }
            break;
        case JHPostDetailActionTypeLongPress: /// 长按
        {
            NSLog(@"长按了子评论 弹出弹窗呢要");
            [self showAlertSheetView:NO];
        }
            break;
        case JHPostDetailActionTypeEnterPersonPage: ///进入个人主页
        {
            NSLog(@"长按了子评论 弹出弹窗呢要");
            [self enterPersonalPage:self.currentComment.publisher.user_id publisher:self.currentComment.publisher roomId:self.currentComment.publisher.room_id];
        }
            break;

        default:
            break;
    }
}

///进入个人主页
- (void)enterPersonalPage:(NSString *)userId publisher:(JHPublisher *)publisher roomId:(NSString *)room_id {
    if (![userId isNotBlank]) {
        return;
    }
    [JHRouterManager pushUserInfoPageWithUserId:userId publisher:publisher from:JHFromSQPicDetail roomId:room_id];
}

#pragma mark - 点赞
- (void)likeActionWithContentView:(id)contentView itemType:(NSInteger)itemType itemId:(NSString *)itemId likeNum:(NSInteger)likeNum isLike:(BOOL)isLike {
    if (self.postDetail.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }
    if (IS_LOGIN) {
        @weakify(self);
        if (isLike) {
            ///当前状态是已赞状态 需要取消点赞
            [JHUserInfoApiManager sendCommentUnLikeRequest:itemType itemId:itemId likeNum:likeNum block:^(RequestModel *respObj, BOOL hasError) {
                @strongify(self);
                if (!hasError) {
                    [UITipView showTipStr:@"取消点赞成功"];
                    [self __updateContentViewData:contentView isLike:!isLike];
                }
            }];
        }
        else {
            [JHUserInfoApiManager sendCommentLikeRequest:itemType itemId:itemId likeNum:likeNum block:^(RequestModel *respObj, BOOL hasError) {
                @strongify(self);
                if (!hasError) {
                    [UITipView showTipStr:@"点赞成功"];
                    [self __updateContentViewData:contentView isLike:!isLike];
                }
            }];
        }
    }
}

- (void)__updateContentViewData:(id)contentView isLike:(BOOL)isLike {
    if (contentView) {
        self.currentComment.like_num += isLike ? 1 : (-1);
        self.currentComment.is_like = @(isLike).integerValue;
        if ([contentView isMemberOfClass:[JHPostMainCommentHeader class]]) {
            JHPostMainCommentHeader *header = (JHPostMainCommentHeader *)contentView;
            [header updateLikeButtonStatus:self.currentComment];
        }
        else if ([contentView isMemberOfClass:[JHSubCommentTableCell class]]) {
            JHSubCommentTableCell *cell = (JHSubCommentTableCell *)contentView;
            [cell updateLikeButtonStatus:self.currentComment];
        }
    }
    else {
        self.postDetail.like_num = @(self.postDetail.like_num_int + (isLike ? 1 : (-1))).stringValue;
        self.postDetail.like_num_int += isLike ? 1 : (-1);
        self.postDetail.is_like = @(isLike).integerValue;
        [self.homeTable reloadData];
    }
}

- (void)inputComment:(BOOL)isMainComment {
    if (self.postDetail.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }

    if(IS_LOGIN){
        JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
        easyView.showLimitNum = YES;
        [self addSubview:easyView];
        [easyView show];
        @weakify(self);
        [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
            @strongify(self);
            //发送评论 埋点
            NSMutableDictionary *params = [self sa_getParams];
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_edit_send" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            [easyView endEditing:YES];
            if (isMainComment) {
                [self toPublishPostComment:inputInfos];
            }
            else {
                [self toPublishReplyComment:inputInfos];
            }
        }];
        
        easyView.actionClickBlock = ^(ActionClickType type) {
            NSMutableDictionary *params = [self sa_getParams];
            if (type == ActionClickEmoji) {
                //发送评论 表情
                [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_emoji"params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            }else if (type == ActionClickPicture) {
                //发送评论 图片
                [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_picture" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            }
        };
    }
}

///评论帖子
- (void)toPublishPostComment:(NSDictionary *)inputInfos {
    if (!inputInfos) {
        [UITipView showTipStr:@"请输入评论内容"];
        return;
    }
    @weakify(self);
    [JHSQApiManager submitCommentWithCommentInfos:inputInfos itemId:self.postDetail.item_id itemType:self.postDetail.item_type completeBlock:^(RequestModel *respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"评论成功"];
            JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respObj.data];
            [self.commentArray insertObject:model atIndex:0];
            [self.filterIds addObject:[NSString stringWithFormat:@"%ld", (long)model.comment_id]];
            [self.homeTable reloadData];
            self.postDetail.comment_num += 1;
            [self updateCommentCount];
        }
        else {
            [UITipView showTipStr:[respObj.message isNotBlank] ? respObj.message : @"评论失败"];
        }
    }];
}

- (void)updateCommentCount {
    self.commentCountLabel.text = [NSString stringWithFormat:@"全部评论 %ld", (long)self.postDetail.comment_num];
    [self showNoData];
}

///回复主评论或者子评论
- (void)toPublishReplyComment:(NSDictionary *)commentInfos {
    if (!commentInfos) {
        [UITipView showTipStr:@"请输入评论内容"];
        return;
    }
    //需要判断是@的还是主动发送的
    //注意：：：@子评论的时候，comment_id一直传的是主评论id
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ///355新增 --- TODO lihui
    [params addEntriesFromDictionary:commentInfos];
    if (self.currentComment.parent_id > 0) { ///子评论
        [params setValue:@(self.currentComment.parent_id) forKey:@"comment_id"];
        [params setValue:[NSNumber numberWithString:self.currentComment.publisher.user_id] forKey:@"at_user_id"];
        [params setValue:self.currentComment.publisher.user_name forKey:@"at_user_name"];
    }
    else {///主评论
        [params setValue:[NSNumber numberWithString:self.currentComment.comment_id] forKey:@"comment_id"];
    }
    
    @weakify(self);
    [JHSQApiManager submitCommentReplay:params completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            @strongify(self);
            //无论回复的是主评论还是子评论，都插在当前组的第一条
            JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respObj.data];
            if (model) {
                ///通知列表页处理数据
                [self.filterIds addObject:[NSString stringWithFormat:@"%ld", (long)model.comment_id]];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.currentMainComment.reply_list];
                [arr insertObject:model atIndex:0];
                self.currentMainComment.reply_list = arr.copy;
                [self.homeTable reloadData];
                self.postDetail.comment_num += 1;
                [self updateCommentCount];
            }
        }
    }];
}

#pragma mark -
#pragma mark - 评论弹窗相关
- (void)showAlertSheetView:(BOOL)isMain {
    NSArray *actions = [JHSQManager commentActions:self.postDetail comment:self.currentComment];
    if (actions == nil || actions.count == 0) {
        return;
    }
    User *user = [UserInfoRequestManager sharedInstance].user;
    [JHSQManager jh_showAlertSheetController:actions isSelf:[self.currentComment.publisher.user_id isEqualToString:user.customerId] actionBlock:^(JHAlertSheetControllerAction sheetAction, NSString * _Nonnull reason, NSString * _Nonnull reasonId, NSInteger timeType) {
        [self sheetActionEvent:sheetAction isMain:isMain reasonId:reasonId timeType:timeType];
    }];
}

- (void)sheetActionEvent:(JHAlertSheetControllerAction)action isMain:(BOOL)isMain reasonId:(NSString *)reasonId  timeType:(NSInteger)timeType {
    switch (action) {
        case JHAlertSheetControllerActionReply:///回复
        {
            [self inputComment:NO];
        }
            break;
        case JHAlertSheetControllerActionCopy:///复制
            [self toCopy];
            break;
        case JHAlertSheetControllerActionDelete:///删除
        {
            User *user = [UserInfoRequestManager sharedInstance].user;
            if([self.currentComment.publisher.user_id isEqualToString:user.customerId])
            {
                [self toDeleteComment];
            }
            else
            {
                [self deleteCommentWithReasonId:reasonId];
            }
        }
            break;
        case JHAlertSheetControllerActionReport:///举报
            [self toReport];
            break;
        case JHAlertSheetControllerActionWarning:///警告
            [self toWarningWithReasonId:reasonId];
            break;
        case JHAlertSheetControllerActionBanned: ///禁言
            [self toMuteWithReasonId:reasonId timeType:timeType];
            break;
        case JHAlertSheetControllerActionBlockAccount:///封号
            [self toBan];
            break;
        default:
            break;
    }
}
 
///删除评论~
- (void)toDeleteComment {
    if (self.postDetail.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }

    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除内容" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self deleteCommentWithReasonId:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertV addAction:deleteAction];
    [alertV addAction:cancelAction];
    [JHRootController.currentViewController presentViewController:alertV animated:YES completion:nil];
}

///警告！！！！！待测试
- (void)toWarningWithReasonId:(NSString *)reasonId {
    NSInteger itemType = self.currentComment.parent_id > 0 ? 3 : 2;
    [JHSQApiManager warningRequest:self.currentComment.comment_id itemType:itemType userId:self.currentComment.publisher.user_id reasonId:reasonId block:^(id  _Nullable respObj, BOOL hasError) {
        [UITipView showTipStr:@"警告成功"];
    }];
}

///复制~
- (void)toCopy {
    if ([self.currentComment.content isNotBlank]) {
        [[UIPasteboard generalPasteboard] setString:self.currentComment.content];
        [UITipView showTipStr:@"复制成功~"];
    }
}

///举报~
- (void)toReport {
    NSInteger itemType = self.currentComment.parent_id > 0 ? 3 : 2;
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.titleString = @"举报";
    NSString *url = H5_BASE_HTTP_STRING(@"/jianhuo/app/report.html?");
    url = [url stringByAppendingFormat:@"rep_source=%ld&rep_obj_id=%ld&live_user_id=%@",
           (long)itemType, (long)self.currentComment.comment_id, self.currentComment.publisher.user_id];
    webVC.urlString = url;
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
}

///封号
- (void)toBan {
    JHCommitViewController *vc = [[JHCommitViewController alloc] init];
    vc.commentModel = self.currentComment;
    JHRootController.currentViewController.definesPresentationContext = YES;
    vc.edgesForExtendedLayout = UIRectEdgeAll;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [JHRootController.currentViewController presentViewController:vc animated:YES completion:nil];
}

///禁言！！！！待测试
- (void)toMuteWithReasonId:(NSString *)reasonId timeType:(NSInteger)timeType {
    [JHSQApiManager muteRequestWithUserId:self.currentComment.publisher.user_id reasonId:reasonId timeType:timeType block:^(id  _Nullable respObj, BOOL hasError) {
        [UITipView showTipStr:@"禁言成功"];
    }];
}

///提交删除评论结果
- (void)deleteCommentWithReasonId:(NSString *)reasonId {
    [JHSQApiManager deletePostDetailCommentWithCommentId:self.currentComment.comment_id reasonId:reasonId completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            if (self.currentComment.parent_id > 0) {
                NSMutableArray *comments = self.currentMainComment.reply_list.mutableCopy;
                [comments removeObject:self.currentComment];
                self.currentMainComment.reply_list = comments.copy;
            }
            else {
                [self.commentArray removeObject:self.currentComment];
            }
            [self.homeTable reloadData];
            self.postDetail.comment_num -= 1;
            [self updateCommentCount];
        }
        NSString *str = hasError ? (respObj.message?:@"删除失败") : @"删除成功";
        [UITipView showTipStr:str];
    }];
}

- (void)dealloc {
    NSLog(@"deallocdealloc");
}

- (NSMutableDictionary *)sa_getParams {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postDetail.item_id forKey:@"vedio_id"];
    [params setValue:self.postDetail.content forKey:@"vedio_name"];
    [params setValue:self.postDetail.publisher.user_id forKey:@"authorid"];
    [params setValue:@"onlineAppraise" forKey:@"from"];
    if([JHRootController isLogin]) {
        User *user = [UserInfoRequestManager sharedInstance].user;
        [params setValue:user.name forKey:@"user_name"];
    }
    return params;
}

@end
