//
//  JHRecycleMeAttentionModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleMeAttentionModel.h"

@implementation JHRecycleMeAttentionListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"images" : JHRecycleUploadImageInfoModel.class};
}

- (NSString *)categoryName{
    return [NSString stringWithFormat:@"回收分类：%@",_categoryName];
}
- (NSString *)productDesc{
    return [NSString stringWithFormat:@"回收说明：%@",_productDesc];
}
@end

@implementation JHRecycleMeAttentionModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"resultList" : JHRecycleMeAttentionListModel.class};
}

@end
