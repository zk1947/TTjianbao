//
//  JHAppraiserUserReplyModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/5/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAppraiserUserReplyModel.h"

@implementation JHAppraiserUserReplyModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHAppraiserUserReplyData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/content/appraiseReplyList/%ld"),
                     (long)self.page];
    return url;
}

- (void)configModel:(JHAppraiserUserReplyModel *)model {
    if (!model) return;
    //if (model.list.count <= 0) return;
    
    if (self.willLoadMore) {
        [_list addObjectsFromArray:model.list];
        
    } else {
        _list = [NSMutableArray arrayWithArray:model.list];
    }
    
    self.canLoadMore = model.list.count > 0;
}

@end


#pragma mark -
#pragma mark - data
@implementation JHAppraiserUserReplyData

- (void)setImage:(NSString *)image {
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end

