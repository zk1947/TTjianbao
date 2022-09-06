//
//  JHPutawayViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"

typedef NS_ENUM(NSUInteger, JHStoneEditType)
{
    JHStoneEditTypeDefault,
    JHStoneEditTypeWithData, //已有数据,暂时未用
    JHStoneEditTypeReqData, //请求数据,二次编辑
};

NS_ASSUME_NONNULL_BEGIN

@interface JHPutawayViewController : JHBaseViewExtController
//1203283609065537538
@property (nonatomic, copy) NSString *stoneRestoreId;
@property (nonatomic, assign) BOOL isOnlyLibrary;//只能调用相册
@property (nonatomic, assign) JHStoneEditType editType;
@property (nonatomic, copy) JHActionBlock baseFinishBlock;
@end

NS_ASSUME_NONNULL_END
