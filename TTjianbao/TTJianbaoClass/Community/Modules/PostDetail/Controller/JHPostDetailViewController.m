//
//  JHPostDetailViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHBuryPointOperator.h"
#import "UIScrollView+JHEmpty.h"
#import "JHPostDetailViewController.h"
#import "JHWebViewController.h"
#import "JHCommitViewController.h"
#import "JHPostDetailHeaderTableCell.h"
#import "JHPostDtailEnterTableCell.h"
#import "JHPostMainCommentHeader.h"
#import "JHPostCommentFooterView.h"
#import "JHSubCommentTableCell.h"
#import "JHPostDetailPicInfoTableCell.h"
#import "JHPostDetailPlateEnterTableCell.h"
#import "JHPlateDetailController.h"
#import "JHTopicTallyView.h"
#import "JHPostDetailToolBar.h"
#import "JHSQApiManager.h"
#import "JHPostDetailModel.h"
#import "JHPostDetailCommentHeader.h"
#import "JHWebImage.h"
#import "JHUserInfoViewController.h"
#import "JHShopHomeController.h"
#import "JHUserInfoApiManager.h"
#import "JHPostDetailTextLinkCell.h"
#import "JHPostDetailImageTableCell.h"
#import "JHPostDetailVideoTableCell.h"
#import "JHPostDetailUpdateTimeTableCell.h"
#import "JHPlayerCustomConrolView.h"
#import "JHCommentTypeHeader.h"
#import "JHSQManager.h"

#import "JHNewShopDetailViewController.h"
#import "UIImageView+ZFCache.h"

#import "JHBaseOperationModel.h"
#import "JHBaseOperationView.h"

#define kPlayerHeight  (ScreenW*250/375)
#define kToolBarHeight  (UI.bottomSafeAreaHeight + 44)
#define kTallyHeight (39.f)
#define SECTION_COUNT  5
#define DEFAULT_COMMENT_NUM  2
#define kUserInfoHeight 68.f

#import "JHPhotoBrowserManager.h"
#import "JHDetailSvgaLoadingView.h"
#import "JHPostUserInfoView.h"

#import "JHEasyInputTextView.h"
#import "JHAttributeStringTool.h"
#import "JHPlayerViewController.h"
#import "JHNormalControlView.h"
#import "JHTrackingPostDetailModel.h"


@interface JHPostDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataList;
///视频播放器
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHNormalControlView *normalPlayerControlView;
/** 当前播放的cell*/
@property (nonatomic, strong) JHPostDetailVideoTableCell *currentCell;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger replyPage;
@property (nonatomic, strong) dispatch_group_t group;
//@property (nonatomic, strong) JHPostData *postData;//分享、更多调用。
@property (nonatomic, copy) NSArray <JHCommentModel *>*commentArray;
///372新增热评数组
@property (nonatomic, strong) NSMutableArray <JHCommentModel *>*hotCommentArray;
///存储最热评论和所有评论的数组
@property (nonatomic, strong) NSMutableArray <JHCommentModel *>*allCommentArray;
@property (nonatomic, strong) NSMutableArray <NSString *>*filterIds;
@property (nonatomic, strong) NSArray <JHPostDetailResourceModel *>*resourceInfo;
///选中的当前评论的信息
@property (nonatomic, strong) JHCommentModel *currentMainComment;
@property (nonatomic, strong) JHCommentModel *currentComment;
@property (nonatomic, assign) BOOL hasMoreComment;
@property (nonatomic, strong) JHDetailSvgaLoadingView *svgaPlayer;
///记录用户进入时间
@property (nonatomic, assign) NSTimeInterval enterTime;
///用户信息view 用于处理悬停
@property (nonatomic, strong) JHPostUserInfoView *userInfoView;
@property (nonatomic, strong) UILabel *allCommentView;
@property (nonatomic, strong) UILabel *tableFooterLabel;

@end

@implementation JHPostDetailViewController

- (void)dealloc {
    
    NSLog(@"%s被释放了🔥🔥🔥🔥🔥🔥🔥🔥", __func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self setupTableView];
    [self refreshData];
    
    JHDetailSvgaLoadingView *svgaPlayer = [[JHDetailSvgaLoadingView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH) placeholderImage:@"post_detail_loading"];
    [self.view insertSubview:svgaPlayer belowSubview:self.jhNavView];
    [svgaPlayer showLoading];
    _svgaPlayer = svgaPlayer;
}

- (void)createNav {
    [self initRightButtonWithImageName:@"topic_nav_more0" action:@selector(rightActionButton:)];
}

#pragma mark - UI
- (void)setupTableView {
    CGFloat topSpace = (self.itemType == JHPostItemTypeVideo) ? (kPlayerHeight) : (UI.statusAndNavBarHeight);
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(topSpace+1, 0, kToolBarHeight, 0));
    }];
    ///其他fuview没有添加的cell
    [self.mainTableView registerClass:[JHPostDetailTextLinkCell class] forCellReuseIdentifier:kJHPostDetailTextLinkIdentifer];
    [self.mainTableView registerClass:[JHPostDetailImageTableCell class] forCellReuseIdentifier:kJHPostDetailImageIdentifer];
    [self.mainTableView registerClass:[JHPostDetailVideoTableCell class] forCellReuseIdentifier:kPostDetailVideoIdentifer];
    [self.mainTableView registerClass:[JHPostDetailUpdateTimeTableCell class] forCellReuseIdentifier:kUpdateTimteCellIdentifer];
    
    self.mainTableView.tableFooterView = self.tableFooterLabel;
    self.mainTableView.tableFooterView.hidden = YES;
}

