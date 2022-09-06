//
//  SAAutoTrackUtils.m
//  SensorsAnalyticsSDK
//
//  Created by MC on 2019/4/22.
//  Copyright © 2019-2020 Sensors Data Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif

#import "SAAutoTrackUtils.h"
#import "SAConstants+Private.h"
#import "SACommonUtility.h"
#import "SensorsAnalyticsSDK.h"
#import "UIView+SAElementSelector.h"
#import "UIView+AutoTrack.h"
#import "SALog.h"
#import "SAAlertController.h"
#import "SAValidator.h"

/// 一个元素 $AppClick 全埋点最小时间间隔，100 毫秒
static NSTimeInterval SATrackAppClickMinTimeInterval = 0.1;

@implementation SAAutoTrackUtils

+ (UIViewController *)findNextViewControllerByResponder:(UIResponder *)responder {
    UIResponder *next = [responder nextResponder];
    do {
        if ([next isKindOfClass:UIViewController.class]) {
            UIViewController *vc = (UIViewController *)next;
            if ([vc isKindOfClass:UINavigationController.class]) {
                next = [(UINavigationController *)vc topViewController];
                break;
            } else if ([vc isKindOfClass:UITabBarController.class]) {
                next = [(UITabBarController *)vc selectedViewController];
                break;
            }
            UIViewController *parentVC = vc.parentViewController;
            if (parentVC) {
                if ([parentVC isKindOfClass:UINavigationController.class] ||
                    [parentVC isKindOfClass:UITabBarController.class] ||
                    [parentVC isKindOfClass:UIPageViewController.class] ||
                    [parentVC isKindOfClass:UISplitViewController.class]) {
                    break;
                }
            } else {
                break;
            }
        }
    } while ((next = next.nextResponder));
    return [next isKindOfClass:UIViewController.class] ? (UIViewController *)next : nil;
}

+ (UIViewController *)currentViewController {
    __block UIViewController *currentViewController = nil;
    void (^ block)(void) = ^{
        UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        currentViewController = [SAAutoTrackUtils findCurrentViewControllerFromRootViewController:rootViewController isRoot:YES];
    };

    [SACommonUtility performBlockOnMainThread:block];
    return currentViewController;
}

+ (UIViewController *)findCurrentViewControllerFromRootViewController:(UIViewController *)viewController isRoot:(BOOL)isRoot {
    if (viewController.presentedViewController && ![viewController.presentedViewController isKindOfClass:UIAlertController.class]) {
         return [self findCurrentViewControllerFromRootViewController:viewController.presentedViewController isRoot:NO];
     }

    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self findCurrentViewControllerFromRootViewController:[(UITabBarController *)viewController selectedViewController] isRoot:NO];
    }

    if ([viewController isKindOfClass:[UINavigationController class]]) {
        // 根视图为 UINavigationController
        UIViewController *topViewController = [(UINavigationController *)viewController topViewController];
        return [self findCurrentViewControllerFromRootViewController:topViewController isRoot:NO];
    }

    if (viewController.childViewControllers.count > 0) {
        if (viewController.childViewControllers.count == 1 && isRoot) {
            return [self findCurrentViewControllerFromRootViewController:viewController.childViewControllers.firstObject isRoot:NO];
        } else {
            __block UIViewController *currentViewController = viewController;
            //从最上层遍历（逆序），查找正在显示的 UITabBarController 或 UINavigationController 类型的
            // 是否包含 UINavigationController 或 UITabBarController 类全屏显示的 controller
            [viewController.childViewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                // 判断 obj.view 是否加载，如果尚未加载，调用 obj.view 会触发 viewDidLoad，可能影响客户业务
                if (obj.isViewLoaded) {
                    CGPoint point = [obj.view convertPoint:CGPointZero toView:nil];
                    CGSize windowSize = obj.view.window.bounds.size;
                   // 正在全屏显示
                    BOOL isFullScreenShow = !obj.view.hidden && obj.view.alpha > 0 && CGPointEqualToPoint(point, CGPointZero) && CGSizeEqualToSize(obj.view.bounds.size, windowSize);
                   // 判断类型
                    BOOL isStopFindController = [obj isKindOfClass:UINavigationController.class] || [obj isKindOfClass:UITabBarController.class];
                    if (isFullScreenShow && isStopFindController) {
                        currentViewController = [self findCurrentViewControllerFromRootViewController:obj isRoot:NO];
                        *stop = YES;
                    }
                }
            }];
            return currentViewController;
        }
    } else if ([viewController respondsToSelector:NSSelectorFromString(@"contentViewController")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIViewController *tempViewController = [viewController performSelector:NSSelectorFromString(@"contentViewController")];
#pragma clang diagnostic pop
        if (tempViewController) {
            return [self findCurrentViewControllerFromRootViewController:tempViewController isRoot:NO];
        }
    } 
    return viewController;
}

