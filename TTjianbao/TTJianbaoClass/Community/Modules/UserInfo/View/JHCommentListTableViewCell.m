//
//  JHCommentListTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommentListTableViewCell.h"
#import "TTjianbao.h"
#import "JHUserInfoCommentModel.h"
#import "JHSQApiManager.h"
#import "JHCommentHelper.h"
#import "JHUserInfoApiManager.h"
#import "JHPhotoBrowserManager.h"
#import "PPStickerDataManager.h"

@interface JHCommentListTableViewCell ()

@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) YYLabel *descLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIView *seperatorView;
///别人的评论区域
@property (nonatomic, strong) YYLabel *otherCommentLabel;

///当评论或者帖子被删除时 删除按钮
@property (nonatomic, strong) UIButton *deleteButton;
///显示删除文案的label
@property (nonatomic, strong) UILabel *deleteLabel;
///评论图片 支持gif
@property (nonatomic, strong)  YYAnimatedImageView *commentImageView;
///图片是长图还是gif还是普通图片的标签
@property (nonatomic, strong) UILabel *picTagLabel;

@end

@implementation JHCommentListTableViewCell

- (void)dealloc {
    NSLog(@" ---- JHCommentListTableViewCell  --- ");
}

- (void)makeCommentLayouts {
    NSAttributedString *comment = (_commentModel.comment.replyCommentAttrString != nil)
    ? _commentModel.comment.replyCommentAttrString.copy
    : [[NSAttributedString alloc] initWithString:@"评论已被删除"];
    _otherCommentLabel.attributedText = comment;
    
    YYTextLayout *layout = _commentModel.comment.textLayout;
//    _otherCommentLabel.textLayout = layout;
    _otherCommentLabel.size = layout.textBoundingSize;

    [_otherCommentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailView).offset(_commentModel.mainInfo.parent_id > 0 ? 10 : 0);
        make.left.equalTo(self.detailView).offset(10);
        make.right.equalTo(self.detailView).offset(-10);
        make.bottom.equalTo(self.iconImageView.mas_top).offset(-10);
        make.height.mas_equalTo(layout.textBoundingSize.height);
    }];
    
    ///有图 需要响应查看图片的点击事件
    if (_commentModel.comment.hasPicture) {
        @weakify(self);
        _commentModel.comment.seePicBlock = ^{
            @strongify(self);
            NSLog(@"::::查看图片::::");
            [self seePostCommentPic];
        };
    }
}

- (void)makePostInfoLayouts {
    BOOL isShow = (_commentModel.postData.show_status == JHPostDataShowStatusNormal);
    if (isShow) {
        ///帖子部分正常
        _deleteLabel.hidden = YES;
        NSString *thumbImage = (_commentModel.postData.images_thumb.count > 0) ? [_commentModel.postData.images_thumb firstObject] : _commentModel.postData.publisher.avatar;
        [_iconImageView jhSetImageWithURL:[NSURL URLWithString:thumbImage] placeholder:kDefaultCoverImage];
        _authorLabel.text = [NSString stringWithFormat:@"@%@", _commentModel.postData.publisher.user_name?:@"暂无昵称"];
        
//        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:_commentModel.postData.content];
//        [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:string font:_descLabel.font];
//        _descLabel.attributedText = string;
        NSMutableAttributedString * string =  [[NSMutableAttributedString alloc] initWithString:@""];
        if([_commentModel.postData.title length] > 0) {
            string = [[NSMutableAttributedString alloc] initWithString:_commentModel.postData.title];
            [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:string font:_descLabel.font];
            _descLabel.attributedText = string;
        }else {
            NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:@""];
            if (_commentModel.postData.resource_data.count > 0 || _commentModel.postData.content.length > 0) {
                contentString = _commentModel.postData.contentAttributedString;
            }
            _descLabel.attributedText = contentString;
        }
        
        [_detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.timeLabel.mas_top).offset(-15);
            make.left.right.equalTo(self.commentLabel);
        }];
        [_deleteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.detailView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    else {
        _deleteLabel.hidden = NO;
        _deleteLabel.backgroundColor = _commentModel.comment ? kColorFFF : [UIColor clearColor];
        UIView *v = [self isAuthor] ? self.deleteButton : self.timeLabel;
        [_detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(v.mas_top).offset(-15);
            make.left.right.equalTo(self.commentLabel);
        }];
        
        [_deleteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailView).offset(10);
            make.right.bottom.equalTo(self.detailView).offset(-10);
            make.height.mas_equalTo(44);
        }];
    }
    ///帖子相关
    _iconImageView.hidden = !isShow;
    _authorLabel.hidden = !isShow;
    _descLabel.hidden = !isShow;
}

