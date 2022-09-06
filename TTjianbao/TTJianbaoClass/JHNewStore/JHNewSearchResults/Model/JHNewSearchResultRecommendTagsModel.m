//
//  JHNewSearchResultRecommendTagsModel.m
//  TTjianbao
//
//  Created by hao on 2021/10/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewSearchResultRecommendTagsModel.h"

@implementation JHNewSearchResultRecommendTagsListModel

@end

@implementation JHNewSearchResultRecommendTagsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"keyTagList" : [JHNewSearchResultRecommendTagsListModel class],
    };
}
@end
