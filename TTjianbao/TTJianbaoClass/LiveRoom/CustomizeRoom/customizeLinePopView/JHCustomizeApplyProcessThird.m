//
//  JHCustomizeApplyProcessThird.m
//  TTjianbao
//
//  Created by apple on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeApplyProcessThird.h"
#import "JHMaterialsImageCell.h"
#import "JHAddMaterialsVideoAndImageCell.h"
#import "JHUploadManager.h"
#import "UIView+Toast.h"
#import "JHCustomizePopModel.h"
#import "SVProgressHUD.h"

@interface JHCustomizeApplyProcessThird ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSArray * imagearray; //示例图片
@property(nonatomic,strong) NSMutableArray * uploadImagearray; //上传图片
@end

@implementation JHCustomizeApplyProcessThird

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bar.frame= CGRectMake(0, 0, ScreenW, 362+UI.bottomSafeAreaHeight);
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    self.titleLabel.text = @"请上传您想要定制的原料影像（3/3）";
    [self creatBottomBtn:2];
    [self.sureBtn setTitle:@"确认申请" forState:UIControlStateNormal];
    [self.bar addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(self.sureBtn.mas_top).offset(-10);
                
    }];
    [self.bar bringSubviewToFront:self.topView];
    
}
- (void)requestImageData{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/appraisal/customizeSample/findSampleImgs") Parameters:@{@"cateId":self.applyModel.goodsCateId} successBlock:^(RequestModel * _Nullable respondObject) {
        
        self.imagearray = respondObject.data[@"images"];
        JHMaterialsImageCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell reloadCellData:self.imagearray];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xF5F6FA);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 136;
    }else if (indexPath.row == 1){
        return 171;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JHAddMaterialsVideoAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[JHAddMaterialsVideoAndImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.uploadImagearray = self.uploadImagearray;
        }
        
        return cell;
    }else if (indexPath.row == 1){
        JHMaterialsImageCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell1) {
            cell1 = [[JHMaterialsImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
//        [cell1 setCellToShowSample];
        return cell1;
    }
    return [UITableViewCell new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)nextClick:(UIButton *)sender{
    if (self.uploadImagearray.count == 0) {
        [self makeToast:@"请上传您想要定制的原料影像" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [self uploadImage];
}

#pragma mark - 上传images图片
- (void)uploadImage{
    [SVProgressHUD showProgress:1/100];
    [[JHUploadManager shareInstance] uploadImage_third:self.uploadImagearray uploadProgress:^(CGFloat progress){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress/100];
            NSLog(@"-----------=====-%f",progress/100);
        });

    } finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            for (NSString *imageUrl in imgKeys) {
                JHOwnMaterialsImageInfo * model = [[JHOwnMaterialsImageInfo alloc] init];
                model.type = @"0";
                model.url = imageUrl;
                model.coverUrl = imageUrl;
                [self.applyModel.materialList addObject:model];
            }
            [self applyLinkAuchor];
        });
    }];
}

- (void)applyLinkAuchor{
    [SVProgressHUD show];
    self.applyModel.materialSource = @"1";
    JH_WEAK(self);
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/createMaterialOrder") Parameters:[self.applyModel mj_keyValues] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        JH_STRONG(self);
        JHCustomizePopModel * model = [JHCustomizePopModel mj_objectWithKeyValues:respondObject.data];
        if (self.completeBlock) {
            self.completeBlock(model);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CustomizeApplyProcessFirstRemoveNoTip" object:nil];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
    }];
}
- (NSMutableArray *)uploadImagearray{
    if (!_uploadImagearray) {
        _uploadImagearray = [[NSMutableArray alloc] init];
    }
    return _uploadImagearray;
}
@end
