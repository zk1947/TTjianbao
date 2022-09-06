//
//  JHC2CAllScreenPlayController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/7/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CAllScreenPlayController.h"

#import "JHPlayerViewController.h"
@interface JHC2CAllScreenPlayController ()

@property (nonatomic, strong) JHPlayerViewController *playerController;

@end

@implementation JHC2CAllScreenPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.playerController.view];
    [self.view bringSubviewToFront:self.jhNavView];
    self.jhNavView.backgroundColor = UIColor.clearColor;
    [self jhSetLightStatusBarStyle];
    self.playerController.urlString = self.videoUrl;

}



//初始化播放器页面
- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.looping = YES;
        _playerController.alwaysPlay = YES; //无论4G还是 WIFI总是播放
        _playerController.view.frame = UIScreen.mainScreen.bounds;
        [_playerController setSubviewsFrame];

        [self addChildViewController:_playerController];
    }
    return _playerController;
}




@end

