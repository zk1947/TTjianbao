//
//  JHCustomerDescCommentView.h
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerDescCommentView : UIView

@property (nonatomic, copy) void(^commentPictsAcitonBlock)(NSInteger index, NSArray *imgArr);


- (void)setViewModel:(id __nullable)viewModel;
@end

NS_ASSUME_NONNULL_END