- (void)makeBottomInfoLayouts {
    ///对回复的评论被删除
    BOOL subReplyDeleted = (_commentModel.postData.show_status == JHPostDataShowStatusDelete ||
                            _commentModel.comment.show_status == JHPostDataShowStatusDelete);
    if ([self isAuthor] && subReplyDeleted) {
        _deleteButton.hidden = NO;
        _likeButton.hidden = YES;
        _timeLabel.hidden = YES;
        UIView *v = [self isAuthor] ? self.deleteButton : self.timeLabel;
        [_detailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(v.mas_top).offset(-15);
        }];
    }
    else {
        _deleteButton.hidden = YES;
        _likeButton.hidden = NO;
        _timeLabel.hidden = NO;
        [_detailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.timeLabel.mas_top).offset(-15);
        }];
    }
}

- (void)makeCommentPicLayouts {
    ///图片评论部分
    CGFloat COMMENT_PIC_H = 0;
    CGFloat space = 0;
    if (_commentModel.mainInfo.hasPicture) {
        COMMENT_PIC_H = COMMENT_PIC_W;
        space = 10.f;
        @weakify(self);
        [self.commentImageView jhSetImageWithURL:[NSURL URLWithString:_commentModel.mainInfo.comment_images_thumb.firstObject] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
                @strongify(self);
                self.commentImageView.image = image;
                BOOL has = [_commentModel.mainInfo.img_type isNotBlank];
                self.picTagLabel.text = has ? _commentModel.mainInfo.img_type : @"";
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
    
    _commentImageView.hidden = !_commentModel.mainInfo.hasPicture;
    [_commentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.detailView.mas_top).offset(-space);
        make.height.mas_equalTo(COMMENT_PIC_H);
    }];
}

- (void)setCommentModel:(JHUserInfoCommentModel *)commentModel {
    if (!commentModel) {
        return;
    }
    _commentModel = commentModel;
    ///回复的评论
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:_commentModel.mainInfo.content];
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:string font:_commentLabel.font];
    _commentLabel.attributedText = _commentModel.mainInfo.commentAttrString;
    
    ///计算文字高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 30), MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:_commentModel.mainInfo.commentAttrString];
    [_commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textLayout.textBoundingSize.height);
    }];
                                
    _timeLabel.text = _commentModel.mainInfo.time;

    if (_commentModel.comment == nil && _commentModel.postData == nil) {
        ///无文章评论 无帖子
        _iconImageView.hidden = YES;
        _authorLabel.hidden = YES;
        _descLabel.hidden = YES;
        _deleteLabel.hidden = NO;
        
        UIView *v = [self isAuthor] ? self.deleteButton : self.timeLabel;
        [_detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(v.mas_top).offset(-15);
            make.left.right.equalTo(self.commentLabel);
            make.height.mas_equalTo(64);
        }];
    }
    else {
        ///图片评论
        [self makeCommentPicLayouts];
        ///原贴信息部分布局
        [self makePostInfoLayouts];
        ///底部时间删除按钮点赞信息部分
        [self makeBottomInfoLayouts];
        ///帖子信息展示上面的评论部分 --- 因为布局的关系必须放在最后！！！TODO:lihui
        [self makeCommentLayouts];
    }
}

