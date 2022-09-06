//
//  JHCommMenuView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommMenuView.h"
#import "JHCommMenuCell.h"

@interface JHCommMenuView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIView *shadeView;
@end

@implementation JHCommMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
       // self.backgroundColor = HEXCOLORA(0xffffff, 0);
          self.backgroundColor = [UIColor clearColor];
        
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    [JHKeyWindow insertSubview:self.shadeView belowSubview:self];
    
    [self addSubview:self.bgImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
         make.width.equalTo(@72);
    }];
    
    [self addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(_bgImageView);
         make.right.equalTo(_bgImageView);
         make.height.offset(0);
         make.top.equalTo(_bgImageView);
        make.bottom.equalTo(_bgImageView).offset(-8);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCommMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHCommMenuCell"];
    cell.titleString = self.dataArr[indexPath.row];
    
    if (indexPath.row == self.dataArr.count-1) {
           [cell showBottomLine:NO];
       }else{
           [cell showBottomLine:YES];
       }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.buttonHandle) {
        self.buttonHandle([NSNumber numberWithInteger:indexPath.row]);
    }
    [self disMiss];
}
-(UIView *)shadeView
{
    if(!_shadeView)
    {
        _shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _shadeView.backgroundColor = [UIColor clearColor];
        _shadeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss)];
        [_shadeView  addGestureRecognizer:tap];
    }
    return _shadeView;
}
-(UIImageView *)bgImageView
{
    if(!_bgImageView)
    {
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image =[[UIImage imageNamed:@"customize_btn_meun_icon"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,10,0)resizingMode:UIImageResizingModeStretch];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[JHCommMenuCell class] forCellReuseIdentifier:@"JHCommMenuCell"];
    }
    return _tableView;
}
-(void)setDataArr:(NSArray *)dataArr{
    
      _dataArr = dataArr;
      [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.offset(_dataArr.count*35);
         }];
    [self.tableView reloadData];
}
-(void)disMiss{
    
    [self.shadeView removeFromSuperview];
    [self removeFromSuperview];
    
}
- (void)dealloc
{
    NSLog(@"JHCommMenuView_dealloc");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
