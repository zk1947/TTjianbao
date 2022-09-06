//
//  JHTagView.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  标签<e.g.版块图标+版块名称>
//

#import "YYControl.h"

typedef void (^JHTagClickBlock) (void);

typedef NS_ENUM(NSInteger, JHTagViewStyle) {
    /**版块tag样式*/
    JHTagViewStylePlate = 0,
    ///鉴定帖标签样式
    JHTagViewStyleAppraisePlate,
};


NS_ASSUME_NONNULL_BEGIN

@interface JHTagView : YYControl

@property (nonatomic, copy) NSString *title;

+ (instancetype)tagWithStyle:(JHTagViewStyle)style clickBlock:(JHTagClickBlock)clickBlock;
///设置标签样式
@property (nonatomic, assign) JHTagViewStyle tagViewStyle;


@end

NS_ASSUME_NONNULL_END
