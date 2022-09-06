//
//  JHBusinessFansSettingLevelViewController.m
//  TTjianbao
//
//  Created by user on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansSettingLevelViewController.h"
#import "JHBusinessFansGradeEditTableViewCell.h"
#import "UIView+JHGradient.h"
#import "JHBusinessFansEquityEditTableViewCell.h"
#import "JHBusinessFansSettingEquityViewController.h"
#import "JHBusinessFansSettingBusiness.h"
#import "IQKeyboardManager.h"
#import "JHBusinessFansSettingMissionViewController.h"
#import "JHFansLeaveSectionView.h"
#import "JHNewFansLevelCell.h"


@interface JHBusinessFansLevelBottomView : UIView
@property (nonatomic, strong) UIButton         *nextButton;
@property (nonatomic,   copy) dispatch_block_t  clickBlock;
@end

@implementation JHBusinessFansLevelBottomView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xFFFFFF);
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *lineView                  = [[UIView alloc] init];
    lineView.backgroundColor          = HEXCOLOR(0xEEEEEE);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(1.f);
    }];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _nextButton.userInteractionEnabled = NO;
    _nextButton.backgroundColor = HEXCOLOR(0xEEEEEE);
    _nextButton.layer.borderWidth = 0.f;
    _nextButton.titleLabel.font     = [UIFont fontWithName:kFontNormal size:15.f];
    [_nextButton addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.layer.cornerRadius  = 19.5;
    _nextButton.layer.masksToBounds = YES;
    [self addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10.f);
        make.left.equalTo(self.mas_left).offset(40.f);
        make.right.equalTo(self.mas_right).offset(-40.f);
        make.height.mas_equalTo(44.f);
    }];
}

- (void)bottomBtnClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setNextBtnClickStatus:(BOOL)canClick {
    if (canClick) {
        self.nextButton.userInteractionEnabled = YES;
        [self.nextButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    } else {
        self.nextButton.userInteractionEnabled = NO;
        [self.nextButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xEEEEEE), HEXCOLOR(0xEEEEEE)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        self.nextButton.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
}

@end



@interface JHBusinessFansSettingLevelViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) JHBusinessFansLevelBottomView *bottomView;
@property (nonatomic, strong) UITableView                   *fansTableView;
@property (nonatomic, strong) NSMutableArray                *dataSourceArray;
@property (nonatomic, strong) JHBusinessFansSettingBusiness *business;

@property(nonatomic, strong) NSMutableDictionary *showDetailDic;

@property(nonatomic) NSInteger  currentSelSection;

@end

@implementation JHBusinessFansSettingLevelViewController

- (void)dealloc {
    NSLog(@"++++ 等级设置 release");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhNavView.hidden = YES;
    self.view.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.showDetailDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
    self.currentSelSection  = 0;
    
    [self.setModel.levelTemplateVos enumerateObjectsUsingBlock:^(JHBusinessFansLevelTemplateVosModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.check) {
            self.currentSelSection = idx;
            *stop = YES;
        }
    }];
    
    [self setupViews];
    
    if (self.setModel.levelTemplateVos.count) {
        JHBusinessFansLevelTemplateVosModel *model = self.setModel.levelTemplateVos[self.currentSelSection];
        self.applyModel.levelTemplateId = model.temID;
        self.applyModel.levelMsgList = [model.levelMsgList jh_map:^id _Nonnull(JHBusinessFansSettingLevelMsgListModel * _Nonnull obj, NSUInteger idx) {
            JHBusinessFansLevelMsgListApplyModel *aa = [JHBusinessFansLevelMsgListApplyModel new];
            aa.levelType = obj.levelType;
            aa.levelExp = obj.levelExp.longValue;
            return aa;
        }];
    }
    __block BOOL canUse = NO;
    [self.setModel.levelTemplateVos enumerateObjectsUsingBlock:^(JHBusinessFansLevelTemplateVosModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.recommendFlag isEqualToString:@"1"]) {
            canUse = YES;
        }
    }];
    [self.bottomView setNextBtnClickStatus:canUse];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}


