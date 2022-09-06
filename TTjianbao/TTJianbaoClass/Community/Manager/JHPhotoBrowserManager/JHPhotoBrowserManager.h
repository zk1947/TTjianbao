//
//  JHPhotoBrowserManager.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GKPhotoBrowser/GKPhotoBrowser.h>

NS_ASSUME_NONNULL_BEGIN


@interface JHPhotoBrowserManager : NSObject


/**
 * 图片预览，默认没有查看原图功能
 * @param images 所有图片地址
 * @param source 所有图片容器
 * @param index 将要显示的图片下标
 */
+ (void)showPhotoBrowserImages:(NSArray<NSString *> *)images
                       sources:(NSArray<UIImageView *> *__nullable)sources
                  currentIndex:(NSInteger)index;

/** 图片浏览，可选查看原图 */
+ (void)showPhotoBrowserThumbImages:(NSArray<NSString *> *)images
                         origImages:(NSArray<NSString *> *)origImages
                            sources:(NSArray<UIImageView *> *__nullable)sources
                       currentIndex:(NSInteger)currenIndex
                canPreviewOrigImage:(BOOL)canPreviewOrigImage
                          showStyle:(GKPhotoBrowserShowStyle)showStyle;

+ (void)showPhotoBrowserThumbImages:(NSArray<NSString *> *)images
                       mediumImages:(NSArray<NSString *>*)mediumImages
                         origImages:(NSArray<NSString *> *)origImages
                            sources:(NSArray<UIImageView *> *__nullable)sources
                       currentIndex:(NSInteger)currenIndex
                canPreviewOrigImage:(BOOL)canPreviewOrigImage
                          showStyle:(GKPhotoBrowserShowStyle)showStyle;
/** 图片浏览，可选隐藏下载 */
+ (void)showPhotoBrowserThumbImages:(NSArray<NSString *> *)images
                         origImages:(NSArray<NSString *> *)origImages
                            sources:(NSArray<UIImageView *> *__nullable)sources
                       currentIndex:(NSInteger)currenIndex
                canPreviewOrigImage:(BOOL)canPreviewOrigImage
                          showStyle:(GKPhotoBrowserShowStyle)showStyle
                       hideDownload: (BOOL) hideDownload;

+ (void)showPhotoBrowserThumbImages:(NSArray<NSString *> *)images
                       mediumImages:(NSArray<NSString *>*)mediumImages
                         origImages:(NSArray<NSString *> *)origImages
                            sources:(NSArray<UIImageView *> *__nullable)sources
                       currentIndex:(NSInteger)currenIndex
                canPreviewOrigImage:(BOOL)canPreviewOrigImage
                          showStyle:(GKPhotoBrowserShowStyle)showStyle
                       hideDownload: (BOOL) hideDownload;
@end

NS_ASSUME_NONNULL_END
