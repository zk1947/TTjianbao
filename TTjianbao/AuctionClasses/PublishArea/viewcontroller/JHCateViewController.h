//
//  JHCateViewController.h
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 Netease. All rights reserved.
//  选择分类
//

#import "JHBaseViewExtController.h"
typedef NS_ENUM(NSInteger, JHCateViewType) {
    JHCateViewTypePublish = 1, //发布分类选择列表页
    JHCateViewTypeSearch=2, //搜索分类选择列表页
    
};
NS_ASSUME_NONNULL_BEGIN

@interface JHCateViewController : JHBaseViewExtController
@property (nonatomic, copy) void(^seletedFinish)(NSString *channelID, NSString *cateID, NSString *subCateID,NSString *selString);

@property (nonatomic, assign)JHCateViewType viewType;


@end

NS_ASSUME_NONNULL_END
