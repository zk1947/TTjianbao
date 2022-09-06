//
//  JHSQOptionToolBar.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQOptionToolBar.h"
#import "TTjianbao.h"
#import "JHSQManager.h"
#import "JHSQModel.h"
#import "JHTagView.h"
#import "JHSQApiManager.h"

//以下是评论需要的头文件，暂时的
#import "JHBaseOperationView.h"
#import "UMengManager.h"
#import "JHSQBasePostCell.h"
#import "JHTrackingPostDetailModel.h"

@interface JHSQOptionToolBar ()
@property (nonatomic, strong) JHTagView *tagView; //标签
@property (nonatomic, strong) UIButton *shareButton; //分享
@end

@implementation JHSQOptionToolBar

+ (CGFloat)toolBarHeight {
    return 54.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        if (!_tagView) {
            @weakify(self);
            _tagView = [JHTagView tagWithStyle:JHTagViewStylePlate clickBlock:^{
                //进入版块主页
                @strongify(self);
                if (self.postData.item_type != JHPostItemTypeAppraisalVideo) {
                    ///点击版块标签相关埋点
                    [self __clickPlateGrowingAction];
                    ///鉴定视频的板块标签不可点击
                    [JHRouterManager pushPlateDetailWithPlateId:self.postData.plate_info.ID pageType:self.pageType];
                }
            }];
        }
        
        _shareButton = [UIButton buttonWithTitle:@"分享" titleColor:kColor333];
        _shareButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_shareButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_share"] forState:UIControlStateNormal];
        _shareButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _shareButton.adjustsImageWhenHighlighted = NO;
        [_shareButton setImageInsetStyle:MRImageInsetStyleLeft spacing:3];
        //_shareButton.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
        
        _commentButton = [UIButton buttonWithTitle:@"评论" titleColor:kColor333];
        _commentButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_commentButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_comment"] forState:UIControlStateNormal];
        _commentButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _commentButton.adjustsImageWhenHighlighted = NO;
        [_commentButton setImageInsetStyle:MRImageInsetStyleLeft spacing:3];
        //_commentButton.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
        
        _likeButton = [UIButton buttonWithTitle:@"点赞" titleColor:kColor333];
        _likeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_likeButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_selected"] forState:UIControlStateSelected];
        _likeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _likeButton.adjustsImageWhenHighlighted = NO;
        [_likeButton setImageInsetStyle:MRImageInsetStyleLeft spacing:3];
        //_likeButton.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
        
        @weakify(self);
        [[_shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [JHNotificationCenter postNotificationName:UIKeyboardWillHideNotification object:nil];
            @strongify(self);
            [self _handleShareEvent];
        }];

        [[_commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [JHNotificationCenter postNotificationName:UIKeyboardWillHideNotification object:nil];
            @strongify(self);
            if (![JHRootController isLogin]) {
                [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
            } else {
                [self _handleCommentEvent];
            }
        }];
        
        [[_likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [JHNotificationCenter postNotificationName:UIKeyboardWillHideNotification object:nil];
            @strongify(self);
            if (![JHRootController isLogin]) {
                [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
            } else {
                if (self.postData.is_like) {
                    [self _handleUnLikeEvent];
                } else {
                    [self _handleLikeEvent];
                }
            }
        }];
        
        [self sd_addSubviews:@[_tagView, _shareButton, _commentButton, _likeButton]];
        
        _tagView.sd_layout
        .leftSpaceToView(self, 10)
        .centerYEqualToView(self)
        .heightIs(24);
        
        _likeButton.sd_layout
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 10)
        .widthIs(60)
        .heightIs([[self class] toolBarHeight]);
        
        _commentButton.sd_layout
        .topSpaceToView(self, 0)
        .rightSpaceToView(_likeButton, 0)
        .widthIs(60)
        .heightIs([[self class] toolBarHeight]);
        
        _shareButton.sd_layout
        .topSpaceToView(self, 0)
        .rightSpaceToView(_commentButton, 0)
        .widthIs(60)
        .heightIs([[self class] toolBarHeight]);
        
    }
    return self;
}

- (void)setPostData:(JHPostData *)postData {
    _postData = postData;
    JHPlateInfo *plateInfo = postData.plate_info;
    if (!plateInfo) {
        return;
    }
    JHTagViewStyle style = (_postData.item_type == JHPostItemTypeAppraisalVideo) ?JHTagViewStyleAppraisePlate:JHTagViewStylePlate;
    self.tagView.tagViewStyle = style;
    _tagView.title = (style == JHTagViewStylePlate) ? plateInfo.name : @"鉴定视频";
    _tagView.hidden = ![plateInfo.name isNotBlank];

    [self _updateShareNum]; //分享数
    [self _updateLikeButtonNum]; //点赞数
    [self _updateCommentNum]; //评论数
}

