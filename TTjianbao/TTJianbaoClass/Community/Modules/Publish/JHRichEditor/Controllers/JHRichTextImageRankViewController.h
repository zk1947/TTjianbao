//
//  JHRichTextImageRankViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHImagePickerPublishManager.h"
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRichTextImageRankViewController : JHBaseViewExtController
@property (nonatomic, strong) NSMutableArray <JHAlbumPickerModel *>*albumArray;
@property (nonatomic, copy) JHActionBlock completeBlock;

@end

NS_ASSUME_NONNULL_END