#pragma mark -
#pragma mark - UITableViewDataSource / UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == JHPostDetailSectionTypeInput) {
        JHPostDetailCommentHeader *header = [[JHPostDetailCommentHeader alloc] init];
        header.commentCount = @(self.postDetaiInfo.comment_num).stringValue;
        @weakify(self);
        header.actionBlock = ^{
            @strongify(self);
            if (self.postDetaiInfo.show_status == JHPostDataShowStatusChecking) {
                [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
            }
            else {
                ///340埋点 - 文章详情页写评论
                [self sa_tracking:@"nrhdComment" andOptionType:@""];
                [self growingForWriteComment];
                [self inputComment:YES];
            }
        };
        return header;
    }
    if (section == JHPostDetailSectionTypeComment && self.hotCommentArray.count > 0) {
        ///评论header
        JHCommentTypeHeader *header = [[JHCommentTypeHeader alloc] init];
        [header setTitle:@"最热评论" icon:@"icon_postdetail_hot"];
        return header;
    }
    if (section == JHPostDetailSectionTypeComment + self.hotCommentArray.count) {
        ///评论header
        JHCommentTypeHeader *header = [[JHCommentTypeHeader alloc] init];
        [header setTitle:@"全部评论" icon:@""];
        return header;
    }
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == JHPostDetailSectionTypeUserDesc) { /// 标签
        JHTopicTallyView *tallyView = [[JHTopicTallyView alloc] init];
        tallyView.topicInfos = self.postDetaiInfo.topics;
        return tallyView;
    }
    if (section >= SECTION_COUNT) {
        JHCommentModel *model = self.allCommentArray[section - SECTION_COUNT];
        BOOL showLine = [self showCellLine:section];
        if (model.reply_list.count > 0) {
            JHPostCommentFooterView *footer = [[JHPostCommentFooterView alloc] init];
            footer.footerSection = section;
            footer.showBottomLine = showLine;
            footer.commentCount = @(model.remaining_reply_count).stringValue;
            @weakify(self);
            footer.unfoldBlock = ^(NSInteger footerSection, JHPostCommentFooterView * _Nonnull footer) {
                @strongify(self);
                ///340埋点 - 展开父级评论
                [self growingForOpenSecondComment];
                [self requestMoreSubComment:footerSection contentView:footer];
            };
            return footer;
        }
        if (showLine) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
            lineView.backgroundColor = kColorFFF;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(55, 0, ScreenW-55-15, 1)];
            line.backgroundColor = kColorF5F6FA;
            [lineView addSubview:line];
            return lineView;
        }
        return [UIView new];
    }
    return [UIView new];
}

- (BOOL)showCellLine:(NSInteger)section {
    if (section == self.hotCommentArray.count+SECTION_COUNT-1) {
        return NO;
    }
    if (section == self.allCommentArray.count+SECTION_COUNT-1) {
        return NO;
    }
    return YES;
}