- (BOOL)isAuthor {
    if ([_commentModel.mainInfo.publisher.user_id isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
        return YES;
    }
    return NO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)__handleDeleteEvent {
    if (self.deleteBlock) {
        self.deleteBlock(self.indexPath.row);
    }
}

///main评论查看图片的方法
- (void)seeCommentPicture {
    [self seeCommentPicture:YES];
}

- (void)seePostCommentPic {
    [self seeCommentPicture:NO];
}

- (void)seeCommentPicture:(BOOL)isMain {
    ///如果是评论 对文章的评论
    if (isMain) {
        JHCommentModel *info = _commentModel.mainInfo;
        if (!info.hasPicture) {
            return;
        }
        NSRange range = NSMakeRange(0, 1);
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:[info.comment_images_thumb subarrayWithRange:range]
                                                origImages:[info.comment_images subarrayWithRange:range]
                                                   sources:@[_commentImageView]
                                              currentIndex:0
                                       canPreviewOrigImage:YES
                                                 showStyle:GKPhotoBrowserShowStyleZoom];
    }
    else if (_commentModel.comment.hasPicture) {
        JHCommentModel *info = _commentModel.comment;
        NSRange range = NSMakeRange(0, 1);
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:[info.comment_images_thumb subarrayWithRange:range]
                                                origImages:[info.comment_images subarrayWithRange:range]
                                                   sources:@[[UIImageView new]]
                                              currentIndex:0
                                       canPreviewOrigImage:YES
                                                 showStyle:GKPhotoBrowserShowStyleNone];
    }
}

- (void)setUpViews {
    _commentLabel = [[YYLabel alloc] init];
    _commentLabel.text = @"";
    _commentLabel.font = [UIFont fontWithName:kFontNormal size:16.f];
    _commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _commentLabel.numberOfLines = 0;
    [self.contentView addSubview:_commentLabel];
    
    _commentImageView = [[YYAnimatedImageView alloc] initWithImage:kDefaultCoverImage];
    _commentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _commentImageView.layer.cornerRadius = kCommentPicCorner;
    _commentImageView.layer.masksToBounds = YES;
    _commentImageView.hidden = YES;
    [self.contentView addSubview:_commentImageView];
    _commentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeCommentPicture)];
    [_commentImageView addGestureRecognizer:imgTap];
    
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

    _detailView = [[UIView alloc] init];
    _detailView.backgroundColor = HEXCOLOR(0xF9F9F9);
    _detailView.layer.cornerRadius = 8.f;
    _detailView.layer.masksToBounds = YES;
    [self.contentView addSubview:_detailView];
    
    UILabel *deleteLabel = [[UILabel alloc] init];
    deleteLabel.backgroundColor = HEXCOLOR(0xF9F9F9);
    deleteLabel.text = @"帖子已被删除";
    deleteLabel.font = [UIFont fontWithName:kFontNormal size:15];
    deleteLabel.textColor = kColor999;
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    deleteLabel.layer.cornerRadius = 8.f;
    deleteLabel.layer.masksToBounds = YES;
    [_detailView addSubview:deleteLabel];
    _deleteLabel = deleteLabel;
    _deleteLabel.hidden = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:kColor666 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
    [btn addTarget:self action:@selector(__handleDeleteEvent) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton = btn;
    _deleteButton.hidden = YES;
    [self.contentView addSubview:btn];

    _otherCommentLabel = [[YYLabel alloc] init];
    _otherCommentLabel.text = @"";
    _otherCommentLabel.font = [UIFont fontWithName:kFontNormal size:15];
    _otherCommentLabel.textColor = HEXCOLOR(0x999999);
    _otherCommentLabel.numberOfLines = 2;
    _otherCommentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_detailView addSubview:_otherCommentLabel];
    
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_detailView addSubview:_iconImageView];
    _iconImageView.layer.cornerRadius = 8.f;
    _iconImageView.layer.masksToBounds = YES;
    
    _authorLabel = [[UILabel alloc] init];
    _authorLabel.text = @"";
    _authorLabel.textColor = kColor666;
    _authorLabel.font = [UIFont fontWithName:kFontNormal size:15];
    [_detailView addSubview:_authorLabel];

    _descLabel = [[YYLabel alloc] init];
    _descLabel.text = @"";
    _descLabel.textColor = kColor999;
    _descLabel.font = [UIFont fontWithName:kFontNormal size:15];
    [_detailView addSubview:_descLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"刚刚";
    _timeLabel.textColor = kColor999;
    _timeLabel.font = [UIFont fontWithName:kFontNormal size:11];
    [self.contentView addSubview:_timeLabel];
    
    _likeButton = [UIButton buttonWithTitle:@"点赞" titleColor:kColor333];
    _likeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [_likeButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_selected"] forState:UIControlStateSelected];
    _likeButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _likeButton.adjustsImageWhenHighlighted = NO;
    [_likeButton setImageInsetStyle:MRImageInsetStyleLeft spacing:3];
    [self.contentView addSubview:_likeButton];
    @weakify(self);
    [[_likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {}];
        } else {
            if (self.commentModel.mainInfo.is_like) {
                [self _handleUnLikeEvent];
            } else {
                [self _handleLikeEvent];
            }
        }
    }];

    _seperatorView = [[UIView alloc] init];
    _seperatorView.backgroundColor = kColorF5F6FA;
    [self.contentView addSubview:_seperatorView];
    
    [self makeLayouts];
}

