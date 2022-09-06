//
//  JHSQPostNormalCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPostNormalCell.h"
#import "NSString+Emotion.h"
#import "PPStickerDataManager.h"

@interface JHSQPostNormalCell ()
{
    BOOL _hasImage;
    BOOL _hasContent;
    BOOL _hasHotComment;
    CGFloat maxTitleHeight;
}

@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *imgView; //图片
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) YYLabel *contentLabel; //内容
///355新增 -- lihui
///文章标签
@property (nonatomic, strong) UILabel *postTagLabel;
@end

@implementation JHSQPostNormalCell
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
            
            if(self.pageType == JHPageTypeUserInfoLikeTab)
            {
                [JHGrowingIO trackEventId:@"profile_like_article_enter"];
            }
            else if(self.pageType == JHPageTypeUserInfoPublishTab)
            {
                [JHGrowingIO trackEventId:@"profile_write_article_enter"];
            }
        };
    }
    
    //1
    self.userInfoView = [[JHSQUserInfoView alloc] initWithFrame:CGRectZero];
    self.userInfoView.pageFrom = [JHRouterManager getPageFrom:self.pageType];
    @weakify(self);
    self.userInfoView.clickUserInfoBlock = ^{
        @strongify(self);
        [self handleClickUserInfoEvent];
        //埋点
        [self baseAvatarAction];
    };
    self.userInfoView.clickMoreBlock = ^{
        @strongify(self);
        [self handleClickMoreEvent];
        //埋点
        [self baseMoreAction];
    };
    
    //2
    _imgView = [UIImageView new];
    _imgView.clipsToBounds = YES;
    _imgView.sd_cornerRadius = @(8);
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    _postTagLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColorFFF];
    _postTagLabel.backgroundColor = HEXCOLORA(0x333333, .5);
    _postTagLabel.text = @"文章";
    _postTagLabel.textAlignment = NSTextAlignmentCenter;
    [_imgView addSubview:_postTagLabel];
    
    //3
    _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:18] textColor:kColor333];
    _titleLabel.numberOfLines = 0;
    _titleLabel.isAttributedContent = YES;
    maxTitleHeight = _titleLabel.font.lineHeight * 2;
    
    //4
    _contentLabel = [YYLabel labelWithFont:[UIFont fontWithName:kFontNormal size:16] textColor:kColor333];
    _contentLabel.numberOfLines = 3;
    [self addSeeMoreButton];
    
    //5
    self.toolBar = [[JHSQOptionToolBar alloc] initWithFrame:CGRectZero];
    self.toolBar.pageType = self.pageType;
    self.toolBar.clickShareBlock = ^{
        @strongify(self);
        [self handleClickShareEvent];
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
    _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomLine.backgroundColor = kColorF5F6FA;
    
    [_contentControl sd_addSubviews:@[self.userInfoView, _imgView, _titleLabel, _contentLabel, self.toolBar, _hotCommentView]];
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
    
    _titleLabel.sd_layout
    .topSpaceToView(self.userInfoView, 2)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10)
    .autoHeightRatio(0);
    
    _contentLabel.sd_layout
    .topSpaceToView(_titleLabel, 10)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10)
    .heightIs(0);
    
    _imgView.sd_layout
    .topSpaceToView(_contentLabel, 10)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10)
    .heightIs(JHScaleToiPhone6(200));
    
    _postTagLabel.sd_cornerRadius = @(21./2);
    _postTagLabel.sd_layout
    .rightSpaceToView(_imgView, 15)
    .bottomSpaceToView(_imgView, 15)
    .widthIs(34).heightIs(21);
        
    self.toolBar.sd_layout
    .topSpaceToView(_imgView, 0)
    .leftSpaceToView(_contentControl, 0)
    .rightSpaceToView(_contentControl, 0)
    .heightIs([JHSQOptionToolBar toolBarHeight]);
    
    _hotCommentView.sd_layout
    .topSpaceToView(self.toolBar, 0)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10);
    
    _bottomLine.sd_layout
    .topSpaceToView(_hotCommentView, 15)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(10);
    
    [_contentControl setupAutoHeightWithBottomViewsArray:@[self.toolBar, _hotCommentView] bottomMargin:0];
    [self setupAutoHeightWithBottomViewsArray:@[_bottomLine] bottomMargin:0];
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

