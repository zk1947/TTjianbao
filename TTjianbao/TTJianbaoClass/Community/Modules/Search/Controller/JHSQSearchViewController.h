//
//  JHSQSearchViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewController.h"
#import "JHBaseListPlayerViewController.h"
#import "JHSQUploadView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSQSearchViewController : JHBaseListPlayerViewController
@property (nonatomic, assign) NSInteger section_id;
@property (nonatomic, assign) NSInteger topic_id;
@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *placeholder;

@end

NS_ASSUME_NONNULL_END
