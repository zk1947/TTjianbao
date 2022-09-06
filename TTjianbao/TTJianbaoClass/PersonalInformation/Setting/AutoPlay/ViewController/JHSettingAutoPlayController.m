//
//  JHSettingAutoPlayController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/11/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSettingAutoPlayController.h"

@interface JHSettingAutoPlayController ()

@property (nonatomic, weak) UIImageView *selectedIcon;

@end

@implementation JHSettingAutoPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    self.title = @"视频自动播放";
    [self jhNavBottomLine];
    
    UIView * view1 = [self creatViewWithTitle:@"4G和WIFI"];
    [view1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
    @weakify(self);
    [view1 jh_addTapGesture:^{
        @strongify(self);
        [self switchAutoPlayStatus:JHAutoPlayStatusWIFIAnd4G];
    }];
    
    UIView * view2 = [self creatViewWithTitle:@"仅WIFI"];
    [view2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_bottom);
    }];
    [view2 jh_addTapGesture:^{
        @strongify(self);
        [self switchAutoPlayStatus:JHAutoPlayStatusWIFI];
    }];
    
    UIView * view3 = [self creatViewWithTitle:@"关闭"];
    [view3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom);
    }];
    [view3 jh_addTapGesture:^{
        @strongify(self);
        [self switchAutoPlayStatus:JHAutoPlayStatusClose];
    }];
    
    JHAutoPlayStatus status = [JHSettingAutoPlayController getAutoPlayStatus];
    _selectedIcon = [UIImageView jh_imageViewWithImage:JHImageNamed(@"my_set_auto_play_select") addToSuperview:self.view];
    [_selectedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.jhNavView.mas_bottom).offset(15);
        make.right.equalTo(self.view).offset(-10);
    }];
    [self.selectedIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom).offset(15 + (status + 1) * 51);
    }];
}

- (UIView *)creatViewWithTitle:(NSString *)title
{
    UIView *view = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(51);
        make.left.right.equalTo(self.view);
    }];
    
    UIView *line = [UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:view];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.bottom.equalTo(view);
    }];
    
    UILabel *titleLabel = [UILabel jh_labelWithFont:15 textColor:RGB515151 addToSuperView:view];
    titleLabel.text = title;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.centerY.equalTo(view);
    }];
    
    return view;
}

- (void)switchAutoPlayStatus:(JHAutoPlayStatus)status
{
    [self.selectedIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom).offset(15 + (status + 1) * 51);
    }];
    
    [[NSUserDefaults standardUserDefaults] setInteger:status forKey:@"autoPlaySettingStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// -1：WiFi + 4G自动播放
///  0：wifi自动播放
///  1：关闭自动播放
+ (JHAutoPlayStatus)getAutoPlayStatus;
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"autoPlaySettingStatus"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
