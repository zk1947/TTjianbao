//
//  JHReplyViewController.m
//  TTjianbao
//
//  Created by mac on 2019/9/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHReplyViewController.h"

@interface JHReplyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation JHReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
//    
//    [self.navbar setTitle:@"问题回复"];
    self.title = @"问题回复";  //背景颜色不一致
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);

}

- (IBAction)submitAction:(id)sender {
}


@end