#pragma mark - private method
/// play the video

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (indexPath.section == JHPostDetailSectionTypeUserDesc) {
        ///上面描述部分 长文章和 动态 视频的顶部是一样的 固定indexPath.row = 0 为用户信息及标题
        if (indexPath.row == 0) {
            ///用户信息和帖子描述信息
            JHPostDetailHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHPostDetailHeaderCellIdentifer];
            cell.postDetailInfo = self.postDetaiInfo;
            cell.iconEnterBlock = ^ {
                @strongify(self);
                ///340埋点 - 文章详情页点击用户头像
                NSDictionary *params = [self growingParams];
                [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailUserEnter params:params  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                
                [self enterPersonalPage:self.postDetaiInfo.publisher.user_id  publisher:self.postDetaiInfo.publisher roomId:self.postDetaiInfo.publisher.room_id];
            };
            cell.followBlock = ^(BOOL isFollow) {
                @strongify(self);
                ///340埋点 - 文章详情页 关注用户
                NSDictionary *params = [self growingParams];
                [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetialFollowClick params:params  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                [self toFollow:isFollow];
            };
            return cell;
        }
        
        ///详细信息
        JHPostDetailResourceModel *model = self.resourceInfo[indexPath.row-1];
        if (model.type == JHPostDetailResourceTypeVideo) {
            JHPostDetailVideoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostDetailVideoIdentifer];
            cell.resourceModel = model;
            // 点击播放按钮
            @weakify(self);
            cell.playCallback = ^(JHPostDetailVideoTableCell * _Nonnull videoCell) {
                @strongify(self);
                self.currentCell = videoCell;
                [self addPlayerToCell];
            };
            return cell;
        }

        if (model.type == JHPostDetailResourceTypeImage) {  ///图片
            JHPostDetailImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHPostDetailImageIdentifer];
            cell.indexPath = indexPath;
            [self confirmCell:cell atIndexPath:indexPath];
            cell.imageBlock = ^(NSArray * _Nonnull imageViews, NSIndexPath * _Nonnull selectIndexPath) {
                @strongify(self);
                ///340埋点 - 文章详情页点开大图
                NSDictionary *params = [self growingParams];
                [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailPicEnter params:params  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                [self sa_tracking:@"nrhdImageClick" andOptionType:@""];
                __block NSInteger textCount = 0;
                NSMutableArray *imgArrayMed = [NSMutableArray array];
                NSMutableArray *imgArrayOri = [NSMutableArray array];
                [self.resourceInfo enumerateObjectsUsingBlock:^(JHPostDetailResourceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.type == JHPostDetailResourceTypeText ||
                         obj.type == JHPostDetailResourceTypeVideo) {
                        if (idx < selectIndexPath.row) {
                            textCount ++;
                        }
                    }
                    else {
                        [imgArrayMed addObject:[self getResourceString:obj]];
                
                        NSString *imgUrl = obj.data[@"image_url"];
                        if (![imgUrl hasPrefix:@"http"]) {
                            imgUrl = [NSString stringWithFormat:@"%@%@", ALIYUNCS_FILE_BASE_STRING(@"/"), imgUrl];
                        }
                        [imgArrayOri addObject:imgUrl];
                    }
                }];
                
                [JHPhotoBrowserManager showPhotoBrowserThumbImages:imgArrayMed mediumImages:imgArrayMed origImages:imgArrayOri sources:imageViews currentIndex:selectIndexPath.row-textCount-1 canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleNone];
            };
            return cell;
        }
        
        if (model.type == JHPostDetailResourceTypeText) {  ///文字
            JHPostDetailTextLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHPostDetailTextLinkIdentifer];
            
            NSString *arrayString = model.data[@"attrs"];
            NSArray *array = [NSArray array];
            if ([arrayString isNotBlank]) {
                NSData *jsonData = [model.data[@"attrs"] dataUsingEncoding:NSUTF8StringEncoding];
                   NSError *err;
               array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&err];
            }
            if (array.count > 0) {
                [cell setContent:[JHAttributeStringTool getOneParagraphAttrForPostDetail:array normalColor:kColor333 font:[UIFont fontWithName:kFontNormal size:16] logoSize:CGSizeMake(12, 12)] isEssence:NO];
            }else{
                NSString *str = [NSString stringWithFormat:@"%@", model.data[@"text"]];
                if (![str isNotBlank] || [str containsString:@"null"]) {
                    str = @"";
                }
                [cell setContent:[[NSMutableAttributedString alloc] initWithString:str] isEssence:NO];
            }
            return cell;
        }
        
        return nil;
    }
    
    ///板块
    if (indexPath.section == JHPostDetailSectionTypePlate) {
        JHPostDetailPlateEnterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostDetailPlateEnterCellIdentifer];
        cell.detailModel = self.postDetaiInfo;
        return cell;
    }
    ///店铺和直播间
    if (indexPath.section == JHPostDetailSectionTypeShop) { ///店铺
        JHPostDtailEnterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostDetailEnterIdentifer];
        [cell setDetailModel:self.postDetaiInfo SectionType:indexPath.section];
        return cell;
    }
    if (indexPath.section == JHPostDetailSectionTypeLivingRoom) { /// 店铺和直播间
        if (indexPath.row == 1) {  ///修改时间
            JHPostDetailUpdateTimeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kUpdateTimteCellIdentifer];
            cell.updateTime = self.postDetaiInfo.update_time;
            return cell;
        }
        if ([self.postDetaiInfo.archorInfo.room_id integerValue] > 0) {
            JHPostDtailEnterTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostDetailEnterIdentifer];
            [cell setDetailModel:self.postDetaiInfo SectionType:indexPath.section];
            return cell;
        }
        return [UITableViewCell new];
    }
    ///评论区
    if (indexPath.section >= SECTION_COUNT) {
        if (indexPath.row == 0) {
            ///主评论
            JHPostMainCommentHeader *header = [tableView dequeueReusableCellWithIdentifier:kCommentSectionHeader];
            header.postAuthorId = self.postDetaiInfo.publisher.user_id;
            header.indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            JHCommentModel *model = self.allCommentArray[indexPath.section - SECTION_COUNT];
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
        JHCommentModel *model = self.allCommentArray[indexPath.section - SECTION_COUNT];
        cell.postAuthorId = self.postDetaiInfo.publisher.user_id;
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
    
    return [UITableViewCell new];
}

- (NSString *)getResourceString:(JHPostDetailResourceModel *)model {
    switch (model.type) {
        case JHPostDetailResourceTypeImage:
        {
            NSString *imgUrl = model.data[@"image_url_medium"];
            if (![imgUrl hasPrefix:@"http"]) {
                imgUrl = [NSString stringWithFormat:@"%@%@", ALIYUNCS_FILE_BASE_STRING(@"/"), imgUrl];
            }
            return imgUrl;
        }
            break;
        case JHPostDetailResourceTypeVideo:
        {
            NSString *imgUrl = model.data[@"video_cover_url"];
            if (![imgUrl hasPrefix:@"http"]) {
                imgUrl = [NSString stringWithFormat:@"%@%@", ALIYUNCS_FILE_BASE_STRING(@"/"), imgUrl];
            }
            return imgUrl;
        }
            break;
        
        case JHPostDetailResourceTypeText:
        {
            NSString *str = [NSString stringWithFormat:@"%@", model.data[@"text"]];
            if (![str isNotBlank] || [str containsString:@"null"]) {
                str = @"";
            }
            return str;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_COUNT + self.allCommentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == JHPostDetailSectionTypeUserDesc) {
        return self.resourceInfo.count + 1;
    }
    if (section == JHPostDetailSectionTypePlate) {
        return (self.postDetaiInfo.plateInfo.ID > 0) ? 1 : 0;
    }
    if (section == JHPostDetailSectionTypeShop) {
        return ([self.postDetaiInfo.shopInfo.seller_id integerValue] > 0) ? 1 : 0;
    }
    if (section == JHPostDetailSectionTypeLivingRoom) {
        return 2;
//        return ([self.postDetaiInfo.archorInfo.room_id integerValue] > 0) ? 1 : 0;
    }
    if (section >= SECTION_COUNT) {
        NSInteger mainCount = 1;
        JHCommentModel *model = self.allCommentArray[section - SECTION_COUNT];
        return model.reply_list.count + mainCount;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == JHPostDetailSectionTypeInput) {
        return 100.f;
    }
    if (section == JHPostDetailSectionTypeComment && self.hotCommentArray.count > 0) {
        ///评论header
        return 41.f;
    }
    if (section == JHPostDetailSectionTypeComment + self.hotCommentArray.count) {
        ///评论header
        return 41.f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == JHPostDetailSectionTypeUserDesc) {
        return self.postDetaiInfo.topics.count > 0 ? kTallyHeight : 0;
    }
    if (section >= SECTION_COUNT) {
        BOOL showLine = [self showCellLine:section];
        JHCommentModel *model = self.allCommentArray[section - SECTION_COUNT];
        if (model.remaining_reply_count > 0) {
            return 43.f;
        }
        return model.reply_list.count > 0 ? 23. : (showLine ? 1 : CGFLOAT_MIN);
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JHPostDetailSectionTypeUserDesc && indexPath.row > 0) {
        JHPostDetailResourceModel *model = self.resourceInfo[indexPath.row-1];
        NSString *resourceString = [self getResourceString:model];
        if (model.type == JHPostDetailResourceTypeVideo) {
            return (ScreenW - 30) * 200 /345;
        }
        if (model.type == JHPostDetailResourceTypeImage) {
            UIImage *img = [JHWebImage imageFromDiskCacheForKey:resourceString];
            if (!img) {
                img =  kDefaultCoverImage;
            }
            CGFloat height = img.size.height;
            NSLog(@"height :----- %f", (ScreenW - 30)*height / img.size.width);
            return (ScreenW - 30)*height / img.size.width + 10;
        }
        return UITableViewAutomaticDimension;
    }
    
    if (indexPath.section == JHPostDetailSectionTypePlate) {
        return 86;
    }
    if (indexPath.section == JHPostDetailSectionTypeShop) {
        return 78;
    }
    if (indexPath.section == JHPostDetailSectionTypeLivingRoom) {
        if (indexPath.row == 0) {
            ///有直播间
            return ([self.postDetaiInfo.archorInfo.room_id integerValue] > 0) ? 78 : 0;
        }
        
        return [self.postDetaiInfo.update_time isNotBlank] ? 27 : 0;
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = nil;
    if (indexPath.section == JHPostDetailSectionTypePlate) { ///板块
        ///340埋点 - 文章详情页点击版块
        key = JHTrackSQArticleDetailPlateEnter;
        JHPlateDetailController *vc = [[JHPlateDetailController alloc] init];
        vc.plateId = self.postDetaiInfo.plateInfo.ID;
        vc.plateName = self.postDetaiInfo.plateInfo.name;
        vc.pageFrom = JHFromSQPostDetail; ///长文章详情页
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == JHPostDetailSectionTypeShop) {
        ///340埋点 - 文章详情页点击店铺
        key = JHTrackSQArticleDetailShopEnter;
        ///进入店铺
//        JHShopHomeController *vc = [[JHShopHomeController alloc] init];
//        vc.sellerId = [self.postDetaiInfo.shopInfo.seller_id integerValue];

        JHNewShopDetailViewController *vc = [[JHNewShopDetailViewController alloc] init];
        vc.customerId = self.postDetaiInfo.shopInfo.seller_id;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == JHPostDetailSectionTypeLivingRoom &&
             self.postDetaiInfo.archorInfo.room_id > 0) { ///直播间
        ///340埋点 - 文章详情页点击直播间
        key = JHTrackSQArticleDetailLiveEnter;
        if (![self.postDetaiInfo.publisher.user_id isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
            [JHRootController EnterLiveRoom:self.postDetaiInfo.archorInfo.room_id fromString:JHFromSQPicDetail];
        }
    }
    
//    ///评论区
//    if (indexPath.section >= SECTION_COUNT) {
//        if (indexPath.row == 0) {
//            ///主评论
//            [self handleCommentActionEvent:JHPostDetailActionTypeSingleTap selecIndexPath:indexPath contentView:nil];
//        }
//
//        ///回复列表
//    }
    
    
    ///340埋点 - 文章详情页
    if ([key isNotBlank]) {
        NSDictionary *params = [self growingParams];
        ///340埋点 - 文章详情页点击板块
        [JHAllStatistics jh_allStatisticsWithEventId:key params:params  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == JHPostDetailSectionTypeUserDesc) {
        if (indexPath.row == 0) {
            return;
        }
        JHPostDetailResourceModel *model = self.resourceInfo[indexPath.row-1];
//        if (!self.player.playingIndexPath &&
//            model.type == JHPostDetailResourceTypeVideo &&
//            [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
//            [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
//        }
    }
}

- (void)confirmCell:(JHPostDetailImageTableCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    JHPostDetailResourceModel *model = self.resourceInfo[indexPath.row-1];
    NSString *imgUrl = [self getResourceString:model];
    UIImage *cachedImg = [JHWebImage imageFromDiskCacheForKey:imgUrl];
    cell.detailString = imgUrl;
    if (!cachedImg) {
        [self downloadImage:imgUrl forIndexPath:indexPath];
    }
}

- (void)downloadImage:(NSString *)imageURL forIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    [JHWebImage downloadImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (!error) {
            @strongify(self);
            [JHWebImage storeImage:image forKey:imageURL completion:nil];
            [self performSelectorOnMainThread:@selector(reloadCellAtIndexPath:) withObject:indexPath waitUntilDone:NO];
        }else{
            
        }
    }];
}

-(void)reloadCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainTableView reloadData];
}

#pragma mark --------------------------------------------------------
#pragma mark -
#pragma mark - load Data
- (void)refreshData {
    [self.view beginLoading];
    [self.mainTableView.mj_footer resetNoMoreData];
    self.allCommentArray = [NSMutableArray array];
    self.commentArray = [NSArray array];
    self.page = 1;
    self.replyPage = 2;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    [self loadPostDetail:^{
        dispatch_group_leave(group);
    }];
    [self loadHotCommentList:^{
        self.allCommentArray = [NSMutableArray arrayWithArray:self.hotCommentArray.copy];
        dispatch_group_leave(group);
    }];
    [self loadCommentData:^(NSArray<JHCommentModel *> *commentList) {
        self.commentArray = commentList;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.svgaPlayer dismissLoading];
        self.mainTableView.hidden = NO;
        [self.view endLoading];
        [self.mainTableView.mj_header endRefreshing];
        [self.allCommentArray addObjectsFromArray:self.commentArray];
        [self.mainTableView reloadData];
        ///滑动到评论区
        [self ShowInputViewWhenScrollToComment];
    });
}

