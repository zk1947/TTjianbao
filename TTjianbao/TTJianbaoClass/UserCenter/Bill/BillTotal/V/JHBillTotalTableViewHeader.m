//
//  JHBillTotalTableViewHeader.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillTotalTableViewHeader.h"
#import "UserInfoRequestManager.h"

@interface JHBillTotalTableViewHeader ()

@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation JHBillTotalTableViewHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = UIColor.whiteColor;
        [self addSelfView];
    }
    
    return self;
}

-(void)addSelfView
{
    UIImageView *imageView = [UIImageView jh_imageViewAddToSuperview:self];
    imageView.image = [UIImage imageNamed:@"bg_shop_top"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 78.f, 0));
    }];
    


    _moneyLabel = [UILabel jh_labelWithBoldText:@"10000.00" font:20 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:imageView];
    _moneyLabel.backgroundColor = UIColor.clearColor;
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).offset(15.f);
        make.bottom.equalTo(imageView).offset(-15.f);
    }];
    
    UILabel *tipLabel = [UILabel jh_labelWithText:@"可提现（元）" font:13 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:imageView];
    tipLabel.backgroundColor = UIColor.clearColor;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel);
        make.bottom.equalTo(self.moneyLabel.mas_top).offset(-5.f);
    }];
    
    if (![UserInfoRequestManager sharedInstance].user.blRole_saleAnchorAssistant && ![UserInfoRequestManager sharedInstance].user.blRole_restoreAssistant) {
        UIView *buttonView = [UIView jh_viewWithColor:RGBA(0.f, 0.f, 0.f, 0.05) addToSuperview:self];
        [buttonView jh_cornerRadius:13 rectCorner:UIRectCornerBottomLeft | UIRectCornerTopLeft bounds:CGRectMake(0, 0, 87, 26)];
        [buttonView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getMoneyAction)]];
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(imageView);
            make.centerY.equalTo(self.moneyLabel);
            make.size.mas_equalTo(CGSizeMake(87.f, 26.f));
        }];
        
        
        UIImageView *icon = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_money" addToSuperview:buttonView];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonView).offset(13);
            make.centerY.equalTo(buttonView);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        UILabel *buttonLabel = [UILabel jh_labelWithText:@"去提现" font:12 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:buttonView];
        buttonLabel.backgroundColor = UIColor.clearColor;
        [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(5);
            make.centerY.equalTo(buttonView);
        }];
        
        UIImageView *icon2 = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_white_push" addToSuperview:buttonView];
        [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(buttonLabel.mas_right).offset(5);
            make.centerY.equalTo(buttonView);
            make.size.mas_equalTo(CGSizeMake(4.5, 8));
        }];
    }

    
    {
        UIView *cellView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(imageView.mas_bottom);
            make.height.mas_equalTo(48.f);
        }];
        
        [cellView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoDetailAction)]];
        
        UIImageView *icon = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_detail" addToSuperview:cellView];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellView).offset(15.f);
            make.centerY.equalTo(cellView);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        UILabel *descLabel = [UILabel jh_labelWithText:@"资金明细" font:13 textColor:[UIColor blackColor] textAlignment:0 addToSuperView:cellView];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(5.f);
            make.centerY.equalTo(icon);
        }];
        
        UIImageView *pushIcon = [UIImageView new];
        pushIcon.image = [UIImage imageNamed:@"icon_shop_push"];
        [cellView addSubview:pushIcon];
        [pushIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cellView).offset(-15.f);
            make.centerY.equalTo(cellView);
        }];
    }
    
    {
        UIView *cellView = [UIView jh_viewWithColor:RGB(255.f, 247.f, 234.f) addToSuperview:self];
           [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.right.equalTo(self);
               make.top.equalTo(imageView.mas_bottom).offset(48.f);
               make.height.mas_equalTo(30.f);
           }];
        
        _descLabel = [UILabel jh_labelWithText:@"" font:13 textColor:RGB(255, 66, 0) textAlignment:0 addToSuperView:cellView];
        _descLabel.backgroundColor = UIColor.clearColor;
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cellView).offset(8.f);
            make.centerY.equalTo(cellView);
        }];
        
           UIImageView *icon = [UIImageView jh_imageViewWithImage:@"icon_shop_bill_warn" addToSuperview:cellView];
        
           [icon mas_makeConstraints:^(MASConstraintMaker *make) {
               make.right.equalTo(self.descLabel.mas_left).offset(-5.f);
               make.centerY.equalTo(cellView);
               make.size.mas_equalTo(CGSizeMake(14, 14));
           }];
    }

    
}

#pragma mark ---------------------------- Action ----------------------------

-(void)gotoDetailAction
{
    if(_detailActionBlock){
        _detailActionBlock();
    }
}

-(void)getMoneyAction
{
    if (_getMoneyActionBlock) {
        _getMoneyActionBlock();
    }
}

-(void)setAccountDate:(NSString *)accountDate{
    if(accountDate){
        _accountDate = accountDate;
        NSString *descStr = [NSString stringWithFormat:@"以下数据自%@开始统计",_accountDate];
        self.descLabel.text = descStr;
    }
}


#pragma mark ---------------------------- method ----------------------------
+(CGSize)headerViewSize
{
    return CGSizeMake(ScreenW, JHScaleToiPhone6(165.f) + 48.f +30.f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
