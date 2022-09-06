//
//  JHRichTextImage.h
//  TTjianbao
//
//  Created by jiangchao on 2020/6/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHImagePickerPublishManager.h"
#import "YYImage.h"

@class JHRichTextImage;

@protocol JHRichTextImageDelegate<NSObject>

- (void)p_longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress;
-(void)remove:(JHRichTextImage*)image;
@end
@interface JHRichTextImage : UIView
@property (nonatomic, strong) id image;
@property(nonatomic,assign)float imageW;
@property(nonatomic,assign)float imageH;
@property (nonatomic, copy) NSString *uuid;
//
//@property (nonatomic, assign) BOOL isVideo;
//@property (nonatomic, copy) NSString *coverUrl;
//@property (nonatomic, copy) NSString *videoPath;
//@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, strong) JHAlbumPickerModel *albumModel;
@property (nonatomic, assign) id<JHRichTextImageDelegate> delegete;

- (instancetype)initWithDataSourece:(id<JHRichTextImageDelegate>)delegete;
@end
