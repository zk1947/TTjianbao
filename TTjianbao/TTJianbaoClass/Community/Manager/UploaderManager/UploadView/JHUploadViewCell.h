//
//  JHUploadViewCell.h
//  TTjianbao
//
//  Created by apple on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHArticleItemModel;

@protocol JHUploadViewCellDelegate <NSObject>

///取消上传
- (void)cancelUpload:(NSIndexPath *)indexPath;
///重新上传
- (void)reUpload:(NSIndexPath *)indexPath;


@end

@interface JHUploadViewCell : UITableViewCell

@property (nonatomic, weak) id<JHUploadViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) JHArticleItemModel *article;

- (void)setIsShowReload:(BOOL)isShowReload;

@end


NS_ASSUME_NONNULL_END
