//
//  JHStoneSearchConditionFooterView.m
//  TTjianbao
//
//  Created by apple on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSearchConditionFooterView.h"

@implementation JHStoneSearchConditionFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *cancleButton = [UIButton jh_buttonWithTitle:@"重置" fontSize:16 textColor:UIColor.blackColor target:self action:@selector(cancleMethod) addToSuperView:self];
        [cancleButton jh_cornerRadius:20 borderColor:RGB(204, 204, 204) borderWidth:1];
        [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(6);
            make.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(128, 40));
        }];
        
        UIButton *sureButton = [UIButton jh_buttonWithTitle:@"确定" fontSize:16 textColor:UIColor.blackColor target:self action:@selector(sureMethod) addToSuperView:self];
        [sureButton jh_cornerRadius:20.f];
        sureButton.backgroundColor = RGB(254, 225, 0);
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.bottom.equalTo(cancleButton);
            make.right.equalTo(self).offset(-6);
        }];
    }
    return self;
}

-(void)cancleMethod
{
    if(_cancleBlock)
    {
        _cancleBlock();
    }
}

-(void)sureMethod
{
    if(_makeSureBlock)
    {
        _makeSureBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
