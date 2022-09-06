//
//  JHSQPostADCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPostADCell.h"

#define AD_W_H_RATIO  (355.f/200)

@interface JHSQPostADCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;

///355新增
@property (nonatomic, strong) UILabel *detailLabel;
///活动tag
@property (nonatomic, strong) UILabel *activityLabel;
@end

@implementation JHSQPostADCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
        [self.contentView addSubview:_imgView];
    }
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.f] textColor:kColor333];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_titleLabel];
    }
    
    
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:15] textColor:HEXCOLOR(0x408FFE)];
        _detailLabel.text = @"查看详情";
        [self.contentView addSubview:_detailLabel];
    }

    if (!_activityLabel) {
        _activityLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColorFFF];
        _activityLabel.backgroundColor = HEXCOLORA(0x333333, .5);
        _activityLabel.text = @"活动";
        _activityLabel.sd_cornerRadius = @(21./2);
        _activityLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_activityLabel];
    }
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = kColorF5F6FA;
        [self.contentView addSubview:_bottomLine];
    }
    
    _contentControl.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomSpaceToView(_bottomLine, 0);
    
    _titleLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0)
    .maxHeightIs(ceil(_titleLabel.font.lineHeight * 2));
    
    _imgView.sd_layout
    .topSpaceToView(_titleLabel, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(JHScaleToiPhone6(200));
    
    _activityLabel.sd_layout
    .rightEqualToView(_imgView)
    .topSpaceToView(_imgView, 10)
    .widthIs(34).heightIs(21);
    
    _detailLabel.sd_layout
    .leftEqualToView(_imgView)
    .topSpaceToView(_imgView, 10)
    .rightSpaceToView(_activityLabel, 10)
    .autoHeightRatio(0);
    
    _bottomLine.sd_layout
    .topSpaceToView(_detailLabel, 15)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:self.bottomLine bottomMargin:0];
}

- (void)setPostData:(JHPostData *)postData {
    _postData = postData;
    
    [_imgView jhSetImageWithURL:[NSURL URLWithString:postData.image] placeholder:kDefaultCoverImage];
    
    _titleLabel.text = postData.title;
    
    [_contentControl updateLayout];
}


#pragma mark -
#pragma mark - 点击事件

//NSLog(@"点击广告");
- (void)handleClickEvent {
    [JHRootController toNativeVC:_postData.target.componentName withParam:_postData.target.params from:JHFromSQHomeFeedList];
}

@end
