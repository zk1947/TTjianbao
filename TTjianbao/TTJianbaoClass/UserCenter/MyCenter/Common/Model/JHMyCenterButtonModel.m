//
//  JHMyCenterButtonModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterButtonModel.h"

@implementation JHMyCenterButtonModel

+ (JHMyCenterButtonModel *)creatWithIcon:(NSString *)icon name:(NSString *)name type:(JHMyCenterButtonType)type
{
    JHMyCenterButtonModel *model = [JHMyCenterButtonModel new];
    model.icon = icon;
    model.name = name;
    model.type = type;
    return model;
}

+ (void)pushWithType:(JHMyCenterButtonType)type{
    
    switch (type) {
        case JHMyCenterButtonTypeReward:
            {
                [JHRouterManager pushRewardViewController];
            }
            break;
            
            case JHMyCenterButtonTypeSetCover:
            {
                [JHRouterManager pushSetCoverViewController];
            }
            break;
            
            case JHMyCenterButtonTypeOrderAppraisal:
            {
                [JHRouterManager pushOrderAppraiseViewController];
            }
            break;
            
            case JHMyCenterButtonTypeAppraisalRecord:
            {
                [JHRouterManager pushAppraiseRecoreViewController];
            }
            break;
            
            case JHMyCenterButtonTypeGetAppraisal:
            {
                [JHRouterManager pushGetAppraseListViewController];
            }
            break;
            
            case JHMyCenterButtonTypeAppraisalReply:
            {
                [JHRouterManager pushAppraisalReplyViewController];
            }
            break;
            
            case JHMyCenterButtonTypeMute:
            {
                [JHRouterManager pushMuteViewController];
            }
            break;
            
        default:
            break;
    }
}

@end
