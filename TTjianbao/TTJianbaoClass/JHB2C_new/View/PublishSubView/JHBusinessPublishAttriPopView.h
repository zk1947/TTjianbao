//
//  JHBusinessPublishAttriPopView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessPublishAttriPopView : UIControl
@property (nonatomic,copy)void(^sureClickBlock)(NSString * selectedStr);
@property(nonatomic,assign) BOOL isShow;
@property(nonatomic,strong) UIView * bar;
- (void)showAlert;
- (void)hiddenAlert;
- (void)setArrayModel:(NSMutableArray *)modelArray andSeletype:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
