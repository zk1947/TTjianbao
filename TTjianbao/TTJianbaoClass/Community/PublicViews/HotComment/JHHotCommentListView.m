//
//  JHHotCommentListView.m
//  TTjianbao
//
//  Created by lihui on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHotCommentListView.h"
#import "TTjianbao.h"
#import "JHSQModel.h"
#import "JHPhotoBrowserManager.h"
#import "JHCommentHelper.h"


static CGFloat const commentImgHeight = 98.f;

@interface JHHotCommentListView ()
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) UIImageView *commentImageView;
///图片是长图还是gif还是普通图片的标签
@property (nonatomic, strong) UILabel *picTagLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation JHHotCommentListView

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    _lineView.hidden = !_showLine;
}

- (void)setHotComment:(JHCommentData *)hotComment {
    if (!hotComment) {
        return;
    }
    
    _hotComment = hotComment;
    _commentLabel.attributedText = hotComment.contentAttributedString;
//    _commentLabel.backgroundColor = [UIColor redColor];
    
    BOOL showCommentImg = (_hotComment.comment_images_thumb && _hotComment.comment_images_thumb.count > 0);
    _commentImageView.hidden = !showCommentImg;
    if (showCommentImg) {
        @weakify(self);
        [self.commentImageView jhSetImageWithURL:[NSURL URLWithString:_hotComment.comment_images_thumb.firstObject] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image) {
                @strongify(self);
                self.commentImageView.image = image;
                ///图片标签
                BOOL has = [_hotComment.img_type isNotBlank];
                self.picTagLabel.text = has ? _hotComment.img_type : @"";
                self.picTagLabel.hidden = !has;
            }
            else {
                self.commentImageView.image = kDefaultCoverImage;
            }
        }];
        _commentImageView.sd_layout
        .topSpaceToView(self.commentLabel, 5)
        .heightIs(commentImgHeight);
    }
    else {
        self.commentImageView.image = kDefaultCoverImage;
        _commentImageView.sd_layout
        .topSpaceToView(self.commentLabel, 0)
        .heightIs(0);
    }
    
    [self setupAutoHeightWithBottomView:_bottomLabel bottomMargin:0];
    [self layoutIfNeeded];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    YYLabel *commentLabel = [[YYLabel alloc] init];
    commentLabel.font = [UIFont fontWithName:kFontMedium size:14];
    commentLabel.numberOfLines = 3;
    commentLabel.displaysAsynchronously = YES; /// enable async display
    commentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    commentLabel.preferredMaxLayoutWidth = (ScreenW - 35);
    _commentLabel = commentLabel;
    [self addSubview:commentLabel];
    
    UIImageView *commentImageView = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    commentImageView.contentMode = UIViewContentModeScaleAspectFill;
    commentImageView.sd_cornerRadius = @(8.f);
    commentImageView.clipsToBounds = YES;
    [self addSubview:commentImageView];
    _commentImageView = commentImageView;
    _commentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleCommentPicTapEvent)];
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
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = kColorEEE;
    [self addSubview:_lineView];
    
    ///这个必须得留着 自适应cell使用 ！！！！！ ------- TODO lihui
    UILabel *bottomLabel = [[UILabel alloc] init];
    [self addSubview:bottomLabel];
    _bottomLabel = bottomLabel;

    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(10);
    }];
    
    _commentImageView.sd_layout
    .topSpaceToView(self.commentLabel, 5)
    .leftEqualToView(self.commentLabel)
    .widthIs(commentImgHeight).heightIs(0);
    
    _picTagLabel.sd_layout
    .bottomSpaceToView(self.commentImageView, 5)
    .rightSpaceToView(self.commentImageView, 5)
    .widthIs(32).heightIs(18);
    
    bottomLabel.sd_layout
    .topSpaceToView(_commentImageView, 10)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .autoHeightRatio(0);
    
    _lineView.sd_layout
    .bottomEqualToView(_bottomLabel)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(1);
    
//    UIFont *fontName = [UIFont fontWithName:kFontMedium size:14];
//    CGFloat maxHeight = ceil(fontName.lineHeight * 3);
//    commentLabel.sd_layout.maxHeightIs(90);
    
    [self setupAutoHeightWithBottomView:bottomLabel bottomMargin:0];
}

- (void)__handleCommentPicTapEvent {
    NSLog(@"handleCommentPicTapEvent");
    if (_hotComment.comment_images_thumb.count > 0) {
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[_hotComment.comment_images_thumb.firstObject]
                                                origImages:@[_hotComment.comment_images.firstObject]
                                                   sources:@[_commentImageView]
                                              currentIndex:0
                                       canPreviewOrigImage:YES
                                                 showStyle:GKPhotoBrowserShowStyleZoom];
    }
}

@end
