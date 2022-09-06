//
//  JHHomeCollectionViewHeaer.h
//  TTjianbao
//
//  Created by jiangchao on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHomeHeaderView.h"
#import "JHHomeHeaderMainAnchorView.h"
#import "VideoCateMode.h"
#import "JHLiveRoomMode.h"
#import "JHRecycleHomeModel.h"
#import "JHRecycleCategoryView.h"

#define kHeaderTypeCateButton (-199)

typedef void (^JHHomeHeaderSegmentClickAction)(VideoCateMode *catemode);
@protocol JHHomeHeaderViewDelegate <NSObject>

@optional
-(void)ViewLoadComplete:(UIView*)view;

@end
#import "BaseView.h"

@interface JHHomeHeaderView : BaseView
@property(nonatomic, strong)void(^viewLoadComplete)( NSInteger viewHeight);
@property (nonatomic, copy) JHActionBlock selectedCell;
@property(nonatomic, strong)void(^clickButton)(UIButton* button,JHLiveRoomMode * mode);
@property (nonatomic, copy) JHChannelData * channeData;
/// 回收
@property (nonatomic, strong) JHRecycleCategoryView *recycleView;

-(void)setChanneData:(JHChannelData *)channeData isCacheData:(BOOL)cache;
@property(weak,nonatomic)id<JHHomeHeaderViewDelegate>delegate;
-(JHHomeHeaderMainAnchorView*)getNearlyAnchorView;
@property(strong,nonatomic)NSArray * banners;

- (void)refreshThemeView:(BOOL)isActiveTheme;

@property(nonatomic, copy)void(^selectLiveBlock)(void);

- (void)updateAppraise;
- (void)bindRecycleData:(JHRecycleHomeGetRecyclePlateModel *__nullable)plateModel;

@end

@interface JHHomeHeaderSegmentView : UICollectionReusableView
@property (nonatomic, copy) JHHomeHeaderSegmentClickAction clickeHeader;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) NSInteger type;
-(void)setUpSegmentView:(NSArray*)cates;
@end



