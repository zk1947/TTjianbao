//
//  AdressManagerViewController.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/1/19.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "AdressManagerViewController.h"
#import "AdressTableViewCell.h"
#import "AddAdressViewController.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoBussiness.h"
#define pagesize 10

@interface AdressManagerViewController ()<UITableViewDelegate,UITableViewDataSource,AdressTableViewCellDelegate>
{
      NSString *selectAdressId;
      NSInteger PageNum;
}
@property(nonatomic,strong) UITableView *contentTalbe;
@property (nonatomic,assign) CellButton cellButton;
@property (nonatomic,assign) NSInteger selectCellIndex;
@property (nonatomic,strong) NSMutableArray  *adressModels;
@property (nonatomic,strong) NSDictionary  *adressDic;
@end

@implementation AdressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    self.selectCellIndex=-1;
    [self.view addSubview:self.contentTalbe];
    [self setFootView];
    [self requestInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestInfo) name:ADRESSALTERSUSSNotifaction object:nil];
}

-(void)requestInfo{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/address/all") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
-(void)setDefaultAdress{
    
    [HttpRequestTool putWithURL:[FILE_BASE_STRING(@"/auth/address/default/") stringByAppendingString:OBJ_TO_STRING(selectAdressId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"设置成功"duration:1.0 position:CSToastPositionCenter];
        for (AdressMode *adressMode in self.adressModels ) {
            adressMode.isDefault=NO;
            if ([adressMode.ID isEqualToString:selectAdressId]) {
                adressMode.isDefault=YES;
            }
        }
        [self.contentTalbe reloadData];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
    
}
-(void)setDeleteAdress{
    
    [HttpRequestTool deleteWithURL:[FILE_BASE_STRING(@"/auth/address/") stringByAppendingString:OBJ_TO_STRING(selectAdressId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:@"删除成功"duration:1.0 position:CSToastPositionCenter];
        [self requestInfo];
        
        for (AdressMode *adressMode in self.adressModels ) {
            if ([adressMode.ID isEqualToString:selectAdressId]) {
                if (self.deleteBlock) {
                    self.deleteBlock(adressMode);
                }
                return;
            }
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
- (void)handleDataWithArr:(NSArray *)array {
    
    NSArray *arr = [AdressMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.adressModels = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.adressModels addObjectsFromArray:arr];
    }
    [self.contentTalbe reloadData];
    
    if ([arr count]<pagesize) {
        self.contentTalbe.mj_footer.hidden=YES;
    }
    else{
        self.contentTalbe.mj_footer.hidden=NO;
    }
}
- (void)endRefresh {
    [self.contentTalbe.mj_header endRefreshing];
    [self.contentTalbe.mj_footer endRefreshing];
    if (self.adressModels.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.contentTalbe];
    }
}

-(UITableView*)contentTalbe{

    if (!_contentTalbe) {
        
        _contentTalbe=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, self.view.frame.size.width, self.view.frame.size.height-UI.statusAndNavBarHeight-47) style:UITableViewStyleGrouped];
        _contentTalbe.delegate=self;
        _contentTalbe.dataSource=self;
        _contentTalbe.estimatedRowHeight = 100;
        _contentTalbe.alwaysBounceVertical=YES;
        _contentTalbe.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_contentTalbe setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
      return _contentTalbe;
}

-(void )setFootView{
    
    UIButton* _completeBtn=[[UIButton alloc]init];
    _completeBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [_completeBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    _completeBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [_completeBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
    [_completeBtn setBackgroundImage:[[UIImage imageNamed:@"commentButonImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [_completeBtn setBackgroundImage:[[UIImage imageNamed:@"commentButonImage.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    [_completeBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_completeBtn];
    
    [ _completeBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@47);
        make.left.offset(0);
        make.right.offset(0);
    }];
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.adressModels count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *downCellIdentifier=@"DownloadCell";
    AdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:downCellIdentifier];
    if(cell == nil)
    {
        cell = [[AdressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downCellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.delegate=self;
          [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
       
    }
        [cell setAdressMode:[self.adressModels objectAtIndex:indexPath.section]];
        [cell setCellIndex:indexPath.section];
    
        return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor blackColor];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor clearColor];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AdressMode * mode=[self.adressModels objectAtIndex:indexPath.section];
    if(self.selectedBlock){
        self.selectedBlock(mode);
        [self.navigationController popViewControllerAnimated:YES];
    }
    //修改订单地址
    if (self.orderId) {
        [self alterOrderAddress:mode.ID];
    }
}
-(void)buttonPress:(UIButton*)button cellIndex:(NSInteger)index{
    
    self.cellButton=(int)button.tag;
     self.selectCellIndex=index;
    
    switch (_cellButton) {
        case setDefault:
        {
            selectAdressId=[self.adressModels[self.selectCellIndex]ID];
            [self setDefaultAdress];
            
        }
            break;
            
        case setEdit:
        {
            AddAdressViewController * addAdessVC=[[AddAdressViewController alloc]init];
            AdressMode* adressMode=[self.adressModels objectAtIndex:self.selectCellIndex];
            NSDictionary *Dict = adressMode.mj_keyValues;
            AdressMode * newAdressMode= [AdressMode mj_objectWithKeyValues:Dict];
            [addAdessVC setAdress:newAdressMode];
            addAdessVC.isUpdateAdress=YES;
            addAdessVC.orderId=self.orderId;
            addAdessVC.fromType=1;
            [self.navigationController pushViewController: addAdessVC animated:YES];
            
        }
            break;
            
        case setDelete:
            selectAdressId=[self.adressModels[self.selectCellIndex]ID];
            [self setDeleteAdress];
            break;
        default:
            break;
    }
    
}
-(void)buttonPress:(UIButton*)button{
    
    AddAdressViewController * addAdessVC=[[AddAdressViewController alloc]init];
    addAdessVC.isUpdateAdress=NO;
    addAdessVC.orderId=self.orderId;
    addAdessVC.fromType=1;
    [self.navigationController pushViewController: addAdessVC animated:YES];
}

-(void)alterOrderAddress:(NSString*)addressId{
    
    [JHOrderViewModel alterOrderAddressByOrderId:self.orderId andAddressId:addressId completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
                 [self.navigationController popViewControllerAnimated:YES];
              [[UIApplication sharedApplication].keyWindow makeToast:@"修改地址成功" duration:2 position:CSToastPositionCenter];
        }
        else{
              [self.view makeToast:respondObject.message duration:2 position:CSToastPositionCenter];
        }
    }];
    [SVProgressHUD show];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
