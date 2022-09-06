//
//  JHAppraiserUserReplyListCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/5/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAppraiserUserReplyListCell.h"
#import "JHAppraiserUserReplyModel.h"
#import "JHAppraiseVideoViewController.h"
#import "JHSQManager.h"
#import "YYControl.h"

@interface JHAppraiserUserReplyListCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation JHAppraiserUserReplyListCell

+ (CGFloat)cellHeight {
    return 88.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    _contentControl = [YYControl new];
    _contentControl.backgroundColor = [UIColor whiteColor];
    _contentControl.layer.cornerRadius = 4;
    _contentControl.clipsToBounds = YES;
    _contentControl.exclusiveTouch = YES;
    [self.contentView addSubview:_contentControl];
    @weakify(self);
    _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                [self enterDiscoverDetailVC];
            }
        }
    };
    
    _coverImgView = [[UIImageView alloc] init];
    _coverImgView.clipsToBounds = YES;
    _coverImgView.sd_cornerRadius = @(2.0);
    _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.0] textColor:kColor222];
    _descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:13.0] textColor:kColor666];
    _timeLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:11.0] textColor:kColor999];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyButton setTitle:@"马上回复" forState:UIControlStateNormal];
    [_replyButton setTitleColor:kColor333 forState:UIControlStateNormal];
    _replyButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
    [_replyButton setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateNormal];
    [_replyButton setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateHighlighted];
    _replyButton.clipsToBounds = YES;
    _replyButton.sd_cornerRadius = @(15.0);
    _replyButton.exclusiveTouch = YES;
    [[_replyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self enterDiscoverDetailVC];
    }];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = kColorCellLine;
    
    [_contentControl sd_addSubviews:@[_coverImgView, _titleLabel, _timeLabel, _descLabel, _replyButton, _bottomLine]];
    
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _coverImgView.sd_layout
    .topSpaceToView(_contentControl, 10)
    .leftSpaceToView(_contentControl, 10)
    .widthIs(66).heightEqualToWidth();
    
    _timeLabel.sd_layout
    .topEqualToView(_coverImgView)
    .rightSpaceToView(_contentControl, 10)
    .heightIs(22);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:120];
    [_timeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _titleLabel.sd_layout
    .topEqualToView(_coverImgView)
    .leftSpaceToView(_coverImgView, 10)
    .rightSpaceToView(_timeLabel, 10)
    .heightIs(22);
    
    _replyButton.sd_layout
    .rightSpaceToView(_contentControl, 10)
    .bottomSpaceToView(_contentControl, 12)
    .widthIs(74).heightIs(30);
    
    _descLabel.sd_layout
    .leftSpaceToView(_coverImgView, 10)
    .rightSpaceToView(_replyButton, 10)
    .bottomEqualToView(_coverImgView)
    .heightIs(18);
    
    _bottomLine.sd_layout
    .leftSpaceToView(_coverImgView, 10)
    .rightSpaceToView(_contentControl, 0)
    .bottomEqualToView(_contentControl)
    .heightIs(1.0);
}

#pragma mark - 赋值

- (void)setCurData:(JHAppraiserUserReplyData *)curData {
    _curData = curData;
    
    [_coverImgView jhSetImageWithURL:[NSURL URLWithString:curData.image] placeholder:kDefaultCoverImage];
    
    _titleLabel.text = curData.title;
    _timeLabel.text = curData.publish_time;
    _descLabel.text = curData.reply_desc;
}


//进入帖子详情
- (void)enterDiscoverDetailVC {
    if (_curData.layout == JHSQLayoutTypeAppraisalVideo) {//鉴定剪辑视频
        NSString *url = [NSString stringWithFormat:@"content/detailBridge/%ld/%@",
                         (long)_curData.item_type, _curData.item_id];
        @weakify(self);
        [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
            @strongify(self);
            JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
            vc.cateId = [NSString stringWithFormat:@"%@", respondObject.data[@"item_type"]];
            vc.appraiseId = respondObject.data[@"item_id"];
            vc.commentId = self.curData.comment_id;
            vc.from = JHFromUndefined;
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            
        } failureBlock:^(RequestModel *respondObject) {}];
        
    } else {
        [JHRouterManager pushPostDetailWithItemType:(JHPostItemType)_curData.item_type itemId:_curData.item_id pageFrom:JHFromHomeIdentity scrollComment:1];
    }
    
}

@end
