//
//  JHCustomerCerEditBusiness.m
//  TTjianbao
//
//  Created by user on 2020/11/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerCerEditBusiness.h"
#import "NSObject+Cast.h"

@implementation JHCustomerCerEditBusiness

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:@[
            @{
                @"id":@(JHCerEditCellStyle_Image),
                @"title":@"image",
                @"value":@"",
                @"noMess":@"请添加证书图片",
                @"moreMess":@"",
                @"maxCount":@(0),
                @"status":@(JHCerEditCellStatus_NoMess),
            }, @{
                @"id":@(JHCerEditCellStyle_Title),
                @"title":@"证书名称",
                @"value":@"",
                @"noMess":@"请输入证书名称",
                @"moreMess":@"名称太长，请小于20个字",
                @"maxCount":@(20),
                @"status":@(JHCerEditCellStatus_NoMess),
            }, @{
                @"id":@(JHCerEditCellStyle_Prize),
                @"title":@"奖    项：",
                @"placeHolder":@"请输入奖项名称（100字以内）",
                @"value":@"",
                @"noMess":@"请输入奖项名称",
                @"moreMess":@"奖项名称太长，请小于100个字",
                @"maxCount":@(100),
                @"status":@(JHCerEditCellStatus_NoMess),
            }, @{
                @"id":@(JHCerEditCellStyle_Owner),
                @"title":@"持 证 人：",
                @"placeHolder":@"请输入持证人名称（10字以内）",
                @"value":@"",
                @"noMess":@"请输入持证人",
                @"moreMess":@"持证人太长，请小于10个字",
                @"maxCount":@(10),
                @"status":@(JHCerEditCellStatus_NoMess),
            }, @{
                @"id":@(JHCerEditCellStyle_Date),
                @"title":@"发证日期：",
                @"placeHolder":@"点击选择",
                @"value":@"",
                @"noMess":@"请输入发证日期",
                @"maxCount":@(0),
                @"status":@(JHCerEditCellStatus_NoMess),
            }, @{
                @"id":@(JHCerEditCellStyle_Business),
                @"title":@"发证机构：",
                @"placeHolder":@"请输入发证机构（20字以内）",
                @"value":@"",
                @"noMess":@"请输入发证机构",
                @"moreMess":@"发证机构太长，请小于20个字",
                @"maxCount":@(20),
                @"status":@(JHCerEditCellStatus_NoMess),
            }
        ]];
    }
    return _dataArray;
}

- (void)replaceObjectStyle:(JHCerEditCellStyle)style value:(id)val {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[style]];
    if (dict) {
        if (!val || isEmpty(val)) {
            [dict setValue:@"" forKey:@"value"];
            [dict setValue:@(JHCerEditCellStatus_NoMess) forKey:@"status"];
            [self.dataArray replaceObjectAtIndex:style withObject:dict];
            return;
        }
        switch (style) {
            case JHCerEditCellStyle_Image: {  /// 图
                [dict setValue:@(JHCerEditCellStatus_Normale) forKey:@"status"];
                [dict setValue:val forKey:@"value"];
                [self.dataArray replaceObjectAtIndex:style withObject:dict];
            }
                break;
            case JHCerEditCellStyle_Title: /// 名称
            case JHCerEditCellStyle_Prize: /// 奖项
            case JHCerEditCellStyle_Owner: /// 持证人
            case JHCerEditCellStyle_Business: { /// 发证机构
                NSString *str = [NSString cast:val];
                if (str.length < 1) {
                    [dict setValue:@(JHCerEditCellStatus_NoMess) forKey:@"status"];
                    return;
                }
                if (str.length > [dict[@"maxCount"] integerValue]) {
                    [dict setValue:@(JHCerEditCellStatus_MoreMess) forKey:@"status"];
                } else {
                    [dict setValue:@(JHCerEditCellStatus_Normale) forKey:@"status"];
                }
                [dict setValue:val forKey:@"value"];
                [self.dataArray replaceObjectAtIndex:style withObject:dict];
            }
                break;
            case JHCerEditCellStyle_Date: { /// 发证日期
                [dict setValue:val forKey:@"value"];
                [dict setValue:@(JHCerEditCellStatus_Normale) forKey:@"status"];
                [self.dataArray replaceObjectAtIndex:style withObject:dict];
            }
                break;
            default:
                break;
        }
        
    }
}


@end
