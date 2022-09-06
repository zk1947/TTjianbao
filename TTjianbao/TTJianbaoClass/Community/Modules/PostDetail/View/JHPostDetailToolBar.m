//
//  JHPostDetailToolBar.m
//  TTjianbao
//
//  Created by lihui on 2020/8/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailToolBar.h"
#import "UIView+CornerRadius.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YYControl.h"
#import "JHPostDetailModel.h"

@interface JHPostDetailToolBar ()

///输入框底部
@property (nonatomic, strong) YYControl *inputView;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@end

@implementation JHPostDetailToolBar

- (void)dealloc {
    
}

- (void)setDetailModel:(JHPostDetailModel *)detailModel {
    if (!detailModel) {
        return;
    }
    
    _detailModel = detailModel;
    NSString *shareString = _detailModel.share_count_int > 0 ? ([_detailModel.share_count isNotBlank] ? _detailModel.share_count : @(_detailModel.share_count_int).stringValue) : @"分享";
    NSString *commentString = _detailModel.comment_num > 0 ? @(_detailModel.comment_num).stringValue : @"评论";
    NSString *likeString = _detailModel.like_num_int > 0 ? _detailModel.like_num : @"赞";

    [_shareButton setTitle:shareString forState:UIControlStateNormal];
    [_commentButton setTitle:commentString forState:UIControlStateNormal];
    [_likeButton setTitle:likeString forState:UIControlStateNormal];
    _likeButton.selected = _detailModel.is_like;
}

#pragma mark -
#pragma mark - event action

- (void)shareAction {
    NSLog(@"--- shareAction ---");
    if (![self postIsChecking] && self.actionBlock) {
        self.actionBlock(JHPostDetailActionTypeShare);
    }
}

- (void)commentAction {
    if (![self postIsChecking] && self.actionBlock) {
        self.actionBlock(JHPostDetailActionTypeComment);
    }
}

- (void)likeAction {
    if (![self postIsChecking] && self.actionBlock) {
        self.actionBlock(JHPostDetailActionTypeLike);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kColorF5F6FA;
    [self addSubview:line];
        
    YYControl *inputView = [[YYControl alloc] init];
    inputView.backgroundColor = kColorF5F6FA;
    inputView.exclusiveTouch = YES;
    _inputView = inputView;
    @weakify(self);
    inputView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                if (![self postIsChecking]) {
                    if (self.actionBlock) {
                        self.actionBlock(JHPostDetailActionTypeInput);
                    }
                }
            }
        }
    };
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"宝友，期待你的神评";
    label.font = [UIFont fontWithName:kFontNormal size:12];
    label.textColor = kColor999;
    _placeholder = label;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"sq_toolbar_icon_share"] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [shareBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    _shareButton = shareBtn;
        
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"sq_toolbar_icon_comment"] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [commentBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    _commentButton = commentBtn;
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setTitle:@"赞" forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_selected"] forState:UIControlStateSelected];
    likeBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [likeBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
    [likeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    _likeButton = likeBtn;

    [self addSubview:_inputView];
    [inputView addSubview:_placeholder];
    [self addSubview:_shareButton];
    [self addSubview:_commentButton];
    [self addSubview:_likeButton];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(36);
        make.top.equalTo(self).offset(4);
    }];

    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.likeButton);
        make.right.equalTo(self.likeButton.mas_left).offset(-15);
    }];

    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.likeButton);
        make.right.equalTo(self.commentButton.mas_left).offset(-15);
    }];

    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(4);
        make.height.mas_equalTo(36);
        make.right.equalTo(self.shareButton.mas_left).offset(-26);
    }];

    [_placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView).offset(10);
        make.centerY.equalTo(self.inputView);
        make.height.mas_equalTo(36);
        make.right.equalTo(self.inputView).offset(-10);
    }];
    
    [_inputView layoutIfNeeded];
    [_inputView yd_setCornerRadius:_inputView.height/2.f corners:UIRectCornerAllCorners];
}

- (BOOL)postIsChecking {
    if (self.detailModel.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return YES;
    }
    return NO;
}

@end
