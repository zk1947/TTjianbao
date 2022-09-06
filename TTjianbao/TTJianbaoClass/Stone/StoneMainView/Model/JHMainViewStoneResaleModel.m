//
//  JHMainViewStoneResaleModel.m
//  TTjianbao
//
//  Created by jiang on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMainViewStoneResaleModel.h"

@implementation JHMainViewStoneResaleModel
- (instancetype) init {
    self = [super init];
    if (self) {
        _title_row = 2;
        self.wh_scale=1;
        self.picHeight = (ScreenW-25) * 0.5 / self.wh_scale;
    }
    return self;
}
-(CGFloat)height{
    return  [self calculateCellheigh];
}
- (CGFloat)calculateCellheigh
{
    if (self.goodsTitle&&[self.goodsTitle length]>0) {
        NSDictionary *attribute =@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:14]};
        CGFloat titleH = [self.goodsTitle boundingRectWithSize:CGSizeMake((ScreenW-25) * 0.5 - 12, 25 * self.title_row) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
        NSLog(@"titleH===%lf",titleH);
        self.titleHeight = titleH > 25 * self.title_row ? 25 * self.title_row : ceil(titleH);
        return ceil(self.picHeight)+ceil(self.titleHeight)+55+3;
    }
    else{
        self.titleHeight = 0;
        return ceil(self.picHeight)+ceil(self.titleHeight)+55;
    }
}

-(CGFloat)reSaleBigCellheight{
    
    if (self.goodsTitle&&[self.goodsTitle length]>0){
        return kStoneTableCellHeight + 53;
    }
    return kStoneTableCellHeight + 28;
}
-(CGFloat)soldBigCellheight{
    
//    if (self.goodsTitle&&[self.goodsTitle length]>0){
//        return kStoneTableCellHeight + 65;
//    }
//    return kStoneTableCellHeight + 35;
    if (self.goodsTitle&&[self.goodsTitle length]>0){
        return kStoneTableCellHeight + 53;
    }
    return kStoneTableCellHeight + 28;
}

@end

@implementation JHMainViewStoneHeaderInfoModel
+ (void)requestHeaderInfoCompletion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/anon/stone-channel/report-channel-deal-and-total") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
           NSError *error=nil;
           if (completion) {
               completion(respondObject,error);
           }
       } failureBlock:^(RequestModel * _Nullable respondObject) {
           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                code:respondObject.code
                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           if (completion) {
               completion(respondObject,error);
           }
       }];
}
@end