-(void)bindMethod
{
    NSString *numStr = [CommHelp convertNumToWUnitString:_postData.comment_num existDecimal:NO];
    [_commentButton setTitle:_postData.comment_num > 0 ? numStr : @"评论" forState:UIControlStateNormal];
}



#pragma mark -
#pragma mark - 更新数据

//更新分享数
- (void)_updateShareNum {
    NSString *numStr = [CommHelp convertNumToWUnitString:_postData.share_num existDecimal:NO];
    [_shareButton setTitle:_postData.share_num > 0 ? numStr : @"分享" forState:UIControlStateNormal];
}

//更新点赞数
- (void)_updateLikeButtonNum {
    _likeButton.selected = (_postData.is_like && _postData.like_num > 0);
    NSString *numStr = [CommHelp convertNumToWUnitString:_postData.like_num existDecimal:NO];
    [_likeButton setTitle:_postData.like_num > 0 ? numStr : @"点赞" forState:UIControlStateNormal];
}

//更新评论数
- (void)_updateCommentNum {
    NSString *numStr = [CommHelp convertNumToWUnitString:_postData.comment_num existDecimal:NO];
    [_commentButton setTitle:_postData.comment_num > 0 ? numStr : @"评论" forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark - 事件处理

//点赞
- (void)_handleLikeEvent {
    if ([self postIsChecking]) {///审核中
        return;
    }
//    [self sa_tracking:@"nrhdLike" andOptionType:@"点赞"];
    @weakify(self);
    [JHSQApiManager sendLikeRequest:_postData block:^(RequestModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"点赞成功"];
            self.postData.like_num = [respObj.data[@"like_num_int"] integerValue];
            self.postData.is_like = YES;
            [self _updateLikeButtonNum];
            [JHNotificationCenter postNotificationName:kUpdateUserCenterInfoNotification object:@{@"likeNum":@(1)}];
        }
        else {
            [UITipView showTipStr:@"点赞失败"];
        }
    }];
    
    //埋点
    if (self.clickLikeForGrowingIOBlock) {
        self.clickLikeForGrowingIOBlock();
    }
}

//取消点赞
- (void)_handleUnLikeEvent {
    if ([self postIsChecking]) {///审核中
        return;
    }

//    [self sa_tracking:@"nrhdLike" andOptionType:@"取消点赞"];
    @weakify(self);
    [JHSQApiManager sendUnLikeRequest:_postData block:^(RequestModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            self.postData.like_num = [respObj.data[@"like_num_int"] integerValue];
            self.postData.is_like = NO;
            [self _updateLikeButtonNum];
            [JHNotificationCenter postNotificationName:kUpdateUserCenterInfoNotification object:@{@"likeNum":@(-1),@"postInfo":self.postData}];
        }
        else {
            [UITipView showTipStr:@"取消点赞失败"];
        }
    }];
    
    //埋点
    if (self.clickUnLikeForGrowingIOBlock) {
        self.clickUnLikeForGrowingIOBlock();
    }
}

//点击评论
- (void)_handleCommentEvent {
    if ([self postIsChecking]) {///审核中
        return;
    }
    
    if (self.clickCommentBlock) {
        self.clickCommentBlock();
    }
}

//点击分享
- (void)_handleShareEvent {
    if ([self postIsChecking]) {///审核中
        return;
    }
//    [self sa_tracking:@"nrhdShare" andOptionType:@"微信"];
    if (self.clickShareBlock) {
        self.clickShareBlock();
    }
}


#pragma mark -
#pragma mark - 点击列表底部工具栏埋点相关
///点击版块
- (void)__clickPlateGrowingAction {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome: /// 社区首页
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_list_channel_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
        case JHPageTypeSQPlateList: ///版块
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateListChannelEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQTopicList: ///话题
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicListTopicEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        default:
            break;
    }
}

- (BOOL)postIsChecking {
    if (_postData.show_status == JHPostDataShowStatusChecking) {
        ///审核中
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return YES;
    }
    return NO;
}
//神策埋点
//- (void)sa_tracking:(NSString *)event andOptionType:(NSString *)option{
//
//    JHTrackingPostDetailModel * model = [JHTrackingPostDetailModel new];
//    model.event = event;
//    model.operation_type = option;
//    model.page_position = @"内容列表页";
//    switch (self.postData.item_type) {
//        case JHPostItemTypeDynamic:  ///动态
//        {
//            model.content_type = @"动态";
//        }
//            break;
//        case JHPostItemTypePost: ///长文章
//        {
//            model.content_type = @"长文章";
//        }
//            break;
//        case JHPostItemTypeVideo: ///小视频
//        {
//            model.content_type = @"小视频";
//        }
//            break;
//        default:
//            break;
//    }
//    [model transitionWithPostData:self.postData];
//    [JHTracking trackModel:model];
//}
@end
