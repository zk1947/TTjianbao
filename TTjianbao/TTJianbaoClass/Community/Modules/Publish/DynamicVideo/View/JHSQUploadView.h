//
//  JHSQUploadView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSQUploadManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSQUploadView : UIView

+(BOOL)show;

@property (nonatomic, copy) dispatch_block_t deleteViewBlock;

@end

NS_ASSUME_NONNULL_END

/*
 
 if([JHSQUploadView show] && !_uploadView)
 {
     JHSQUploadView *view = [JHSQUploadView new];
     [self.view addSubview: view];
     _uploadView = view;
     [view mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.equalTo(self.view);
         make.height.mas_equalTo(140);
         make.top.equalTo(self.searchBar.mas_bottom).offset(5);
     }];
     @weakify(self);
     view.deleteViewBlock = ^{
         @strongify(self);
         [self.uploadView removeFromSuperview];
         self.uploadView = nil;
     };
 }
 if(_uploadView)
 {
     [JHSQUploadManager reload];
 }
 
 */