#pragma mark - 请求更多评论列表数据
- (void)loadMoreData {
    [self.view beginLoading];
    /// 展开父级评论
    [self growingForOpenFirstComment];
    [self loadCommentData:^(NSArray<JHCommentModel *> *commendList) {
        [self.view endLoading];
        if (commendList.count > 0) {
            self.commentArray = commendList;
            [self.allCommentArray addObjectsFromArray:commendList];
            [self.mainTableView reloadData];
            self.mainTableView.tableFooterView.hidden = YES;
            [self.mainTableView.mj_footer endRefreshing];
        }
        else {
            self.mainTableView.tableFooterView.hidden = NO;
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (UILabel *)tableFooterLabel {
    if (!_tableFooterLabel) {
        _tableFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _tableFooterLabel.text = @"没有更多评论了";
        _tableFooterLabel.font = [UIFont fontWithName:kFontNormal size:13.];
        _tableFooterLabel.textColor = kColor999;
        _tableFooterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tableFooterLabel;
}

- (void)loadPostDetail:(dispatch_block_t)block {
    @weakify(self);
    [JHSQApiManager getPostDetailInfo:@(self.itemType).stringValue itemId:self.itemId block:^(JHPostDetailModel *detailModel, BOOL hasError) {
        @strongify(self);
        NSLog(@"respObj:---- %@", detailModel);
        if (!hasError) {
            self.postDetaiInfo = detailModel;
            if ([self.postDetaiInfo.plateInfo.ID isEqual:@"82"] &&
                [self.postDetaiInfo.plateInfo.name isEqual:@"钱币"]) {
                [self setupRecyclingMoneyLayer:detailModel];
            }
            self.toolBar.detailModel = self.postDetaiInfo;
            self.userInfoView.postInfo = self.postDetaiInfo;
            self.allCommentView.text = [NSString stringWithFormat:@"共%ld条评论", (long)self.postDetaiInfo.comment_num];
            self.resourceInfo = self.postDetaiInfo.resourceData;
        }
        
        ///340埋点 - 文章详情页进入事件  因为相关信息得等接口请求回来后才能拿到 所以放在了这个位置埋点
        [self growingForEnterArticleDetail];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        [params setValue:self.itemId forKey:@"item_id"];
        [params setValue:self.postDetaiInfo.plateInfo.ID forKey:@"plate_id"];
        [JHUserStatistics noteEventType:kUPEventTypeCommunityPostDetailEntrance params:params];
        [self noteEventType:JHUPBrowseBegin];
        
        if (block) {
            block();
        }
    }];
}

///获取最热评论
- (void)loadHotCommentList:(dispatch_block_t)block {
    @weakify(self);
    [JHSQApiManager getHotCommentList:self.itemId itemType:self.itemType completation:^(NSArray <JHCommentModel *>*commetList, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            self.hotCommentArray = [NSMutableArray arrayWithArray:commetList];
        }
        if (block) {
            block();
        }
    }];
}

///全部评论接口
- (void)loadCommentData:(void(^)(NSArray <JHCommentModel *>*))block {
    [self.view beginLoading];
    ///展开父级评论
    [JHGrowingIO trackEventId:JHTrackSQTwitterDetailOpenFirstCommentClick variables:[self growingParams]];
    //获取最后一条主评论的评论id
    NSString *lastId = @"0";
    if (self.commentArray.count > 0) {
        JHCommentModel *model = self.commentArray.lastObject;
        lastId = model.comment_id;
    }
    
    NSString *fillterIds = self.filterIds.count > 0 ? [self.filterIds componentsJoinedByString:@","] : @"0";
    [JHSQApiManager getAllCommentList:self.itemId itemType:self.itemType page:self.page lastId:lastId filterIds:fillterIds completation:^(RequestModel *respObj, BOOL hasError) {
        [self.view endLoading];
        [self.mainTableView jh_endRefreshing];
        NSMutableArray *commentList = [NSMutableArray array];
        if (!hasError) {
            self.hasMoreComment = [respObj.data[@"is_more"] boolValue];
            NSMutableArray <JHCommentModel *>*arr = [JHCommentModel mj_objectArrayWithKeyValuesArray:respObj.data[@"list"]];
            NSArray *comments = [self resolveCommentData:arr];
            [commentList addObjectsFromArray:comments];
        }
        else {
            [UITipView showTipStr:respObj.message ?: @"加载失败"];
        }
        if (block) {
            block(commentList);
        }
    }];
}

///处理全部评论数据
- (NSArray *)resolveCommentData:(NSMutableArray *)arr {
    if (arr.count > 0) {
        self.mainTableView.mj_footer.state = MJRefreshStateIdle;
        for (JHCommentModel *model in arr) {
            if ([model.comment_id isEqualToString:[self.commentArray.firstObject comment_id]]) {
                [arr removeObject:model];
                break;
            }
        }
        ///成功拿到数据页数＋
        self.page ++;
    }
    else {
        self.mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
    }
    return arr.copy;
}

- (void)ShowInputViewWhenScrollToComment {
    if(self.scrollComment > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if(self.mainTableView.contentSize.height > (ScreenH - UI.statusAndNavBarHeight - UI.tabBarAndBottomSafeAreaHeight)) {
                CGRect rect = [self.mainTableView rectForSection:4];
                [self.mainTableView setContentOffset:CGPointMake(0, rect.origin.y) animated:YES];
            }
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.allCommentArray.count == 0) {
                [self inputComment:YES];
            }
        });
    }
}

#pragma mark - 请求更多回复
- (void)requestMoreSubComment:(NSInteger)section contentView:(id)contentView {
    if (![contentView isMemberOfClass:[JHPostCommentFooterView class]]) {
        return;
    }
    JHPostCommentFooterView *footer = (JHPostCommentFooterView *)contentView;
    JHCommentModel *mainComment = self.allCommentArray[section - SECTION_COUNT];
    JHCommentModel *lastReplyComment = mainComment.reply_list.lastObject;
    NSString *fillterIds = self.filterIds.count > 0 ? [self.filterIds componentsJoinedByString:@","] : @"0";
    [JHSQApiManager requestPostDetailReplyListWithCommentId:mainComment.comment_id lastId:lastReplyComment.comment_id.integerValue page:self.replyPage filterIds:fillterIds completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            NSArray *arr = [JHCommentModel mj_objectArrayWithKeyValuesArray:respObj.data[@"list"]];
            if (arr.count > 0) {
                NSMutableArray *comments = [NSMutableArray arrayWithArray:mainComment.reply_list];
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
            [self.mainTableView reloadData];
        }
        else {
            [UITipView showTipStr:respObj.message];
        }
    }];
}

