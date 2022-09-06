//
//  JHMessageLikesTableViewCell.m
//  TTjianbao
//
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageLikesTableViewCell.h"
#import "JHPreTitleLabel.h"
#import "UIImageView+JHWebImage.h"
#import "UIImageView+WebCache.h"
#import "TTjianbaoMarcoUI.h"
#import "JHSQMedalView.h"
#import "YYKit.h"
#import "JHCommentHelper.h"
#import "JHPhotoBrowserManager.h"
#import "PPStickerDataManager.h"

@interface JHMessageLikesTableViewCell ()

@property (strong, nonatomic)  UIImageView* replyImg; //回复者头像
@property (strong, nonatomic)  UIImageView* writerImg; //作者的帖子图片
@property (strong, nonatomic)  JHSQMedalView* metalView; //勋章标识 or level icon
@property (strong, nonatomic)  UILabel* replyName; //回复者
@property (strong, nonatomic)  UILabel* replyTime; //回复时间
@property (strong, nonatomic)  YYLabel* content; //点赞或评论内容
@property (strong, nonatomic)  YYLabel* replyWriterText; //回复作者信息<一行>
@property (strong, nonatomic)  UILabel* writer; //作者
@property (strong, nonatomic)  YYLabel* writeText; //作者的帖子内容<一行>
///评论图片 支持gif
@property (nonatomic, strong)  YYAnimatedImageView *commentImageView;
///图片是长图还是gif还是普通图片的标签
@property (nonatomic, strong) UILabel *picTagLabel;

@property (nonatomic, strong) JHMsgSubListLikeCommentModel *commentModel;


@end

@implementation JHMessageLikesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self drawHeadview]; //上部view
        [self drawInnerview]; //内部view
    }
    
    return self;
}

- (void)drawHeadview {
    //回复者头像 背景
    UIImageView* replyBgImg = [[UIImageView alloc]init];
    [replyBgImg setImage:[UIImage imageNamed:@"icon_live_default_avatar"]];
    replyBgImg.userInteractionEnabled = YES;
    [self.backgroundsView addSubview:replyBgImg];
    [replyBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundsView).offset(15);
        make.left.equalTo(self.backgroundsView).offset(10);
        make.size.mas_equalTo(38);
    }];

    //回复者头像
    _replyImg = [[UIImageView alloc]init];
    _replyImg.layer.masksToBounds = YES;
    _replyImg.layer.cornerRadius = 17;
    _replyImg.userInteractionEnabled = YES;
    [self.backgroundsView addSubview:_replyImg];
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapAction:)];
    [_replyImg addGestureRecognizer:imgTap];
    
    
    //回复者 名字
    _replyName = [[UILabel alloc]init];
    _replyName.font = JHMediumFont(13);
    _replyName.textColor = HEXCOLOR(0x333333);
    _replyName.numberOfLines = 1;
    _replyName.textAlignment = NSTextAlignmentLeft;
    _replyName.lineBreakMode = NSLineBreakByTruncatingTail;
    _replyName.userInteractionEnabled = YES;
    [self.backgroundsView addSubview:_replyName];
    UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapAction:)];
    [_replyName addGestureRecognizer:labTap];
    
    ///勋章标识view
    _metalView = [[JHSQMedalView alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
    _metalView.backgroundColor = HEXCOLOR(0xFFFF00);
    [self.backgroundsView addSubview:_metalView];
    
    //回复时间
    _replyTime = [[UILabel alloc]init];
    _replyTime.font = JHFont(11);
    _replyTime.textColor = HEXCOLOR(0x999999);
    _replyTime.numberOfLines = 1;
    _replyTime.textAlignment = NSTextAlignmentLeft;
    _replyTime.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.backgroundsView addSubview:_replyTime];

    //点赞或评论内容
    _content = [[YYLabel alloc] init];
    _content.displaysAsynchronously = YES; /// enable async display
    _content.numberOfLines = 0;
    [self.backgroundsView addSubview:_content];
    
    _commentImageView = [[YYAnimatedImageView alloc] initWithImage:kDefaultCoverImage];
    _commentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _commentImageView.layer.cornerRadius = 8.f;
    _commentImageView.layer.masksToBounds = YES;
    _commentImageView.hidden = YES;
    [self.backgroundsView addSubview:_commentImageView];
    _commentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeCommentPic)];
    [_commentImageView addGestureRecognizer:tapImg];
    
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
    
    ///headerView布局
    [self makeHeadviewLayouts];
}

