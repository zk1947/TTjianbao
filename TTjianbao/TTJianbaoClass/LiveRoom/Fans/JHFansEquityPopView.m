//
//  JHFansEquityPopView.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansEquityPopView.h"
#import "UIView+JHGradient.h"
#import "JHFansEquityTableViewCell.h"
#import "JHFansEquityCollectionView.h"
#import "JHFansRequestManager.h"
#import "JHFansEquityListModel.h"
#import "JHFansEquityWebView.h"

@interface JHFansEquityPopView()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,copy) NSString *anchorId;
@property(nonatomic,strong)UIView *popView;
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton *questionBtn;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)UIButton *joinFansGroupBtn;
@property(nonatomic,strong)JHFansEquityCollectionView * equityView;
@property(nonatomic,strong)JHFansEquityListModel * model;
@property(nonatomic,assign)BOOL isfans;
@end

@implementation JHFansEquityPopView
- (instancetype)initWithAnchorId:(NSString *)anchorId andisFans:(BOOL)isfans{
    self = [super initWithFrame:CGRectMake(0, 0 ,kScreenWidth , kScreenHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3];
        
        self.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - (450 + UI.bottomSafeAreaHeight) ,kScreenWidth , 450 + UI.bottomSafeAreaHeight)];
        self.popView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.popView];
        
        self.anchorId = anchorId;
        self.isfans = isfans;
        [self creatUI];
        [self requestFansEquityData];
    }
    return self;
}
- (void)requestFansEquityData{
    [JHFansRequestManager getFansEquityInfoWithAnchorId:self.anchorId successBlock:^(RequestModel * _Nullable respondObject) {
        self.model = [JHFansEquityListModel mj_objectWithKeyValues:respondObject.data];
        [self resetUI];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
- (void)resetUI{
    [_headImage jh_setAvatorWithUrl:self.model.anchorIcon];
    NSString * name = self.model.anchorName;
    if (self.model.anchorName.length>8) {
        name = [[self.model.anchorName substringToIndex:8] stringByAppendingString:@"…"];
    }
    _nameLabel.text = [NSString stringWithFormat:@"%@的粉丝团（%@人）",name,self.model.fansCount];
    [self.tableView reloadData];
    if (self.model.levelRewardVos.count>=self.model.userLevelType) {
        if (self.model.userLevelType == 0) {
            JHFansEquityLVModel * temp = self.model.levelRewardVos[self.model.userLevelType];
            temp.isget = NO;
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.equityView resetCollectWithModel:temp];
        }else{
            JHFansEquityLVModel * temp = self.model.levelRewardVos[self.model.userLevelType-1];
            temp.isget = YES;
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(self.model.userLevelType-1) inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.equityView resetCollectWithModel:temp];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.model.userLevelType-1) inSection:0] atScrollPosition:0 animated:NO];
        }
        
    }
    
}
- (void)creatUI{
    UIView * headView = [[UIView alloc] init];
    [self.popView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.popView);
        make.height.mas_equalTo(110);
    }];
    [headView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFF0C8), HEXCOLOR(0xFFFFFF)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    
    if (self.isfans) {
//
        UIButton * backnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backnBtn setImage:[UIImage imageNamed:@"newStore_icon_back_black"] forState:UIControlStateNormal];

        [backnBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        backnBtn.contentMode=UIViewContentModeScaleAspectFit;
        
        [self.popView addSubview:backnBtn];
        
        [backnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.top.equalTo(self.popView);
        }];
    }
    
    _headImage = [[UIImageView alloc]init];
    _headImage.image = kDefaultAvatarImage;
    _headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImage.layer.borderWidth = 2.f;
    _headImage.layer.cornerRadius = 35;
    _headImage.userInteractionEnabled = YES;
    [self.popView addSubview:_headImage];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.popView).offset(-35);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.centerX.mas_equalTo(self.popView.mas_centerX);
    }];
    
    _nameLabel = [[UILabel alloc]init];
    
    _nameLabel.font = [UIFont fontWithName:kFontMedium size:15];
    _nameLabel.textColor = kColor333;
    _nameLabel.numberOfLines = 1;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(@40);
    }];
    
    _questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_questionBtn setImage:[UIImage imageNamed:@"orderconfirm_introduce_icon"] forState:UIControlStateNormal];

    [_questionBtn addTarget:self action:@selector(questionBtnPress) forControlEvents:UIControlEventTouchUpInside];
    _questionBtn.contentMode=UIViewContentModeScaleAspectFit;
    
    [self.popView addSubview:_questionBtn];
    
    [_questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(39, 39));
        make.right.top.equalTo(self.popView);
    }];
    
    UILabel *leftLab = [[UILabel alloc]init];
    leftLab.text = @"等级：";
    leftLab.font = JHFont(12);
    leftLab.textColor = kColor333;
    leftLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@76);
    }];
    CGFloat height = 270;
    if (self.isfans) {
        height = height + 74;
    }
    self.equityView = [[JHFansEquityCollectionView alloc] init];
    self.equityView.backgroundColor = UIColor.whiteColor;
    [self.popView addSubview:self.equityView];
    [self.equityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(107);
        make.height.mas_equalTo(height);
    }];
    self.equityView.layer.shadowColor = UIColor.blackColor.CGColor;
    self.equityView.layer.shadowOffset = CGSizeMake(0, 1);
    self.equityView.layer.shadowOpacity = 0.1;
    self.equityView.layer.shadowRadius = 4;
    self.equityView.layer.cornerRadius = 4;
    
    [self.popView addSubview:self.tableView];
    
    if (!self.isfans) {
        [self.popView addSubview:self.joinFansGroupBtn];
        [self.joinFansGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.equityView.mas_bottom).offset(21);
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(45);
            
        }];
    }
        
}