#pragma mark -
#pragma mark - 点击事件相关的接口请求

///评论帖子
- (void)toPublishPostComment:(NSDictionary *)inputInfos {
    @weakify(self);
    [JHSQApiManager submitCommentWithCommentInfos:inputInfos itemId:self.postDetaiInfo.item_id itemType:self.postDetaiInfo.item_type completeBlock:^(RequestModel *respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"评论成功"];
            JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respObj.data];
            [self.allCommentArray insertObject:model atIndex:self.hotCommentArray.count];
            self.postDetaiInfo.comment_num += 1;
            self.toolBar.detailModel = self.postDetaiInfo;
            [self.filterIds addObject:[NSString stringWithFormat:@"%ld", (long)model.comment_id]];
            [self.mainTableView reloadData];
        }
        else {
            [UITipView showTipStr:[respObj.message isNotBlank] ? respObj.message : @"评论失败"];
        }
    }];
//    //埋点：发布评论
//    [GrowingManager articleDetailCommentPost:[self growingBaseParams]];
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
//        [params setValue:self.currentComment.comment_id forKey:@"comment_id"];
        [params setValue:[NSNumber numberWithString:self.currentComment.comment_id] forKey:@"comment_id"];
    }
    
    [JHSQApiManager submitCommentReplay:params completeBlock:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            //无论回复的是主评论还是子评论，都插在当前组的第一条
            JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respObj.data];
            if (model) {
                ///通知列表页处理数据
                [self.filterIds addObject:[NSString stringWithFormat:@"%ld", (long)model.comment_id]];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.currentMainComment.reply_list];
                [arr insertObject:model atIndex:0];
                self.currentMainComment.reply_list = arr.copy;
                [self.mainTableView reloadData];
            }
        }
        else {
            [UITipView showTipStr:[respObj.message isNotBlank] ? respObj.message : @"评论失败"];
        }
    }];
}

#pragma mark - 点赞
- (void)likeActionWithContentView:(id)contentView
                         itemType:(NSInteger)itemType
                           itemId:(NSString *)itemId
                          likeNum:(NSInteger)likeNum
                           isLike:(BOOL)isLike {
    if (self.postDetaiInfo.show_status == JHPostDataShowStatusChecking) {
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
        self.postDetaiInfo.like_num = @(self.postDetaiInfo.like_num_int + (isLike ? 1 : (-1))).stringValue;
        self.postDetaiInfo.like_num_int += isLike ? 1 : (-1);
        self.postDetaiInfo.is_like = @(isLike).integerValue;
        self.toolBar.detailModel = self.postDetaiInfo;
        [self.mainTableView reloadData];
    }
}