- (void)drawInnerview {
    //子背景
//    self.subBgView = [UIButton buttonWithType:UIButtonTypeCustom];
//    _subBgView.userInteractionEnabled = YES;
//    _subBgView.backgroundColor = HEXCOLOR(0xF9FAF9);
//    _subBgView.layer.masksToBounds = YES;
//    _subBgView.layer.cornerRadius = 4;
//    [self.backgroundsView addSubview:_subBgView];
    self.subBgView = [UIView new];
//    _subBgView.userInteractionEnabled = YES;
    _subBgView.backgroundColor = HEXCOLOR(0xF9FAF9);
    _subBgView.layer.masksToBounds = YES;
    _subBgView.layer.cornerRadius = 4;
    [self.backgroundsView addSubview:_subBgView];

    //回复作者信息<有多少显示多少行>
    _replyWriterText = [[YYLabel alloc] init];
    _replyWriterText.displaysAsynchronously = YES; /// enable async display
    _replyWriterText.numberOfLines = 0;
    [_subBgView addSubview:_replyWriterText];
    
    //作者的帖子图片
    _writerImg = [[UIImageView alloc] init];
    _writerImg.layer.masksToBounds = YES;
    _writerImg.layer.cornerRadius = 8;
    _writerImg.contentMode = UIViewContentModeScaleAspectFill;
    _writerImg.clipsToBounds = YES;
    [_subBgView addSubview:_writerImg];
    
    //作者
    _writer = [[UILabel alloc]init];
    _writer.font = JHMediumFont(15);
    _writer.textColor = HEXCOLOR(0x666666);
    _writer.textAlignment = NSTextAlignmentLeft;
    _writer.numberOfLines = 1;
    [_subBgView addSubview:_writer];
    
    //作者的帖子内容<一行>
    _writeText = [[YYLabel alloc]init];
    _writeText.text = @"";
    _writeText.font = JHFont(15);
    _writeText.textColor = HEXCOLOR(0x999999);
    _writeText.lineBreakMode = NSLineBreakByTruncatingTail;
    _writeText.numberOfLines = 1;
    [_subBgView addSubview:_writeText];
    
    [self makeInnerviewLayouts];
}

- (void)makeHeadviewLayouts {
    [_replyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundsView).offset(17);
        make.left.equalTo(self.backgroundsView).offset(12);
        make.size.mas_equalTo(34);
    }];
    
    [_replyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_replyImg).offset(0);
        make.left.mas_equalTo(_replyImg.mas_right).offset(12);
//        make.width.mas_equalTo(80);
        make.height.offset(18);
    }];
    
    [_metalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_replyName).offset(0);
        make.left.mas_equalTo(_replyName.mas_right).offset(5);
        make.height.mas_equalTo(15);
    }];

    [_replyTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_replyName.mas_bottom).offset(0);
        make.left.mas_equalTo(_replyName).offset(0);
        make.height.offset(16);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_replyImg.mas_bottom).offset(17);
        make.left.equalTo(self.backgroundsView).offset(10);
        make.right.equalTo(self.backgroundsView).offset(-10);
        make.height.mas_equalTo(0);
    }];
    
    [_commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content);
        make.top.equalTo(self.content.mas_bottom).offset(5);
        make.width.mas_equalTo(COMMENT_PIC_W);
        make.height.mas_equalTo(0);
    }];
    
    [_picTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.commentImageView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(32, 18));
    }];
}

- (void)makeInnerviewLayouts {
    [self.subBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentImageView.mas_bottom).offset(10);
        make.left.equalTo(self.backgroundsView).offset(10);
        make.right.equalTo(self.backgroundsView).offset(-10);
        make.bottom.mas_equalTo(self.backgroundsView).offset(-15);
    }];

    ///作者头像
    [_writerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_subBgView).offset(-10);
        make.left.equalTo(_subBgView).offset(10);
        make.size.offset(44);
    }];
    ///作者名称
    [_writer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_writerImg).offset(0);
        make.left.mas_equalTo(_writerImg.mas_right).offset(10);
        make.right.equalTo(_subBgView).offset(-10);
        make.height.mas_equalTo(21);
    }];

    ///文章内容
    [_writeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_writer.mas_bottom).offset(2);
        make.left.right.equalTo(_writer);
        make.bottom.equalTo(_writerImg);
        make.height.mas_equalTo(21);
    }];

    ///评论
    [_replyWriterText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.writerImg.mas_top).offset(0);
        make.top.left.mas_equalTo(_subBgView).offset(10);
        make.right.equalTo(_subBgView).offset(-10);
        make.height.mas_equalTo(0);
    }];
}

- (void)resetSubviewConstraints {
    [self.subBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_commentImageView.mas_bottom).offset(10);
        make.left.equalTo(self.backgroundsView).offset(10);
        make.right.equalTo(self.backgroundsView).offset(-10);
    }];
}

#pragma mark - update data
- (void)updateData:(JHMsgSubListLikeCommentModel*)model {
    _commentModel = model;
    
    //赋值显示类型
    model.pageType = kMsgSublistTypeLike;
    //article
    [_replyImg jhSetImageWithURL:[NSURL URLWithString:model.article.publisher.avatar] placeholder:kDefaultAvatarImage];
    _replyName.text = model.article.publisher.name;
    _metalView.tagArray = model.article.publisher.levelIcons;
    _replyTime.text = model.article.time;

    ///文字评论部分
    [self makeContentLayouts];
    ///图片评论部分
    [self makeCommentPicLayouts];
    ///对文章的评论内容部分
    [self makeReplyCommentLayouts];
    ///文章内容部分
    [self makeArticleLayouts];
}

