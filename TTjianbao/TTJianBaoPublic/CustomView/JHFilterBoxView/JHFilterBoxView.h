//
//  JHFilterBoxView.h
//  test
//
//  Created by YJ on 2020/12/14.
//  Copyright © 2020 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHFilterBoxModel.h"

@class JHFilterBoxView;

NS_ASSUME_NONNULL_BEGIN

@protocol JHFilterBoxViewDelegate <NSObject>

//- (void)filterBoxView:(JHFilterBoxView *)filterBoxView clickButton:(NSArray *)selectedItems;

- (void)filterBoxView:(JHFilterBoxView *)filterBoxView clickButton:(NSMutableDictionary *)dic title:(NSString *)title;


@end

@interface JHFilterBoxView : UIView

@property (weak, nonatomic) id<JHFilterBoxViewDelegate>delegate;

- (instancetype)initWithTitles:(NSMutableArray<JHFilterBoxModel *> *)titles items:(NSMutableArray<NSString *> *)items cateTypes:(NSMutableArray<NSString *> *)types;

- (void)show;

- (void)dismiss;

+ (void)clearRecord;


@end

NS_ASSUME_NONNULL_END