+ (BOOL)isAlertForResponder:(UIResponder *)responder {
    do {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        BOOL isUIAlertView = [responder isKindOfClass:UIAlertView.class];
        BOOL isUIActionSheet = [responder isKindOfClass:UIActionSheet.class];
#pragma clang diagnostic pop

        BOOL isUIAlertController = [responder isKindOfClass:UIAlertController.class];

        if ([[responder nextResponder] isKindOfClass:SAAlertController.class]) {
            return NO;
        }
        if (isUIAlertController || isUIAlertView || isUIActionSheet) {
            return YES;
        }
    } while ((responder = [responder nextResponder]));
    return NO;
}

/// 是否为弹框点击
+ (BOOL)isAlertClickForView:(UIView *)view {
 #ifndef SENSORS_ANALYTICS_DISABLE_PRIVATE_APIS
        if ([NSStringFromClass(view.class) isEqualToString:@"_UIInterfaceActionCustomViewRepresentationView"] || [NSStringFromClass(view.class) isEqualToString:@"_UIAlertControllerCollectionViewCell"]) { // 标记弹框
            return YES;
        }
#endif
     return NO;
}

///  在间隔时间内是否采集 $AppClick 全埋点
+ (BOOL)isValidAppClickForObject:(id<SAAutoTrackViewProperty>)object {
    if (!object) {
        return NO;
    }
    
    if (![object respondsToSelector:@selector(sensorsdata_timeIntervalForLastAppClick)]) {
        return YES;
    }

    NSTimeInterval lastTime = object.sensorsdata_timeIntervalForLastAppClick;
    NSTimeInterval currentTime = [[NSProcessInfo processInfo] systemUptime];
    if (lastTime > 0 && currentTime - lastTime < SATrackAppClickMinTimeInterval) {
        return NO;
    }
    return YES;
}

