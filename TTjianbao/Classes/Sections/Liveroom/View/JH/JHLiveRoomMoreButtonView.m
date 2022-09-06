//
//  JHLiveRoomMoreButtonView.m
//  TTjianbao
//
//  Created by 于岳 on 2020/7/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomMoreButtonView.h"

@implementation JHLiveRoomMoreButtonView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    [self btn];
}
-(void)updateBtnWithImage:(NSString *)icon Title:(NSString *)title
{
    [self.btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.btn setTitle:title forState:UIControlStateNormal];
}
-(UIButton *)btn
{
    if(!_btn)
    {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_btn];
        [_btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.0];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);

        }];
    }
    return _btn;
}

@end
