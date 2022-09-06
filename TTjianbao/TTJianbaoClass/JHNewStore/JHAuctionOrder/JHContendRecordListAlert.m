//
//  JHContendRecordListAlert.m
//  TTjianbao
//
//  Created by zk on 2021/8/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHContendRecordListAlert.h"
#import "UIView+JHGradient.h"
#import "JHC2CJiangPaiListModel.h"
#import "YDRefreshFooter.h"
#import "JHC2CProductDetailBusiness.h"

@interface JHContendRecordListCell : UITableViewCell

@property (nonatomic, strong) JHC2CJiangPaiRecord *model;
@property (nonatomic, strong) UIImageView *imgv;
@property (nonatomic, strong) UILabel *statusLab;
@property (nonatomic, strong) UILabel *titLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *expLab;
@property (nonatomic, strong) UILabel *priceLab;

@end

@implementation JHContendRecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    _imgv = [[UIImageView alloc]init];
    _imgv.image = JHImageNamed(@"dis_picAppraise");
    [_imgv jh_cornerRadius:16];
    [self.contentView addSubview:_imgv];
    
    _statusLab = [[UILabel alloc] init];
    _statusLab.text = @"已领先";
    _statusLab.textColor = kColorFFF;
    _statusLab.font = JHFont(9);
    _statusLab.textAlignment = NSTextAlignmentCenter;
    _statusLab.backgroundColor = HEXCOLOR(0xFF4200);
    [_statusLab jh_cornerRadius:2];
    [self.contentView addSubview:_statusLab];
    
    _titLab = [[UILabel alloc] init];
    _titLab.text = @"昵称：***大师";
    _titLab.textColor = kColor333;
    _titLab.font = JHFont(12);
    [self.contentView addSubview:_titLab];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"2020-05-06 17:34:23";
    _timeLab.textColor = kColor999;
    _timeLab.font = JHFont(10);
    [self.contentView addSubview:_timeLab];
    
    _expLab = [[UILabel alloc] init];
    _expLab.text = @"出价";
    _expLab.textColor = kColor999;
    _expLab.font = JHFont(12);
    [self.contentView addSubview:_expLab];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.text = @"￥1000";
    _priceLab.textColor = HEXCOLOR(0xFF4200);
    _priceLab.font = JHFont(12);
    [self.contentView addSubview:_priceLab];
}

-(void)setModel:(JHC2CJiangPaiRecord *)model{
    _model = model;

    //头像
    [_imgv jhSetImageWithURL:[NSURL URLWithString:_model.img] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
    //状态 拍卖状态（0无状态 1 失效 2出局 3领先 4中拍）
    if ([_model.status isEqualToString:@"3"]) {
        _statusLab.hidden = NO;
        _statusLab.text = @"已领先";
        _statusLab.backgroundColor = HEXCOLOR(0xFF4200);
    } else if ([_model.status isEqualToString:@"4"]){
        _statusLab.hidden = NO;
        _statusLab.text = @"已中拍";
        _statusLab.backgroundColor = HEXCOLOR(0xD4A86A);
    }else{
        _statusLab.hidden = YES;
        _statusLab.text = @"";
        _statusLab.backgroundColor = HEXCOLOR(0xFF4200);
    }
    //用户名 @"昵称：***大师";
    _titLab.text = [NSString stringWithFormat:@"昵称：%@",_model.name];
    //出价时间
    _timeLab.text = _model.createTime;
    //出价金额 priceYuan price
    _priceLab.text = [NSString stringWithFormat:@"￥%@",_model.priceYuan];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(9);
        make.width.height.mas_equalTo(32);
    }];

    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.bottom.mas_equalTo(-3);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(13);
    }];
    
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgv.mas_right).offset(6);
        make.top.mas_equalTo(9);
        make.height.mas_equalTo(17);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgv.mas_right).offset(6);
        make.top.mas_equalTo(_titLab.mas_bottom).offset(1);
        make.height.mas_equalTo(14);
    }];
    
    [_expLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(9);
        make.height.mas_equalTo(17);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(_expLab.mas_bottom).offset(1);
        make.height.mas_equalTo(14);
    }];
}
@end

@interface JHContendRecordListAlert ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *resourceArr;

@property (nonatomic, strong) UIControl *shadowView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *closeBtn2;

@property (nonatomic, strong) UIView *noneView;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, assign) NSInteger requestPageIndex;

@end

@implementation JHContendRecordListAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.resourceArr = [NSMutableArray array];
        [self setUpView];
        [self dealNoneDataUI];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame withResource:(NSMutableArray *)resourceArr
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.resourceArr = resourceArr;
//        [self setUpView];
//        if (self.resourceArr.count == 0) {
//            [self dealNoneDataUI];
//        }
//    }
//    return self;
//}

