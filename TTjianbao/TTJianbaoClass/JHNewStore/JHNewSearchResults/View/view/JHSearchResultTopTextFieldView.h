//
//  JHSearchResultTopTextFieldView.h
//  TTjianbao
//
//  Created by hao on 2021/11/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchResultTopTextFieldView : UIView
@property (nonatomic,   copy) NSArray *tagsDataArray;
///点击回调
@property (nonatomic,   copy) JHFinishBlock deleteAllTagsBlock;

///搜索框中的文字
@property (nonatomic,   copy) NSString *searchText;
///搜索标签
@property (nonatomic, strong) NSMutableArray *searchTagsArray;
///推荐标签
@property (nonatomic, strong) NSMutableArray *recommendTagsArray;
///是否添加过推荐标签
@property (nonatomic, assign) BOOL isAddRecommendTags;
///搜索词
@property (nonatomic,   copy) NSString *searchWord;
@end

NS_ASSUME_NONNULL_END
