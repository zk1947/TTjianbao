//
//  JHLiveRoomListView.h
//  TTjianbao
//
//  Created by 于岳 on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHLiveRoomListViewCellModel;
NS_ASSUME_NONNULL_BEGIN
@protocol JHLiveRoomListViewDelegate<NSObject>
-(void)didSelectedItem:(JHLiveRoomListViewCellModel *)model;
@end
@interface JHLiveRoomListView : UIView
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,weak) id<JHLiveRoomListViewDelegate> delegate;
-(void)updateData:(NSArray *)dataArr;
@end

NS_ASSUME_NONNULL_END
