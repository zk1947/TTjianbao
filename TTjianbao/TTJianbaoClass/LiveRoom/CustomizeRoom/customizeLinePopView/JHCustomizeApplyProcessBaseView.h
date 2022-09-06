//
//  JHCustomizeApplyProcessBaseView.h
//  TTjianbao
//
//  Created by apple on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOwnMaterialsApplyCustomModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeApplyProcessBaseView : UIControl
- (void)showAlert;

- (void)pushAlertView;
- (void)popAlertView;
- (void)creatBottomBtn:(NSInteger)btnNum;

@property(nonatomic,strong) UIView * bar;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic, strong) UIButton* sureBtn;
@property(nonatomic,strong) JHOwnMaterialsApplyCustomModel *applyModel;
@property (nonatomic, copy) JHActionBlock completeBlock;
@end

NS_ASSUME_NONNULL_END