///关注用户
- (void)toFollow:(BOOL)isFollow {
    if (!isFollow) {
        [self sa_tracking:@"nrhdAttention" andOptionType:@"关注"];
        @weakify(self);
        [JHUserInfoApiManager followUserAction:self.postDetaiInfo.publisher.user_id fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
            @strongify(self);
            if (!hasError) {
                [UITipView showTipStr:@"已关注"];
                self.postDetaiInfo.publisher.is_follow = YES;
                [self.mainTableView reloadData];
            }
        }];
    }
}

#pragma mark ---------------------------------------------------------------
#pragma mark -
#pragma mark - action event
///底部工具栏点击事件
- (void)bottomToolBarAction:(JHPostDetailActionType)actionType {
    switch (actionType) {
        case JHPostDetailActionTypeInput:
        { ///340埋点 - 互动区写评论
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailInteractionWriteCommentClick params:[self growingParams]  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            [self sa_tracking:@"nrhdComment" andOptionType:@""];
            [self inputComment:YES];
        }
            break;
        case JHPostDetailActionTypeLike:
        {///340埋点 - 互动区点击点赞
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailInteractionLikeClick params:[self growingParams]  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            [self sa_tracking:@"nrhdLike" andOptionType:(@(self.postDetaiInfo.is_like).boolValue ? @"取消点赞":@"点赞")];
            [self likeActionWithContentView:nil itemType:self.postDetaiInfo.item_type itemId:self.postDetaiInfo.item_id likeNum:self.postDetaiInfo.like_num_int isLike:@(self.postDetaiInfo.is_like).boolValue];
        }
            break;
        case JHPostDetailActionTypeShare:
        {///340埋点 - 互动区点击分享
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailInteractionShareClick params:[self growingParams]  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            [self sa_tracking:@"nrhdShare" andOptionType:@"微信"];
            [self toShare:JHPageFromTypeSQPostDetailFastOperate];
        }
        case JHPostDetailActionTypeComment:
        {///340埋点 - 互动区点击评论icon
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailInteractionCommentClick params:[self growingParams]  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            ///需要将界面滑动到评论的位置
            [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:SECTION_COUNT-1] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        default:
            break;
    }
}
///处理评论列表的各种点击事件
- (void)handleCommentActionEvent:(JHPostDetailActionType)type
                  selecIndexPath:(NSIndexPath *)indexPath
                     contentView:(id)contentView {
    if (self.postDetaiInfo.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }

    JHCommentModel *commentInfo = self.allCommentArray[indexPath.section - SECTION_COUNT];
    BOOL isMain = [contentView isMemberOfClass:[JHPostMainCommentHeader class]];
    self.currentMainComment = commentInfo;
    self.currentComment = isMain ? self.currentMainComment : commentInfo.reply_list[indexPath.row-1];

    switch (type) {
        case JHPostDetailActionTypeLike: /// 点赞
        {
            ///340埋点 - 文章详情页评论点赞
            NSString *key = isMain ? JHTrackSQArticleDetailLikeFirstCommentClick : JHTrackSQArticleDetailLikeSecondCommentClick;
            [JHAllStatistics jh_allStatisticsWithEventId:key params:[self growingParams]  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            
            NSInteger itemType = (self.currentComment.parent_id > 0) ? 4 : 3;
            [self likeActionWithContentView:contentView itemType:itemType itemId:self.currentComment.comment_id likeNum:self.currentComment.like_num isLike:@(self.currentComment.is_like).boolValue];
        }
            break;
        case JHPostDetailActionTypeSingleTap: /// 单击
        {
            ///340埋点 - 文章详情页回复评论
            [self growingForReplyComment];
            [self sa_tracking:@"nrhdReply" andOptionType:@"回复"];
            ///单击评论列表
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
            [self sa_tracking:@"nrhdHeadClick" andOptionType:@""];
        }
            break;
        default:
            break;
    }
}

///进入个人主页
- (void)enterPersonalPage:(NSString *)userId
                publisher:(JHPublisher *)publisher
                   roomId:(NSString *)room_id {
    if (![userId isNotBlank]) {
        return;
    }
    [JHRouterManager pushUserInfoPageWithUserId:userId publisher:publisher from:JHFromSQPicDetail roomId:room_id completeBlock:^(NSString * _Nonnull userId, BOOL isFollow) {
        self.postDetaiInfo.publisher.is_follow = isFollow;
        [self.mainTableView reloadData];
    }];
}

- (void)inputComment:(BOOL)isMainComment {
    if (self.postDetaiInfo.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }

    if(IS_LOGIN){
        @weakify(self);
        JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
        easyView.showLimitNum = YES;
        easyView.type = 1;
        [self.view addSubview:easyView];
        [easyView show];
        [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
            @strongify(self);
            [easyView endEditing:YES];
            if (isMainComment) {
                [self toPublishPostComment:inputInfos];
            }
            else {
                [self toPublishReplyComment:inputInfos];
            }
        }];
    }
}


- (void)toShare:(JHPageFromType)pageFrom {
    if (self.postDetaiInfo.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }
    self.postDetaiInfo.share_info.pageFrom = pageFrom;
    [JHBaseOperationView creatShareOperationView:self.postDetaiInfo.shareInfo object_flag:self.postDetaiInfo.item_id];
}

///弹出弹窗
- (void)presentOptionWindow {
    if (self.postDetaiInfo.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }
    
    ///传字段为页面来源
    @weakify(self);
//    self.postData = [JHPostData mj_objectWithKeyValues:[self.postDetaiInfo mj_JSONObject]];
    self.postDetaiInfo.share_info.pageFrom = JHPageFromTypeSQPostDetailMore;
    [JHBaseOperationView creatSQPostDetailOperationView:self.postDetaiInfo Block:^(JHOperationType operationType) {
        @strongify(self);
        [JHBaseOperationAction operationAction:operationType operationMode:(JHPostData *)self.postDetaiInfo bolck:^{
             //成功
            [self operationComplete:operationType];
        }];
    }];
}

#pragma mark -
#pragma mark - 评论弹窗相关

- (void)showAlertSheetView:(BOOL)isMain {
    NSArray *actions = [JHSQManager commentActions:self.postDetaiInfo comment:self.currentComment];
    if (actions == nil || actions.count == 0) {
        return;
    }
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    [JHSQManager jh_showAlertSheetController:actions isSelf:[self.currentComment.publisher.user_id isEqualToString:user.customerId] actionBlock:^(JHAlertSheetControllerAction sheetAction,NSString *reason,NSString *reasonId, NSInteger timeType) {
        [self sheetActionEvent:sheetAction isMain:isMain reasonId:reasonId timeType:timeType];
    }];
}

- (void)sheetActionEvent:(JHAlertSheetControllerAction)action
                  isMain:(BOOL)isMain reasonId:(NSString *)reasonId
                timeType:(NSInteger)timeType {
    switch (action) {
        case JHAlertSheetControllerActionReply:///回复
        {
            if (self.postDetaiInfo.show_status != JHPostDataShowStatusChecking) {
                ///340埋点 - 文章详情页回复评论
                [self growingForReplyComment];
                ///长按回复评论 都是回复 参数应该是NO
                [self sa_tracking:@"nrhdReply" andOptionType:@"回复"];
                [self inputComment:NO];
                
            }
            else {
                [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
            }
            
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
            [self sa_tracking:@"nrhdReply" andOptionType:@"删除回复"];
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
    if (self.postDetaiInfo.show_status == JHPostDataShowStatusChecking) {
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
    [self presentViewController:alertV animated:YES completion:nil];
}

///警告
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
    // rep_source:来源 1 文章 2 商品 3 评论 4 回复 6 直播间 61直播间 7话题 8投票贴 9商场商品 10猜价  于天文20210128
    NSInteger itemType = self.currentComment.parent_id > 0 ? 4 : 3;
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.titleString = @"举报";
    NSString *url = H5_BASE_HTTP_STRING(@"/jianhuo/app/report.html?");
    url = [url stringByAppendingFormat:@"rep_source=%ld&rep_obj_id=%@&live_user_id=%@",
           (long)itemType, self.currentComment.comment_id, self.currentComment.publisher.user_id];
    webVC.urlString = url;
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
}

///封号
- (void)toBan {
    JHCommitViewController *vc = [[JHCommitViewController alloc] init];
    vc.commentModel = self.currentComment;
    self.definesPresentationContext = YES;
    vc.edgesForExtendedLayout = UIRectEdgeAll;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

///禁言
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
                [self.allCommentArray removeObject:self.currentComment];
            }
            [self.mainTableView reloadData];
        }
        NSString *str = hasError ? (respObj.message?:@"删除失败") : @"删除成功";
        [UITipView showTipStr:str];
    }];
}

