//
//  JHFansListView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHFansBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHFansListView : JHFansBaseView
@property (nonatomic, copy) NSString  *anchorId;
- (void)show;
- (void)loadNewData;
@end

NS_ASSUME_NONNULL_END
