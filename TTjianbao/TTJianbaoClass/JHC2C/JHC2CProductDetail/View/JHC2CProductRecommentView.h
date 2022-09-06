//
//  JHC2CProductRecommentView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductRecommentView : UIView


///埋点类型
@property(nonatomic, strong) NSString * staticTypeName;
@property(nonatomic, strong) NSString * locationProductID;

@property(nonatomic, strong) NSString * productType;

@property(nonatomic, weak) UITableView * mainTableView;

- (void)refrshWithMainScroolViewScrool:(UITableView*)scrollView;

- (void)scrTop;
@end

NS_ASSUME_NONNULL_END