- (void)setUpView{
    self.backgroundColor = kColorFFF;
    [self jh_cornerRadius:8];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
    titLab.text = @"竞价记录";
    titLab.textColor = kColor333;
    titLab.font = JHMediumFont(15);
    titLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titLab];
    
    UIButton *closeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn1.frame = CGRectMake(self.width-40, 0, 40, 40);
    [closeBtn1 setImage:JHImageNamed(@"appraisepaycopon_close") forState:UIControlStateNormal];
    closeBtn1.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14);
    [closeBtn1 addTarget:self action:@selector(hiddenMsgAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn1];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.width, 1)];
    line.backgroundColor = HEXCOLOR(0xEDEDED);
    [self addSubview:line];
    
    [self addSubview:self.tableView];
    
    _closeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn2.frame = CGRectMake(30, self.height-55, self.width-60, 40);
    [_closeBtn2 jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFC242), HEXCOLOR(0xFEE100)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)];
    [_closeBtn2 jh_cornerRadius:20];
    [_closeBtn2 setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeBtn2 setTitleColor:kColor333 forState:UIControlStateNormal];
    _closeBtn2.titleLabel.font = JHFont(15);
    [_closeBtn2 addTarget:self action:@selector(hiddenMsgAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn2];
    
}

//- (void)setResourceArr:(NSMutableArray *)resourceArr{
//    _resourceArr = resourceArr;
//    if (_resourceArr.count == 0) {
//        [self dealNoneDataUI];
//    }
//    [self.tableView reloadData];
//}

- (void)setProductID:(NSString *)productID{
    _productID = productID;
    [self loadData];
}

#pragma mark   -配置单元格
- (UITableView *)tableView{
    if (!_tableView) {
        //单元格
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 41, self.width, self.height-41-70) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[JHContendRecordListCell class] forCellReuseIdentifier:@"JHContendRecordListCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        ((YDRefreshFooter *)_tableView.mj_footer).showNoMoreString = YES;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHContendRecordListCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"JHContendRecordListCell" forIndexPath:indexPath];
    cell.model = _resourceArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void)showAlert{
    self.shadowView.alpha= 0;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.25 animations:^{
        _shadowView.alpha = 0.7;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:_shadowView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
}

-(void)hiddenMsgAlert{
    [self.shadowView removeFromSuperview];
    self.shadowView = nil;
    [self removeFromSuperview];
}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_shadowView addTarget:self action:@selector(hiddenMsgAlert) forControlEvents:UIControlEventTouchUpInside];
        _shadowView.backgroundColor = [UIColor blackColor];
    }
    return _shadowView;
}

- (void)dealNoneDataUI{
    [self.noneView removeFromSuperview];
    [self addSubview:self.noneView];
    self.closeBtn2.hidden = YES;
}

- (void)dealHaveDataUI{
    [self.noneView removeFromSuperview];
    self.closeBtn2.hidden = NO;
}

- (UIView *)noneView{
    if (!_noneView) {
        _noneView = [[UIView alloc]initWithFrame:CGRectMake(0, 41, self.width, self.height-41-70)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(85, 63, 89, 71)];
        imageView.centerX = self.centerX;
        imageView.image = JHImageNamed(@"img_default_page");
        [_noneView addSubview:imageView];
                                  
        UILabel *textLabel = [UILabel jh_labelWithText:@"暂无竞价记录" font:12 textColor:HEXCOLOR(0xa7a7a7) textAlignment:1 addToSuperView:self];
        textLabel.frame = CGRectMake(0, imageView.bottom+15, self.width, 17);
        textLabel.centerX = self.centerX;
        [_noneView addSubview:textLabel];
    }
    return _noneView;
}

- (void)loadData{
    self.requestPageIndex = 1;
    [self.resourceArr removeAllObjects];
    @weakify(self);
    [JHC2CProductDetailBusiness requestC2CProductDetailPaiMaiList:self.productID page:@(self.requestPageIndex) completion:^(NSError * _Nullable error, JHC2CJiangPaiListModel * _Nullable model) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        self.hasMore = model.hasMore;
        if (!model.records || model.records.count == 0) {
            [self dealNoneDataUI];
            [self.tableView jh_footerStatusWithNoMoreData:YES];
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        [self dealHaveDataUI];
        [self.resourceArr addObjectsFromArray:model.records];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData{
    if (!self.hasMore) {
        [self.tableView jh_footerStatusWithNoMoreData:YES];
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    self.requestPageIndex ++;
    @weakify(self);
    [JHC2CProductDetailBusiness requestC2CProductDetailPaiMaiList:self.productID page:@(self.requestPageIndex) completion:^(NSError * _Nullable error, JHC2CJiangPaiListModel * _Nullable model) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.hasMore = model.hasMore;
        if (!model.records || model.records.count == 0) {
            [self.tableView jh_footerStatusWithNoMoreData:YES];
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        [self.resourceArr addObjectsFromArray:model.records];
        if (model.records.count == 0) {
            [self.tableView jh_footerStatusWithNoMoreData:YES];
        } else {
            [self.tableView jh_footerStatusWithNoMoreData:NO];
        }
        [self.tableView reloadData];
    }];
}

@end
