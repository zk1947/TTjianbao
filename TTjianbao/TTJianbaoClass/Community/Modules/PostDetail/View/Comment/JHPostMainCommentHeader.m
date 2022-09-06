//
//  JHPostMainCommentHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostMainCommentHeader.h"
#import "JHPostDetailModel.h"
#import "JHSQModel.h"
#import "UIButton+zan.h"
#import "JHSQMedalView.h"
#import "JHSQManager.h"
#import "JHSQMedalView.h"
#import "JHLikeButton.h"
#import "PPStickerDataManager.h"
#import "YYKit.h"
#import "JHCommentHelper.h"
#import "JHPhotoBrowserManager.h"
#import "UIImage+GIF.h"
#import "UIImageView+JHWebImage.h"

@interface JHPostMainCommentHeader ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *authorIcon;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) JHLikeButton *likeButton;
@property (nonatomic, strong) JHSQMedalView *metalView;///勋章view
///355新增
///评论图片
@property (nonatomic, strong) YYAnimatedImageView *commentImageView;
///图片是长图还是gif还是普通图片的标签
@property (nonatomic, strong) UILabel *picTagLabel;
@property (nonatomic, strong) UIView *actionView;
@end

@implementation JHPostMainCommentHeader

- (void)dealloc {
    NSLog(@"%s 被释放了🔥🔥🔥🔥-----", __func__);
}

- (void)setMainComment:(JHCommentModel *)mainComment {
    if (!mainComment) {
        return;
    }
    _mainComment = mainComment;
    
    [_authorIcon jhSetImageWithURL:[NSURL URLWithString:_mainComment.publisher.avatar] placeholder:kDefaultAvatarImage];
    _authorNameLabel.text = [_mainComment.publisher.user_name isNotBlank] ? _mainComment.publisher.user_name : @"暂无昵称";
    ///判断是否是作者显示作者标签
    BOOL isAuthor = [self isAuthor];
    _tagLabel.hidden = !isAuthor;
    CGFloat tagSpace = isAuthor ? 5.f : 0;
    CGFloat tagW = isAuthor ? 26.f : 0;
    [_tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(tagW);
        make.left.equalTo(self.authorNameLabel.mas_right).offset(tagSpace);
    }];
    
    _timeLabel.text = [NSString stringWithFormat:@"%ld楼 · %@", _mainComment.floor, _mainComment.time ? : @"暂无"];
    ///图片评论布局
    [self makeCommentLayouts];
    
    _likeButton.selected = _mainComment.is_like;
    NSString * likeNum = _mainComment.like_num > 0 ? @(_mainComment.like_num).stringValue : @"赞";
    [_likeButton setTitle:likeNum forState:UIControlStateNormal];
    
    ///勋章
    NSArray *arr = _mainComment.publisher.levelIcons;
    _metalView.tagArray = arr;
}

- (void)makeCommentLayouts {
    ///主评论里面不需要查看图片的标识
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:_mainComment.contentAttri font:_commentLabel.font];
    _commentLabel.attributedText = _mainComment.contentAttri;
//
//    YYTextLayout *layout = _mainComment.textLayout;
//    _commentLabel.size = layout.textBoundingSize;
//    [_commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(layout.textBoundingSize.height);
//    }];
    
    ///评论图片
    CGFloat COMMENT_PIC_H = 0;
    CGFloat space = 0;
    if (_mainComment.hasPicture) {
        COMMENT_PIC_H = COMMENT_PIC_W;
        space = 5.f;
        @weakify(self);
        [self.commentImageView jhSetImageWithURL:[NSURL URLWithString:_mainComment.comment_images_thumb.firstObject] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
                @strongify(self);
                self.commentImageView.image = image;
                ///图片标签
                BOOL has = [_mainComment.img_type isNotBlank];
                self.picTagLabel.text = has ? _mainComment.img_type : @"";
                self.picTagLabel.hidden = !has;
            }
            else {
                self.commentImageView.image = kDefaultCoverImage;
            }
        }];
    }
    else {
        self.commentImageView.image = kDefaultCoverImage;
    }
    [_commentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLabel.mas_bottom).offset(space);
        make.height.mas_equalTo(COMMENT_PIC_H);
    }];
    
    if (_mainComment.reply_list.count > 0) {
        [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
    }
    else {
        [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
    }
}

- (void)updateLikeButtonStatus:(JHCommentModel *)comment {
    _likeButton.selected = comment.is_like;
    NSString *likeNum = comment.like_num > 0 ? @(comment.like_num).stringValue : @"赞";
    [_likeButton setTitle:likeNum forState:UIControlStateNormal];
    if (comment.is_like) {
        [_likeButton zanAnimation];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *actionView = [[UIView alloc] init];
        [self.contentView addSubview:actionView];
        self.actionView = actionView;
        actionView.userInteractionEnabled = YES;
        [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.delegate = self;
        [actionView addGestureRecognizer:singleTap];
        ///双击手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        singleTap.delegate = self;
        [actionView addGestureRecognizer:longPress];

        [self setupViews];
    }
    return self;
}

- (void)__handleLikebuttonEvent {
    if (self.actionBlock) {
       self.actionBlock(self.indexPath, self, JHPostDetailActionTypeLike);
    }
}

- (void)singleTapAction:(UITapGestureRecognizer *)gesture {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath, self, JHPostDetailActionTypeSingleTap);
    }
}

