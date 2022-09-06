//
//  JHPublishReportView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportView.h"
#import "JHPublishReportModel.h"
#import "JHPublishReportRecommendCell.h"
#import "JHPublishReportCateCell.h"
#import "JHPublishReportRecommendCollectionViewCell.h"
#import "JHPublishReportCateCollectionViewCell.h"
#import "JHPublishReportTrueFalseCell.h"
#import "JHPublishReportFalseCell.h"
#import "JHPublishReportTrueCell.h"
#import "JHPublishReportTrueOtherCell.h"
#import "JHGradientView.h"
@interface JHPublishReportView ()

@property (nonatomic, weak) UITableView *tableView;

/// 鉴定报告模型
@property (nonatomic, strong) JHReportTotalModel *reportModel;

/// 鉴定报告模型
@property (nonatomic, weak) UIView *bgView;

@end


@implementation JHPublishReportView

- (void)dealloc {
    NSLog(@"🔥");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        @weakify(self);
        
        _reportModel = [JHReportTotalModel new];
        _reportModel.updateBlock = ^{
            @strongify(self);
            [self.tableView reloadData];
        };
        
        _reportModel.removeBlock = ^{
            @strongify(self);
            [self removeFromSuperview];
        };
        [self addSelfSubViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        
    }
    return self;
}

#pragma mark -------- 键盘 --------
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.bgView.hidden = NO;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottomAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(keyboardRect.origin.y - ScreenH);
        }];
        [self layoutIfNeeded];
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    self.bgView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottomAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
        }];
        [self layoutIfNeeded];
    }];
}

- (void)addSelfSubViews {
    
    UILabel *titleLabel = [UILabel jh_labelWithText:@"评估报告" font:16 textColor:RGB(34, 34, 34) textAlignment:1 addToSuperView:self];
    [titleLabel jh_cornerRadius:8.f];
    titleLabel.backgroundColor = UIColor.whiteColor;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomAnimationView);
        make.bottom.equalTo(self.bottomAnimationView.mas_top).offset(8);
        make.height.mas_equalTo(54);
    }];
    
    
    UIButton *closeButton = [UIButton jh_buttonWithImage:@"newStore_coupon_close_icon" target:self action:@selector(dissmiss) addToSuperView:self];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(54);
        make.top.right.equalTo(titleLabel);
    }];
    
    JHGradientView *buttonBg = [JHGradientView new];
    [buttonBg setGradientColor:@[(__bridge id)RGB(254, 215, 58).CGColor,(__bridge id)RGB(254, 203, 51).CGColor] orientation:JHGradientOrientationHorizontal];
    [self.bottomAnimationView addSubview:buttonBg];
    [buttonBg jh_cornerRadius:5];
    [buttonBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomAnimationView).offset(15);
        make.right.equalTo(self.bottomAnimationView).offset(-15);
        make.top.equalTo(self.tableView.mas_bottom).offset(12);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *button = [UIButton jh_buttonWithTitle:@"提交" fontSize:16 textColor:RGB(34,34,34) target:self action:@selector(clickMethod:) addToSuperView:self.bottomAnimationView];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(buttonBg);
    }];
    
    JHGradientView *line = [JHGradientView new];
    [line setGradientColor:@[(__bridge id)RGBA(255, 255, 255, 0.38).CGColor,(__bridge id)RGBA(255, 255, 255, 1).CGColor] orientation:JHGradientOrientationVertical];
    [self.bottomAnimationView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tableView);
        make.height.mas_equalTo(20);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.reportModel.publishParams.isRecommend ? 2 : 1;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return (self.reportModel.type == 0) ? 1 : 2;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            if(indexPath.row == 0) {
                return 50.f;
            }
            else {
                return 86.f;
            }
        }
            break;
            
        case 1: {
            if(indexPath.row == 0) {
                return 50.f;
            }
            else {
                return 86.f;
            }
        }
            break;
            
        case 2: {
            if(indexPath.row == 0) {
                return 86.f;
            }
            else {
                
                return (self.reportModel.type == 1) ? 143.f : 173.f;
            }
        }
            break;
            
        default:
            return 0.f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            if(indexPath.row == 0) {
                JHPublishReportRecommendCell *cell = [JHPublishReportRecommendCell dequeueReusableCellWithTableView:tableView];
                @weakify(self);
                cell.switchBlock = ^(BOOL isRecommend) {
                    @strongify(self);
                    self.reportModel.publishParams.isRecommend = isRecommend;
                    [self.tableView reloadData];
                };
                cell.isRecommend = self.reportModel.publishParams.isRecommend;
                cell.lineHidden = self.reportModel.publishParams.isRecommend;
                return cell;
            }
            else {
                JHPublishReportRecommendCollectionViewCell *cell = [JHPublishReportRecommendCollectionViewCell dequeueReusableCellWithTableView:tableView];
                cell.recommendArray = self.reportModel.recommendArray;
                cell.lineHidden = NO;
                return cell;
            }
        }
            break;
            
        case 1: {
            if(indexPath.row == 0) {
                JHPublishReportCateCell *cell = [JHPublishReportCateCell dequeueReusableCellWithTableView:tableView];
                return cell;
            }
            else {
                JHPublishReportCateCollectionViewCell *cell = [JHPublishReportCateCollectionViewCell dequeueReusableCellWithTableView:tableView];
                cell.cateArray = self.reportModel.cateArray;
                @weakify(self);
                cell.selectBlock = ^{
                    @strongify(self);
                    [self selectedCateMethod];
                };
                return cell;
            }
        }
            break;
            
        case 2: {
            if(indexPath.row == 0) {
                JHPublishReportTrueFalseCell *cell = [JHPublishReportTrueFalseCell dequeueReusableCellWithTableView:tableView];
                @weakify(self);
                @weakify(cell);
                cell.clickBlock = ^(NSInteger type) {
                    @strongify(self);
                    @strongify(cell);
                    if(![self.reportModel selectedCate] && type == 2) {
                        JHTOAST(@"请先选择宝物类别");
                        cell.type = self.reportModel.type;
                    }
                    else {
                        self.reportModel.type = type;
                        self.reportModel.publishParams.properties = nil;
                        self.reportModel.publishParams.price = nil;
                        self.reportModel.publishParams.manulReport = nil;
                        [self resetProperties];
                    }
                    [self.tableView reloadData];
                };
                cell.type = self.reportModel.type;
                return cell;
            }
            else {
                if(self.reportModel.type == 1) {
                    JHPublishReportFalseCell *cell = [JHPublishReportFalseCell dequeueReusableCellWithTableView:tableView];
                    cell.reasonArray = self.reportModel.noPriceReasonArray;
                    cell.clickBlock = ^(NSString * _Nonnull reason) {
                        self.reportModel.publishParams.manulReport = reason;
                    };
                    if(!self.reportModel.publishParams.manulReport) {
                        [cell reset];
                    }
                    return cell;
                }
                else {
                    if([self.reportModel selectedOtherCate]) {
                        JHPublishReportTrueOtherCell *cell = [JHPublishReportTrueOtherCell dequeueReusableCellWithTableView:tableView];
                        @weakify(self);
                        cell.priceBlock = ^(NSString * _Nonnull price) {
                            @strongify(self);
                            self.reportModel.publishParams.price = price;
                        };
                        cell.descBlock = ^(NSString * _Nonnull desc) {
                            @strongify(self);
                            self.reportModel.publishParams.manulReport = desc;
                        };
                        if(!self.reportModel.publishParams.price) {
                            cell.priceTf.text = @"";
                        }
                        if(!self.reportModel.publishParams.manulReport) {
                            cell.descTf.text = @"";
                        }
                        return cell;
                    }
                    else {
                        JHPublishReportTrueCell *cell = [JHPublishReportTrueCell dequeueReusableCellWithTableView:tableView];
                        @weakify(self);
                        cell.priceBlock = ^(NSString * _Nonnull price) {
                            @strongify(self);
                            self.reportModel.publishParams.price = price;
                        };
                        cell.subCateArray = self.reportModel.subCateArray;
                        if(!self.reportModel.publishParams.price) {
                            cell.priceTf.text = @"";
                        }
                        return cell;
                    }   
                }
            }
        }
            break;
            
        default:
            return [UITableViewCell new];
            break;
    }
}

