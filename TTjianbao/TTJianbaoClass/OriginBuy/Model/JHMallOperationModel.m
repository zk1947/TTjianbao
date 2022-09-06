//
//  JHMallOperationModel.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallOperationModel.h"



@implementation JHMallOperationModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"operationPosition" : @"JHOperationDetailModel",
         @"slideShow" : @"JHLiveRoomMode",
    };
}
-(float)height{
    float h = 0;
    for (int i=0; i< self.operationPosition.count; i++) {
        JHOperationDetailModel * mode = self.operationPosition[i];
         h = h+mode.cellHeight;
        NSLog(@"mode.cellHeight==%lf",mode.cellHeight);
    }
     return h;
}
@end


@implementation JHOperationDetailModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"definiDetails" : @"JHOperationImageModel",
    };
}
-(float)cellHeight{
    float rate = 1;
    switch (self.definiDetails.count) {
        case 1:
            rate = 90/355.;
            break;
        case 2:
            rate = 100/355.;
            break;
        case 3:
            rate = 100/355.;
            break;
        case 4:
            rate = 100/355.;
            break;
        default:
           rate = 100/355.;
            break;
    }
    
    return (ScreenW-20)*rate;
}
@end

@implementation JHOperationImageModel
-(NSDictionary*)target{
    
    return [self.landingTarget mj_JSONObject];
}
@end
