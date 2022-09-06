//
//  JHSubCommentTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSubCommentTableCell.h"
#import "JHPostDetailModel.h"
#import "UIImageView+JHWebImage.h"
#import <UIImageView+WebCache.h>
#import "JHSQModel.h"
#import "UIButton+zan.h"
#import "UIView+CornerRadius.h"
#import "JHSQMedalView.h"
#import "JHLikeButton.h"
#import "PPStickerDataManager.h"
#import "YYKit.h"
#import "JHCommentHelper.h"
#import "JHPhotoBrowserManager.h"
#import "PPStickerDataManager.h"

#define kCellCorner     8.f
#define COMMENT_PIC_W   (98.f)
#define PIC_W_MIN       (300.f)

@interface JHSubCommentTableCell ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView        *bgView;
@property (nonatomic, strong) UIImageView   *authorIcon;
@property (nonatomic, strong) UILabel       *authorNameLabel;
@property (nonatomic, strong) UILabel       *tagLabel;
@property (nonatomic, strong) YYLabel       *commentLabel;
@property (nonatomic, strong) UILabel       *bottomTimeLabel;
@property (nonatomic, strong) JHLikeButton  *likeButton;
@property (nonatomic, strong) JHSQMedalView *metalView;///勋章view
///355新增
///评论图片
@property (nonatomic, strong) YYAnimatedImageView *commentImageView;
///图片是长图还是gif还是普通图片的标签
@property (nonatomic, strong) UILabel *picTagLabel;
@property (nonatomic, strong) UIView *actionView;
@end

@implementation JHSubCommentTableCell

- (void)dealloc {
    NSLog(@"%s 被释放了🔥🔥🔥🔥-----", __func__);
}

- (void)setCommentModel:(JHCommentModel *)commentModel {
    if (!commentModel) {
        return;
    }
    _commentModel = commentModel;
    
    [_authorIcon jhSetImageWithURL:[NSURL URLWithString:_commentModel.publisher.avatar] placeholder:kDefaultAvatarImage];
    _authorNameLabel.text = [_commentModel.publisher.user_name isNotBlank] ? _commentModel.publisher.user_name :@"暂无昵称";
    ///判断是否是作者显示作者标签
    BOOL isAuthor = [self isAuthor];
    _tagLabel.hidden = !isAuthor;
    CGFloat tagSpace = isAuthor ? 5.f : 0;
    CGFloat tagW = isAuthor ? 26.f : 0;
    [_tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(tagW);
        make.left.equalTo(self.authorNameLabel.mas_right).offset(tagSpace);
    }];
    _bottomTimeLabel.text = _commentModel.time ? : @"暂无";
    
    ///评论内容部分
    [self makeCommentLayouts];

    _likeButton.selected = _commentModel.is_like;
    NSString * likeNum = _commentModel.like_num > 0 ? @(_commentModel.like_num).stringValue : @"赞";
    [_likeButton setTitle:likeNum forState:UIControlStateNormal];
    
    ///勋章
    NSArray *arr = _commentModel.publisher.levelIcons;
    _metalView.tagArray = arr;
}

