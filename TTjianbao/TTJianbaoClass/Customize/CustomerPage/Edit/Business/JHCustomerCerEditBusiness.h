//
//  JHCustomerCerEditBusiness.h
//  TTjianbao
//
//  Created by user on 2020/11/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHCerEditCellStatus) {
    JHCerEditCellStatus_Normale = 0, /// 正常文本状态
    JHCerEditCellStatus_NoMess,      /// 无消息，提示用户输入
    JHCerEditCellStatus_MoreMess     /// 超过文本限制
};

typedef NS_ENUM(NSUInteger, JHCerEditCellStyle) {
    JHCerEditCellStyle_Image = 0, /// 图
    JHCerEditCellStyle_Title,     /// 名称
    JHCerEditCellStyle_Prize,     /// 奖项
    JHCerEditCellStyle_Owner,     /// 持证人
    JHCerEditCellStyle_Date,      /// 发证日期
    JHCerEditCellStyle_Business   /// 发证机构
};

@interface JHCustomerCerEditBusiness : NSObject
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void)replaceObjectStyle:(JHCerEditCellStyle)style value:(id)val;

@end

NS_ASSUME_NONNULL_END
