//
//  JHSQPostVideoCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPostVideoCell.h"
#import "JHSQShortVideoView.h"

//以下是评论需要的头文件
#import "UMengManager.h"
#import "JHAppraiseVideoViewController.h"
#import "PPStickerDataManager.h"

@interface JHSQPostVideoCell ()
{
    BOOL _hasContent;
    BOOL _hasHotComment;
}

@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) YYLabel *contentLabel; //内容
@property (nonatomic, strong) JHSQShortVideoView *videoView; //视频

@end

@implementation JHSQPostVideoCell
@synthesize hotCommentView = _hotCommentView;
@synthesize bottomLine = _bottomLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.layer.cornerRadius = 8.f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.clipsToBounds = YES;
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = YES;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.layer.cornerRadius = 8.f;
        _contentControl.layer.masksToBounds = YES;
        _contentControl.exclusiveTouch = YES;
        @weakify(self);
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    [self handleClickEvent];
                }
            }
            if(self.pageType == JHPageTypeUserInfoLikeTab)
            {
                [JHGrowingIO trackEventId:@"profile_like_video_enter"];
            }
            else if(self.pageType == JHPageTypeUserInfoPublishTab)
            {
                [JHGrowingIO trackEventId:@"profile_write_video_enter"];
            }
        };
    }
    
    //1
    self.userInfoView = [[JHSQUserInfoView alloc] initWithFrame:CGRectZero];
    @weakify(self);
    self.userInfoView.clickUserInfoBlock = ^{
        @strongify(self);
        [self handleClickUserInfoEvent];
        //埋点
        [self baseAvatarAction];
    };
    self.userInfoView.clickMoreBlock = ^{
        @strongify(self);
        [self handleClickMoreEvent]; //点击点点点
        //埋点
        [self baseMoreAction];
    };
    
    //2
    _contentLabel = [YYLabel labelWithFont:[UIFont fontWithName:kFontNormal size:16] textColor:kColor333];
    _contentLabel.numberOfLines = 3;
    [self addSeeMoreButton];
    
    //3
    _videoView = [[JHSQShortVideoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [JHSQShortVideoView viewHeight])];
    _videoView.clickPlayBlock = ^{
        @strongify(self);
        [self baseEnterDetailAction];
        [self __enterPostDetailComment:NO];
    };
    
    //4
    self.toolBar = [[JHSQOptionToolBar alloc] initWithFrame:CGRectZero];
    self.toolBar.pageType = self.pageType;
    self.toolBar.clickShareBlock = ^{
        @strongify(self);
        [self handleClickShareEvent]; //点击分享
        //埋点
        [self baseShareAction];
    };
    self.toolBar.clickCommentBlock = ^{
        @strongify(self);
        [self __enterPostDetailComment:YES];
        //埋点
        [self baseCommentAction];
    };
    
    //埋点-点赞
    self.toolBar.clickLikeForGrowingIOBlock = ^{
        @strongify(self);
        [self baseLikeAction];
    };
    //埋点-取消点赞
    self.toolBar.clickUnLikeForGrowingIOBlock = ^{
        @strongify(self);
        [self baseUnLikeAction];
    };
    
    //5
    _hotCommentView = [JHSQHotCommentView new];
    
    //6
    _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLine.backgroundColor = kColorF5F6FA;
    
    [_contentControl sd_addSubviews:@[self.userInfoView, _contentLabel, _videoView, self.toolBar, _hotCommentView]];
    [self.contentView sd_addSubviews:@[_contentControl, _bottomLine]];
    
    //布局
    _contentControl.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    self.userInfoView.sd_layout
    .topEqualToView(_contentControl)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightIs([JHSQUserInfoView viewHeight]);
    
    _contentLabel.sd_layout
    .topSpaceToView(self.userInfoView, 0)
    .leftSpaceToView(_contentControl, 10)
    .widthIs(kScreenWidth - 20);
    
    _videoView.sd_layout
    .topSpaceToView(_contentLabel, 10)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightIs([JHSQShortVideoView viewHeight]);
    
    self.toolBar.sd_layout
    .topSpaceToView(_videoView, 0)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightIs([JHSQOptionToolBar toolBarHeight]);
    
    _hotCommentView.sd_layout
    .topSpaceToView(self.toolBar, 0)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10);
    
    _bottomLine.sd_layout
    .topSpaceToView(_hotCommentView, 15)
    .leftSpaceToView(self.contentView, 0)
    .widthIs(kScreenWidth)
    .heightIs(10);
    
    [_contentControl setupAutoHeightWithBottomViewsArray:@[self.toolBar, _hotCommentView] bottomMargin:0];
    [self setupAutoHeightWithBottomView:_bottomLine bottomMargin:0];
}

#pragma mark - 全文按钮

