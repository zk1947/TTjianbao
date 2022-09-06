//
//  JHAllowanceViewController.m
//  TTjianbao
//
//  Created by apple on 2020/2/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAllowanceViewController.h"
#import "JHAllowanceListVCCell.h"
#import "JHWebViewController.h"
#import "JHGrowingIO.h"

@interface JHAllowanceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *vmArray;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *activityButton;

@property (nonatomic, copy) NSString *targetUrl;

///collection 高度
@property (nonatomic, assign) CGFloat collectionHeight;

@end

@implementation JHAllowanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateViewController];
    
    [self addSelfUI];
    
    [self getActivityMethod];
    
    _collectionHeight = ScreenH - 184 - UI.statusAndNavBarHeight;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!_isNative)
    {
        [JHGrowingIO trackEventId:@"page_create" from:@"h5"];
    }
}

#pragma mark --------------- method ---------------
-(void)updateViewController
{
    self.title = @"津贴";
    [self initRightButtonWithImageName:@"my_allowance_tips" action:@selector(rightActionButton:)];
    self.view.backgroundColor = RGB(245, 246, 250);
}

-(void)addSelfUI
{
    UIImageView *headerImageViewBg = [UIImageView jh_imageViewAddToSuperview:self.view];
    headerImageViewBg.image = JHImageNamed(@"my_allowance_header_bg");
    [headerImageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.height.mas_equalTo(110.f);
    }];
    
    UILabel *moneyLabel = [UILabel jh_labelWithBoldText:@"0" font:40 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:self.view];
    moneyLabel.font = JHDINBoldFont(40);
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageViewBg).offset(20.f);
        make.left.equalTo(headerImageViewBg).offset(25);
    }];
    _moneyLabel = moneyLabel;
    
    UILabel *tipLabel = [UILabel jh_labelWithText:@"消费时可抵等额人民币" font:15 textColor:RGB(255, 249, 249) textAlignment:1 addToSuperView:headerImageViewBg];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLabel.mas_bottom).offset(7.f);
        make.left.width.equalTo(moneyLabel);
    }];
    
    UIView *bgView = [UIView jh_viewWithColor:RGB(255, 245, 227) addToSuperview:self.view];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerImageViewBg);
        make.top.equalTo(headerImageViewBg.mas_bottom);
        make.height.mas_equalTo(30.f);
    }];
    UILabel *descLabel = [UILabel jh_labelWithText:@"" font:13 textColor:RGB(255, 249, 249) textAlignment:1 addToSuperView:bgView];
    descLabel.backgroundColor = RGB(255, 245, 227);
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView).offset(10);
        make.centerY.equalTo(bgView);
    }];
    _descLabel = descLabel;
    
    UIImageView *tipView = [UIImageView jh_imageViewWithImage:@"my_allowance_tip" addToSuperview:headerImageViewBg];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.descLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.descLabel);
        make.width.height.mas_equalTo(14);
    }];
    
    UIView *buttonbg = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
    [buttonbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerImageViewBg);
        make.height.mas_equalTo(44.f);
        make.top.equalTo(headerImageViewBg.mas_bottom).offset(30);
    }];
    
    NSArray *titleArray = @[@"获取", @"支出", @"过期"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton jh_buttonWithTitle:titleArray[i] fontSize:15 textColor:RGB(102, 102, 102) target:self action:@selector(selectTypeMethod:) addToSuperView:buttonbg];
        button.selected = (i == 0);
        [button setTitleColor:UIColor.blackColor forState:UIControlStateSelected];
        button.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
        button.tag = 3000 + i;
        [self.buttonArray addObject:button];
    }
    
    [self.buttonArray mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:0 leadSpacing:60 tailSpacing:60];
    [self.buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonbg);
        make.height.mas_equalTo(44);
    }];
    
    _lineView = [UIView jh_viewWithColor:RGB(254, 225, 0) addToSuperview:self.view];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 4));
        make.top.equalTo(buttonbg).offset(34);
        make.centerX.equalTo(self.view).offset(-(ScreenW - 120.f)/3.f);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(buttonbg.mas_bottom);
    }];
    
    @weakify(self);
    [JHAllowanceListViewModel requestAllowanceTotalBlock:^(JHAllowanceTotalModel * _Nonnull model) {
       @strongify(self);
        
        self.moneyLabel.text = model.bountyTotal;
        NSString *descStr = [NSString stringWithFormat:@"%@即将过期%@，请尽快使用",model.latestExpiredDate,model.bountyExpiredSoon];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:descStr attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName: RGB(252, 66, 0)}];
        [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(model.latestExpiredDate.length + 4, model.bountyExpiredSoon.length)];
        self.descLabel.attributedText = attributedString;
        if([model.bountyExpiredSoon floatValue] <= 0)
        {
            [buttonbg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerImageViewBg.mas_bottom);
            }];
            
            _collectionHeight += 30;
            [self.collectionView reloadData];
        }
    }];
}

- (void)getActivityMethod
{
    [JHAllowanceListViewModel requestActivityBlock:^(NSString * _Nonnull imgUrl, NSString * _Nonnull webUrl) {
        if(imgUrl && webUrl)
        {
            [self.activityButton jh_setImageWithUrl:imgUrl];
            self.targetUrl = webUrl;
        }
    }];
}

#pragma mark --------------- action ---------------
-(void)rightActionButton:(UIButton *)sender
{
    [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/subsidiesRules.html") title:@"规则" controller:self];
}

-(void)selectTypeMethod:(UIButton *)sender
{
    NSInteger index = sender.tag - 3000;
    [self selectPageIndex:index];
    [self.collectionView setContentOffset:CGPointMake(ScreenW * index, 0) animated:YES];
}

-(void)selectPageIndex:(NSInteger)index
{
    for (int i = 0; i< self.buttonArray.count; i++) {
        UIButton *button = self.buttonArray[i];
        button.selected = (button.tag == index + 3000);
    }
    
    CGFloat x = (ScreenW - 120.f)/3.f;
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-x + x * index);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)activityMethod
{
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = self.targetUrl;
    [self.navigationController pushViewController:vc animated:YES];
    
    [JHGrowingIO trackEventId:@"allowance_freeze_click"];
}

#pragma mark --------------- collectionView Delegate ---------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.vmArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHAllowanceListVCCell *cell = [JHAllowanceListVCCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    if(indexPath.item < self.vmArray.count)
    {
        cell.viewModel = self.vmArray[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenW, _collectionHeight);
}

#pragma mark --------------- scrollView delegate ---------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    int page = sender.contentOffset.x / ScreenW;
    [self selectPageIndex:page];
}
#pragma mark --------------- get ---------------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JHAllowanceListVCCell class] forCellWithReuseIdentifier:[JHAllowanceListVCCell cellIdentifier]];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableArray *)buttonArray
{
    if(!_buttonArray){
        _buttonArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _buttonArray;
}

-(NSMutableArray *)vmArray
{
    if(!_vmArray)
    {
        _vmArray = [NSMutableArray arrayWithCapacity:3];
        for (NSInteger i = 0; i<3; i++) {
            JHAllowanceListViewModel *vm = [JHAllowanceListViewModel new];
            vm.pageIndex = 0 ;
            vm.pageSize = 20;
            vm.type = i;
            [_vmArray addObject:vm];
        }
    }
    return _vmArray;
}

- (UIButton *)activityButton
{
    if(!_activityButton)
    {
        _activityButton = [UIButton jh_buttonWithTarget:self action:@selector(activityMethod) addToSuperView:self.view];
        [_activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-26);
            make.top.equalTo(self.jhNavView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(72, 92));
        }];
    }
    return _activityButton;
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
