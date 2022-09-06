//
//  JHContactSearchViewController.m
//  TTjianbao
//
//  Created by YJ on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHContactSearchViewController.h"
#import "JHSearchTextfield.h"
#import "JHContactCell.h"
#import "JHContactUserInfoModel.h"
#import "TTJianBaoColor.h"

#define kLeftSpace 40
#define kRightSpace 15
#define kSearchBarWidth  (ScreenW - kLeftSpace - kRightSpace)
#define itemWidth 44.f
#define itemHeight 30.f
#define searchBarH 28.f
#define cancelWidth 28.0f

@interface JHContactSearchViewController ()<JHSearchTextfieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) JHSearchTextfield *searchBar;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) NSMutableArray *resultArray;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *selectedModelArray;

@end

@implementation JHContactSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
    
}

- (void)setUI
{
    [self showNavView];
    self.jhLeftButton.hidden = YES;
    [self.jhNavView addSubview:self.searchBar];
    [self.jhNavView addSubview:self.cancelButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    NSValue *rectValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [rectValue CGRectValue].size;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, keyboardSize.height, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    JHContactCell *cell = [[JHContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.model = self.resultArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = USELECTED_COLOR;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 15*2, 30)];
    titleLabel.textColor = LIGHTGRAY_COLOR;
    titleLabel.font = [UIFont fontWithName:kFontNormal size:13.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"我关注的人";
    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.resultArray.count > 0)
    {
        return 30.f;
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

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = BGVIEW_COLOR;
        _tableView.tableHeaderView = self.headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (JHSearchTextfield *)searchBar
{
    if (!_searchBar)
    {
        _searchBar = [[JHSearchTextfield alloc] initWithFrame:CGRectMake(15, UI.statusBarHeight+(44-searchBarH)/2, ScreenWidth - itemWidth - 15 - 10*2, searchBarH)];
        _searchBar.backgroundColor = kColorF5F6FA;
        _searchBar.layer.cornerRadius = _searchBar.height/2;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.textColor = [UIColor blackColor];
        _searchBar.font = [UIFont fontWithName:kFontNormal size:13];
        _searchBar.delegate = self;
        [_searchBar.searchTextField becomeFirstResponder];
    }
    return _searchBar;
}
- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(ScreenW - itemWidth - 10, 0, itemWidth, cancelWidth);
        _cancelButton.centerY = self.searchBar.centerY;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:B_COLOR forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_cancelButton addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (BOOL)searchTextfieldShouldReturn:(JHSearchTextfield *)searchTextfield
{
    [self searchData];
    return YES;
}

-(void)searchData
{
    self.resultArray = [NSMutableArray new];
    self.selectedModelArray = [NSMutableArray new];
    
    NSString *text = self.searchBar.searchTextField.text;
    
    for (int i = 0; i < self.modelsArray.count; i++)
    {
        JHContactUserInfoModel *model = self.modelsArray[i];
        
        NSString *string = model.name;
        
        if (string.length >= text.length)
        {
            if([string rangeOfString:text].location != NSNotFound)
            {
                [self.resultArray addObject:model];
            }
        }
        
        if ([string isEqualToString:text])
        {
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 44);
            self.titleLabel.text = [NSString stringWithFormat:@"@%@",string];
            
            [self.selectedModelArray addObject:model];
        }
    }
    
    if (self.selectedModelArray.count <= 0)
    {
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 0);
        self.titleLabel.text = @"";
    }

    [self.tableView reloadData];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
    
    [self.view endEditing:YES];
}
- (BOOL)searchTextfieldTextDidClear:(JHSearchTextfield *_Nonnull)searchTextfield
{
    [self.resultArray removeAllObjects];
    [self.selectedModelArray removeAllObjects];
    
    self.headerView.frame = CGRectMake(0, 0, ScreenW, 0);
    [self.tableView reloadData];
    return YES;
}
- (void)clickCancelBtn
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.userInteractionEnabled = YES;
        [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView)]];
    }
    return _headerView;
}
- (void)tapHeaderView
{
    [self.searchBar resignFirstResponder];
    if (self.selectedModelArray.count > 0)
    {
        JHContactUserInfoModel *model = self.selectedModelArray[0];
        NSLog(@"%@",model.name);
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = B_COLOR;
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:15.0f];
        [self.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self.headerView).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        }];

    }
    return _titleLabel;
}

- (NSMutableArray *)modelsArray
{
    if (!_modelsArray)
    {
        _modelsArray = [NSMutableArray new];
    }
    return _modelsArray;
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
