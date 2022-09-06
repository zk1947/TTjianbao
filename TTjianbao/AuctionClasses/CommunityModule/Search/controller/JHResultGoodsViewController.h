//
//  JHResultGoodsViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/4/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JXCategoryView.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHResultGoodsViewController : UIViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, copy) NSString *keyword;  ///关键字
@property (nonatomic, copy) NSString *keywordSource;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
