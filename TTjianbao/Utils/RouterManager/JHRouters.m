//
//  JHRouters.m
//  TTjianbao
//
//  Created by jesee on 02/02/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRouters.h"
#import "JHRouterManager.h"

@implementation JHRouters

+ (BOOL)gotoPageByJson:(id)aData
{
    BOOL ret = NO;
    if(aData)
    {
        JHRouterModel* model = [JHRouterModel convertData:aData];
        ret = [[self class] gotoPageByModel:model];
    }
    
    return ret;
}

+ (BOOL)gotoPageByModel:(JHRouterModel*)model
{
    BOOL ret = NO;
    if(model && (model.vc || model.componentName))
    {
        UIViewController* viewController;
        if (model.vc.length > 0) {
            viewController = [[self class] JHViewControllerByName:model.vc];
        }else{
            viewController = [[self class] JHViewControllerByName:model.componentName];
        }
        
        if(viewController)
        {
            //根据参数类型,匹配参数
            if([model.type integerValue] == JHRouterTypeParams && model.params)
            {
                [viewController mj_setKeyValues:model.params];
            }
            
            //跳转方式
            if([model.presentType integerValue] == JHRouterPresentTypePush)
            {
                [[JHRouterManager jh_getViewController].navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                [[JHRouterManager jh_getViewController] presentViewController:viewController animated:YES completion:nil];
            }
        }
    }
    
    return ret;
}


//字符串转成viewController,确保它有效且存在
+ (UIViewController*)JHViewControllerByName:(NSString*)vc
{
    UIViewController* jhViewController = nil;
    if(vc)
    {
        Class cls = NSClassFromString(vc);
        if(cls)
        {
            jhViewController = [cls new];
            if([jhViewController isKindOfClass:[UIViewController class]])
            {
                NSLog(@"~~ %@ is allocated ", vc);
            }
            else
            {
                NSLog(@"~~ %@ is not UIViewController", vc);
            }
        }
        else
        {
            NSLog(@"~~ %@ Class is not exist", vc);
        }
    }
    else
    {
        NSLog(@"~~ %@ is nil", vc);
    }
    return jhViewController;
}

@end