///文字评论部分
- (void)makeContentLayouts {
    NSMutableAttributedString * string = _commentModel.article.contentAttributedString;
    
    _content.attributedText = string;
//    YYTextLayout *layout = _commentModel.article.mainTextLayout;
//    _content.textLayout = layout;
//    _content.size = layout.textBoundingSize;
    ///计算文字高度
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake((ScreenW - 20), MAXFLOAT)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:string];
    [_content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textLayout.textBoundingSize.height);
    }];
}
///图片评论部分
- (void)makeCommentPicLayouts {
    ///图片评论部分
    CGFloat space = 0;
    CGFloat COMMENT_PIC_H = 0;
    if (_commentModel.article.hasPicture) {
        COMMENT_PIC_H = COMMENT_PIC_W;
        space = 10.f;
        @weakify(self);
        [self.commentImageView jhSetImageWithURL:[NSURL URLWithString:_commentModel.article.comment_images_thumb.firstObject] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
                @strongify(self);
                self.commentImageView.image = image;
                BOOL has = [_commentModel.article.img_type isNotBlank];
                self.picTagLabel.text = has ? _commentModel.article.img_type : @"";
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
    
    _commentImageView.hidden = !_commentModel.article.hasPicture;
    [_commentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).offset(space);
        make.height.mas_equalTo(COMMENT_PIC_H);
    }];
}

/// 对文章的评论部分
- (void)makeReplyCommentLayouts {
    //inner view>replyArticle
    BOOL hasComment = (_commentModel.replyArticle &&
                       _commentModel.replyArticle.content &&
                       _commentModel.replyArticle.publisher.name);
    ///文章评论赋值
    _replyWriterText.attributedText = hasComment
    ? _commentModel.replyArticle.commentAttrString
    : nil;
    
    YYTextLayout *layout = _commentModel.replyArticle.textLayout;
//    _replyWriterText.textLayout = layout;
    _replyWriterText.size = layout.textBoundingSize;
    
    CGFloat bottomSpace = hasComment ? 10.f : 0;
    [_replyWriterText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.writerImg.mas_top).offset(-bottomSpace);
        make.height.mas_equalTo(layout.textBoundingSize.height);
    }];
    [self layoutIfNeeded];
    
    ///有图 需要响应查看图片的点击事件
    if (_commentModel.replyArticle.hasPicture) {
        @weakify(self);
        _commentModel.replyArticle.seePicBlock = ^{
            @strongify(self);
            NSLog(@"::::查看图片::::");
            [self seePicture];
        };
    }
}

///文章内容布局
- (void)makeArticleLayouts {
    //articleContent
    BOOL hasWriterIcon = (_commentModel.articleContent &&
                          _commentModel.articleContent.thumbImages.count > 0);
    
    NSString *writerImg = hasWriterIcon
    ? _commentModel.articleContent.thumbImages[0]
    : _commentModel.article.publisher.avatar;
    [_writerImg sd_setImageWithURL:[NSURL URLWithString:writerImg] placeholderImage:kDefaultCoverImage];

    if([_commentModel.articleContent.publisher.name length] > 0) {
        _writer.text = [NSString stringWithFormat:@"@%@", _commentModel.articleContent.publisher.name];
    }
    
    if([_commentModel.articleContent.title length] > 0) {
        _writeText.text = _commentModel.articleContent.title;
    }
    
    else {
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:@""];
        if (_commentModel.articleContent.resource_data.count > 0 || _commentModel.articleContent.content.length > 0) {
            contentString = _commentModel.articleContent.contentAttributedString;
        }
        [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:contentString font:_writeText.font];
        _writeText.attributedText = contentString;
    }
}

- (void)seeCommentPic {
    JHMsgSubListArticleModel *comment = _commentModel.article;
    if (comment.comment_images_thumb.count > 0) {
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[comment.comment_images_thumb.firstObject]
                                                origImages:@[comment.comment_images.firstObject]
                                                   sources:@[_commentImageView]
                                              currentIndex:0
                                       canPreviewOrigImage:YES
                                                 showStyle:GKPhotoBrowserShowStyleZoom];
    }
}

///查看图片的方法
- (void)seePicture {
    JHMsgSubListArticleModel *comment = _commentModel.replyArticle;
    if (comment.comment_images_thumb.count > 0) {
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[comment.comment_images_thumb.firstObject]
                                                origImages:@[comment.comment_images.firstObject]
                                                   sources:@[[UIImageView new]]
                                              currentIndex:0
                                       canPreviewOrigImage:YES
                                                 showStyle:GKPhotoBrowserShowStyleNone];
    }
}

///跳转个人主页
- (void)userTapAction:(UITapGestureRecognizer *)gest{
    [self gotoPersonPage];
}

- (void)gotoPersonPage{
    
}

@end
