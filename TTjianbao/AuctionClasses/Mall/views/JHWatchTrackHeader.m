//
//  JHWatchTrackHeader.m
//  TTjianbao
//
//  Created by jiang on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHWatchTrackHeader.h"
#import "CommHelp.h"
#import "TTjianbaoMarco.h"
#import "UIButton+ImageTitleSpacing.h"
#import "TTJianBaoColor.h"

@interface JHWatchTrackHeader()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHWatchTrackHeader


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}
- (void)configViews {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我的足迹";
    label.font = [UIFont fontWithName:kFontMedium size:15];
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
       button.backgroundColor=[UIColor clearColor];
       button.layer.cornerRadius=15;
       button.layer.masksToBounds=YES;
//       button.layer.borderColor = HEXCOLOR(0xFEE100).CGColor;
//       button.layer.borderWidth = 0.5;
       [button setTitleColor:GRAY_COLOR forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont fontWithName:kFontNormal size:13];
       [button  setTitle:@"查看全部" forState:UIControlStateNormal];
      [button setImage:[UIImage imageNamed:@"foot_arrow"] forState:UIControlStateNormal];
       button.contentMode=UIViewContentModeScaleAspectFit;
       [button addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       [self addSubview:button];
       [button mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self).offset(-10);
           make.centerY.equalTo(self);
           make.width.offset(76);
           make.height.offset(25);
       }];
      [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                                                  imageTitleSpace:4];
       
    
}
-(void)onClickBtnAction:(UIButton*)button{
    
    if (self.buttonClick) {
        self.buttonClick();
    }
}

@end
