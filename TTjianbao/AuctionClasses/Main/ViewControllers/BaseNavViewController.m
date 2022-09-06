//
//  BaseNavViewController.m
//  YouPinFenQi
//
//  Created by jiangchao on 2017/6/22.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseNavViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&& animated == YES ){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
//    if (viewControllerToPresent.modalPresentationStyle<0) {
//        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
//    }
//    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
//}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        if (navigationController.childViewControllers.count == 1) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }else {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 屏蔽调用rootViewController的滑动返回手势
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] || self.isForbidDragBack) {
            return NO;
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
