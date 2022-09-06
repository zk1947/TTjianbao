//
//  JHPersonalResellViewController.m
//  TTjianbao
//
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPersonalResellViewController.h"
#import "JHPersonalResellView.h"

@interface JHPersonalResellViewController ()

@property (nonatomic, strong) JHPersonalResellView* resellView;
@end

@implementation JHPersonalResellViewController

-(void)dealloc
{
    NSLog(@"JHPersonalResellViewController~~");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //绘制
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
    self.jhTitleLabel.text=@"个人转售";
    [self.view addSubview:self.resellView];
//    JH_WEAK(self)
    [self.resellView drawSubviews:^(id sender) {
//        JH_STRONG(self)
    }];
}

- (JHPersonalResellView *)resellView
{
    if(!_resellView)
    {
        _resellView = [[JHPersonalResellView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, self.view.width, self.view.height - UI.statusAndNavBarHeight)];
    }
    return _resellView;
}

@end