// 判断是否为 RN 元素
+ (BOOL)isKindOfRNView:(UIView *)view {
    NSArray <NSString *> *classNames = @[@"RCTSurfaceView", @"RCTSurfaceHostingView", @"RCTFPSGraph", @"RCTModalHostView", @"RCTView", @"RCTTextView", @"RCTInputAccessoryView", @"RCTInputAccessoryViewContent", @"RNSScreenContainerView", @"RNSScreen", @"RCTVideo"];
    for (NSString *className in classNames) {
        Class class = NSClassFromString(className);
        if (class && [view isKindOfClass:class]) {
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark -
@implementation SAAutoTrackUtils (Property)

+ (NSDictionary<NSString *, NSString *> *)propertiesWithViewController:(UIViewController<SAAutoTrackViewControllerProperty> *)viewController {
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    properties[SA_EVENT_PROPERTY_SCREEN_NAME] = viewController.sensorsdata_screenName;
    properties[SA_EVENT_PROPERTY_TITLE] = viewController.sensorsdata_title;
    
    if ([viewController conformsToProtocol:@protocol(SAAutoTracker)] &&
        [viewController respondsToSelector:@selector(getTrackProperties)]) {
        NSDictionary *trackProperties = [(UIViewController<SAAutoTracker> *)viewController getTrackProperties];
        if ([SAValidator isValidDictionary:trackProperties]) {
            [properties addEntriesFromDictionary:trackProperties];
        }
    }

    return [properties copy];
}

+ (NSMutableDictionary<NSString *, NSString *> *)propertiesWithAutoTrackObject:(id<SAAutoTrackViewProperty>)object {
    return [self propertiesWithAutoTrackObject:object viewController:nil isCodeTrack:NO];
}

+ (NSMutableDictionary<NSString *, NSString *> *)propertiesWithAutoTrackObject:(id<SAAutoTrackViewProperty>)object isCodeTrack:(BOOL)isCodeTrack {
    return [self propertiesWithAutoTrackObject:object viewController:nil isCodeTrack:isCodeTrack];
}

+ (NSMutableDictionary<NSString *, NSString *> *)propertiesWithAutoTrackObject:(id<SAAutoTrackViewProperty>)object viewController:(nullable UIViewController<SAAutoTrackViewControllerProperty> *)viewController {
    return [self propertiesWithAutoTrackObject:object viewController:viewController isCodeTrack:NO];
}

+ (NSMutableDictionary<NSString *, NSString *> *)propertiesWithAutoTrackObject:(id<SAAutoTrackViewProperty>)object viewController:(nullable UIViewController<SAAutoTrackViewControllerProperty> *)viewController isCodeTrack:(BOOL)isCodeTrack {
    if (![object respondsToSelector:@selector(sensorsdata_isIgnored)] || (!isCodeTrack && object.sensorsdata_isIgnored)) {
        return nil;
    }

    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    // ViewID
    properties[SA_EVENT_PROPERTY_ELEMENT_ID] = object.sensorsdata_elementId;

    viewController = viewController ? : object.sensorsdata_viewController;
    if (!isCodeTrack && viewController.sensorsdata_isIgnored) {
        return nil;
    }

    NSDictionary *dic = [self propertiesWithViewController:viewController];
    [properties addEntriesFromDictionary:dic];

    properties[SA_EVENT_PROPERTY_ELEMENT_TYPE] = object.sensorsdata_elementType;
    properties[SA_EVENT_PROPERTY_ELEMENT_CONTENT] = object.sensorsdata_elementContent;
    properties[SA_EVENT_PROPERTY_ELEMENT_POSITION] = object.sensorsdata_elementPosition;

    UIView *view = (UIView *)object;
    //View Properties
    if ([object isKindOfClass:UIView.class]) {
        [properties addEntriesFromDictionary:view.sensorsAnalyticsViewProperties];
    } else {
        return properties;
    }

    NSString *viewPath = [self viewPathForView:view atViewController:viewController];
    properties[SA_EVENT_PROPERTY_ELEMENT_SELECTOR] = viewPath;

    NSString *viewSimilarPath = [self viewSimilarPathForView:view atViewController:viewController shouldSimilarPath:YES];
    properties[SA_EVENT_PROPERTY_ELEMENT_PATH] = viewSimilarPath;

    return properties;
}

@end

#pragma mark -
@implementation SAAutoTrackUtils (ViewPath)
+ (BOOL)isIgnoredViewPathForViewController:(UIViewController *)viewController {
    SensorsAnalyticsSDK *sa = [SensorsAnalyticsSDK sharedInstance];

    BOOL isEnableVisualizedAutoTrack = [sa isVisualizedAutoTrackEnabled] && [sa isVisualizedAutoTrackViewController:viewController];
    BOOL isEnableHeatMap = [sa isHeatMapEnabled] && [sa isHeatMapViewController:viewController];
    return !isEnableVisualizedAutoTrack && !isEnableHeatMap;
}

+ (NSArray<NSString *> *)viewPathsForViewController:(UIViewController<SAAutoTrackViewPathProperty> *)viewController {
    NSMutableArray *viewPaths = [NSMutableArray array];
    do {
        [viewPaths addObject:viewController.sensorsdata_heatMapPath];
        viewController = (UIViewController<SAAutoTrackViewPathProperty> *)viewController.parentViewController;
    } while (viewController);

    UIViewController<SAAutoTrackViewPathProperty> *vc = (UIViewController<SAAutoTrackViewPathProperty> *)viewController.presentingViewController;
    if ([vc conformsToProtocol:@protocol(SAAutoTrackViewPathProperty)]) {
        [viewPaths addObjectsFromArray:[self viewPathsForViewController:vc]];
    }
    return viewPaths;
}

+ (NSArray<NSString *> *)viewPathsForView:(UIView<SAAutoTrackViewPathProperty> *)view {
    NSMutableArray *viewPathArray = [NSMutableArray array];
    do { // 遍历 view 层级 路径
        if (view.sensorsdata_heatMapPath) {
            [viewPathArray addObject:view.sensorsdata_heatMapPath];
        }
    } while ((view = (id)view.nextResponder) && [view isKindOfClass:UIView.class] && ![view isKindOfClass:UIWindow.class]);

    if ([view isKindOfClass:UIViewController.class] && [view conformsToProtocol:@protocol(SAAutoTrackViewPathProperty)]) {
        // 遍历 controller 层 路径
        [viewPathArray addObjectsFromArray:[self viewPathsForViewController:(UIViewController<SAAutoTrackViewPathProperty> *)view]];
    }
    return viewPathArray;
}

+ (NSString *)viewPathForView:(UIView *)view atViewController:(UIViewController *)viewController {
    if ([self isIgnoredViewPathForViewController:viewController]) {
        return nil;
    }
    NSArray *viewPaths = [[[self viewPathsForView:view] reverseObjectEnumerator] allObjects];
    NSString *viewPath = [viewPaths componentsJoinedByString:@"/"];

    return viewPath;
}

/// 获取模糊路径
+ (NSString *)viewSimilarPathForView:(UIView *)view atViewController:(UIViewController *)viewController shouldSimilarPath:(BOOL)shouldSimilarPath {
    if ([self isIgnoredViewPathForViewController:viewController]) {
        return nil;
    }

    NSMutableArray *viewPathArray = [NSMutableArray array];
    BOOL isContainSimilarPath = NO;

    do {
        if (isContainSimilarPath || !shouldSimilarPath) { // 防止 cell 嵌套，被拼上多个 [-]
            if (view.sensorsdata_itemPath) {
                [viewPathArray addObject:view.sensorsdata_itemPath];
            }
        } else {
            NSString *currentSimilarPath = view.sensorsdata_similarPath;
            if (currentSimilarPath) {
                [viewPathArray addObject:currentSimilarPath];
                if ([currentSimilarPath rangeOfString:@"[-]"].location != NSNotFound) {
                    isContainSimilarPath = YES;
                }
            }
        }
    } while ((view = (id)view.nextResponder) && [view isKindOfClass:UIView.class]);

    if ([view isKindOfClass:UIAlertController.class]) {
        UIViewController<SAAutoTrackViewPathProperty> *viewController = (UIViewController<SAAutoTrackViewPathProperty> *)view;
        [viewPathArray addObject:viewController.sensorsdata_itemPath];
    }

    NSString *viewPath = [[[viewPathArray reverseObjectEnumerator] allObjects] componentsJoinedByString:@"/"];

    return viewPath;
}

+ (NSInteger)itemIndexForResponder:(UIResponder *)responder {
    NSString *classString = NSStringFromClass(responder.class);
    NSArray *subResponder = nil;
    if ([responder isKindOfClass:UIView.class]) {
        UIResponder *next = [responder nextResponder];
        if ([next isKindOfClass:UISegmentedControl.class]) {
            // UISegmentedControl 点击之后，subviews 顺序会变化，需要根据坐标排序才能匹配正确
            UISegmentedControl *segmentedControl = (UISegmentedControl *)next;
            NSArray <UIView *> *subViews = segmentedControl.subviews;
            subResponder = [subViews sortedArrayUsingComparator:^NSComparisonResult (UIView *obj1, UIView *obj2) {
                if (obj1.frame.origin.x > obj2.frame.origin.x) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }];
        } else if ([next isKindOfClass:UIView.class]) {
            subResponder = [(UIView *)next subviews];
        }
    } else if ([responder isKindOfClass:UIViewController.class]) {
        subResponder = [(UIViewController *)responder parentViewController].childViewControllers;
    }

    NSInteger count = 0;
    NSInteger index = -1;
    for (UIResponder *res in subResponder) {
        if ([classString isEqualToString:NSStringFromClass(res.class)]) {
            count++;
        }
        if (res == responder) {
            index = count - 1;
        }
    }
    // 单个 UIViewController 拼接路径，不需要序号
    if ([responder isKindOfClass:UIViewController.class] && ![responder isKindOfClass:UIAlertController.class] && count == 1) {
        index = -1;
    }
    return index;
}

+ (NSString *)viewIdentifierForView:(UIView *)view {
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    NSString *value = [view jjf_varE];
    if (value) {
        [valueArray addObject:[NSString stringWithFormat:@"jjf_varE='%@'", value]];
    }
    value = [view jjf_varC];
    if (value) {
        [valueArray addObject:[NSString stringWithFormat:@"jjf_varC='%@'", value]];
    }
    value = [view jjf_varB];
    if (value) {
        [valueArray addObject:[NSString stringWithFormat:@"jjf_varB='%@'", value]];
    }
    value = [view jjf_varA];
    if (value) {
        [valueArray addObject:[NSString stringWithFormat:@"jjf_varA='%@'", value]];
    }
    if (valueArray.count == 0) {
        return nil;
    }
    NSString *viewVarString = [valueArray componentsJoinedByString:@" AND "];
    return [NSString stringWithFormat:@"%@[(%@)]", NSStringFromClass([view class]), viewVarString];
}

+ (NSString *)itemHeatMapPathForResponder:(UIResponder *)responder {
    NSString *classString = NSStringFromClass(responder.class);

    NSArray *subResponder = nil;
    if ([responder isKindOfClass:UIView.class]) {
        UIResponder *next = [responder nextResponder];
        if ([next isKindOfClass:UIView.class]) {
            subResponder = [(UIView *)next subviews];
        }
    } else if ([responder isKindOfClass:UIViewController.class]) {
        subResponder = [(UIViewController *)responder parentViewController].childViewControllers;
    }

    NSInteger count = 0;
    NSInteger index = -1;
    for (UIResponder *res in subResponder) {
        if ([classString isEqualToString:NSStringFromClass(res.class)]) {
            count++;
        }
        if (res == responder) {
            index = count - 1;
        }
    }
    return count <= 1 ? classString : [NSString stringWithFormat:@"%@[%ld]", classString, (long)index];
}

@end


#pragma mark -
@implementation SAAutoTrackUtils (IndexPath)

+ (NSMutableDictionary<NSString *, NSString *> *)propertiesWithAutoTrackObject:(UIScrollView<SAAutoTrackViewProperty> *)object didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    if (![object respondsToSelector:@selector(sensorsdata_isIgnored)] || object.sensorsdata_isIgnored) {
        return nil;
    }
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];

    id<SAAutoTrackCellProperty> cell = nil;
    if ([object isKindOfClass:UITableView.class]) {
        UITableView *tableView = (UITableView *)object;
        cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            [tableView layoutIfNeeded];
            cell = [tableView cellForRowAtIndexPath:indexPath];
        }
    } else if ([object isKindOfClass:UICollectionView.class]) {
        UICollectionView *collectionView = (UICollectionView *)object;
        cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (!cell) {
            [collectionView layoutIfNeeded];
            cell = [collectionView cellForItemAtIndexPath:indexPath];
        }
    }
    if (!cell) {
        return nil;
    }

    // ViewID
    properties[SA_EVENT_PROPERTY_ELEMENT_ID] = object.sensorsdata_elementId;

    UIViewController<SAAutoTrackViewControllerProperty> *viewController = object.sensorsdata_viewController;
    if (viewController.sensorsdata_isIgnored) {
        return nil;
    }

    NSDictionary *dic = [self propertiesWithViewController:viewController];
    [properties addEntriesFromDictionary:dic];

    properties[SA_EVENT_PROPERTY_ELEMENT_TYPE] = object.sensorsdata_elementType;
    properties[SA_EVENT_PROPERTY_ELEMENT_CONTENT] = cell.sensorsdata_elementContent;
    properties[SA_EVENT_PROPERTY_ELEMENT_POSITION] = [cell sensorsdata_elementPositionWithIndexPath:indexPath];

    //View Properties
    NSDictionary *propDict = ((UIView *)object).sensorsAnalyticsViewProperties;
    if (propDict != nil) {
        [properties addEntriesFromDictionary:propDict];
    }

    NSString *viewPath = [self viewPathForView:((UIView *)cell) atViewController:viewController];
    properties[SA_EVENT_PROPERTY_ELEMENT_SELECTOR] = viewPath;

    NSString *viewSimilarPath = [self viewSimilarPathForView:(UIView *)cell atViewController:viewController shouldSimilarPath:YES];
    properties[SA_EVENT_PROPERTY_ELEMENT_PATH] = viewSimilarPath;

    return properties;
}

