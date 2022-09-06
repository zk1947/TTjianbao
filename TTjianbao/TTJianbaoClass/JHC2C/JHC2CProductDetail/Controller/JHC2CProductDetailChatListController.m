//
//  JHC2CProductDetailChatListController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailChatListController.h"
#import "SVProgressHUD.h"
#import "JHTextInPutView.h"
#import "JHC2CProductDetailAccusationViewController.h"
#import "JHC2CProductDetailChatHeader.h"
#import <YYLabel.h>
#import "UIScrollView+JHEmpty.h"
#import "JHDynamicViewController.h"
#import "JHUserInfoViewController.h"
#import "JHNewShopDetailViewController.h"
#import "JHPlateDetailController.h"
#import "JHWebViewController.h"
#import "JHCommitViewController.h"
#import "JHSettingAutoPlayController.h"
#import "JHTopicTallyView.h"
#import "JHWebImage.h"
#import "JHBaseOperationView.h"
#import "JHBaseOperationModel.h"

#import "JHSQManager.h"
#import "JHSQApiManager.h"
#import "JHUserInfoApiManager.h"
#import "JHPostDetailModel.h"

#import "UIImageView+ZFCache.h"
#import "JHPostDetailEventManager.h"
#import "UIImageView+JHWebImage.h"
#import "CommAlertView.h"
#import "JHDetailSvgaLoadingView.h"
#import "JHPostUserInfoView.h"
#import "JHLivePlayer.h"

#import "JHEasyInputTextView.h"
#import "JHAttributeStringTool.h"

#import "JHTrackingPostDetailModel.h"
#import "JHPlayerViewController.h"
#import "JHNormalControlView.h"
#import "JHPlayerVerticalBigView.h"
#import "JHVideoPlayCompleteView.h"
#import "JHCommentTypeHeader.h"
#import "UIView+CornerRadius.h"
#import "JHC2CProductInnerChatMainCell.h"
#import "JHC2CProductInnerChatSubCell.h"
#import "JHC2CProductDetailBusiness.h"
#import "JHSQManager.h"



@interface JHC2CProductDetailChatListController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIView * topView;
@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) UIButton * bottomBtn;
@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) YYLabel * placeHolderLbl;

///评论的数组
@property (nonatomic, strong) NSMutableArray <JHCommentModel *>*commentArray;

///选中的当前评论的信息
@property (nonatomic, strong) JHCommentModel *currentMainComment;
@property (nonatomic, strong) JHCommentModel *currentComment;

@property(nonatomic) BOOL  hasChenge;

@property(nonatomic) NSInteger allChatCount;

@property(nonatomic, strong) UILabel * titleCountLbl;

@end

@implementation JHC2CProductDetailChatListController

- (instancetype)init{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setItems];
    [self layoutItems];
    [self getChatData];
}

- (void)getChatData{
    [SVProgressHUD show];
    [self loadCommentData:^(NSArray<JHCommentModel *> *commentList) {
        self.commentArray = [NSMutableArray arrayWithArray:commentList];
        [self.tableView reloadData];
    }];
    
    [JHC2CProductDetailBusiness requestC2CChatCount:self.productSn completion:^(NSError * _Nullable error, NSInteger count) {
        self.allChatCount = count;
        [self refreshCount];
    }];
}

- (void)refreshCount{
    self.titleCountLbl.text = [NSString stringWithFormat:@"全部留言 %ld",self.allChatCount];
}

