//
//  JHContactListViewController.m
//  TTjianbao
//
//  Created by YJ on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHContactListViewController.h"
#import "JHEasyPollSearchBar.h"
#import "TTJianBaoColor.h"
#import "JHContactCell.h"
#import "JHContactHeaderView.h"
#import "JHContactSearchViewController.h"
#import "JHGreetViewController.h"
#import "JHContactManager.h"
#import "MBProgressHUD.h"
#import "JHContactSearchView.h"
#import "UIScrollView+JHEmpty.h"

#define TOP_PAD 10
#define Duration 0.25f

@interface JHContactListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat headerView_height;
    CGFloat sections_height;
    CGFloat rows_height;
}
@property (nonatomic, strong) JHEasyPollSearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (strong, nonatomic) NSMutableArray *modelsArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) JHContactHeaderView *headerView;
@property (strong, nonatomic) JHContactSearchView *searchView;
@property (strong, nonatomic) NSMutableArray *numsArray;

@end

@implementation JHContactListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.jhTitleLabel.text = @"联系人";
    
    sections_height = 0;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, 30 + TOP_PAD*2)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *separateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    separateLineView.backgroundColor = kColorF5F6FA;
    [bgView addSubview:separateLineView];
    
    [bgView addSubview:self.searchBar];
    
    @weakify(self);
    self.searchBar.didSelectedBlock = ^(NSInteger selectedIndex, BOOL isLeft) {
        @strongify(self);
        self.searchView = [[JHContactSearchView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.searchView.modelsArray = self.dataArray;
        self.searchView.block = ^(JHContactUserInfoModel * _Nonnull model)
        {
            @strongify(self);
            self.block(model);
            [JHContactManager storeModel:model];
            [JHRootController.currentViewController.navigationController popViewControllerAnimated:YES];
        };
        
        [self.searchView.cancelButton addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self pushView:self.self.searchView inView:self.view];
    };
    
    NSArray *array = [JHContactManager getModelsArray];
    headerView_height = 0;
    if (array.count > 0)
    {
        headerView_height = 60*array.count + 30;
        self.headerView = [[JHContactHeaderView alloc] initWithArray:array];
        @weakify(self);
        self.headerView.block = ^(JHContactUserInfoModel * _Nonnull model)
        {
            @strongify(self);
            self.block(model);
            [JHContactManager storeModel:model];
            [self.navigationController popViewControllerAnimated:YES];
        };
        self.tableView.tableHeaderView = self.headerView;
    }

    [self requestData];
}

- (void)backActionButton:(UIButton *)sender {
    if (self.block) {
        self.block(nil);
    }
    
    [JHRootController.currentViewController.navigationController popViewControllerAnimated:YES];
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/auth/user/follow/list");
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSArray *dataArray = [NSArray new];
        dataArray = respondObject.data;
        self.modelsArray = [NSMutableArray new];
        self.dataArray = [NSMutableArray new];
        
        if (dataArray.count > 0)
        {
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                JHContactUserInfoModel *model = [JHContactUserInfoModel mj_objectWithKeyValues:obj];
                [self.modelsArray addObject:model];
            }];
            
            self.dataArray = self.modelsArray;
            rows_height = 60*self.dataArray.count;
        
            [self setDataSort];
        }
        else
        {
            [self.dataArray removeAllObjects];
            [self.modelsArray removeAllObjects];
        }
             
        [self.tableView reloadData];
        
        NSArray *array = [JHContactManager getModelsArray];
        if (array.count <= 0)
        {
            [self.tableView jh_reloadDataWithEmputyView];
        }
        
        if ((headerView_height + sections_height + rows_height) <= 0)
        {
            self.tableView.sectionIndexColor = [UIColor clearColor];
        }
        else
        {
            self.tableView.sectionIndexColor = kColor666;
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UITipView showTipStr:respondObject.message?:@"网络请求失败"];
    }];

}

- (void)clickCancelBtn
{
    [self.searchBar resignFirstResponder];
    [self popView:self.searchView];
}

