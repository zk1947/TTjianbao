//
//  JHQuickCommentBar.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHQuickCommentBar.h"
#import "TTjianbao.h"

@interface JHQuickCommentBar ()
@property (nonatomic, strong) UIButton *contentControl;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation JHQuickCommentBar

+ (CGFloat)viewHeight {
    return 55.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_contentControl) {
        _contentControl = [UIButton jh_buttonWithTarget:self action:@selector(inputClick) addToSuperView:self];
        _contentControl.backgroundColor = UIColor.clearColor;
    }
    
    if (!_userIcon) {
        _userIcon = [UIImageView new];
        [_userIcon jhSetImageWithURL:[NSURL URLWithString:[UserInfoRequestManager sharedInstance].user.icon]
                     placeholder:kDefaultAvatarImage];
        [_contentControl addSubview:_userIcon];
    }
    
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColor999];
        _tipLabel.text = @"宝友，期待你的神评";
        _tipLabel.yd_contentInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_tipLabel doBorderWidth:0.5 color:[UIColor colorWithHexString:@"BDBFC2"] cornerRadius:15];
        [_contentControl addSubview:_tipLabel];
    }
    
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _userIcon.sd_layout
    .leftSpaceToView(_contentControl, 10)
    .topSpaceToView(_contentControl, 10)
    .widthIs(30).heightEqualToWidth();
    _userIcon.sd_cornerRadiusFromHeightRatio = @0.5;
    
    _tipLabel.sd_layout
    .leftSpaceToView(_userIcon, 5)
    .rightSpaceToView(_contentControl, 10)
    .centerYEqualToView(_userIcon)
    .heightIs(30.0);
    _tipLabel.sd_cornerRadiusFromHeightRatio = @0.5;
}

-(void)inputClick
{
    if (self.didClickBlock) {
        self.didClickBlock();
    }
}

- (void)updateAvatarIcon {
    [_userIcon jhSetImageWithURL:[NSURL URLWithString:[UserInfoRequestManager sharedInstance].user.icon]
                 placeholder:kDefaultAvatarImage];
}

@end
