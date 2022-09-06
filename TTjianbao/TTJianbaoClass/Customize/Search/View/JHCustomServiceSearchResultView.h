//
//  JHCustomServiceSearchResultView.h
//  TTjianbao
//  Description:定制服务-搜索结果View
//  Created by Jesse on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomServiceSearchResultView : UIView

//加载数据,显示内容或空白页
- (void)reloadResultData:(NSArray*)array callback:(JHActionBlock)callback;
@end

NS_ASSUME_NONNULL_END
