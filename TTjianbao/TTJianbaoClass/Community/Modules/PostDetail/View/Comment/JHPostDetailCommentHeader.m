//
//  JHPostDetailCommentHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/8/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailCommentHeader.h"
#import "YYControl.h"
#import "TTjianbaoMarcoUI.h"
#import "UserInfoRequestManager.h"
#import "UIImageView+JHWebImage.h"

@interface JHPostDetailCommentHeader ()
@property (nonatomic, strong) UIView *whiteBottomView;
@property (nonatomic, strong) UILabel *commentCountLabel;

@property (nonatomic, strong) UIImageView *authorIcon;
@property (nonatomic, strong) YYControl *inputView;
@property (nonatomic, strong) UILabel *placeholder;

@end


@implementation JHPostDetailCommentHeader

- (void)setCommentCount:(NSString *)commentCount {
    _commentCount = commentCount;
    _commentCountLabel.text = [NSString stringWithFormat:@"共%@条评论", [_commentCount isNotBlank] ? _commentCount : @"0"];    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorF5F6FA;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    _whiteBottomView = bottomView;
    
    UILabel *commLabel = [[UILabel alloc] init];
    commLabel.font = [UIFont fontWithName:kFontMedium size:15];
    commLabel.text = @"共0条评论";
    commLabel.textColor = kColor333;
    _commentCountLabel = commLabel;
    
    ///用户头像
    _authorIcon = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _authorIcon.contentMode = UIViewContentModeScaleAspectFill;
    _authorIcon.layer.cornerRadius = 15.;
    _authorIcon.layer.masksToBounds = YES;
    [_authorIcon jhSetImageWithURL:[NSURL URLWithString:[UserInfoRequestManager sharedInstance].user.icon] placeholder:kDefaultAvatarImage];
    
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
                if (self.actionBlock) {
                    self.actionBlock();
                }
            }
        }
    };
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"宝友，期待你的神评";
    label.font = [UIFont fontWithName:kFontNormal size:12];
    label.textColor = kColor999;
    _placeholder = label;

    [self addSubview:_whiteBottomView];
    [_whiteBottomView addSubview:_commentCountLabel];
    [_whiteBottomView addSubview:_authorIcon];
    [_whiteBottomView addSubview:_inputView];
    [_inputView addSubview:_placeholder];

    [self makeLayouts];
}

- (void)makeLayouts {
    [_whiteBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    [_commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
    }];
    
    [_authorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentCountLabel.mas_bottom).offset(15);
        make.leading.equalTo(self.commentCountLabel);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorIcon.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.authorIcon);
        make.right.equalTo(self).offset(-15);
    }];

    [_placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView).offset(10);
        make.centerY.equalTo(self.inputView);
        make.height.equalTo(self.inputView);
        make.right.equalTo(self.inputView).offset(-10);
    }];
    
    [_inputView layoutIfNeeded];
    _inputView.layer.cornerRadius = _inputView.height/2;
    _inputView.layer.masksToBounds = YES;
}


@end
