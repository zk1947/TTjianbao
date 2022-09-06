//
//  PageView.h
//  AutographAlbum
//
//  Created by jiangchao on 2016/11/22.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageBaseView.h"
#import "PageView.h"

@class PageView;
@protocol PageViewDelgatge <NSObject>

@optional
-(void)CreatUIForPage:(PageView*)page Index:(NSInteger)pageIndex;
-(void)UpdateInfoForCurrentPage:(PageView*)page Index:(NSInteger)pageIndex;
@end



#import "BaseView.h"

@interface PageView : BaseView
-(void)createPagerView;
- (instancetype)initWithFrame:(CGRect)frame
                    WithTitles:(NSArray *)titles
                    WithColorArrays:(NSArray *)colors
                    WithViewString:(NSString*)String;

@property (strong,nonatomic) PageBaseView *pagerView;
@property(weak,nonatomic)id<PageViewDelgatge>delegate;
@property (strong,nonatomic) UIColor *topCoulor;
@property (assign,nonatomic) NSInteger viewTag;
@property (assign, nonatomic) NSInteger currentPage; /**<  页码   **/
@property (strong, nonatomic) UIColor *selectColor; /**<  选中时的颜色   **/
@property (strong, nonatomic) UIColor *unselectColor; /**<  未选中时的颜色   **/
@property (strong, nonatomic) UIColor *underlineColor; /**<  下划线的颜色   **/
@end
