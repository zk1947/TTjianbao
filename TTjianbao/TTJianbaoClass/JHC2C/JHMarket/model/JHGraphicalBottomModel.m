//
//  JHGraphicalBottomModel.m
//  TTjianbao
//
//  Created by miao on 2021/7/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphicalBottomModel.h"
#import "NSString+NTES.h"

@implementation JHGraphicalBottomModel

- (void)setKindName:(NSString *)kindName {
    _kindName = kindName;
    if  ([self.kindName isEqual:@"toPayBtnFlag"]){
        _titleName = @"立即支付";
        _selName = @"toPayWith:";
        
    }
    
    if  ([self.kindName isEqual:@"cancelAppraisalBtnFlag"]){
        _titleName = @"取消鉴定";
        _selName = @"cancelAppraisalWith:";
    }
  
    if  ([self.kindName isEqual:@"seeReportBtnFlag"]){
        _titleName = @"查看报告";
        _selName = @"checkTheReportWith:";
    }
    
    if  ([self.kindName isEqual:@"deleteOrderBtnFlag"]){
        _titleName = @"删除";
        _selName = @"toDeleteWith:";
    }
    
}

- (CGFloat)titleSizeWidth {
    
    CGSize titleSize  = [self.titleName stringSizeWithFont:[UIFont systemFontOfSize:12]];
    return titleSize.width < 49 ? 49.f : titleSize.width;
}

- (BOOL)isShowUISpecial {
    
    if ([self.kindName isEqual:@"deleteOrderBtnFlag"] || [self.kindName isEqual:@"cancelAppraisalBtnFlag"]) {
        return NO;
    }
    return YES;
}

@end
