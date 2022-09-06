//
//  PanSwiper.m
//  PanPush
//
//  Created by lpc on 16/3/16.
//  Copyright © 2016年 lpc. All rights reserved.
//

#import "PanSwiper.h"
#import "PanPopAnimator.h"
#import "PanPushAnimator.h"
#import "PanInteractiveTransition.h"

typedef NS_ENUM(NSInteger, PanGestureRecognizer_Direction) {
    PanGestureRecognizer_Direction_None   = 0,
    PanGestureRecognizer_Direction_Left   = 1,
    PanGestureRecognizer_Direction_Right  = 2,
};

@interface PanSwiper () <UINavigationControllerDelegate,PanAnimatorDelegate,UIGestureRecognizerDelegate>

@property (weak, readwrite, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) PanInteractiveTransition *interactionController;

@property (strong, nonatomic) PanAnimator *animator;
@property (assign, nonatomic) BOOL is_Should_Begain_Animation;      //Default is NO;

@end

@implementation PanSwiper
{
    PanGestureRecognizer_Direction _panDirection;   //Default is 0;
}

- (void)dealloc
{
    [_panRecognizer removeTarget:self action:@selector(handleWithPanGestureRecongizer:)];
    [_navigationController.view removeGestureRecognizer:_panRecognizer];
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    NSCParameterAssert(!!navigationController);

    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _navigationController.delegate = self;
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)commonInit
{
    UIGestureRecognizer *gesture = self.navigationController.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;

    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWithPanGestureRecongizer:)];;
    popRecognizer.maximumNumberOfTouches = 1;
    popRecognizer.delegate=self;
    [gestureView addGestureRecognizer:popRecognizer];
    self.panRecognizer = popRecognizer;
    
    self.is_Should_Begain_Animation = NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    if (self.isForbidDragBack) {
        return NO;
    }

    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"NTESLiveBypassView"]) {
        return NO;
    }
    
    if ([NSStringFromClass([touch.view.superview class]) isEqualToString: @"JHPhotoCollectionViewCell"]) {
        return NO;
    }
    
    if (touch.view.tag == guideViewTag) {
        return NO;
    }
    
    if ([[touch.view viewController] isKindOfClass:[self.receiveTouchViewController class]])//NSClassFromString(@"JHMessageViewController")])
    {
        return NO;
    }

    return YES;
}

#pragma mark -- 偏移量、速度 --
//偏移量
- (CGFloat)translationWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    CGFloat t_x = point.x;
    return t_x;
}

//速度
- (CGFloat)velocityWithPanGestureRecongizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint point = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    return point.x;
}

//更新拖拽方向
- (CGFloat)updatePanDirection:(UIPanGestureRecognizer *)panGestureRecognizer
{
    

    CGFloat velocity_x = [self velocityWithPanGestureRecongizer:panGestureRecognizer];
    if (velocity_x > 0) {
        _panDirection = PanGestureRecognizer_Direction_Right;
    }else if (velocity_x < 0) {
        _panDirection = PanGestureRecognizer_Direction_Left;
    }else {
        _panDirection = PanGestureRecognizer_Direction_None;
    }
    
    return velocity_x;
}


#pragma mark -- PanGesture Response --

- (void)handleWithPanGestureRecongizer:(UIPanGestureRecognizer *)recognizer
{
    
    CGFloat translation_x = [self translationWithPanGestureRecongizer:recognizer];
    CGFloat progress = translation_x / recognizer.view.bounds.size.width;

    [self updatePanDirection:recognizer];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self panGrBegan:recognizer];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self panGrChanged:recognizer progress:progress];
    }
    else {
        [self panGrEnded:recognizer progress:progress];
    }
}

