//
//  JHOrderListZhiFaListView.m
//  TTjianbao
//
//  Created by user on 2021/6/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderListZhiFaListView.h"

@interface JHOrderListZhiFaListViewTableViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHOrderListZhiFaListViewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
    }];
}

@end





@interface JHOrderListZhiFaListView ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIImageView *backImageView;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation JHOrderListZhiFaListView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HEXCOLOR(0xFFFFFF);
        _noBackImage = NO;
        [self initUI];
    }
    return self;
}

- (void)setTabColor:(UIColor *)tabColor {
    _tabColor = tabColor;
    self.tableView.backgroundColor = tabColor;
}

- (void)setNoBackImage:(BOOL)noBackImage {
    _noBackImage = noBackImage;
    _backImageView.hidden = noBackImage;
    _tableView.showsVerticalScrollIndicator = noBackImage;
    if (noBackImage) {
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0.f);
        }];
    } else {
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(18.f);
        }];
    }
}

- (void)initUI {
    _backImageView = [[UIImageView alloc] init];
    _backImageView.image = [UIImage imageNamed:@"jhOrderList_zhifaBackImage"];
    _backImageView.hidden = YES;
    [self addSubview:_backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.tableView = [UITableView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 30.f;
    [self.tableView registerClass:[JHOrderListZhiFaListViewTableViewCell class] forCellReuseIdentifier:@"fmenualert"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(18.f);
        make.bottom.left.right.equalTo(self);
    }];
}

- (void)setArrMDataSource:(NSMutableArray *)arrMDataSource {
    _arrMDataSource = arrMDataSource;
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectedCallback) {
        self.didSelectedCallback(indexPath.row, _arrMDataSource[indexPath.row]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrMDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.noBackImage) {
        return 36.f;
    } else {
        return 30.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHOrderListZhiFaListViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fmenualert" forIndexPath:indexPath];
    if (!cell) {
        cell = [[JHOrderListZhiFaListViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fmenualert"];
    }
    cell.titleLabel.text = _arrMDataSource[indexPath.row];
    cell.titleLabel.textColor = _txtColor ? _txtColor : HEXCOLOR(0x999999);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = _tabColor;
    cell.titleLabel.backgroundColor = self.tabColor;
    cell.titleLabel.font = _cusFont ? _cusFont : [UIFont fontWithName:kFontNormal size:12.f];
    cell.backgroundColor = _tabColor;
    if (self.noBackImage) {
        cell.titleLabel.textAlignment = NSTextAlignmentLeft;
        [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(10.f);
        }];
    } else {
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(0.f);
        }];
    }
    return cell;
}


@end
