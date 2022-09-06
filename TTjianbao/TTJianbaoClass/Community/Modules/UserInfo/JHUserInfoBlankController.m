//
//  JHUserInfoBlankController.m
//  TTjianbao
//
//  Created by lihui on 2021/1/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserInfoBlankController.h"
#import "JHEmptyCollectionCell.h"

@interface JHUserInfoBlankController ()

@end

@implementation JHUserInfoBlankController

- (void)viewDidLoad {
    [super viewDidLoad];
    JHEmptyCollectionCell *cell = [[JHEmptyCollectionCell alloc] initWithFrame:self.view.bounds];
    cell.imageView.image = [UIImage imageNamed:@"img_default_page"];
    cell.label.text = @"用户不存在";
    [self.view addSubview:cell];
    
    [self.view bringSubviewToFront:self.jhNavView];
}

@end