///全部评论接口
- (void)loadCommentData:(void(^)(NSArray <JHCommentModel *>*))block {
    ///展开父级评论
    //获取最后一条主评论的评论id
    NSString *lastId = @"0";
    
    NSString *fillterIds =  @"0";
//    SN2021061944220088
    [JHSQApiManager getAllCommentList:self.productSn itemType:100 page:1 lastId:lastId filterIds:fillterIds completation:^(RequestModel *respObj, BOOL hasError) {
        [SVProgressHUD dismiss];
        NSMutableArray *commentList = [NSMutableArray array];
        if (!hasError) {
            NSMutableArray <JHCommentModel *>*arr = [JHCommentModel mj_objectArrayWithKeyValuesArray:respObj.data[@"list"]];
            [commentList addObjectsFromArray:arr];
        }
        else {
            [UITipView showTipStr:respObj.message ?: @"加载失败"];
        }
        if (block) {
            block(commentList);
        }
    }];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.transform = CGAffineTransformIdentity;
    }];
}

- (void)setItems{
    self.view.backgroundColor = HEXCOLORA(0x000000, 0.3);
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.topView];
    [self.backView addSubview:self.tableView];
    [self.backView addSubview:self.bottomBtn];
    self.jhNavView.hidden = YES;
    self.backView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@200);
        make.bottom.equalTo(@0).offset(20);
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.mas_equalTo(54);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.topView.mas_bottom);
        make.bottom.equalTo(@0).offset(-20);
    }];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.mas_equalTo(UI.tabBarAndBottomSafeAreaHeight);
        make.bottom.equalTo(self.tableView);
    }];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeVC];
}
#pragma mark - 评论输入框相关

- (void)inputComment:(BOOL)isMainComment {
    JHTextInPutView *easyView = [[JHTextInPutView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
    easyView.showLimitNum = YES;
    [JHKeyWindow addSubview:easyView];
    [easyView show];
    @weakify(easyView);
    [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
        @strongify(easyView);
        [easyView endEditing:YES];
        if (isMainComment) {
            [self toPublishPostComment:inputInfos];
        }else {
            [self toPublishReplyComment:inputInfos];
        }
    }];
}


///评论帖子
- (void)toPublishPostComment:(NSDictionary *)inputInfos {
    self.hasChenge = YES;
    if (!inputInfos) {
        [UITipView showTipStr:@"请输入评论内容"];
        return;
    }
    @weakify(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:inputInfos];
    params[@"item_user_id"] = self.sellerID;
    
    [JHSQApiManager submitCommentWithCommentInfos:params itemId:self.productSn itemType:100 completeBlock:^(RequestModel *respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"评论成功"];
            JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respObj.data];
            [self.commentArray insertObject:model atIndex:0];
            [self.tableView reloadData];
            self.allChatCount += 1;
            [self refreshCount];
        }else {
            [UITipView showTipStr:[respObj.message isNotBlank] ? respObj.message : @"评论失败"];
        }
    }];
}

///回复主评论或者子评论
- (void)toPublishReplyComment:(NSDictionary *)commentInfos {
    self.hasChenge = YES;
    if (!commentInfos) {
        [UITipView showTipStr:@"请输入评论内容"];
        return;
    }
    //需要判断是@的还是主动发送的
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"item_user_id"] = self.sellerID;
    params[@"item_id"] = self.productSn;
    params[@"item_type"] = @100;
    [params addEntriesFromDictionary:commentInfos];
    if (self.currentComment.parent_id > 0) { ///子评论
        [params setValue:@(self.currentComment.parent_id) forKey:@"comment_id"];
        [params setValue:[NSNumber numberWithString:self.currentComment.publisher.user_id] forKey:@"at_user_id"];
        [params setValue:self.currentComment.publisher.user_name forKey:@"at_user_name"];
    }else {///主评论
        [params setValue:[NSNumber numberWithString:self.currentComment.comment_id] forKey:@"comment_id"];
    }
    [JHSQApiManager submitCommentReplay:params completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            //无论回复的是主评论还是子评论，都插在当前组的第一条
            JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respObj.data];
            if (model) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.currentMainComment.reply_list];
                [arr insertObject:model atIndex:0];
                self.currentMainComment.reply_list = arr.copy;
                [self.tableView reloadData];
                self.allChatCount += 1;
                [self refreshCount];
            }
        }
    }];
}