- (void)setupViews {
    self.bottomView = [[JHBusinessFansLevelBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    CGFloat bottomHeight = UI.bottomSafeAreaHeight;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(bottomHeight +59.f);
    }];
    @weakify(self);
    self.bottomView.clickBlock = ^{
        @strongify(self);
        if ([self checkAllValueIfCorrect]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JHBUSINESSSETTINGPROCESS" object:@(1)];
            JHBusinessFansSettingMissionViewController *vc = [[JHBusinessFansSettingMissionViewController alloc] init];
            vc.applyModel = self.applyModel;
            vc.business   = self.business;
            vc.setModel   = self.setModel;
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self.view);
            }];
        } else {
            [[UIApplication sharedApplication].keyWindow makeToast:@"经验值不能低于上一级经验值" duration:1.f position:CSToastPositionCenter];
        }
    };
    
    [self.view addSubview:self.fansTableView];
    [self.fansTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (UITableView *)fansTableView {
    if (!_fansTableView) {
        _fansTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _fansTableView.dataSource                     = self;
        _fansTableView.delegate                       = self;
        _fansTableView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _fansTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _fansTableView.rowHeight             = 35.f;
        if (@available(iOS 11.0, *)) {
            _fansTableView.estimatedSectionHeaderHeight   = 0.1f;
            _fansTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
//        for (int i = 0; i<10; i++) {
//            NSString *string = [NSString stringWithFormat:@"%@_%d",NSStringFromClass([JHBusinessFansGradeEditTableViewCell class]),i];
//            [_fansTableView registerClass:[JHBusinessFansGradeEditTableViewCell class] forCellReuseIdentifier:string];
//        }
//
        NSString *name = NSStringFromClass(JHNewFansLevelCell.class);
        [_fansTableView registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
        
        if ([_fansTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_fansTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_fansTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_fansTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _fansTableView;
}


#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JHFansLeaveSectionView *view = [[JHFansLeaveSectionView alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth - 24, 54)];
    JHBusinessFansLevelTemplateVosModel *model = self.setModel.levelTemplateVos[section];
    view.model = model;
    view.fanSection = section;
    NSNumber* isShow = self.showDetailDic[@(section)];
    view.isShow = isShow.boolValue;
    view.isSelted = self.currentSelSection == section;
    @weakify(self);
    [view setShowDetailBlock:^(NSInteger section, BOOL show) {
        @strongify(self);
        self.showDetailDic[@(section)] = @(show);
        [self.fansTableView  reloadData];
    }];
    [view setSelteSectionBlock:^(NSInteger section, JHBusinessFansLevelTemplateVosModel *model) {
        @strongify(self);
        self.applyModel.levelTemplateId = model.temID;
        self.applyModel.levelMsgList = [model.levelMsgList jh_map:^id _Nonnull(JHBusinessFansSettingLevelMsgListModel * _Nonnull obj, NSUInteger idx) {
            JHBusinessFansLevelMsgListApplyModel *aa = [JHBusinessFansLevelMsgListApplyModel new];
            aa.levelType = obj.levelType;
            aa.levelExp = obj.levelExp.longValue;
            return aa;
        }];
        self.currentSelSection = section;
        [self.fansTableView  reloadData];
    }];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.setModel.levelTemplateVos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JHBusinessFansLevelTemplateVosModel *model = self.setModel.levelTemplateVos[section];
    NSNumber* isShow = self.showDetailDic[@(section)];
    if (isShow.boolValue) {
        return model.levelMsgList.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBusinessFansLevelTemplateVosModel *model = self.setModel.levelTemplateVos[indexPath.section];
    NSString *name = NSStringFromClass(JHNewFansLevelCell.class);
    JHNewFansLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];

    if (indexPath.row > 0) {
        JHBusinessFansSettingLevelMsgListModel *leModel = model.levelMsgList[indexPath.row - 1];
        NSString *left = [NSString stringWithFormat:@"Lv.%@", leModel.levelType];
        NSString *right = [NSString stringWithFormat:@"≥%@", leModel.levelExp];
        [cell refreshLeftText:left andRightText:right];
    }
    
    cell.cellType = JHNewFansLevelCellType_Normal;
    if (indexPath.row == 0) {
        cell.cellType = JHNewFansLevelCellType_Top;
    }else if(indexPath.row == model.levelMsgList.count){
        cell.cellType = JHNewFansLevelCellType_Bottom;
    }else if(indexPath.row == model.levelMsgList.count - 1){
        cell.cellType = JHNewFansLevelCellType_NearBottom;
    }

    return cell;
}

#pragma mark - check value




- (void)checkAllTextHasValueAndChangeNextBtnStatus {
    BOOL isAllTextHasValue = NO;
    for (int i = 1; i<self.dataSourceArray.count; i++) {
        JHBusinessFansLevelMsgListApplyModel *model = (JHBusinessFansLevelMsgListApplyModel *)self.dataSourceArray[i];
        if (model.levelExp <= 0) {
            isAllTextHasValue = NO;
            break;
        } else {
            isAllTextHasValue = YES;
        }
    }
    if (isAllTextHasValue) {
        [self.bottomView setNextBtnClickStatus:YES];
    } else {
        [self.bottomView setNextBtnClickStatus:NO];
    }
}

- (BOOL)checkAllValueIfCorrect {
    return YES;

    for (int i = 0; i < self.dataSourceArray.count; i++) {
        JHBusinessFansLevelMsgListApplyModel *model = (JHBusinessFansLevelMsgListApplyModel *)self.dataSourceArray[i];
        if (i >0) {
            JHBusinessFansLevelMsgListApplyModel *subModel = (JHBusinessFansLevelMsgListApplyModel *)self.dataSourceArray[i -1];
            if (model.levelExp <= subModel.levelExp) {
                return NO;
            }
        }
    }
}

@end
