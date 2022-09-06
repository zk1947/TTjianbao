//
//  JHLiveRoomMode.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/11.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHLiveRoomMode.h"
#import "BannerMode.h"

@implementation JHLiveRoomMode
- (instancetype) init {
    self = [super init];
    if (self) {
            _title_row = 2;
            self.wh_scale=1;
            self.picHeight = (ScreenW-25) * 0.5 / self.wh_scale;
    }
    return self;
}

- (void)setAppraiserTags:(NSArray<NSString *> *)appraiserTags {
    _appraiserTags = [appraiserTags sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
}

- (void)setWatchTotal:(NSString *)watchTotal{
    NSString *watchTotalStr = @"";
    double watchTotalInt = watchTotal.doubleValue;
    if (watchTotalInt > 10000) {
        watchTotalStr = [NSString stringWithFormat:@"%.1f", watchTotalInt / 10000.f];
        NSArray *array = [watchTotalStr componentsSeparatedByString:@"."];
        if (array.count == 2) {
            NSString *string = array.lastObject;
            if ([string isEqualToString:@"0"]) {
                watchTotalStr = array.firstObject;
            }
        }
        watchTotalStr = [NSString stringWithFormat:@"%@万", watchTotalStr];
    }else{
        watchTotalStr = watchTotal;
    }
    _watchTotalString = watchTotalStr;
}
-(CGFloat)height{
      [self calculateTitleheigh];
      return  [self calculateCellheigh];
}
- (void)calculateTitleheigh
{
//    if (self.title&&[self.title length]>0){
//        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:self.title?:@""];//
//        [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:14] range:NSMakeRange(0, attri.length)];
//        CGFloat titleH = [attri boundingRectWithSize:CGSizeMake((ScreenW-25) * 0.5 - 10, 25 * self.title_row) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
//        NSLog(@"titleH===%lf",titleH);
//              self.titleHeight = titleH > 25 * self.title_row ? 25 * self.title_row : ceil(titleH);
//    }
//    else{
//          self.titleHeight = 0;
//    }
//    return;
    if (self.title&&[self.title length]>0) {
        NSDictionary *attribute =@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:14]};
        CGFloat titleH = [self.title boundingRectWithSize:CGSizeMake((ScreenW-25) * 0.5 - 10, 25 * self.title_row) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
        NSLog(@"titleH===%lf",titleH);
        self.titleHeight = titleH > 25 * self.title_row ? 25 * self.title_row : ceil(titleH);
    }
    else{
        self.titleHeight = 0;
    }
  
}

- (CGFloat)calculateCellheigh
{
    return ceil(self.picHeight)+ceil(self.titleHeight)+60;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"channelLocalId",
             };
}

- (void)setCoverImg:(NSString *)coverImg {
    _coverImg = [coverImg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setSmallCoverImg:(NSString *)smallCoverImg {
    _smallCoverImg = [smallCoverImg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

-(void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues{
    
     // _tagContent = @"全名辅导费";
    if ([_tagContent isKindOfClass:[NSString class]]&&_tagContent.length>0) {
        NSMutableString * str = [NSMutableString stringWithCapacity:10];
        for (int i = 0; i<_tagContent.length; i++) {
            [str appendString:[_tagContent substringWithRange:NSMakeRange(i, 1)]];
            if (i!=_tagContent.length-1) {
                [str appendString:@"\n"];
            }
        }
        _tagContent = str;
    }
   
}

- (void)setLandingTarget:(NSString *)landingTarget {
    _landingTarget = landingTarget;
    NSDictionary *dic = [_landingTarget mj_JSONObject];
    _target = [TargetModel mj_objectWithKeyValues:dic];
}


@end

@implementation JHChannelData

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"channels" : @"JHLiveRoomMode",
             };
    
}
@end
