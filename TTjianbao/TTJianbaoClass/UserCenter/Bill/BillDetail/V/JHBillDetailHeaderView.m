//
//  JHBillDetailHeaderView.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillDetailHeaderView.h"
#import "UserInfoRequestManager.h"

@interface JHBillDetailHeaderView ()
@property (nonatomic, weak) UILabel *descLabel;
@end

@implementation JHBillDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(255.f, 247.f, 234.f);
               
        
        _descLabel = [UILabel jh_labelWithText:@"" font:13 textColor:RGB(255, 66, 0) textAlignment:0 addToSuperView:self];
        _descLabel.backgroundColor = UIColor.clearColor;
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(8.f);
            make.centerY.equalTo(self);
        }];
        
       UIImageView *icon = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_warn" addToSuperview:self];
    
       [icon mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self.descLabel.mas_left).offset(-5.f);
           make.centerY.equalTo(self);
           make.size.mas_equalTo(CGSizeMake(14, 14));
       }];
    }
    return self;
}

-(void)setAccountDate:(NSString *)accountDate{
    if(accountDate){
        _accountDate = accountDate;
        NSString *descStr = [NSString stringWithFormat:@"以下数据自%@开始统计",_accountDate];
        self.descLabel.text = descStr;

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
