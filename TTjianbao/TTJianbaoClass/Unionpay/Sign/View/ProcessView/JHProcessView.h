//
//  JHProcessView.h
//  TTjianbao
//
//  Created by lihui on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHProcessView : UIView

///需要展示的流程的数据
@property (nonatomic, copy) NSArray *processArray;

@property (nonatomic, assign) NSInteger currentSelectIndex;  ///当前选中的页面


///刷新数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