#pragma mark ---UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.model.levelRewardVos[indexPath.row];
    JHFansEquityLVModel * temp = self.model.levelRewardVos[indexPath.row];
    if (indexPath.row <self.model.userLevelType) {
        temp.isget = YES;
    }else{
        temp.isget = NO;
    }
    
    [self.equityView resetCollectWithModel:self.model.levelRewardVos[indexPath.row]];
    [JHTracking trackEvent:@"djanClick" property:@{@"lever":@(indexPath.row+1)}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.levelRewardVos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"JHFansEquityTableViewCell";
    JHFansEquityTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[JHFansEquityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.transform = CGAffineTransformMakeRotation(- M_PI * 1.5);
    }
    JHFansEquityLVModel *temp = self.model.levelRewardVos[indexPath.row];
    [cell setCellWithTitle:[NSString stringWithFormat:@"%@%@",temp.levelType,temp.levelName]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F8"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}
- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        [_tableView setFrame:CGRectMake(48, 61, self.width-60, 49)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.estimatedRowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.bounces = NO;
    }
    return _tableView;
}
- (UIButton *)joinFansGroupBtn{
    if (!_joinFansGroupBtn) {
        _joinFansGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinFansGroupBtn.layer.cornerRadius = 22;
        _joinFansGroupBtn.titleLabel.font = JHFont(15);
        [_joinFansGroupBtn setTitle:@"加入Ta的粉丝团" forState:UIControlStateNormal];
        [_joinFansGroupBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [_joinFansGroupBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        [_joinFansGroupBtn addTarget:self action:@selector(joinFansGroupBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinFansGroupBtn;
}
- (void)questionBtnPress{
    JHFansEquityWebView * first =[[JHFansEquityWebView alloc] initWithFrame:self.popView.bounds];
    [JHKeyWindow addSubview:first];
    [first showAlert];
    [JHTracking trackEvent:@"gzanClick" property:@{@"from":@"粉丝团-权益弹层"}];
}
- (void)joinFansGroupBtnClickAction{
    @weakify(self);
    [JHFansRequestManager joinFansClubAction:self.fansClubId completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            //加入成功
            if (self.joinFansClubVlock) {
                self.joinFansClubVlock();
            }
            [self dismiss];
            [JHTracking trackEvent:@"jrfstClick" property:@{@"channel_local_id":self.channel_id,@"anchor_id":self.anchorId}];
        }else{
            //加入失败
//            [self makeToast:@"加入失败"];
        }
    }];
}

- (void)dismiss{
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isDescendantOfView:self.popView])
    {
        return NO;
    }
    
    return YES;
}
@end