//标题
- (void)makeTitleLayout {
    BOOL isEssence = (self.postData.content_level == 1); //是否是精华
    
    NSString *title = @" ";
    if(IS_STRING(self.postData.title) && self.postData.title.length > 0)
    {
        title = self.postData.title;
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:title];
    if (isEssence == 1) {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"sq_icon_essence"]; //精华帖
        attach.bounds = CGRectMake(0, 0, 31, 14);
        NSAttributedString *icon = [NSAttributedString attributedStringWithAttachment:attach];
        [attri insertAttributedString:icon atIndex:0];
        [attri insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
    }
    _titleLabel.attributedText = attri.mutableCopy;
}

//帖子内容
- (void)makeContentLayout {
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyLabel:self.postData.postContentAttrText font:_contentLabel.font];
    _contentLabel.attributedText = self.postData.postContentAttrText;
    if (_hasContent) {
        _contentLabel.sd_layout.topSpaceToView(_titleLabel, 10).heightIs(self.postData.contentHeight);
    }
    else {
        _contentLabel.sd_layout.topSpaceToView(_titleLabel, 0).heightIs(0);
    }
}

//图片
- (void)makeImageLayout {
    CGFloat space = _hasImage ? 10 : 0;
    if (_hasImage) {
        NSString *urlStr = nil;
        if (self.postData.images_medium.count > 0) {
            urlStr = self.postData.images_medium.firstObject;
        }
        else {
            urlStr = self.postData.video_info.image;
        }
        if ([self hasSourcesWithUrl:urlStr]) {
            [_imgView jhSetImageWithURL:[NSURL URLWithString:urlStr] placeholder:kDefaultCoverImage];
            _imgView.sd_layout.topSpaceToView(_contentLabel, space).heightIs(200);
        }
        else {
            _imgView.sd_layout.topSpaceToView(_contentLabel, space).heightIs(0);
        }
    } else {
        _imgView.sd_layout.topSpaceToView(_contentLabel, space).heightIs(0);
    }
}

//工具栏
- (void)makeToolBarLayout {
    self.toolBar.postData = self.postData;
}

//热评
- (void)makeHotCommentLayout {
    _hotCommentView.hidden = (!_hasHotComment || self.postData.hideComment);
    if (_hasHotComment && !self.postData.hideComment) {
        _hotCommentView.postData = self.postData;
    } else {
        _hotCommentView.sd_layout.heightIs(0);
    }
}

//底部分割线
- (void)makeBottomLineLayout {
    if (_hasHotComment && !self.postData.hideComment) {
        _bottomLine.sd_layout.topSpaceToView(_hotCommentView, 15);
    } else {
        _bottomLine.sd_layout.topSpaceToView(self.toolBar, 0);
    }
}

#pragma mark - 设置数据

- (void)setPostData:(JHPostData *)postData {
    [super setPostData:postData];
    
    if (postData.images_medium.count > 0 && [self hasSourcesWithUrl:postData.images_medium.firstObject]) {
        _hasImage = YES;
    }
    else if (postData.video_info.image && [self hasSourcesWithUrl:postData.video_info.image]) {
        _hasImage = YES;
    }
    else {
        _hasImage = NO;
    }
    _hasContent = self.postData.resource_data.count > 0 ? YES : NO;
    _hasHotComment = self.postData.hot_comments.count > 0;
    
    [self makeImageLayout];
    [self makeTitleLayout];
    [self makeContentLayout];
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
    
    [JHRouterManager pushPostDetailWithItemType:self.postData.item_type itemId:self.postData.item_id pageFrom:[JHRouterManager getPageFrom:self.pageType] scrollComment:0];
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

//NSLog(@"点击点点点");
- (void)handleClickMoreEvent {
    @weakify(self);
    JHPageFromType pageFrom = [self getPageFrom:self.pageType actionType:JHActionTypeMore];
    self.postData.share_info.pageFrom = pageFrom;
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

-(BOOL)hasSourcesWithUrl:(NSString *)urlStr
{
    return (urlStr && [urlStr isKindOfClass:[NSString class]] && urlStr.length > 10);
}

@end