- (void)selectedCateMethod {
    @weakify(self);
    self.reportModel.type = 1;
    self.reportModel.publishParams.properties = nil;
    [self resetProperties];
    self.reportModel.publishParams.price = nil;
    self.reportModel.publishParams.manulReport = nil;

    [self.reportModel requestWithSubCateBlock:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)resetProperties {
    for (JHReportCatePropertyModel *m in self.reportModel.subCateArray) {
        m.selectValue = nil;
    }
}

- (UITableView *)tableView {
    if(!_tableView){
        _tableView = [UITableView jh_tableViewWithStyle:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone target:self addToSuperView:self.bottomAnimationView];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomAnimationView.mas_top).offset(8);
            make.left.right.equalTo(self.bottomAnimationView);
            make.height.mas_equalTo(401);
        }];
    }
    return _tableView;
}

- (void)clickMethod:(UIButton *)sender {
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    [self.reportModel submit];
}

- (UIView *)bgView {
    if(!_bgView) {
        UIView *bgView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [bgView jh_addTapGesture:^{
            [self endEditing:YES];
        }];
        _bgView = bgView;
    }
    return _bgView;
}

/// 显示鉴定报告填写页面
+ (void)showWithModel:(NTESMicConnector *)model controller:(UIViewController *)controller completeBlock:(nonnull void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))completeBlock {
    JHPublishReportView *reportView = [[JHPublishReportView alloc] initWithFrame:controller.view.bounds];
    [controller.view addSubview:reportView];
    reportView.reportModel.publishParams.appraiseRecordId = model.appraiseRecordId;
    reportView.reportModel.completeBlock = completeBlock;
    reportView.bottomAnimationViewHeight = 465 + UI.bottomSafeAreaHeight;
    [reportView show];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