#pragma mark - 点赞
- (void)likeActionWithContentView:(id)contentView itemType:(NSInteger)itemType itemId:(NSString *)itemId likeNum:(NSInteger)likeNum isLike:(BOOL)isLike {
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
        }else {
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
        if ([contentView isMemberOfClass:[JHC2CProductInnerChatMainCell class]]) {
            JHC2CProductInnerChatMainCell *header = (JHC2CProductInnerChatMainCell *)contentView;
            [header updateLikeButtonStatus:self.currentComment];
        }else if ([contentView isMemberOfClass:[JHC2CProductInnerChatSubCell class]]) {
            JHC2CProductInnerChatSubCell *cell = (JHC2CProductInnerChatSubCell *)contentView;
            [cell updateLikeButtonStatus:self.currentComment];
        }
    }
}


- (void)closeVC{
    if (self.closeNeedRefresh) {
        self.closeNeedRefresh(self.hasChenge);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


- (void)showMenu{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"菜单" message:@"菜单" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"ljkds" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dianZan{
    
}
- (void)sendMessage{
    [self inputComment:YES];

}

#pragma mark -- <社区cell事件>
///处理评论列表的各种点击事件
- (void)handleCommentActionEvent:(JHPostDetailActionType)type selecIndexPath:(NSIndexPath *)indexPath contentView:(id)contentView {
    JHCommentModel *commentInfo = self.commentArray[indexPath.section];
    BOOL isMain = [contentView isMemberOfClass:[JHC2CProductInnerChatMainCell class]];
    self.currentMainComment = commentInfo;
    self.currentComment = isMain ? self.currentMainComment : commentInfo.reply_list[indexPath.row-1];
    switch (type) {
        case JHPostDetailActionTypeLike: /// 点赞
        {
            
            NSInteger itemType = (self.currentComment.parent_id > 0) ? 4 : 3;
            [self likeActionWithContentView:contentView itemType:itemType itemId:self.currentComment.comment_id likeNum:self.currentComment.like_num isLike:self.currentComment.is_like];
        }
            break;
        case JHPostDetailActionTypeSingleTap: /// 单击
        {
//            self.commentMethod = @"文章详情页评论";
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
//            NSLog(@"长按了子评论 弹出弹窗呢要");
//            [self enterPersonalPage:self.currentComment.publisher.user_id publisher:self.currentComment.publisher roomId:self.currentComment.publisher.room_id];
        }
            break;

        default:
            break;
    }
}

- (void)showAlertSheetView:(BOOL)isMain {
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSArray <NSString*>* actions = @[@"举报"];
    if([self.sellerID.stringValue isEqualToString:user.customerId]){
        actions = @[@"删除",@"举报"];
        [JHSQManager jh_showAlertSheetController:actions isSelf:YES actionBlock:^(JHAlertSheetControllerAction sheetAction, NSString * _Nonnull reason, NSString * _Nonnull reasonId, NSInteger timeType) {
            [self sheetActionEvent:sheetAction isMain:isMain reasonId:reasonId timeType:timeType];
        }];
    }else if ([self.currentComment.publisher.user_id isEqualToString:user.customerId]) {
        actions = @[@"删除"];
        [JHSQManager jh_showAlertSheetController:actions isSelf:[self.currentComment.publisher.user_id isEqualToString:user.customerId] actionBlock:^(JHAlertSheetControllerAction sheetAction, NSString * _Nonnull reason, NSString * _Nonnull reasonId, NSInteger timeType) {
            [self sheetActionEvent:sheetAction isMain:isMain reasonId:reasonId timeType:timeType];
        }];

    }else{
        [JHSQManager jh_showAlertSheetController:actions isSelf:[self.currentComment.publisher.user_id isEqualToString:user.customerId] actionBlock:^(JHAlertSheetControllerAction sheetAction, NSString * _Nonnull reason, NSString * _Nonnull reasonId, NSInteger timeType) {
            [self sheetActionEvent:sheetAction isMain:isMain reasonId:reasonId timeType:timeType];
        }];

    }
}

- (void)sheetActionEvent:(JHAlertSheetControllerAction)action isMain:(BOOL)isMain reasonId:(NSString *)reasonId  timeType:(NSInteger)timeType {
    switch (action) {
        case JHAlertSheetControllerActionDelete:///删除
        {
            User *user = [UserInfoRequestManager sharedInstance].user;
            if([self.currentComment.publisher.user_id isEqualToString:user.customerId]){
                [self deleteCommentWithReasonId:nil];
            }else{
                [self deleteForPublishCommentWithReasonId];
            }
        }
            break;
        case JHAlertSheetControllerActionReport:///举报
            [self toReport];
            break;
        default:
            break;
    }
}

///举报~
- (void)toReport {
    // rep_source:来源 1 文章 2 商品 3 评论 4 回复 6 直播间 61直播间 7话题 8投票贴 9商场商品 10猜价  于天文20210128
    NSInteger itemType = self.currentComment.parent_id > 0 ? 4 : 3;
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.titleString = @"举报";
    NSString *url = H5_BASE_HTTP_STRING(@"/jianhuo/app/report.html?");
    url = [url stringByAppendingFormat:@"rep_source=%ld&rep_obj_id=%@&live_user_id=%@",
           (long)itemType, self.currentComment.comment_id, self.currentComment.publisher.user_id];
    webVC.urlString = url;
    [self presentViewController:webVC animated:YES completion:nil];
}


- (void)deleteForPublishCommentWithReasonId{
    [JHSQApiManager deletePublishPostDetailCommentWithCommentId:self.currentComment.comment_id reasonId:nil completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            self.allChatCount -= 1;
            if (self.allChatCount < 1) {
                self.allChatCount = 0;
            }
            [self refreshCount];
            if (self.currentComment.parent_id > 0) {
                NSMutableArray *comments = self.currentMainComment.reply_list.mutableCopy;
                [comments removeObject:self.currentComment];
                self.currentMainComment.reply_list = comments.copy;
            }
            else {
                [self.commentArray removeObject:self.currentComment];
            }
            [self.tableView reloadData];
        }
        NSString *str = hasError ? (respObj.message?:@"删除失败") : @"删除成功";
        [UITipView showTipStr:str];
    }];
}


///提交删除评论结果
- (void)deleteCommentWithReasonId:(NSString *)reasonId {
    [JHSQApiManager deletePostDetailCommentWithCommentId:self.currentComment.comment_id reasonId:reasonId completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            
            self.allChatCount -= 1;
            if (self.allChatCount < 1) {
                self.allChatCount = 0;
            }
            [self refreshCount];
            if (self.currentComment.parent_id > 0) {
                NSMutableArray *comments = self.currentMainComment.reply_list.mutableCopy;
                [comments removeObject:self.currentComment];
                self.currentMainComment.reply_list = comments.copy;
            }
            else {
                [self.commentArray removeObject:self.currentComment];
            }
            [self.tableView reloadData];
        }
        NSString *str = hasError ? (respObj.message?:@"删除失败") : @"删除成功";
        [UITipView showTipStr:str];
    }];
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    
    if (indexPath.row == 0) {
        JHCommentModel *model = self.commentArray[indexPath.section];
        ///主评论
        JHC2CProductInnerChatMainCell *header = [tableView dequeueReusableCellWithIdentifier:kCommentSectionHeader];
        //cell为空就创建
        header.postAuthorId = model.publisher.user_id;
        header.indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        model.isDetailView = YES;
        header.mainComment = model;
        header.actionBlock = ^(NSIndexPath * _Nonnull selectIndexPath, JHC2CProductInnerChatMainCell * _Nonnull header, JHPostDetailActionType actionType) {
            @strongify(self);
            [self handleCommentActionEvent:actionType selecIndexPath:selectIndexPath contentView:header];
        };
        return header;
    }
    
    ///回复列表
    JHC2CProductInnerChatSubCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHC2CProductInnerChatSubCell];
    JHCommentModel *model = self.commentArray[indexPath.section];
    cell.postAuthorId = model.publisher.user_id;
    cell.indexPath = indexPath;
    JHCommentModel *subModel = model.reply_list[indexPath.row-1];
    model.isDetailView = YES;
    cell.commentModel = subModel;
    cell.actionBlock = ^(NSIndexPath * _Nonnull selectIndexPath, JHC2CProductInnerChatSubCell * _Nonnull cell, JHPostDetailActionType actionType) {
        @strongify(self);
        [self handleCommentActionEvent:actionType selecIndexPath:selectIndexPath contentView:cell];
    };
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger mainCount = 1;
    JHCommentModel *model = self.commentArray[section];
    return model.reply_list.count + mainCount;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    JHC2CProductDetailAccusationViewController *vc =  [JHC2CProductDetailAccusationViewController new];