- (void)makeLayouts {
    [_seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.timeLabel);
        make.width.mas_equalTo(68);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.seperatorView.mas_top).offset(-15);
        make.right.equalTo(self.likeButton.mas_left).offset(-10).offset(225);
    }];
        
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-15);
        make.left.right.equalTo(self.commentLabel);
    }];
    
    [_deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.detailView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.bottom.equalTo(self.seperatorView.mas_top).offset(-15);
        make.centerX.equalTo(self.contentView);
    }];
        
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailView).offset(10);
        make.bottom.equalTo(self.detailView).offset(-10);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.detailView).offset(-10);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView);
        make.left.equalTo(self.authorLabel);
        make.right.equalTo(self.detailView).offset(-10);
        make.height.mas_equalTo(21);
    }];
    
    [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailView);
        make.bottom.equalTo(self.detailView.mas_top).offset(-10);
        make.width.mas_equalTo(COMMENT_PIC_W);
        make.height.mas_equalTo(0);
    }];
    
    [_picTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.commentImageView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(32, 18));
    }];
    
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.commentImageView.mas_top).offset(-5);
    }];
    
    [_otherCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.detailView).offset(10);
        make.right.equalTo(self.detailView).offset(-10);
        make.bottom.equalTo(self.iconImageView.mas_top).offset(-10);
        make.height.mas_equalTo(0);
    }];
}

#pragma mark -
#pragma mark - 事件处理

//点赞
- (void)_handleLikeEvent {
    @weakify(self);
    NSInteger itemType = _commentModel.comment ? 4 : 3;
    [JHUserInfoApiManager sendCommentLikeRequest:itemType itemId:_commentModel.mainInfo.comment_id likeNum:_commentModel.mainInfo.like_num block:^(RequestModel  *_Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
        self.commentModel.mainInfo.like_num = [respObj.data[@"like_num_int"] integerValue];
        self.commentModel.mainInfo.is_like = YES;
        [self updateLikeButtonValue];
        }
        else {
            [UITipView showTipStr:@"点赞失败"];
        }
    }];
}

//取消点赞
- (void)_handleUnLikeEvent {
    @weakify(self);
    NSInteger itemType = _commentModel.comment ? 4 : 3;
    [JHUserInfoApiManager sendCommentUnLikeRequest:itemType itemId:_commentModel.mainInfo.comment_id likeNum:_commentModel.mainInfo.like_num block:^(RequestModel *_Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            self.commentModel.mainInfo.like_num = [respObj.data[@"like_num_int"] integerValue];
            self.commentModel.mainInfo.is_like = NO;
            [self updateLikeButtonValue];
        }
        else {
            [UITipView showTipStr:@"取消点赞失败"];
        }
    }];
}

///更新按钮的状态
- (void)updateLikeButtonValue {
    _likeButton.selected = (self.commentModel.mainInfo.is_like && self.commentModel.mainInfo.like_num > 0);
    NSString *numStr = [CommHelp convertNumToWUnitString:self.commentModel.mainInfo.like_num existDecimal:NO];
    [_likeButton setTitle:self.commentModel.mainInfo.like_num > 0 ? numStr : @"点赞" forState:UIControlStateNormal];
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
