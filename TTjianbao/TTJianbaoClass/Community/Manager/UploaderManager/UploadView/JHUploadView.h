//
//  JHUploadView.h
//  TTjianbao
//
//  Created by apple on 2019/10/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHUploadView;

@protocol JHUploadViewDelegate <NSObject>

///取消上传媒体
- (void)uploadView:(JHUploadView *_Nonnull)uploadView cancelUpload:(NSIndexPath *_Nonnull)indexPath;

///重新上传媒体
- (void)uploadView:(JHUploadView *_Nonnull)uploadView reUpload:(NSIndexPath *_Nonnull)indexPath;


@end

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUploadView : BaseView

@property (nonatomic, weak) id<JHUploadViewDelegate> delegate;

///更新进度条
- (void)updateProgress;

///刷新数据
- (void)reloadData;

///更新进度条数据
//- (void)updateProgress:(int)progress;



@end


NS_ASSUME_NONNULL_END
