//
//  JHSearchView.h
//  TTjianbao
//  Description:带背景view：🔎+搜索+rightButton<订制>
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHTextField.h"

typedef NS_ENUM(NSUInteger, JHSearchShowType)
{
    JHSearchShowTypeDefault,
    /*右边按钮-全部<搜索>*/
    JHSearchShowTypeRightSearchAll = JHSearchShowTypeDefault,
    /*右边按钮-取消*/
    JHSearchShowTypeRightCancel,
    /*右边按钮-完成:样式和cancel一样*/
    JHSearchShowTypeRightFinish,
};

@protocol JHSearchViewDelegate <NSObject>
@optional
- (void)searchViewBeginEditing:(BOOL)editing;
- (void)searchViewChangeText:(NSString*)text;
- (void)activeButtonEvents:(JHSearchShowType)type keyword:(NSString*)keyword;

@end

@interface JHSearchView : BaseView <UITextFieldDelegate>

@property (nonatomic, weak) id<JHSearchViewDelegate>delegate;
//响应search block,与代理只能选其一
@property (nonatomic, copy) JHActionBlock searchAction;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) NSString *text;

//需要定制化的,使用这个初始化
- (instancetype)initWithShow:(JHSearchShowType)type;
- (void)dismissSearchKeyboard;
- (void)showSearchKeyboard;
@end

