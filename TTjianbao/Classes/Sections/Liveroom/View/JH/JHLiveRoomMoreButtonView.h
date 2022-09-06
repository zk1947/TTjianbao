//
//  JHLiveRoomMoreButtonView.h
//  TTjianbao
//
//  Created by 于岳 on 2020/7/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveRoomMoreButtonView : UIView
@property(nonatomic,strong)UIButton *btn;
-(void)updateBtnWithImage:(NSString *)icon Title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
