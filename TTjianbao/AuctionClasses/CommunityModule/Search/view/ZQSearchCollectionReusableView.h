//
//  ZQSearchCollectionReusableView.h
//  ZQSearchController
//
//  Created by zzq on 2018/9/25.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^emptyBlock)(void);
typedef void(^unfoldBlock)(BOOL isAll);

@interface ZQSearchCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, copy) unfoldBlock foldBlock;
- (void)showDeleteHistoryBtn:(BOOL)show
                 showMoreBtn:(BOOL)showMore
                unfoldStatus:(BOOL)showAll
                    CallBack:(void(^)(void))callBack;
- (void)moreBtnClick:(UIButton *)btn;
@end
