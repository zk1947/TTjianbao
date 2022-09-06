//
//  JHPubTopicViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListPlayerViewController.h"
#import "JHUserInfoApiManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPubTopicViewController : JHBaseListPlayerViewController

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *titleString;
@end

NS_ASSUME_NONNULL_END
