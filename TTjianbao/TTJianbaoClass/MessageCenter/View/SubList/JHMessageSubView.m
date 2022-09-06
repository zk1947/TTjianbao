//
//  JHMessageSubView.m
//  TTjianbao
//
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageSubView.h"
#import "JHMsgSubListModel.h"
#import "JHTableViewExt.h"
#import "JHMessageSubListHeaderView.h"
#import "JHMessageCommonViewCell.h"
#import "JHCommunityInteractiveViewCell.h"
#import "JHMessageActivityViewCell.h"
#import "JHMessageOrderTransportViewCell.h"
#import "JHMessageCommentTableViewCell.h"
#import "JHEasyInputTextView.h"
#import "JHSQManager.h"
#import "JHEasyInputTextView.h"

@interface JHMessageSubView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString* pageType;
@property (nonatomic, strong) JHTableViewExt* tableView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) NSMutableArray<JHMsgSubListShowModel*>* sortedArrayByDate;
@property (nonatomic, strong) NSArray<JHMsgSubListLikeCommentModel *> *commentArray;
@property (nonatomic, strong) NSIndexPath *toCommentIndexPath; //将要对这条帖子进行评论

@end

@implementation JHMessageSubView

- (instancetype) initWithFrame:(CGRect)rect pageType:(NSString*)type
{
    if(self = [super initWithFrame:rect])
    {
        self.pageType = type;
        [self showViews];
    }
    return self;
}

- (void)showViews
{
    [self addSubview:self.tableView];
    [self.tableView addRefreshView];
    [self.tableView addLoadMoreView];
}

- (void)endTableRefresh
{
    [self.tableView hiddenEmptyPage:self.sortedArrayByDate.count > 0 ? YES : NO];
}