///双击点击事件
- (void)longPressAction:(UITapGestureRecognizer *)gesture {
    if (self.actionBlock) {
        self.actionBlock(self.indexPath, self, JHPostDetailActionTypeLongPress);
    }
}

- (void)enterPersonalPage {
    NSLog(@"=== enterPersonalPage ===");
    if (self.actionBlock) {
        self.actionBlock(self.indexPath, self, JHPostDetailActionTypeEnterPersonPage);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL isCanRecognize = YES; //是否能被识别
    if ([touch.view isKindOfClass:[YYLabel class]]) {
        YYLabel *label = (YYLabel *)touch.view;
        NSAttributedString *attributedString = label.attributedText;
        NSUInteger index = [label.textLayout textRangeAtPoint:[touch locationInView:label]].start.offset;
        YYTextHighlight *hl = [attributedString attribute:YYTextHighlightAttributeName atIndex:index];
        //获取当前文本上是否有点击事件
        isCanRecognize = hl ? NO : YES; //检查是否有有高亮对象
    }
    return isCanRecognize;
}
- (void)setupViews {
    ///用户头像
    _authorIcon = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _authorIcon.contentMode = UIViewContentModeScaleAspectFill;
    _authorIcon.layer.cornerRadius = 15.;
    _authorIcon.layer.masksToBounds = YES;
    _authorIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterPersonalPage)];
    [_authorIcon addGestureRecognizer:tap];

    _authorNameLabel = [[UILabel alloc] init];
    _authorNameLabel.text = @"暂无昵称";
    _authorNameLabel.font = [UIFont fontWithName:kFontMedium size:13];
    _authorNameLabel.textColor = kColor666;
    
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.text = @"作者";
    _tagLabel.layer.cornerRadius = 2.f;
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.layer.masksToBounds = YES;
    _tagLabel.backgroundColor = kColorEEE;
    _tagLabel.font = [UIFont fontWithName:kFontMedium size:10];
    _tagLabel.textColor = kColor999;
    
    if (!_metalView) {
        _metalView = [JHSQMedalView new];
    }
        
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"刚刚";
    _timeLabel.textColor = kColor999;
    _timeLabel.font = [UIFont fontWithName:kFontNormal size:11];
    
    YYLabel *label = [[YYLabel alloc] init];
    label.font = [UIFont fontWithName:kFontNormal size:15];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.displaysAsynchronously = YES;
    label.preferredMaxLayoutWidth = kScreenWidth - 125;
    _commentLabel = label;
    
    ///评论图片
    if (!_commentImageView) {
        YYAnimatedImageView *tapImageView = [[YYAnimatedImageView alloc] initWithImage:kDefaultCoverImage];
        tapImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:tapImageView];
        tapImageView.layer.cornerRadius = kCommentPicCorner;
        tapImageView.layer.masksToBounds = YES;
        tapImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *commentPicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleCommentPicTapEvent)];
        [tapImageView addGestureRecognizer:commentPicTap];
        _commentImageView = tapImageView;
    }
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = HEXCOLORA(0x333333, .5f);
    tipLabel.font = [UIFont fontWithName:kFontMedium size:11];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.layer.cornerRadius = 9.f;
    tipLabel.layer.masksToBounds = YES;
    tipLabel.textColor = kColorFFF;
    [self.commentImageView addSubview:tipLabel];
    _picTagLabel = tipLabel;
    _picTagLabel.hidden = YES;

    _likeButton = [JHLikeButton buttonWithType:UIButtonTypeCustom];
    [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(__handleLikebuttonEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.actionView addSubview:_authorIcon];
    [self.actionView addSubview:_authorNameLabel];
    [self.actionView addSubview:_tagLabel];
    [self.actionView addSubview:_metalView];
    [self.actionView addSubview:_timeLabel];
    [self.actionView addSubview:_commentLabel];
    [self.actionView addSubview:_likeButton];

    [self makeLayouts];
}

- (void)__handleCommentPicTapEvent {
    [JHGrowingIO trackEventId:@"comment_list_pic_click"];
    NSLog(@"handleCommentPicTapEvent");
    if (_mainComment.comment_images_thumb.count > 0) {
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[_mainComment.comment_images_thumb.firstObject] mediumImages:@[_mainComment.comment_images_medium.firstObject] origImages:@[_mainComment.comment_images.firstObject] sources:@[_commentImageView] currentIndex:0 canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
    }
}

- (void)makeLayouts {
    [_authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.leading.equalTo(self.contentView).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorIcon);
        make.left.equalTo(self.authorIcon.mas_right).offset(10);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.authorNameLabel);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.authorIcon);
        make.size.mas_equalTo(CGSizeMake(30, 32));
    }];
    
    [_metalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel.mas_right).offset(5);
        make.centerY.equalTo(self.authorNameLabel);
        make.right.equalTo(self.likeButton.mas_left).offset(-10);
        make.height.mas_equalTo(15);
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel);
        make.top.equalTo(self.authorNameLabel.mas_bottom).offset(5);
        make.right.equalTo(self.likeButton.mas_left).offset(-20);
//        make.height.mas_equalTo(0);
    }];
    
    [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLabel);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(COMMENT_PIC_W);
        make.height.mas_equalTo(0);
    }];
    
    [_picTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.commentImageView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(32, 18));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.commentLabel);
        make.top.equalTo(self.commentImageView.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [_likeButton layoutIfNeeded];
    [_likeButton refresh_upImv_downTitle_space:2];
}

- (BOOL)isAuthor {
    return [_mainComment.publisher.user_id isEqualToString:self.postAuthorId];
}

@end
