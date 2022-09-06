//
//  LNLaunchVC.m
//  BabyTest
//
//  Created by Hello on 2019/5/10.
//  Copyright © 2019 LSJ. All rights reserved.
//

#import "LNLaunchVC.h"
#import "JHSelectIntrestCollectionViewCell.h"
#import "JHDiscoverChannelViewModel.h"
#import "JHDiscoverChannelModel.h"
#import "TTjianbaoHeader.h"
#import "JHAppAlertViewManger.h"
@interface LNLaunchVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *errButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic, assign) NSInteger selectedNewChannelId;
@end


@implementation LNLaunchVC

-(void)dealloc
{
    [JHAppAlertViewManger appAlertshowing:NO];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [JHAppAlertViewManger appAlertshowing:YES];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (IBAction)errorBtAction:(id)sender {
    [self requestChannelInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configBackBtn];
    self.errButton.hidden = YES;
    [self requestChannelInfo];
    //[self performSelector:@selector(requestChannelInfo) withObject:nil afterDelay:0.2];
}

- (void)configBackBtn {
    if (!_hideBackBtn) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, UI.statusBarHeight, 44, 44);
        [backBtn setImage:kNavBackBlackImg forState:UIControlStateNormal];
        
        @weakify(self);
        [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self.collectionView addSubview:backBtn];
    }
}

- (void)requestChannelInfo {
    [SVProgressHUD show];
    //[self.view beginLoading];
    @weakify(self);
    [JHDiscoverChannelViewModel getChannelListWithSuccess:^(RequestModel * _Nonnull request) {
        @strongify(self);
        [SVProgressHUD dismiss];
        //[self.view endLoading];
        NSMutableArray *arr = request.data;
        for (NSDictionary *dic in arr) {
            JHDiscoverChannelModel *model = [JHDiscoverChannelModel modelWithDictionary:dic];
            if (model.is_show) {
                // 是否在编辑页显示，0-默认隐藏，1-显示
                [self.dataArr addObject:model];
            }
        }
        [self checkDoneButton];
        [self.collectionView reloadData];
        self.errButton.hidden = YES;
        if (self.didShowNewChannel) {
            self.didShowNewChannel();
        }
    } failure:^(RequestModel * _Nonnull request) {
        @strongify(self);
        [SVProgressHUD dismiss];
        //[self.view endLoading];
        [UITipView showTipStr:request.message];
        self.errButton.hidden = NO;
    }];
}

- (NSInteger)caculteSelectDataArray {
    __block NSInteger num = 0;
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JHDiscoverChannelModel *model = (JHDiscoverChannelModel *)obj;
        if (model.is_show && model.is_selected) {
            num++;
        }
    }];
    return num;
}

- (void)checkDoneButton {
    NSInteger selCount = [self caculteSelectDataArray];
    if (selCount >= 3) {
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"dis_nextEnable"] forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"dis_nextDisenable"] forState:UIControlStateNormal];
        [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.nextBtn setTitle:[NSString stringWithFormat:@"至少选择3个频道(%ld/3)",(long) selCount] forState:UIControlStateNormal];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHSelectIntrestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LNLaunchVC_ItemID" forIndexPath:indexPath];
    [cell setModel:self.dataArr[indexPath.item]];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        identifier = @"LNLaunchVC_FooterID";
    }
    UICollectionReusableView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    return headerview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHDiscoverChannelModel *model = self.dataArr[indexPath.item];
    if (model.is_selected == 0) {
        model.is_selected = 1;
    }else if (model.is_selected == 1) {
        model.is_selected = 0;
    }else {
        return;
    }
    JHSelectIntrestCollectionViewCell *cell = (JHSelectIntrestCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell beginAnimation_Logo];
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self checkDoneButton];
}

- (IBAction)clickNextBtn:(UIButton *)sender {
    self.selectedNewChannelId = -9999;
    __block NSInteger selectedCount = 0;
    NSMutableString *channelIds = [NSMutableString string];
    
    @weakify(self);
    [self.dataArr enumerateObjectsUsingBlock:^(JHDiscoverChannelModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JHDiscoverChannelModel *model = obj;
        if (model.is_selected == 1) {
            selectedCount++;
            if (selectedCount == 1) {
                [channelIds appendString:[NSString stringWithFormat:@"%ld", (long)model.channel_id]];
            }else {
                [channelIds appendString:[NSString stringWithFormat:@",%ld", (long)model.channel_id]];
            }
        }
        if (model.tag_type == 1 && self.selectedNewChannelId == -9999) {
            @strongify(self);
            self.selectedNewChannelId = model.channel_id;
        }
    }];
    
    if (selectedCount < 3) {
        [SVProgressHUD showErrorWithStatus:@"至少选中三个哟"];
        return;
    }
    NSLog(@"channelIds = %@", channelIds);

    //请求接口
    [JHDiscoverChannelViewModel submitChannelWithIds:channelIds success:^(RequestModel * _Nonnull request) {
        @strongify(self);
        if (request.data) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kChannelDataOfResponseNoticeName object:nil userInfo:@{@"key":request.data, @"selectedNewChannelId" : @(self.selectedNewChannelId)}];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if(_completeBlock)
        {
            _completeBlock();
        }
        
    } failure:^(RequestModel * _Nonnull request) {
        [UITipView showTipStr:request.message];
    }];
    
    //埋点
    if (self.hideBackBtn) {
        [Growing track:@"typechoice" withVariable:@{@"value":@(selectedCount)}];
    } else {
        [Growing track:@"sendedit"];
    }
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end

