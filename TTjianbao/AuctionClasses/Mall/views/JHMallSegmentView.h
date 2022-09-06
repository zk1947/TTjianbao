//

//  TTjianbao
//
//  Created by jiangchao on 2019/5/12.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^JHDiscoverSegmentClickAction)(UIButton *titleBtn);
typedef void (^JHDiscoverSegmentClickMoreAction)(void);

@interface JHMallSegmentView : UICollectionReusableView
@property (nonatomic, copy) JHDiscoverSegmentClickAction clickeHeader;
@property (nonatomic, copy) JHDiscoverSegmentClickMoreAction clickeMoreHeader;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger type;
-(void)buttonPress:(UIButton*)button;
-(void)setUpSegmentView:(NSMutableArray*)cates defaultSelectIndex:(NSInteger)index;

//- (void)showRedFlag;
- (void)dismissRedFlag;
@end
