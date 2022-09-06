//
//  JHContactHeaderView.m
//  TTjianbao
//
//  Created by YJ on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHContactHeaderView.h"
#import "JHContactCell.h"
#import "TTJianBaoColor.h"

@interface JHContactHeaderView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *modelsArray;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation JHContactHeaderView

- (instancetype)initWithArray:(NSArray<NSDictionary *> *)array
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        modelsArray = [NSMutableArray new];
        
        if (array.count > 0)
        {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                JHContactUserInfoModel *model = [JHContactUserInfoModel mj_objectWithKeyValues:obj];
                [modelsArray addObject:model];
            }];
            
            self.frame = CGRectMake(0, 0, ScreenW, 60*modelsArray.count + 30);
        }
        else
        {
            self.frame = CGRectMake(0, 0, ScreenW, 0);
        }
        
        [self.tableView reloadData];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelsArray.count;
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
    cell.model = modelsArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.block)
    {
        JHContactUserInfoModel *model = modelsArray[indexPath.row];
        self.block(model);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = BGVIEW_COLOR;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 15*2, 30)];
    titleLabel.textColor = LIGHTGRAY_COLOR;
    titleLabel.font = [UIFont fontWithName:kFontNormal size:13.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"最近联系人";
    [headerView addSubview:titleLabel];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
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
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