- (NSMutableArray<JHCommentModel *> *)hotCommentArray {
    if (!_hotCommentArray) {
        _hotCommentArray = [NSMutableArray array];
    }
    return _hotCommentArray;
}

- (NSMutableArray<NSString *> *)filterIds {
    if (!_filterIds) {
        _filterIds = [NSMutableArray array];
    }
    return _filterIds;
}
- (void)rightActionButton:(UIButton *)sender{
    [self presentOptionWindow];
}
#pragma mark - 操作交互弹框后 刷新cell数据
-(void)operationComplete:(JHOperationType)operationType {
    
    if (operationType == JHOperationTypeColloct||
        operationType == JHOperationTypeCancleColloct) {
        self.postDetaiInfo.is_collect =!self.postDetaiInfo.is_collect;
    }
    if (operationType == JHOperationTypeSetGood||
        operationType == JHOperationTypeCancleSetGood) {
        self.postDetaiInfo.content_level = self.postDetaiInfo.content_level == 1?0:1;
    }
    if (operationType == JHOperationTypeSetTop||
        operationType == JHOperationTypeCancleSetTop) {
        self.postDetaiInfo.content_style = self.postDetaiInfo.content_style == 2?0:2;
    }
    if (operationType == JHOperationTypeNoice||
        operationType == JHOperationTypeCancleNotice) {
        self.postDetaiInfo.content_style = self.postDetaiInfo.content_style == 3?0:3;
    }
    if (operationType == JHOperationTypeDelete) {
//        [self.postArray removeObject:data];
//        [self.contentTableView reloadData];
    }
}

#pragma mark -
#pragma mark - 340埋点相关

///文章详情页进入事件埋点
- (void)growingForEnterArticleDetail {
    NSDictionary *params = [self growingParams];
    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetialEnter params:params  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
}

///340埋点 - 文章详情页写评论
- (void)growingForWriteComment {
    NSMutableArray *topicIds = [NSMutableArray array];
    if (self.postDetaiInfo.topics && self.postDetaiInfo.topics.count > 0) {
        for (JHTopicInfo *info in self.postDetaiInfo.topics) {
            [topicIds addObject:info.ID];
        }
    }
    NSDictionary *params = @{@"page_from" : self.pageFrom,
                          @"item_type" : @(self.itemType),
                          @"item_id" : self.itemId,
                          @"author_id" : self.postDetaiInfo.publisher.user_id,
                          @"plate_id" : self.postDetaiInfo.plateInfo.ID,
                          @"topic_ids" : topicIds.mj_JSONString
    };
    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailWriteCommentClick params:params  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
}

///340埋点 - 文章详情页回复评论
- (void)growingForReplyComment {
    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailReplyCommentClick params:[self growingParams]  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
}

///340埋点 - 展开父级评论
- (void)growingForOpenFirstComment {
    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailOpenFirstCommentClick params:[self growingParams]  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
}

///340埋点 - 展开子级评论
- (void)growingForOpenSecondComment {
    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleDetailOpenSecondCommentClick params:[self growingParams]  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
}

///帖子停留时长埋点
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///340growing埋点：-- 长文章停留时长 记录进入界面的时间
    _enterTime = [YDHelper get13TimeStamp].longLongValue;
    
    [self buryBegin];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self noteEventType:JHUPBrowseEnd];
    ///浏览时长埋点
    [self growingArticleBrowse];
    
    [self sa_tracking:@"contentPageView" andOptionType:@""];
    [self buryEnd];
}

-(void)noteEventType:(id)type
{
    NSString *eventId = kUPEventTypeCommunityPostDetailBrowse;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setValue:self.itemId forKey:@"item_id"];
    [params setValue:self.postDetaiInfo.plateInfo.ID forKey:@"plate_id"];
    [params setValue:type forKey:JHUPBrowseKey];
    [JHUserStatistics noteEventType:eventId params:params];
}

//growingIO 埋点：浏览时长
- (void)growingArticleBrowse {
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:_enterTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:JHFromSQPostDetail forKey:@"page_from"];
    [params setValue:@(duration) forKey:@"duration"];
    [params setValue:self.itemId forKey:@"item_id"];
    if(self.postDetaiInfo && self.postDetaiInfo.publisher)
    {
        [params setValue:self.postDetaiInfo.publisher.user_id forKey:@"user_id"];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQArticleBrowseTime params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
}

