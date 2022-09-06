//
//  JHLiveRoomTopTagsView.h
//  TTjianbao
//
//  Created by liuhai on 2021/4/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MSHotSearchCellDelegate <NSObject>

- (void)deleteHotKey:(NSInteger)index;
- (void)expandBtnAction;
@end

@interface JHLiveRoomTopTagsView : UIView
{
    CGSize sizeFit;

}
@property (nonatomic, assign) NSUInteger height;
- (void)setTags:(NSMutableArray *)array;
- (void)display;
- (CGSize)fittedSize;
- (instancetype)initWithArr:(NSMutableArray*)arr;
@property (nonatomic,weak)id<MSHotSearchCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