//    [JHRootController.navigationController pushViewController:vc animated:YES];
//    [self showInputTextView];
}

#pragma mark -- <set and get>
- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 10;
        _backView = view;
    }
    return _backView;
}
- (UIView *)topView{
    if (!_topView) {
        UIView *view = [UIButton buttonWithType:UIButtonTypeCustom];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 10;
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(16);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"全部留言";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        self.titleCountLbl = label;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"newStore_coupon_close_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(@0);
            make.width.mas_equalTo(54);
        }];
        _topView = view;
    }
    return _topView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
        view.tableFooterView = [self getTableFooterView];
        view.backgroundColor = UIColor.whiteColor;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.estimatedRowHeight = 60;
        [view registerClass:[JHC2CProductInnerChatSubCell class] forCellReuseIdentifier:kJHC2CProductInnerChatSubCell];
        [view registerClass:[JHC2CProductInnerChatMainCell class] forCellReuseIdentifier:kCommentSectionHeader];

        _tableView = view;
    }
    return _tableView;
}

- (UIView*)getTableFooterView{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kScreenWidth, UI.tabBarAndBottomSafeAreaHeight);
    view.backgroundColor = UIColor.whiteColor;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
//    btn.titleLabel.font = JHFont(13);
//    [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
//    [view addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(@0);
//    }];
    return view;
}

- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColor.whiteColor;
        [btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn = btn;
        [btn addSubview:self.iconImageView];
        [btn addSubview:self.placeHolderLbl];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(9);
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.left.equalTo(@0).offset(12);
        }];
        [self.placeHolderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconImageView);
            make.right.equalTo(@0).offset(-12);
            make.left.equalTo(self.iconImageView.mas_right).offset(8);
        }];

    }
    return _bottomBtn;
}


- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 13;
        view.layer.masksToBounds = YES;
        NSString *userID = UserInfoRequestManager.sharedInstance.user.icon;
        [view jhSetImageWithURL:[NSURL URLWithString:userID] placeholder:kDefaultAvatarImage];
        _iconImageView = view;
    }
    return _iconImageView;
}
- (YYLabel *)placeHolderLbl{
    if (!_placeHolderLbl) {
        YYLabel *label = [YYLabel new];
        label.userInteractionEnabled = NO;
        label.font = JHFont(12);
        label.textContainerInset = UIEdgeInsetsMake(8, 14, 8, 0);
        label.backgroundColor = HEXCOLOR(0xF6F6F7);
        label.layer.cornerRadius = 16;
        label.text = @"喜欢就留言，了解更多细节~";
        label.textColor = HEXCOLOR(0x999999);
        _placeHolderLbl = label;
    }
    return _placeHolderLbl;

}

- (void)setAllChatCount:(NSInteger)allChatCount{
    _allChatCount = allChatCount;
    if (self.chatCountChange) {
        self.chatCountChange(allChatCount);
    }
}
@end
