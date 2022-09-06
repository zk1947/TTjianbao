//
//  JHCateViewController.m
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  modifier  jiang  on 2020/2/16
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHCateViewController.h"
#import "JHPublishCateModel.h"
#import "JHPublishChannelTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "JHGoodsSearchController.h"
#import "GrowingManager.h"

@interface JHCateViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray <JHPublishChannelModel*>*dataArray;
@property (nonatomic, strong) JHPublishChannelModel *selectedChannel;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;

@end

@implementation JHCateViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //默认是发布选择页
        self.viewType = JHCateViewTypePublish;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self loadData];
}

-(void)noteEventType:(id)status
{
    if(_selectedChannel)
    {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setValue:status forKey:JHUPBrowseKey];
        [param setValue:self.selectedChannel.channel_id forKey:@"category1_id"];
        [param setValue:self.selectedChannel.channel_name forKey:@"category1_name"];
        [JHUserStatistics noteEventType:kUPEventTypeMallCategoryHomeBrowse params:param];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self noteEventType:JHUPBrowseEnd];
}

- (void)makeUI {
   
    
    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];

//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.navbar setTitle:@"选择分类"];
    self.title = @"选择分类";
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    self.leftTableView.estimatedRowHeight = 58;
    self.leftTableView.backgroundColor = HEXCOLOR(0xF8F8F8);
    [self.leftTableView registerClass:[JHPublishChannelTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHPublishChannelTableViewCell class])];
    self.leftTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.leftTableView];
    self.leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.width.equalTo(@90);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(81, 98);
    layout.minimumLineSpacing = 7.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    layout.headerReferenceSize = CGSizeMake(ScreenW-self.leftTableView.width, 47);
    
    self.rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.dataSource = self;
    [self.rightCollectionView registerClass:[JHPublishSubCateCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHPublishSubCateCollectionCell class])];
    [self.rightCollectionView registerClass:[JHPublishCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHPublishCollectionHeaderView class])];
    self.rightCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.rightCollectionView];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.right.bottom.equalTo(@0);
        make.top.equalTo(self.leftTableView.mas_top);
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHPublishChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHPublishChannelTableViewCell class]) forIndexPath:indexPath];
    cell.title = self.dataArray[indexPath.row].channel_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self noteEventType:JHUPBrowseEnd];
    self.selectedChannel = self.dataArray[indexPath.row];
}

#pragma mark- UICollectionViewDatasource and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.selectedChannel.items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedChannel.items[section].items.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JHPublishCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHPublishCollectionHeaderView class]) forIndexPath:indexPath];
        view.title = self.selectedChannel.items[indexPath.section].name;
        return view;
        
    } else {
        return nil;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHPublishSubCateCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHPublishSubCateCollectionCell class]) forIndexPath:indexPath];
    JHPublishSubCateModel *subCate = self.selectedChannel.items[indexPath.section].items[indexPath.row];
  
    if (self.viewType==JHCateViewTypePublish){
          [collectionCell setImageUrl:subCate.image title:subCate.name];
    }
   else if (self.viewType==JHCateViewTypeSearch){
        [collectionCell setImageUrl:subCate.image title:subCate.name];
    }
    
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHPublishCateModel *cateModel = self.selectedChannel.items[indexPath.section];
    if (self.viewType==JHCateViewTypePublish){
        if (self.seletedFinish) {
        NSString *selectedString = [NSString stringWithFormat:@"%@-%@",cateModel.name ,cateModel.items[indexPath.row].name];
        self.seletedFinish(self.selectedChannel.channel_id, cateModel.cateId, cateModel.items[indexPath.row].subCateId,selectedString);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.viewType==JHCateViewTypeSearch){
        JHGoodsSearchController *vc=[JHGoodsSearchController new];
        vc.keyword=cateModel.items[indexPath.row].show_search_key;
        vc.showKeyword=cateModel.items[indexPath.row].push_search_key;
        vc.isSort = YES;
        vc.category1_id = self.selectedChannel.channel_id;
        vc.category2_id = cateModel.cateId;
        [self.navigationController pushViewController:vc animated:YES];
        
        //埋点：点击三级分类
        [self GIOClickCateThreeLevel:_selectedChannel.items[indexPath.section].name
                           threeName:cateModel.items[indexPath.row].push_search_key];
    }
}

#pragma mark- network
- (void)loadData {
    //content/cateList
    //
//    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/cate_list") Parameters:nil successBlock:^(RequestModel *respondObject) {
//        self.dataArray = [JHPublishChannelModel mj_objectArrayWithKeyValuesArray:respondObject.data];
//        [self.leftTableView reloadData];
//        for (JHPublishChannelModel *model in self.dataArray) {
//            if (model.is_selected) {
//                self.selectedChannel = model;
//                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray indexOfObject:model] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
//                break;
//            }
//        }
//        //api没有返回默认选中channel时
//        if (self.selectedChannel == nil) {
//            self.selectedChannel = [self.dataArray firstObject];
//            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
//        }
//    } failureBlock:^(RequestModel *respondObject) {
//
//    }];
    if (self.viewType==JHCateViewTypePublish) {
        [JHPublishChannelModel requestPublishCatelist:^(RequestModel *respondObject, NSError *error) {
            if (!error) {
                self.dataArray = [JHPublishChannelModel mj_objectArrayWithKeyValuesArray:respondObject.data];
                [self reloadData];
             }
        }];
    }
   else if (self.viewType==JHCateViewTypeSearch) {
        [JHPublishChannelModel requestSearchCatelist:^(RequestModel *respondObject, NSError *error) {
            if (!error) {
                self.dataArray = [JHPublishChannelModel mj_objectArrayWithKeyValuesArray:respondObject.data];
                [self reloadData];
            }
        }];
    }
}
-(void)reloadData{
    
    [self.leftTableView reloadData];
    for (JHPublishChannelModel *model in self.dataArray) {
        if (model.is_selected) {
            [self noteEventType:JHUPBrowseEnd];
            self.selectedChannel = model;
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray indexOfObject:model] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            break;
        }
    }
    //api没有返回默认选中channel时
    if (self.selectedChannel == nil && self.dataArray.count > 0) {
        self.selectedChannel = [self.dataArray firstObject];
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setSelectedChannel:(JHPublishChannelModel *)selectedChannel {
    _selectedChannel = selectedChannel;
    [self noteEventType:JHUPBrowseBegin];
    [self.rightCollectionView reloadData];
    if (self.selectedChannel.items.count>0) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.rightCollectionView];
    }
    
    //埋点：点击一级分类
    [self GIOClickCateOneLevel:selectedChannel.channel_name];
}

#pragma mark -
#pragma mark - v3.1.0埋点
//点击一级分类
- (void)GIOClickCateOneLevel:(NSString *)channelName {
    [GrowingManager clickCateOnLevelOne:@{@"first_cate":channelName}];
}

//点击三级分类
- (void)GIOClickCateThreeLevel:(NSString *)twoName threeName:(NSString *)threeName {
    [GrowingManager clickCateOnLevelThree:@{@"first_cate":_selectedChannel.channel_name,
                                            @"two_cate":twoName,
                                            @"third_cate":threeName
    }];
}

- (void)dealloc
{
    NSLog(@"%@*************被释放",[self class])
}
@end
