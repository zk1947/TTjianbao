//
//  JHAnnouncementDisplayView.h
//  TTjianbao
//
//  Created by Donto on 2020/7/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JHAnnouncementDisplayStyle) {
    //！观众端展示，可以关闭到小窗口
    JHAnnouncementDisplayAudience,
    //！添加公告时示例展示，只能显示不能操作
    JHAnnouncementDisplayExample
};

NS_ASSUME_NONNULL_BEGIN

@protocol JHAnnouncementDisplayViewDelegate <NSObject>

- (void)recoverMaxView;

@end

@interface JHAnnouncementDisplayView : UIView

@property (nonatomic, readonly) JHAnnouncementDisplayStyle style;
@property (nonatomic, strong) UIImage *announcementImage;
@property (nonatomic, weak) id <JHAnnouncementDisplayViewDelegate>delegate;
+ (instancetype)announcementDisplay:(JHAnnouncementDisplayStyle)style;
@end

NS_ASSUME_NONNULL_END
