//
//  JHSQPostDynamicCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIView+Toast.h"
#import "JHSQPostDynamicCell.h"
#import "JHSQPhotoView.h"
#import "JHQuickCommentBar.h"

//以下是评论需要的头文件
#import "UMengManager.h"

#import "JHPhotoBrowserManager.h"


@interface JHSQPostDynamicCell ()
{
    BOOL _hasImage;
    BOOL _hasContent;
    BOOL _hasHotComment;
}

@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) YYLabel *contentLabel; //内容
@property (nonatomic, strong) JHSQPhotoView *photoView; //图片组
@property (nonatomic, strong) JHQuickCommentBar *commentBar; //点击评论panel

@end

@implementation JHSQPostDynamicCell

@synthesize hotCommentView = _hotCommentView;
@synthesize bottomLine = _bottomLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_contentControl) {
        _contentControl = [YYControl new];
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
    _photoView = [[JHSQPhotoView alloc] initWithFrame:CGRectZero];
    _photoView.clickPhotoBlock = ^(NSArray *sourceViews, NSInteger index) {
        @strongify(self);
        //浏览图片
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.postData.images_thumb mediumImages:self.postData.images_medium origImages:self.postData.images_origin sources:sourceViews currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
                
        [JHNotificationCenter postNotificationName:UIKeyboardWillHideNotification object:nil];
        
        [self baseDynamicPhotoAction];
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
        [JHRouterManager pushPostDetailWithItemType:self.postData.item_type itemId:self.postData.item_id pageFrom:[JHRouterManager getPageFrom:self.pageType] scrollComment:1];
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
    
    //6
    _hotCommentView = [JHSQHotCommentView new];
    
    //7
    _commentBar = [JHQuickCommentBar new];
    _commentBar.didClickBlock = ^{
        @strongify(self);
        ///340埋点 - 列表快速评论
        [JHGrowingIO trackEventId:JHTrackSQCommentSuccess variables:@{@"type" : @"评论",
                                                                      @"method" : @"快速评论"
        }];

        [self _handleClickInputEvent];
    };
    
    //8
    _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLine.backgroundColor = kColorF5F6FA;
    
    [_contentControl sd_addSubviews:@[self.userInfoView, _contentLabel, _photoView, self.toolBar, _hotCommentView, _commentBar]];
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
    
    _photoView.sd_layout
    .topSpaceToView(_contentLabel, 10)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightIs([JHSQPhotoView viewHeight]);
    
    self.toolBar.sd_layout
    .topSpaceToView(_photoView, 0)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightIs([JHSQOptionToolBar toolBarHeight]);
    
    _hotCommentView.sd_layout
    .topSpaceToView(self.toolBar, 0)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10);
    
    _commentBar.sd_layout
    .topSpaceToView(_hotCommentView, 0)
    .leftSpaceToView(_contentControl, 0)
    .rightSpaceToView(_contentControl, 0)
    .heightIs([JHQuickCommentBar viewHeight]);
    
    _bottomLine.sd_layout
    .topSpaceToView(_commentBar, 0)
    .leftSpaceToView(self.contentView, 0)
    .widthIs(kScreenWidth)
    .heightIs(10);
    
    [_contentControl setupAutoHeightWithBottomViewsArray:@[_commentBar] bottomMargin:0];
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
        //埋点
        [self baseFullTextAction];
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
    
    _contentLabel.attributedText = self.postData.postContentAttrText;
    _contentLabel.sd_layout.heightIs(self.postData.contentHeight);
}

//图片组视图布局
- (void)makePhotoLayout {
    _photoView.images = self.postData.images_thumb;
    if (_hasImage) {
        _photoView.sd_layout
        .topSpaceToView(_contentLabel, 10).heightIs([JHSQPhotoView viewHeight]);
    } else {
        _photoView.sd_layout.topSpaceToView(_contentLabel, 0).heightIs(0);
    }
}

//工具栏布局
- (void)makeToolBarLayout {
    self.toolBar.postData = self.postData;
    self.toolBar.sd_layout.topSpaceToView(_hasImage ? _photoView : _contentLabel, 0);
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

//快捷评论栏布局
- (void)makeQuickCommentBarLayout {
    if (self.postData.hideComment) {
        _commentBar.hidden = YES;
        _commentBar.sd_layout.topSpaceToView(self.toolBar, 0).heightIs(0);

    } else {
        _commentBar.hidden = NO;
        [_commentBar updateAvatarIcon];

        if (_hasHotComment) {
            _commentBar.sd_layout.topSpaceToView(_hotCommentView, 0);
        } else {
            _commentBar.sd_layout.topSpaceToView(self.toolBar, 0);
        }
    }
}

//底部分割线布局
- (void)makeBottomLineLayout {
    _bottomLine.sd_layout.topSpaceToView(_commentBar, 0);
}

#pragma mark - 设置数据

- (void)setPostData:(JHPostData *)postData {
    [super setPostData:postData];
    _hasImage = self.postData.images_thumb.count > 0;
    _hasContent = [self.postData.content isNotBlank];
    _hasHotComment = self.postData.hot_comments.count > 0;
    
    [self makeContentLayout];
    [self makePhotoLayout];
    [self makeToolBarLayout];
    [self makeHotCommentLayout];
    [self makeQuickCommentBarLayout];
    [self makeBottomLineLayout];
    
    [self setupAutoHeightWithBottomView:self.bottomLine bottomMargin:0];
}


#pragma mark -
#pragma mark - 事件处理
//点击帖子区域
- (void)handleClickEvent {
    [JHRouterManager pushPostDetailWithItemType:self.postData.item_type itemId:self.postData.item_id pageFrom:[JHRouterManager getPageFrom:self.pageType] scrollComment:0];
    [self baseEnterDetailAction];
}

/// 点击用户信息
- (void)handleClickUserInfoEvent {
    
    if(self.postData.recommend_type != 3){
        [JHSQManager enterUserInfoVCWithPublisher:self.postData.publisher];
    }
    else{
        [JHRouterManager pushPlateDetailWithPlateId:self.postData.plate_info.ID pageType:self.pageType];
    }
}

- (void)handleClickMoreEvent {
    NSLog(@"点击更多选项<点点点>");
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

- (void)handleClickShareEvent {
    if (self.postData.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }
    
    NSLog(@"点击分享");
    JHPageFromType pageFrom = [self getPageFrom:self.pageType actionType:JHActionTypeFastOperate];
    self.postData.share_info.pageFrom = pageFrom;
    [JHBaseOperationView creatShareOperationView:self.postData.share_info object_flag:self.postData.item_id];
}

- (void)_handleClickInputEvent {
    if (self.postData.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }

    NSLog(@"点击快捷评论栏");
    if ([JHSQManager needLogin]) {
        return;
    }
    
    if (self.inputBarClickedBlock) {
        self.inputBarClickedBlock(self.indexPath, self.postData);
    }

    //埋点
    [self baseQuickCommentAction];
}

@end