- (NSDictionary *)growingParams {
    NSMutableArray *topicIds = [NSMutableArray array];
    if (self.postDetaiInfo.topics && self.postDetaiInfo.topics.count > 0) {
        for (JHTopicInfo *info in self.postDetaiInfo.topics) {
            [topicIds addObject:info.ID];
        }
    }
    NSDictionary *dic = @{@"page_from" : JHFromSQPostDetail,
                          @"item_type" : @(self.itemType),
                          @"item_id" : self.itemId,
                          @"author_id" : self.postDetaiInfo.publisher.user_id,
                          @"plate_id" : self.postDetaiInfo.plateInfo.ID,
                          @"topic_ids" : topicIds.mj_JSONString
    };

    return dic;
}

- (void)getNowTopSectionView:(CGFloat)offsetY {
    NSArray <UITableViewCell *> *cellArray = [self.mainTableView visibleCells];
    NSInteger section = -1;
    if (cellArray.count > 0) {
        UITableViewCell *cell = [cellArray firstObject];
        NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
        section = indexPath.section;
    }
    NSLog(@"当前悬停的组头是:%ld",section);
    if (section >= 0 && section < SECTION_COUNT-1) {
        self.userInfoView.hidden = offsetY <= 0;
        self.allCommentView.hidden = YES;
    }
    else if (section >= SECTION_COUNT-1) {
        self.allCommentView.hidden = NO;
        self.userInfoView.hidden = YES;
    }
}

- (UILabel *)allCommentView {
    if (!_allCommentView) {
        _allCommentView = [[UILabel alloc] init];
        _allCommentView.backgroundColor = kColorFFF;
        _allCommentView.text = @"共0条评论";
        _allCommentView.font = [UIFont fontWithName:kFontMedium size:15];
        _allCommentView.textColor = kColor333;
        _allCommentView.hidden = YES;
        [self.view addSubview:_allCommentView];
        [_allCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.mainTableView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
            make.height.mas_equalTo(50);
        }];
    }
    return _allCommentView;
}

- (JHPostUserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[JHPostUserInfoView alloc] init];
        _userInfoView.backgroundColor = kColorFFF;
        _userInfoView.postInfo = self.postDetaiInfo;
        _userInfoView.hidden = YES;
        @weakify(self);
        _userInfoView.followBlock = ^(BOOL isFollow) {
            @strongify(self);
            ///340埋点 - 点击关注用户按钮
            [JHGrowingIO trackEventId:JHTrackSQTwitterDetailUserFollowEnter variables:[self growingParams]];
            [self toFollow:isFollow];
        };
        _userInfoView.iconEnterBlock = ^{
            @strongify(self);
            ///340埋点 - 点击用户头像
            NSDictionary *params = [self growingParams];
            [JHGrowingIO trackEventId:JHTrackSQTwitterDetailUserIconEnter variables:params];
            [self enterPersonalPage:self.postDetaiInfo.publisher.user_id publisher:self.postDetaiInfo.publisher roomId:self.postDetaiInfo.publisher.room_id];
        };
        [self.view addSubview:_userInfoView];
        
        [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.mainTableView);
            make.height.mas_equalTo(68.f);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = kColorF5F6FA;
        [_userInfoView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.userInfoView);
            make.height.mas_equalTo(1);
        }];
    }
    return _userInfoView;
}

// 播放器相关
- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.view.frame = CGRectMake(0, 0, ScreenW, ScreenW / 16. * 9.);
        [_playerController setSubviewsFrame];
    }
    return _playerController;
}

- (JHNormalControlView *)normalPlayerControlView {
    if (_normalPlayerControlView == nil) {
        _normalPlayerControlView = [[JHNormalControlView alloc] initWithFrame:self.playerController.view.bounds];
        _normalPlayerControlView.isNeedVertical = YES;
    }
    return _normalPlayerControlView;
}

- (void)addPlayerToCell {
    self.playerController.view.frame = self.currentCell.coverImageView.bounds;
    [self.playerController setSubviewsFrame];
    [self.playerController setControlView:self.normalPlayerControlView];
    [self.currentCell.coverImageView addSubview: self.playerController.view];

    NSString *videoUrl = self.currentCell.resourceModel.data[@"video_url"];
    
    if (![videoUrl hasPrefix:@"http"]) {
        videoUrl = [NSString stringWithFormat:@"%@%@", ALIYUNCS_VIDEO_BASE_STRING(@"/"), videoUrl];
    }
    NSString *width = [NSString stringWithFormat:@"%@", self.currentCell.resourceModel.data[@"width"]];
    NSString *height = [NSString stringWithFormat:@"%@", self.currentCell.resourceModel.data[@"height"]];
    if (height.doubleValue > width.doubleValue) {
        self.playerController.isVerticalScreen = YES;
    }
    self.playerController.urlString = videoUrl;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self endScrollToPlayVideo];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self endScrollToPlayVideo];
}
// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.mainTableView visibleCells];
    if (![visiableCells containsObject:self.currentCell]) {
        if (self.playerController.isPLaying) {
            [self.playerController pause];
        }
    }
    //没有满足条件的 释放视频
}

//神策埋点
- (void)sa_tracking:(NSString *)event andOptionType:(NSString *)option{
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:_enterTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    
    JHTrackingPostDetailModel * model = [JHTrackingPostDetailModel new];
    model.event = event;
    model.operation_type = option;
    model.page_position = @"内容详情页";
    model.view_duration = @(duration);
    model.content_type = @"文章";
    model.source_page = self.pageFrom;
    [model transitionWithModel:self.postDetaiInfo];
    [JHTracking trackModel:model];
}


- (void)buryBegin {
    
    JHBuryPointDiscoverDetailInfoModel *model = [[JHBuryPointDiscoverDetailInfoModel alloc] init];
    model.item_type = self.itemType;
    model.item_id = self.itemId;
    model.request_id = [NSUUID UUID].UUIDString;
    model.time =  [CommHelp getNowTimeTimestampMS];
    [[JHBuryPointOperator shareInstance] discoverDetailInBuryWithModel:model];
}

- (void)buryEnd {
    JHBuryPointDiscoverDetailInfoModel *model = [[JHBuryPointDiscoverDetailInfoModel alloc] init];
    model.item_type = self.itemType;
    model.item_id = self.itemId;
    model.request_id = [NSUUID UUID].UUIDString;
    model.time =  [CommHelp getNowTimeTimestampMS];
    [[JHBuryPointOperator shareInstance] discoverDetailOutBuryWithModel:model];
}

@end
