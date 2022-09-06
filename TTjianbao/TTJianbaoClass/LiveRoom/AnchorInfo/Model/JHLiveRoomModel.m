//
//  JHLiveRoomModel.m
//  TTjianbao
//
//  Created by lihui on 2020/7/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomModel.h"
#import "TTjianbaoMarcoUI.h"

@implementation JHLiveRoomModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"anchorList" : @"broads"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"anchorList" : [JHAnchorInfo class],
        @"fees" : [JHCustomerFeesInfo class],
        @"opusList":[JHCustomerOpusListInfo class],
        @"certificateList":[JHCustomerCertificateListInfo class],
        @"worksList":[JHCustomerWorksListInfo class],
        @"materials":[JHCustomerMaterialsInfo class],
        @"cateNames":[NSString class]
    };
}

//+ (NSDictionary *)mj_objectClassInArray {
//    return @{
//
//    };
//}

- (void)setRoomDes:(NSString *)roomDes {
    if (![roomDes isNotBlank]) {
        _roomDesHeight = 30.f;
        return;
    }
    _roomDes = roomDes;
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:roomDes];
    [introText setLineSpacing:5.f];
    [introText setAlignment:NSTextAlignmentLeft];
    [introText setLineBreakMode:NSLineBreakByCharWrapping];
    [introText addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
                               NSForegroundColorAttributeName:kColor333
    } range:NSMakeRange(0, [_roomDes length])];
    _descAttriText = introText;
    
    CGFloat descHeight = [self getMessageHeight:_roomDes];
    _roomDesAllHeight = descHeight;
    if (_roomDesAllHeight < 75.f) {
        _roomDesHeight = _roomDesAllHeight;
    }
    else {
        _roomDesHeight = 75.f;
    }
}

- (void)setCustomizeIntro:(NSString *)customizeIntro {
    if (![customizeIntro isNotBlank]) {
        _roomDesHeight = 30.f;
        return;
    }
    _customizeIntro = customizeIntro;
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:customizeIntro];
    [introText setLineSpacing:5.f];
    [introText setAlignment:NSTextAlignmentLeft];
    [introText setLineBreakMode:NSLineBreakByCharWrapping];
    [introText addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:12.f],
                               NSForegroundColorAttributeName:kColor333
    } range:NSMakeRange(0, [_customizeIntro length])];
    _customizeDescAttriText = introText;
    
    CGFloat descHeight = [self getMessageHeight:_customizeIntro];
    _roomDesAllHeight = descHeight;
    if (_roomDesAllHeight < 75.f) {
        _roomDesHeight = _roomDesAllHeight;
    }
    else {
        _roomDesHeight = 75.f;
    }
}


- (CGFloat)getMessageHeight:(NSString *)mess {
    YYLabel *descLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
    [introText setFont:[UIFont fontWithName:kFontNormal size:12]];
    [introText setLineSpacing:7.f];
    descLabel.attributedText = introText;
    CGSize introSize = CGSizeMake(ScreenWidth-30, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    descLabel.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight+10;
}

@end

@implementation JHAnchorInfo

- (void)setDes:(NSString *)des {
    _des = des;
    CGFloat desHeight = [_des heightForFont:[UIFont fontWithName:kFontNormal size:13] width:ScreenW - 25];
    CGFloat iconHeight = 26.f;
    _cellHeight = desHeight + iconHeight + 15+10+30;
}

@end

@implementation JHCustomerFeesInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"ID" : @"id"
    };
}
@end

@implementation JHAnchorRoomInfo

@end



@implementation JHCustomerCertificateListInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"ID" : @"id"
    };
}
@end


@implementation JHCustomerOpusListInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id",
        @"desc":@"description"
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"ID" : @"id",
        @"desc":@"description"
    };
}

@end


@implementation JHCustomerWorksListInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"ID" : @"id"
    };
}
@end


@implementation JHCustomerInfoShareDataModel

@end


@implementation JHCustomerMaterialsInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"ID" : @"id"
    };
}
@end
