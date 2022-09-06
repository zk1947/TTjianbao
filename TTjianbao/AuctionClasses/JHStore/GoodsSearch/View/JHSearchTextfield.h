//
//  JHSearchTextfield.h
//  TTjianbao
//
//  Created by LiHui on 2020/2/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHSearchTextfield;

@protocol JHSearchTextfieldDelegate <NSObject>

@optional
- (BOOL)searchTextfieldTextDidClear:(JHSearchTextfield *_Nonnull)searchTextfield;

///搜索框即将点击返回键
- (BOOL)searchTextfieldShouldReturn:(JHSearchTextfield *_Nonnull)searchTextfield;

- (void)searchTextfieldTextDidChange:(JHSearchTextfield *_Nonnull)searchTextfield searchFieldText:(NSString *_Nonnull)searchTextfieldText;

- (BOOL)searchTextfieldShouldChangeCharactersInRange:(NSRange)range searchTextField:(JHSearchTextfield *_Nonnull)searchTextfield;

- (void)searchTextFieldDidBegin:(JHSearchTextfield *_Nonnull)searchTextField;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchTextfield : UIView

@property (nonatomic, weak) id<JHSearchTextfieldDelegate>delegate;

@property (nonatomic, strong) UITextField *searchTextField; ///搜索框

///搜索框中的文字
//@property (nonatomic, copy) NSString *text;
///搜索框文字颜色
@property (nonatomic, strong) UIColor *textColor;
///搜索框文字字体大小
@property (nonatomic, strong) UIFont *font;
///占位文字
@property (nonatomic, copy) NSString *placeholder;

///占位字符数组
@property (nonatomic, copy) NSArray *placeholders;

///当前轮询的下标
@property (nonatomic, assign, readonly) NSInteger currentIndex;

- (void)hidePlaceholder;

///添加点击事件
- (void)addTapBlock:(void(^)(id obj))tapAction;

@end

NS_ASSUME_NONNULL_END
