//
//  JHBusinessGoodsPropertyController.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessGoodsPropertyController.h"
#import "JHBusinessGoodsAttributeModel.h"
#import "JHBusinessGoodAttributeCell.h"
#import <IQKeyboardManager.h>
#import "JHRecycleSureButton.h"
#import "JHBusinessPublishAttriPopView.h"

@interface JHBusinessGoodsPropertyController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) JHRecycleSureButton *sureBtn;
@property(nonatomic,strong) JHBusinessPublishAttriPopView *popView;
@property(nonatomic,strong) NSMutableArray *attriArray;
@property(nonatomic,strong) NSMutableArray *tempArray;

@property (nonatomic, strong) JHEmptyView *emptyView;
@end

@implementation JHBusinessGoodsPropertyController
- (instancetype)initWithArrayModel:(NSMutableArray *)attArray{
    self = [super init];
    if (self) {
        self.tempArray = attArray;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager.sharedManager setShouldResignOnTouchOutside:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager.sharedManager setShouldResignOnTouchOutside:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didKboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    self.view.backgroundColor = HEXCOLOR(0xF5F5F5);
    // Do any additional setup after loading the view.
    self.title = @"商品属性";
 
    [self setItems];

    [self shuxingjiekou];
    
    
}
- (void)setItems{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(50);
        make.right.left.equalTo(self.view).inset(20);
        make.height.mas_equalTo(50);
    }];
}
- (void)reloadView{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(UI.statusAndNavBarHeight+2);
        make.right.left.equalTo(self.view);
        make.height.mas_equalTo(50*self.attriArray.count);
    }];
    [self.tableView reloadData];
}
-(void)shuxingjiekou{
    @weakify(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/attr/listAttrAllByBackCateId") Parameters:@{@"id":self.selectCateId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);

        self.attriArray = [JHBusinessGoodsAttributeModel  mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (self.attriArray.count == 0) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self.view);
                make.top.mas_equalTo(UI.statusAndNavBarHeight);
            }];
            self.sureBtn.hidden = YES;
            return;
        }
        [self.emptyView removeFromSuperview];
        for (JHBusinessGoodsAttributeModel *temp in self.attriArray) {
            for (JHBusinessGoodsAttributeModel *model in self.tempArray) {

                if (model.attrId == temp.attrId) {
                    temp.showValue = model.showValue;
                    continue;
                }
            }
        }
        NSLog(@"backModel");
        [self reloadView];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
 
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attriArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHBusinessGoodsAttributeModel * model = self.attriArray[indexPath.row];
    if (model.attrValueType == 1) {
        static NSString *identifier = @"identifier1";
        JHBusinessGoodAttributeCell* cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell)
        {
            cell = [[JHBusinessGoodAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setCellTitle:model.attrName andIsRequired:model.attrRequired andShowStr:model.showValue];
        [cell setDataModel:model];
        return cell;
    }else{
        static NSString *identifier = @"identifier2";
        JHBusinessGoodAttributeArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];;
        if (!cell)
        {
            cell = [[JHBusinessGoodAttributeArrowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    
        [cell setCellTitle:model.attrName andIsRequired:model.attrRequired andShowStr:model.showValue];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ //属性值类型（0单选项、1自定义、2枚举值、3单选项+自定义、4复选项）",
    JHBusinessGoodsAttributeModel * model = self.attriArray[indexPath.row];
    NSArray * arr = [model.attrValue componentsSeparatedByString:@","];
    NSArray *showArr = [model.showValue componentsSeparatedByString:@","];
    if (model.attrValueType == 1) {
        return;
    }
    else {//if(model.attrValueType == 0)
        if (self.popView) {
            [self.popView removeFromSuperview];
            self.popView = nil;
        }
        [self.view addSubview:self.popView];
        NSMutableArray *attarray = [[NSMutableArray alloc] init];
        for (NSString *temp in arr) {
            JHBusinessGoodsAttributeSelectModel *selModel = [[JHBusinessGoodsAttributeSelectModel alloc] init];
            selModel.attrName = temp;
            if ([showArr containsObject:temp] ) {
                selModel.isSelect = YES;
            }else if([temp isEqualToString:@"其它"] && (model.attrValueType == 3) && [[showArr lastObject] containsString:@"其它-"]){
                selModel.isSelect = YES;
                selModel.textStr = [[showArr lastObject] substringFromIndex:3];
            }
            else{
                selModel.isSelect = NO;
            }
            
            [attarray addObject:selModel];
        }
        @weakify(self);
        self.popView.sureClickBlock = ^(NSString * _Nonnull selectedStr) {
            @strongify(self);
            model.showValue = selectedStr;
            [self.tableView reloadData];
        };
        [self.popView setArrayModel:attarray andSeletype:model.attrValueType];
        [self.popView showAlert];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (JHRecycleSureButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [JHRecycleSureButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        _bottomView.publishBtn.enabled = NO;
    }
    return _sureBtn;
}
- (void)sureBtnAction{
    
    for (JHBusinessGoodsAttributeModel * model in self.attriArray) {
        if (model.attrRequired == 1) {
            if (model.showValue.length == 0) {
                [SVProgressHUD showInfoWithStatus:@"请填写必填项"];
                return;
            }
        }
    }
    
    if (self.sureClickBlock) {
        self.sureClickBlock(self.attriArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (JHBusinessPublishAttriPopView *)popView {
    if (!_popView) {
        _popView = [[JHBusinessPublishAttriPopView alloc] initWithFrame:self.view.bounds];
    }
    return _popView;
}
-(void)didClickKeyboard:(NSNotification *)sender{
 
    if (self.popView.isShow) {
        self.popView.bar.bottom =  kScreenHeight - 220;
    }
}
- (JHEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JHEmptyView alloc] init];
    }
    return _emptyView;
}
#pragma mark - 当键盘即将消失
-(void)didKboardDisappear:(NSNotification *)sender{
    if (self.popView.isShow) {
        self.popView.bar.bottom =  kScreenHeight;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
