//
//  JHSQPostTopicCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPostTopicCell.h"

#define kPaddingTop         (15.0)
#define kBottomLineHeight   (10.0)
#define kImgHeight          (JHScaleToiPhone6(80.0))
#define kContentHeight      (kImgHeight + kPaddingTop*2 + kBottomLineHeight)

@interface JHSQPostTopicCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *tagIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation JHSQPostTopicCell

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
        [self.contentView addSubview:_contentControl];
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
    
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.clipsToBounds = YES;
        _imgView.sd_cornerRadius = @(8);
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    if (!_maskView) {
        _maskView = [UIImageView new];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    
    if (!_tagIcon) {
        _tagIcon = [UIImageView new];
        _tagIcon.clipsToBounds = YES;
        _tagIcon.contentMode = UIViewContentModeScaleAspectFit;
        _tagIcon.image = [UIImage imageNamed:@"sq_icon_topic_tag"];
    }
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:18.0] textColor:[UIColor whiteColor]];
    }
    
    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:12.0] textColor:[UIColor whiteColor]];
    }
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = kColorF5F6FA;
    }
    
    [_imgView sd_addSubviews:@[_maskView, _tagIcon, _titleLabel, _contentLabel]];
    [_contentControl sd_addSubviews:@[_imgView, _bottomLine]];
    
    //1.
    _contentControl.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(kContentHeight);
    
    //2.
    _imgView.sd_layout
    .topSpaceToView(_contentControl, 15)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10)
    .heightIs(kImgHeight);
    
    //2.0
    _maskView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    //2.1
    _tagIcon.sd_layout
    .topSpaceToView(_imgView, 15)
    .leftSpaceToView(_imgView, 10)
    .widthIs(16)
    .heightIs(24);
    
    //2.2
    _titleLabel.sd_layout
    .centerYEqualToView(_tagIcon)
    .leftSpaceToView(_tagIcon, 5)
    .rightSpaceToView(_imgView, 10)
    .heightIs(24);
    
    //2.3
    _contentLabel.sd_layout
    .leftSpaceToView(_imgView, 10)
    .rightSpaceToView(_imgView, 10)
    .bottomSpaceToView(_imgView, 15)
    .heightIs(18);
    
    _bottomLine.sd_layout
    .topSpaceToView(_imgView, 15)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightIs(kBottomLineHeight);
    
    [self setupAutoHeightWithBottomViewsArray:@[_contentControl, _bottomLine] bottomMargin:0];
}

- (void)setPostData:(JHPostData *)postData {
    _postData = postData;
    
    [_imgView jhSetImageWithURL:[NSURL URLWithString:postData.image] placeholder:kDefaultCoverImage];
    
    _titleLabel.text = postData.title;
    _contentLabel.text = postData.content;
}


#pragma mark -
#pragma mark - 点击事件

//NSLog(@"点击话题");
- (void)handleClickEvent {
    [JHRouterManager pushTopicDetailWithTopicId:_postData.item_id pageType:JHPageTypeSQHome];
}

@end