+ (NSDictionary *)propertiesWithAutoTrackDelegate:(UIScrollView *)scrollView didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *properties = nil;
    @try {
        if ([scrollView isKindOfClass:UITableView.class]) {
            UITableView *tableView = (UITableView *)scrollView;
            
            if ([tableView.sensorsAnalyticsDelegate respondsToSelector:@selector(sensorsAnalytics_tableView:autoTrackPropertiesAtIndexPath:)]) {
                properties = [tableView.sensorsAnalyticsDelegate sensorsAnalytics_tableView:tableView autoTrackPropertiesAtIndexPath:indexPath];
            }
        } else if ([scrollView isKindOfClass:UICollectionView.class]) {
            UICollectionView *collectionView = (UICollectionView *)scrollView;
            if ([collectionView.sensorsAnalyticsDelegate respondsToSelector:@selector(sensorsAnalytics_collectionView:autoTrackPropertiesAtIndexPath:)]) {
                properties = [collectionView.sensorsAnalyticsDelegate sensorsAnalytics_collectionView:collectionView autoTrackPropertiesAtIndexPath:indexPath];
            }
        }
    } @catch (NSException *exception) {
        SALogError(@"%@ error: %@", self, exception);
    }
    NSAssert(!properties || [properties isKindOfClass:[NSDictionary class]], @"You must return a dictionary object ❌");
    return properties;
}
@end