- (void)refreshShowData:(NSMutableArray*)array
{
    if(array.count > 0)
    {
        [self.tableView hiddenEmptyPage:YES];
        //新数据跟旧数据一样,认为无新数据
        if ([array count] == [self.sortedArrayByDate count])
            [self.tableView noDataEndRefreshing];
        self.sortedArrayByDate = array;
        [self.tableView reloadData];
    }
    else
    {
        [self.tableView hiddenEmptyPage:NO];
    }
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

- (JHMsgSubListModel*)currentCellModel:(NSIndexPath*)indexPath
{
    JHMsgSubListModel* model = nil;
    if(indexPath.section >= 0 && indexPath.section < [self.sortedArrayByDate count])
    {
        model = self.sortedArrayByDate[indexPath.section].groupArray[indexPath.row];
    }
    return model;
}

- (NSIndexPath*)indexPathFromCell:(UITableViewCell*)cell
{
    return [self.tableView indexPathForCell:cell];
}

#pragma mark - subviews
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[JHTableViewExt alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xF5F6FA);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

- (UIView *)footerView
{
    if(!_footerView)
    {
        _footerView = [UIView new];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

- (void)loadNew
{
    [self messageSubviewEvents:JHMsgSubEventsTypeReload data:nil];
}

- (void)loadMore
{
    [self messageSubviewEvents:JHMsgSubEventsTypeReload data:@"1"];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sortedArrayByDate.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedArrayByDate[section].groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return kHeaderHeight+10;
    return kHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1; //CGFLOAT_MIN
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHMessagesTableViewCell* cell = nil;
    JHMsgSubListModel* model = [self currentCellModel:indexPath];
    
    if([kMsgSublistTypeLike isEqualToString: self.pageType])
    {//点赞「特殊处理」
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMessageLikesTableViewCell class])];
        if(!cell)
        {
            cell = [[JHMessageLikesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMessageLikesTableViewCell class])];
        }
        [cell updateData:model];
    }
    else if([kMsgSublistTypeComment isEqualToString: self.pageType])
    {//评论「特殊处理」
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMessageCommentTableViewCell class])];
        if(!cell)
        {
            cell = [[JHMessageCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMessageCommentTableViewCell class])];
            JH_WEAK(self)
            ((JHMessageCommentTableViewCell*)cell).actionEvents = ^(NSNumber* type, id data) {
                JH_STRONG(self)
                self.toCommentIndexPath = indexPath;
                [self messageSubviewEvents:[type integerValue] data:data];
            };
        }
        [cell updateData:model];
    }
    else if([kMsgSublistShowTypeOrderTransport isEqualToString: model.showType])
    {//订单物流
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMessageOrderTransportViewCell class])];
        if(!cell)
        {
            cell = [[JHMessageOrderTransportViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMessageOrderTransportViewCell class])];
        }
        [cell updateData:model];
    }
    else if([kMsgSublistShowTypeActivitySlogan isEqualToString:model.showType])
    {//优惠活动&平台公告
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMessageActivityViewCell class])];
        if(!cell)
        {
            cell = [[JHMessageActivityViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMessageActivityViewCell class])];
        }
        [cell updateData:model];
    }
    else if([kMsgSublistShowTypeForumFollow isEqualToString: model.showType])
    {//社区互动「宝友关注」
        JHMsgSubListNormalForumModel* forumModel = (JHMsgSubListNormalForumModel*)model;
        if(1)
        {//关注
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCommunityInteractiveButtonViewCell class])];
            if(!cell)
            {
                cell = [[JHCommunityInteractiveButtonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCommunityInteractiveButtonViewCell class])];

                JH_WEAK(self)
                ((JHCommunityInteractiveButtonViewCell*)cell).forumCareActive = ^(id object, id sender) {
                    JH_STRONG(self)
                    [self messageSubviewEvents:JHMsgSubEventsTypeForumCare data:indexPath];
                };

                ((JHCommunityInteractiveButtonViewCell*)cell).forumHeadImageActive = ^(id object, id sender) {
                    JH_STRONG(self)
                    [self messageSubviewEvents:JHMsgSubEventsTypeHeadImage data:indexPath];
                };
            }
            [cell updateData:forumModel];
        }
        else //kMsgSublistForumTypePost=社区帖子
        {
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCommunityInteractiveViewCell class])];
            if(!cell)
            {
                cell = [[JHCommunityInteractiveViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCommunityInteractiveViewCell class])];
            }
            [cell updateData:forumModel];
        }
    }
    else //占位或 /新增类型 / 类通用类型
    {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHMessageCommonViewCell class])];
        if(!cell)
        {
            cell = [[JHMessageCommonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHMessageCommonViewCell class])];
        }
        [cell updateData:model];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JHMessageSubListHeaderView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([JHMessageSubListHeaderView class])];
    if(!headerView)
    {
        headerView = [[JHMessageSubListHeaderView alloc] initWithReuseIdentifier:NSStringFromClass([JHMessageSubListHeaderView class])];
    }
    
    [headerView updateData:self.sortedArrayByDate[section].dateTime section:section];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHMsgSubListModel* model = [self currentCellModel:indexPath];
   //页面跳转
    [self messageSubviewEvents:JHMsgSubEventsTypeOpenPage data:model];
    //埋点
    [self messageSubviewEvents:JHMsgSubEventsTypeGrowing data:model];
}

#pragma mark - event
- (void) messageSubviewEvents:(JHMsgSubEventsType)type data:(id)data
{
    if([self.delegate respondsToSelector:@selector(messageSubviewEvents:data:)])
    {
        [self.delegate messageSubviewEvents:type data:data];
        
        if (JHMsgSubEventsTypeCommentComment == type)
        {
            //弹出评论框
            [self showInputTextView];
        }
    }
}

- (void)refreshJHMsgSubListLikeCommentModelData:(NSArray<JHMsgSubListLikeCommentModel *> *)list
{
    self.commentArray = [NSArray new];
    self.commentArray = list;
    NSLog(@"list----%@",list);
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
            JHCommentData *commentData = [JHCommentData modelWithJSON:respondObject.data];
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


@end
