//
//  JHMyCompeteWantToView.m
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteWantToView.h"
#import "TTJianBaoColor.h"
#import "JHMyCompeteModel.h"

@interface JHMyCompeteWantToView ()
///用户头像
@property (nonatomic, strong) UIImageView *userImgView;
///用户名称
@property (nonatomic, strong) UILabel *userNameLable;
///想要人数
@property (nonatomic, strong) UILabel *wantNumLable;

@end

@implementation JHMyCompeteWantToView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self p_drawSubViews];
        [self p_makeLayouts];
    }
    return self;
}

#pragma mark - Private Methods

- (void)p_drawSubViews {
    
    _userImgView = [[UIImageView alloc] init];
    _userImgView.image = JHImageNamed(@"newStore_default_avatar_placehold");
    [self addSubview:_userImgView];
    
    _userNameLable = [[UILabel alloc] init];
    _userNameLable.font = JHFont(10);
    _userNameLable.textColor = LIGHTGRAY_COLOR;
    [_userNameLable setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    _userNameLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_userNameLable];
    
    _wantNumLable = [[UILabel alloc] init];
    _wantNumLable.font = JHFont(10);
    _wantNumLable.textColor = LIGHTGRAY_COLOR;
    _wantNumLable.textAlignment = NSTextAlignmentRight;
    [_wantNumLable setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:_wantNumLable];
    

}

- (void)p_makeLayouts {
    
    [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(8);
        make.size.mas_offset(CGSizeMake(12, 12));
    }];
    
    [self.userNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userImgView);
        make.left.equalTo(self.userImgView.mas_right).offset(3);
        
    }];
    
    [self.wantNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userImgView);
        make.right.equalTo(self).offset(-8);
        make.left.equalTo(self.userNameLable.mas_right).offset(3);
    }];
    
}

#pragma mark - Public Method

- (void)setMyCompeteWantToModel:(JHMyCompeteWantToModel *)wantToModel {
    
    [_userImgView jhSetImageWithURL:[NSURL URLWithString:wantToModel.userImg]
                              placeholder:kDefaultNewStoreCoverImage];
    [_userNameLable setText:wantToModel.userName];
    [_wantNumLable setText:wantToModel.wantCountStr];
    self.wantNumLable.hidden = wantToModel.isOnelineOfUserInfo;
    if (wantToModel.isOnelineOfUserInfo) {
        [_userNameLable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-8);
        }];
    }
}


@end
