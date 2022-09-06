//
//  NaiveShareManager.m
//  TTjianbao
//
//  Created by jiang on 2019/8/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NaiveShareManager.h"
#import "SVProgressHUD.h"

static NaiveShareManager *shareInstance;
@interface NaiveShareManager ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong)UIDocumentInteractionController * document;
@end
@implementation NaiveShareManager

+ (NaiveShareManager *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[NaiveShareManager alloc]init];
    });
    return shareInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
      
    }
    return self;
}
- (void)nativeShare:(NSString *)path{
    if([path length] > 0)
    {
        _document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
        _document.delegate    = self;
        [_document presentPreviewAnimated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"路径为空，未获取到文件"];
    }
}

#pragma -----
#pragma UIDocumentInteractionControllerDelegate
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller{

    return JHRootController.homeTabController;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {

    return JHRootController.homeTabController.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {

    return JHRootController.homeTabController.view.frame;
}

//点击预览窗口的“Done”(完成)按钮时调用

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)controller {
  
}

// 文件分享面板弹出的时候调用

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController*)controller{
    
    NSLog(@"WillPresentOpenInMenu");
}

// 当选择一个文件分享App的时候调用

- (void)documentInteractionController:(UIDocumentInteractionController*)controller willBeginSendingToApplication:(nullable NSString*)application{
    NSLog(@"begin send : %@", application);
}

// 弹框消失的时候走的方法

-(void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController*)controller{
    
    NSLog(@"dissMiss");
    
}
@end
