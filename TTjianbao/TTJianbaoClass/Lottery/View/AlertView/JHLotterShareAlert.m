//
//  JHLotterShareAlert.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotterShareAlert.h"

@interface JHLotterShareAlert ()

@property (nonatomic, copy) dispatch_block_t clickBlock;

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation JHLotterShareAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(260);
            make.height.mas_equalTo(181);
        }];

        _titleLabel = [UILabel jh_labelWithBoldFont:15 textColor:UIColor.blackColor addToSuperView:self.whiteView];
        _titleLabel.text = @"恭喜你！获得1张抽奖码";
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.whiteView).offset(57);
            make.centerX.equalTo(self.whiteView);
        }];
        
        _shareBtn = [UIButton jh_buttonWithImage:@"lottery_wechat" target:self action:@selector(shareMethod) addToSuperView:self.whiteView];
        _shareBtn.jh_titleColor(UIColor.blackColor).jh_title(@"  立即分享，抽奖码 +1").jh_font([UIFont boldSystemFontOfSize:13]);
        _shareBtn.backgroundColor = RGB(255,194,66);
        [_shareBtn jh_cornerRadius:19];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.whiteView).offset(-27);
            make.left.equalTo(self.whiteView).offset(27);
            make.height.mas_equalTo(38);
            make.top.equalTo(_titleLabel.mas_bottom).offset(37);
        }];
        
        UIImageView *icon = [UIImageView jh_imageViewWithImage:@"lottery_wechat_top" addToSuperview:self.whiteView];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.shareBtn).offset(-16);
            make.top.equalTo(self.shareBtn).offset(-7);
            make.size.mas_equalTo(CGSizeMake(111, 17));
        }];
    }
    return self;
}

- (void)shareMethod
{
    if(_clickBlock)
    {
        _clickBlock();
    }
    [self removeFromSuperview];
}

+ (void)showAlertTitle:(NSString *)title subTitle:(NSString *)subTitle btnTitle:(NSString *)btnTitle  clickBlock:(dispatch_block_t)clickBlock {
    
    JHLotterShareAlert *alert = [[JHLotterShareAlert alloc] initWithFrame:JHKeyWindow.bounds];
    alert.titleLabel.text = title;
    [alert.shareBtn setTitle:btnTitle forState:UIControlStateNormal];
    alert.clickBlock = clickBlock;
    [JHKeyWindow addSubview:alert];
    
    if([subTitle isNotBlank])
    {
        UILabel *label = [UILabel jh_labelWithFont:12 textColor:RGB153153153 addToSuperView:alert.whiteView];
        label.text = subTitle;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(alert.whiteView).offset(-30);
            make.centerX.equalTo(alert.whiteView);
        }];
        [alert.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(208);
        }];
    }
}

@end