- (void)panGrBegan:(UIPanGestureRecognizer *)recognizer
{    
    self.animator = nil;
    self.interactionController = nil;

    if (PanGestureRecognizer_Direction_Right == _panDirection && !self.isForbidDragBack) {
        //Pop
        if (self.navigationController.viewControllers.count > 1) {            
            [self createAnimatorAndTransitionWithPop:YES];
            if (self.popAssignViewController) {
                for (UIViewController*controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:self.popAssignViewController.class]) {
                        int index = (int)[self.navigationController.viewControllers indexOfObject:controller];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
                        break;
                    }
                }
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
    else if (PanGestureRecognizer_Direction_Left == _panDirection){
        //Push
        UIViewController *nextController = [self nextController];
        if (nextController)
        {
            [self createAnimatorAndTransitionWithPop:NO];
            [self.navigationController pushViewController:nextController animated:YES];
        }
    }
}

- (void)panGrChanged:(UIPanGestureRecognizer *)recognizer progress:(CGFloat)progress
{
    if ([self.animator isKindOfClass:[PanPushAnimator class]]) {
        CGFloat temp_progress = ABS(progress);
        CGFloat panPush_progress = MIN(1.0, MAX(0.0, temp_progress));
        if (progress > 0) {
            panPush_progress = 0.0f;
        }
        [self.interactionController updateInteractiveTransition:panPush_progress];
    }
    else {
        if (!self.isForbidDragBack) {
            CGFloat panPop_progress = MIN(1.0, MAX(0.0, progress));
            [self.interactionController updateInteractiveTransition:panPop_progress];
        }
    }
}

- (void)panGrEnded:(UIPanGestureRecognizer *)recognizer progress:(CGFloat)progress
{
    if (self.interactionController || self.animator) {
        //为了防止动画进行时再次重新拖拽,可在动画结束时设置为yes
        self.panRecognizer.enabled = NO;
    }

    CGFloat final_progress = 0.0;
    CGFloat k_Default = 0.0;
    if ([self.animator isKindOfClass:[PanPushAnimator class]]) {
        CGFloat temp_progress = ABS(progress);
        CGFloat panPush_progress = MIN(1.0, MAX(0.0, temp_progress));
        if (progress > 0) {
            panPush_progress = 0.0f;
        }
        final_progress = panPush_progress;
        k_Default = k_Progress_Pan_Push;
    }
    else{
        CGFloat panPop_progress = MIN(1.0, MAX(0.0, progress));
        final_progress = panPop_progress;
        k_Default = k_Progress_Pan_Pop;
    }
    if (final_progress > k_Default) {
        [self.interactionController finishInteractiveTransition];
        
        if (_panPushDelegate && [_panPushDelegate respondsToSelector:@selector(popFinish)]) {
            [_panPushDelegate popFinish];
        }
    }
    else {
        [self.interactionController cancelInteractiveTransition];
    }

    if (_panPushDelegate && [_panPushDelegate respondsToSelector:@selector(swiperDidEndPanPushToNextController:)]) {
        [self.panPushDelegate swiperDidEndPanPushToNextController:self];
    }
    
    
}

- (UIViewController *)nextController
{
    if (_panPushDelegate && [_panPushDelegate respondsToSelector:@selector(swiperBeginPanPushToNextController:)]) {
        UIViewController *nextController = [self.panPushDelegate swiperBeginPanPushToNextController:self];
        if (nextController && [nextController isKindOfClass:[UIViewController class]]){
            return nextController;
        }
    }
    return nil;
}


#pragma mark -- Animator start and end --
- (void)createAnimatorAndTransitionWithPop:(BOOL)isPop
{
    if (isPop) {
        self.animator = [PanPopAnimator new];
    }else {
        self.animator = [PanPushAnimator new];
    }
    self.animator.delegate = self;

    self.interactionController = [PanInteractiveTransition new];
    
    self.is_Should_Begain_Animation = YES;
}

- (void)animatorDidEnd
{
    self.animator = nil;
    self.interactionController = nil;
    
    self.is_Should_Begain_Animation = NO;
    self.panRecognizer.enabled = YES;
}

#pragma mark -- PanAnimatorDelegate --
- (void)animator:(PanAnimator *)animator completeWithTransitionFinished:(BOOL)finish
{
    [self animatorDidEnd];
}

#pragma mark - UINavigationControllerDelegate -

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (self.is_Should_Begain_Animation &&
        (operation == UINavigationControllerOperationPop || operation == UINavigationControllerOperationPush)){
        return self.animator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[PanPopAnimator class]] || [animationController isKindOfClass:[PanPushAnimator class]]) {
        return self.interactionController;
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.is_Should_Begain_Animation = NO;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self animatorDidEnd];
}

@end