///评论内容部分
- (void)makeCommentLayouts {
    _commentLabel.attributedText = _commentModel.commentAttrString;
    ///评论图片
    CGFloat COMMENT_PIC_H = 0;
    CGFloat space = 0;
    if (_commentModel.hasPicture) {
        COMMENT_PIC_H = COMMENT_PIC_W;
        space = 5.f;
        @weakify(self);
        [self.commentImageView jhSetImageWithURL:[NSURL URLWithString:_commentModel.comment_images_thumb.firstObject] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
                @strongify(self);
                self.commentImageView.image = image;
                ///图片标签
                BOOL has = [_commentModel.img_type isNotBlank];
                self.picTagLabel.text = has ? _commentModel.img_type : @"";
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
}

- (void)updateLikeButtonStatus:(JHCommentModel *)comment {
    _likeButton.selected = comment.is_like;
    NSString *likeNum = comment.like_num > 0 ? @(comment.like_num).stringValue : @"赞";
    [_likeButton setTitle:likeNum forState:UIControlStateNormal];
    if (comment.is_like) {
        [_likeButton zanAnimation];
    }
}

- (void)enterPersonalPage {
    NSLog(@"=== enterPersonalPage ===");
    if (self.actionBlock) {
        self.actionBlock(self.indexPath, self, JHPostDetailActionTypeEnterPersonPage);
    }
}

- (void)__handleCommentPicTapEvent {
    NSLog(@"handleCommentPicTapEvent");
    if (_commentModel.comment_images_thumb.count > 0) {
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[_commentModel.comment_images_thumb.firstObject]
                                                origImages:@[_commentModel.comment_images.firstObject]
                                                   sources:@[_commentImageView]
                                              currentIndex:0
                                       canPreviewOrigImage:YES
                                                 showStyle:GKPhotoBrowserShowStyleZoom];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = HEXCOLOR(0xF9FAF9);
    _bgView = bgView;
    
    UIView *actionView = [[UIView alloc] init];
    [bgView addSubview:actionView];
    self.actionView = actionView;
    actionView.userInteractionEnabled = YES;
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    singleTap.delegate = self;
    [actionView addGestureRecognizer:singleTap];
    ///双击手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.delegate = self;
    [actionView addGestureRecognizer:longPress];
    
    ///用户头像
    _authorIcon = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _authorIcon.contentMode = UIViewContentModeScaleAspectFill;
    _authorIcon.layer.cornerRadius = 10.;
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
    _tagLabel.layer.masksToBounds = YES;
    _tagLabel.backgroundColor = kColorEEE;
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.font = [UIFont fontWithName:kFontMedium size:10];
    _tagLabel.textColor = kColor999;
    _tagLabel.hidden = YES;
    
    if (!_metalView) {
        _metalView = [JHSQMedalView new];
    }
            
    UILabel *bottomTime = [[UILabel alloc] init];
    bottomTime.text = @"刚刚";
    bottomTime.textColor = kColor999;
    bottomTime.font = [UIFont fontWithName:kFontNormal size:11];
    _bottomTimeLabel = bottomTime;
    
    YYLabel *label = [[YYLabel alloc] init];
    label.font = [UIFont fontWithName:kFontNormal size:15];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.displaysAsynchronously = YES;
    label.preferredMaxLayoutWidth = kScreenWidth - 70 - 40 - 50;
    _commentLabel = label;
    
    ///评论图片
    YYAnimatedImageView *tapImageView = [[YYAnimatedImageView alloc] initWithImage:kDefaultCoverImage];
    tapImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.actionView addSubview:tapImageView];
    tapImageView.layer.cornerRadius = 8.f;
    tapImageView.layer.masksToBounds = YES;
    _commentImageView = tapImageView;
    tapImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *commentPicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleCommentPicTapEvent)];
    [tapImageView addGestureRecognizer:commentPicTap];
    
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
    
    [self.contentView addSubview:bgView];
    [self.actionView addSubview:_authorIcon];
    [self.actionView addSubview:_authorNameLabel];
    [self.actionView addSubview:_tagLabel];
    [self.actionView addSubview:_metalView];
    [self.actionView addSubview:_bottomTimeLabel];
    [self.actionView addSubview:_commentLabel];
    [self.actionView addSubview:_likeButton];

    [self makeLayouts];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (indexPath.row == 1) {
        ///第一行的cell需要切上圆角
        [_bgView yd_setCornerRadius:kCellCorner corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    }
}

- (void)makeLayouts {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 55, 0, 15));
    }];
        
    [_authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorIcon);
        make.left.equalTo(self.authorIcon.mas_right).offset(10);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorNameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.authorNameLabel);
        make.size.mas_equalTo(CGSizeMake(26, 14));
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-5);
        make.top.equalTo(self.authorIcon);
        make.size.mas_equalTo(CGSizeMake(25, 32));
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
        make.top.equalTo(self.commentLabel.mas_bottom);
        make.width.mas_equalTo(COMMENT_PIC_W);
        make.height.mas_equalTo(0);
    }];
    
    [_picTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.commentImageView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(32, 18));
    }];
    
    [_bottomTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentImageView);
        make.top.equalTo(self.commentImageView.mas_bottom).offset(5);
        make.right.equalTo(self.commentImageView);
        make.bottom.equalTo(self.bgView).offset(-10);
    }];
    
    [_likeButton layoutIfNeeded];
    [_likeButton refresh_upImv_downTitle_space:2];
    
    _bottomTimeLabel.hidden = NO;
}

#pragma mark -
#pragma mark - action event
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

- (BOOL)isAuthor {
    return [_commentModel.publisher.user_id isEqualToString:self.postAuthorId];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
