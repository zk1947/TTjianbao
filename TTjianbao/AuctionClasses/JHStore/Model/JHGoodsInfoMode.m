//
//  JHGoodsInfoMode.m
//  TTjianbao
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsInfoMode.h"

@implementation JHGoodsInfoMode

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"coverImage" : @"cover_img"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coverImage" : [JHCoverImageMode class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"coverImage" : @"cover_img",
    };
}

- (void)setName:(NSString *)name {
    _name = name;
    NSDictionary *attrs = @{NSFontAttributeName :[UIFont fontWithName:kFontMedium size:12]};
    CGSize maxSize = CGSizeMake((ScreenW - 40)/3, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 计算文字占据的宽高
    CGSize size = [_name boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    _titleHeight = size.height < 34 ? size.height : 34;
}

- (CGFloat)height {
    return (ScreenW - 40)/3 + _titleHeight+7+8;
}

- (long long)countDownTime {
    return self.offline_at - self.server_at;
}

@end

@implementation JHCoverImageMode

- (void)setUrl:(NSString *)url {
    _url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end

@implementation JHHeaderInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"shareInfo" : @"share_info",
    };
}

- (void)setHead_img:(NSString *)head_img {
    _head_img = [head_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setBg_img:(NSString *)bg_img {
    _bg_img = [bg_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


@end