- (void)addSeeMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
    YYTextHighlight *hlText = [YYTextHighlight new];
    [hlText setColor:kColor333];
    @weakify(self);
    hlText.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        @strongify(self);
        [self handleClickEvent];
    };
    
    [text setColor:[UIColor colorWithHexString:@"408FFE"] range:[text.string rangeOfString:@"全文"]];
    [text setTextHighlight:hlText range:[text.string rangeOfString:@"全文"]];
    text.font = _contentLabel.font;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
    _contentLabel.truncationToken = truncationToken;
}

#pragma mark -
#pragma mark - 布局

//帖子内容布局
- (void)makeContentLayout {
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:self.postData.contentAttrText font:_contentLabel.font];
    _contentLabel.attributedText = self.postData.postContentAttrText;
    _contentLabel.sd_layout.heightIs(self.postData.contentHeight);
}

//视频布局
- (void)makeVideoLayout {
    //只赋值，不需要布局
    _videoView.videoInfo = self.postData.video_info;
    CGFloat space = (self.postData.postContentAttrText && self.postData.postContentAttrText.length > 0) ? 10 : 0;
    _videoView.sd_layout.topSpaceToView(_contentLabel, space);
    [_videoView updateLayout];
}

//工具栏布局
- (void)makeToolBarLayout {
    self.toolBar.postData = self.postData;
    self.toolBar.sd_layout.topSpaceToView(_videoView, 0);
}

//热评内容布局
- (void)makeHotCommentLayout {
    _hotCommentView.hidden = (!_hasHotComment || self.postData.hideComment);
    
    if (_hasHotComment && !self.postData.hideComment) {
        _hotCommentView.postData = self.postData;
        
    } else {
        _hotCommentView.sd_layout.heightIs(0);
    }
}

//底部分割线布局
- (void)makeBottomLineLayout {
    if (_hasHotComment) {
        _bottomLine.sd_layout.topSpaceToView(_hotCommentView, 15);
    } else {
        _bottomLine.sd_layout.topSpaceToView(self.toolBar, 0);
    }
}

#pragma mark - 设置数据

- (void)setPostData:(JHPostData *)postData {
    [super setPostData:postData];
    _hasContent = [self.postData.content isNotBlank];
    _hasHotComment = self.postData.hot_comments.count > 0;
    
    [self makeContentLayout];
    [self makeVideoLayout];
    [self makeToolBarLayout];
    [self makeHotCommentLayout];
    [self makeBottomLineLayout];
    
    [self setupAutoHeightWithBottomView:self.bottomLine bottomMargin:0];
}


#pragma mark -
#pragma mark - 事件处理

//点击帖子区域
- (void)handleClickEvent {
    [self baseEnterDetailAction];
    [self __enterPostDetailComment:NO];
}

//NSLog(@"点击用户信息");
- (void)handleClickUserInfoEvent {
    if(self.postData.recommend_type != 3){
        [JHSQManager enterUserInfoVCWithPublisher:self.postData.publisher];
    }
    else{
        [JHRouterManager pushPlateDetailWithPlateId:self.postData.plate_info.ID pageType:self.pageType];
    }
}

//NSLog(@"点击更多选项<点点点>");
- (void)handleClickMoreEvent {
    JHPageFromType pageFrom = [self getPageFrom:self.pageType actionType:JHActionTypeMore];
    self.postData.share_info.pageFrom = pageFrom;
    @weakify(self);
    [JHBaseOperationView creatSQOperationView:self.postData Block:^(JHOperationType operationType) {
        @strongify(self);
        [JHBaseOperationAction operationAction:operationType operationMode:self.postData bolck:^{
            //成功
            if (self.operationAction) {
                NSNumber *type=[NSNumber numberWithInteger:operationType];
                self.operationAction(type, self.postData);
            }
        }];
    }];
}

//NSLog(@"点击分享");
- (void)handleClickShareEvent {
    JHPageFromType pageFrom = [self getPageFrom:self.pageType actionType:JHActionTypeFastOperate];
    self.postData.share_info.pageFrom = pageFrom;
    [JHBaseOperationView creatShareOperationView:self.postData.share_info object_flag:self.postData.item_id];
}

- (void)__enterPostDetailComment:(BOOL)isClickComment {
    if (self.postData.item_type == JHPostItemTypeAppraisalVideo) {
        ///鉴定视频
        //鉴定剪辑视频
        JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
        vc.cateId = self.postData.cate_id;
        vc.appraiseId = self.postData.item_id;
        vc.from = JHFromHomeCommunity;
        @weakify(self);
        vc.likeChangedBlock = ^(NSString * _Nonnull likeNum) {
            @strongify(self);
            self.postData.like_num = [likeNum integerValue];
            self.toolBar.postData = self.postData;
        };
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
    else {
        if (self.supportEnterVideo) {
            if (self.enterDetailBlock) {
                self.enterDetailBlock(self.indexPath);
            }
        }
        else {
            [JHRouterManager pushPostDetailWithItemType:self.postData.item_type itemId:self.postData.item_id pageFrom:[JHRouterManager getPageFrom:self.pageType] scrollComment:isClickComment ? 1 : 0];
        }
    }
}

@end
