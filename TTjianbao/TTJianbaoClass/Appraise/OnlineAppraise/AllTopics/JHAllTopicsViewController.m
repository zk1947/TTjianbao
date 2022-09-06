//
//  JHAllTopicsViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAllTopicsViewController.h"
#import "JHTopicDetailController.h"
#import "JHTopicListTableCell.h"
#import "JHOnlineAppraiseModel.h"
#import "CommHelp.h"
#import "UserInfoRequestManager.h"
@interface JHAllTopicsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (nonatomic, copy) NSMutableArray *topicArray;
@end

@implementation JHAllTopicsViewController

- (NSMutableArray *)topicArray {
    if (!_topicArray) {
        _topicArray = [NSMutableArray array];
    }
    return _topicArray;
}

- (instancetype)init {
    if (self) {
        _topicInfo = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F5F8);
    self.jhTitleLabel.text = @"全部鉴定师";
    
    [self configTableView];
}

- (void)configTableView {
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSelectionStyleNone;
    table.delegate = self;
    table.dataSource = self;
    _tableView = table;
    
    self.tableView.sectionIndexColor = kColor666;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = HEXCOLOR(0xf3f3f3);
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JHTopicListTableCell class] forCellReuseIdentifier:kJHTopicListTableCellIdentifer];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.topicArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([NSArray has:self.topicArray[section]]) {
            NSArray *arr = self.topicArray[section];
            return arr.count;
    }
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHTopicListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHTopicListTableCellIdentifer];
    cell.appraiseModel = self.topicArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.+15.+10.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHOnlineAppraiseModel *model = self.topicArray[indexPath.section][indexPath.row];
    if ([model.Id integerValue] > 0) {
        JHTopicDetailController *vc = [[JHTopicDetailController alloc] init];
        vc.topicId = model.Id;
        vc.pageFrom = @"online_appraise_allTopic";   ///需要替换页面来源  ！！！！  ----- MARK： TODO lihui
        [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_head_click" params:@{@"appraisal_name":model.name,@"appraisal_id":model.Id,@"index":@(indexPath.row)} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
}

// 设置section的Header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *userObjsInSection = [self.topicArray objectAtIndex:section];
    if(userObjsInSection == nil || [userObjsInSection count] <= 0) {
        return nil;
    }
    return [[_collation sectionTitles] objectAtIndex:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([NSArray has:self.topicArray[section]]) {
        NSArray *arr = self.topicArray[section];
        if ([arr count] > 0) {
            UIView *header = [[UIView alloc] init];
            header.backgroundColor = HEXCOLOR(0xF5F5F8);
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, 24)];
            titleLabel.textColor = kColor222;
            titleLabel.font = [UIFont fontWithName:kFontMedium size:15.];
            titleLabel.text = [[_collation sectionTitles] objectAtIndex:section];
            [header addSubview:titleLabel];
            return header;
        }
        return [UIView new];
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([NSArray has:self.topicArray[section]]) {
        NSArray *arr = self.topicArray[section];
        if ([arr count] > 0) {
            return 24.f;
        }
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}
// 设置索引标题
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    tableView.sectionIndexColor = kColor666;
    return [_collation sectionIndexTitles];
}
// 关联搜索
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_collation sectionForSectionIndexTitleAtIndex:index];
}

- (void)setTopicInfo:(NSMutableArray<JHOnlineAppraiseModel *> *)topicInfo {
    if (!topicInfo) {
        return;
    }
    _topicInfo = topicInfo;
    [self sortTopicData:@"name"];
}

- (void)sortTopicData:(NSString *)sortKey {
    [self.topicArray removeAllObjects];
    if (self.topicInfo.count > 0) {
        //获得当前UILocalizedIndexedCollation对象并且引用赋给collation,A-Z的数据
        self.collation = [UILocalizedIndexedCollation currentCollation];
        //获得索引数和section标题数
        NSInteger index, sectionTitlesCount = [[_collation sectionTitles] count];
        //临时数据，存放section对应的userObjs数组数据
        NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
        //设置sections数组初始化：元素包含userObjs数据的空数据
        for (index = 0; index < sectionTitlesCount; index++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [newSectionsArray addObject:array];
        }
        //将用户数据进行分类，存储到对应的sesion数组中
        for (JHOnlineAppraiseModel *model in self.topicInfo) {
            //根据timezone的localename，获得对应的的section number
            NSInteger sectionNumber = [_collation sectionForObject:model collationStringSelector:NSSelectorFromString(sortKey)];// 根据WECompanyModel模型的字段属性firstLetter进行排序，也可根据name属性进行排序，排序可能花费时间较长
            //获得section的数组
            NSMutableArray *sectionUserObjs = [newSectionsArray objectAtIndex:sectionNumber];
            //添加内容到section中
            [sectionUserObjs addObject:model];
        }
        //排序，对每个已经分类的数组中的数据进行排序，如果仅仅只是分类的话可以不用这步
        for (index = 0; index < sectionTitlesCount; index++) {
            NSMutableArray *userObjsArrayForSection = [newSectionsArray objectAtIndex:index];
            //获得排序结果，根据模型的firstLetter字段进行排序
            NSArray *sortedUserObjsArrayForSection = [_collation sortedArrayFromArray:userObjsArrayForSection collationStringSelector:NSSelectorFromString(sortKey)];
            //替换原来数组
            [newSectionsArray replaceObjectAtIndex:index withObject:sortedUserObjsArrayForSection];
        }
        self.topicArray = newSectionsArray;
        [self.tableView reloadData];
    }
    else {
        [self.topicArray removeAllObjects];
        [self.tableView reloadData];
    }
}

@end