- (JHEasyPollSearchBar *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[JHEasyPollSearchBar alloc] initWithFrame:CGRectMake(15, TOP_PAD, ScreenW - 15*2, 30)];
        _searchBar.placeholder = @"搜索";
        _searchBar.layer.backgroundColor = BGVIEW_COLOR.CGColor;
        _searchBar.layer.cornerRadius = 30/2;
    }
    return _searchBar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.modelsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([NSArray has:self.modelsArray[section]]) {
        NSArray *arr = self.modelsArray[section];
        return arr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    JHContactCell *cell = [[JHContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.model = self.modelsArray[indexPath.section][indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = BGVIEW_COLOR;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 15*2, 30)];
    titleLabel.textColor = LIGHTGRAY_COLOR;
    titleLabel.font = [UIFont fontWithName:kFontNormal size:13.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [[_collation sectionTitles] objectAtIndex:section];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([NSArray has:self.modelsArray[section]]) {
        NSArray *arr = self.modelsArray[section];
        if (arr.count > 0) {
            return 30.f;
        }
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *userObjsInSection = [self.modelsArray objectAtIndex:section];
    if(userObjsInSection == nil || [userObjsInSection count] <= 0)
    {
        return nil;
    }
    return [[_collation sectionTitles] objectAtIndex:section];
}
// 设置索引标题
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //tableView.sectionIndexColor = kColor666;
    return [_collation sectionIndexTitles];
}
// 关联搜索
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_collation sectionForSectionIndexTitleAtIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHContactUserInfoModel *model = self.modelsArray[indexPath.section][indexPath.row];
    if (self.block)
    {
        self.block(model);
        [self.navigationController popViewControllerAnimated:YES];
        
        [JHContactManager storeModel:model];
    }
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.sectionIndexColor = kColor666;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        //_tableView.sectionIndexTrackingBackgroundColor = HEXCOLOR(0xf3f3f3);
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight + TOP_PAD*2 + 30, 0, 0, 0));
        }];
    }
    return _tableView;
}

- (void)setDataSort
{
    //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
    self.collation = [UILocalizedIndexedCollation currentCollation];
    //获得索引数和section标题数
    NSInteger index, sectionTitlesCount = [[_collation sectionTitles] count];
    //临时数据，存放section对应的userObjs数组数据
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //设置sections数组初始化：元素包含userObjs数据的空数据
    for (index = 0; index < sectionTitlesCount; index++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    //将用户数据进行分类，存储到对应的sesion数组中
    for (JHContactUserInfoModel *model in self.modelsArray)
    {
        //根据timezone的localename，获得对应的的section number
        NSInteger sectionNumber = [_collation sectionForObject:model collationStringSelector:NSSelectorFromString(@"name")];// 根据WECompanyModel模型的字段属性firstLetter进行排序，也可根据name属性进行排序，排序可能花费时间较长
        //获得section的数组
        NSMutableArray *sectionUserObjs = [newSectionsArray objectAtIndex:sectionNumber];
        //添加内容到section中
        [sectionUserObjs addObject:model];
    }
    //排序，对每个已经分类的数组中的数据进行排序，如果仅仅只是分类的话可以不用这步
    for (index = 0; index < sectionTitlesCount; index++)
    {
        NSMutableArray *userObjsArrayForSection = [newSectionsArray objectAtIndex:index];
        //获得排序结果，根据模型的firstLetter字段进行排序
        NSArray *sortedUserObjsArrayForSection = [_collation sortedArrayFromArray:userObjsArrayForSection collationStringSelector:NSSelectorFromString(@"name")];
        //替换原来数组
        [newSectionsArray replaceObjectAtIndex:index withObject:sortedUserObjsArrayForSection];
    }
    
    self.modelsArray = newSectionsArray;
    
    sections_height = 0;
    self.numsArray = [NSMutableArray new];
    if (newSectionsArray.count > 0)
    {
        for (int i = 0; i < newSectionsArray.count; i++)
        {
            NSArray *array = [newSectionsArray objectAtIndex:i];
            if (array.count > 0)
            {
                NSString *num = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
                [self.numsArray addObject:num];
            }
        }
        sections_height = self.numsArray.count * 30;
    }
}

- (void)pushView:(UIView *)pushView inView:(UIView *)inView
{
    CATransition *animation = [CATransition animation];
    animation.duration = Duration;
    animation.timingFunction = [CAMediaTimingFunction
                                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [inView.layer addAnimation:animation forKey:nil];
    [inView addSubview:pushView];
}

- (void)popView:(UIView *)popView
{
    CATransition *animation = [CATransition animation];
    animation.duration = Duration;
    animation.timingFunction = [CAMediaTimingFunction
                                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:animation forKey:nil];
    [popView removeFromSuperview];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
