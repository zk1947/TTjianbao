//
//  AddAdressViewController.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/1/20.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "AddAdressViewController.h"
#import "CusDatePickerWithArea.h"
#import "JHOrderConfirmViewController.h"
#import "MySingleton.h"
#import "JHOrderListViewController.h"
#import "JHOrderDetailViewController.h"
#import <IQKeyboardManager.h>
#import "JHOrderViewModel.h"
#import "UITextField+PlaceHolderColor.h"
#import "JHUIFactory.h"
#import "TTjianbaoBussiness.h"
#import "UIImage+JHColor.h"
#define changeDesc         @"changeDesc"
#define selectCityIndex    @"selectCityIndex"  // 选中城市的下标
@interface AddAdressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
{
    CusDatePickerWithArea  *pickArea;   // PickView视图
    UILabel *titleTip;
}
@property(nonatomic,strong)UITableView *contentTalbe;
@property(nonatomic,strong)NSArray *listArr;
@property(nonatomic,strong)UITextField *nametextField;
@property(nonatomic,strong)UITextField *phoneNumtextField;
@property(nonatomic,strong)UITextView *detailAdress;
@property(nonatomic,strong)UITextField *provinceData;
@property(nonatomic,strong)UISwitch *switchView;
@property (nonatomic,strong)CityModelData  *cityModel;

@end

@implementation AddAdressViewController

/** 动态获取国内地址库*/
- (void)loadAddressData {
    [SVProgressHUD show];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/appConfig/addressDict") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
           if (respondObject.code == 1000) {
               MySingleton *mySing=[MySingleton shareMySingleton];
               NSString *webChinaAddressUrl = respondObject.data[@"chinaAddressUrl"];
               if (mySing.cityModel) {
                   _cityModel=mySing.cityModel;
               }else {
               NSURL *url = [NSURL URLWithString:webChinaAddressUrl];
               NSString *chinaAddressStr = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
               NSArray *chinaAddressArr = [chinaAddressStr mj_JSONObject];
               NSDictionary *dicValue=@{@"province":chinaAddressArr};
               _cityModel=[CityModelData mj_objectWithKeyValues:dicValue];
               mySing.cityModel=_cityModel;
               }
               [[NSUserDefaults standardUserDefaults] setObject:webChinaAddressUrl forKey:@"webChinaAddressUrl"];
               [[NSUserDefaults standardUserDefaults]synchronize];
               [self addPickView];
           }
       } failureBlock:^(RequestModel * _Nullable respondObject) {
           [SVProgressHUD dismiss];
           NSString *chinaAddressUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"webChinaAddressUrl"];
           if (chinaAddressUrl.length > 0) {
               MySingleton *mySing=[MySingleton shareMySingleton];
               if (mySing.cityModel) {
                   _cityModel=mySing.cityModel;
               }else {
               NSURL *url = [NSURL URLWithString:chinaAddressUrl];
               NSString *chinaAddressStr = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
               NSArray *chinaAddressArr = [chinaAddressStr mj_JSONObject];
               NSDictionary *dicValue=@{@"province":chinaAddressArr};
               _cityModel=[CityModelData mj_objectWithKeyValues:dicValue];
               mySing.cityModel=_cityModel;
               }
               [self addPickView];
           }
       }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.isUpdateAdress=NO;
        self.fromType=1;
        self.adress.isDefault = YES;
        _listArr=@[@[@"收货人",@"联系电话",@"所在地区",@""],
                   @[@""]
                  ];
    }
         return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentTalbe];
    [self setFootView];
//    [self initToolsBar];
//    [self.navbar setTitle:@"新增地址"];
    self.title = @"新增地址";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        //关闭键盘
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissTable)];
    tap.delegate=self;
    [self.contentTalbe  addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)setFromType:(NSInteger)fromType{
    _fromType=fromType;
    if (fromType==1) {
        [JHGrowingIO trackEventId:JHTrackCreateAddressEnter from:JHAddAddressFromAddressManger];
    }
    if (fromType==2) {
        [JHGrowingIO trackEventId:JHTrackCreateAddressEnter from:JHAddAddressFromConfirm];
    }
    
}
-(void)setAdressMode:(AdressMode *)adressMode{
    
}
-(void)reloadTable{
    
    [self.contentTalbe reloadData];
}
-(void)updateAdress{
 
    [HttpRequestTool putWithURL:[FILE_BASE_STRING(@"/auth/address/") stringByAppendingString:OBJ_TO_STRING(self.adress.ID)] Parameters:[self getJsonParameter] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"修改成功"duration:1.0 position:CSToastPositionCenter];
         [[NSNotificationCenter defaultCenter] postNotificationName:ADRESSALTERSUSSNotifaction object:nil];//
        [self.navigationController  popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
  
}

-(void)addAdress{
   
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/address") Parameters:[self getJsonParameter] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        
          [SVProgressHUD dismiss];
        
         [self.view makeToast:@"添加成功"duration:1.0 position:CSToastPositionCenter];
         [[NSNotificationCenter defaultCenter] postNotificationName:ADRESSALTERSUSSNotifaction object:nil];//
        //修改订单地址
        if (self.orderId) {
            [self requestAddress];
        }
        else{
            BOOL isPopOrderVC=NO;
            for (UIViewController* vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass: [JHOrderConfirmViewController class]]) {
                    isPopOrderVC=YES;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            if (!isPopOrderVC) {
                
                [self.navigationController  popViewControllerAnimated:YES];
            }
        }
      
        
    } failureBlock:^(RequestModel *respondObject) {
        
          [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
         [SVProgressHUD dismiss];
    }];
   
    [SVProgressHUD show];
}
-(id)getJsonParameter{
    
    //self.adress.isDefault=YES;
    NSDictionary *parameters=@{ @"province":self.adress.province,
                               @"city":self.adress.city,
                               @"county":self.adress.county,
                               @"isDefault":[NSString stringWithFormat:@"%i",self.adress.isDefault],
                               @"detail":self.adress.detail,
                               @"phone":self.adress.phone,
                               @"receiverName":self.adress.receiverName,
                               };
    
    return parameters;
    
}
-(UITableView*)contentTalbe{
    
    if (!_contentTalbe) {
        
        _contentTalbe=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, self.view.frame.size.width, self.view.frame.size.height-UI.statusAndNavBarHeight) style:UITableViewStyleGrouped];
        _contentTalbe.delegate=self;
        _contentTalbe.dataSource=self;
        _contentTalbe.alwaysBounceVertical=YES;
        _contentTalbe.scrollEnabled=NO;
      //  _contentTalbe.tableFooterView = [self setFootView];
        _contentTalbe.backgroundColor=[CommHelp toUIColorByStr:@"ffffff"];
        [_contentTalbe setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    
    return _contentTalbe;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
        return  YES;
}
-(void)dismissTable{
    [self.view endEditing:YES];
}
-(void)setFootView{
    
//    UIView *footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
//    footer.backgroundColor=[UIColor clearColor];
    
       UILabel * title=[[UILabel alloc]init];
       title.text=@"因边疆公安部门要求，为了正常发货，请填写真实姓名哦";
       title.font=[UIFont fontWithName:kFontNormal size:11];
       title.textColor=kColor999;
       title.numberOfLines = 1;
       title.textAlignment = NSTextAlignmentCenter;
       title.lineBreakMode = NSLineBreakByWordWrapping;
       [self.view addSubview:title];
     
    [ title  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton* button=[[UIButton alloc]init];
   // button.backgroundColor=kColorMain;
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(ScreenW-60, 44) radius:22];
    [button setBackgroundImage:nor_image forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:kFontMedium size:16];
    button.layer.cornerRadius=22;
    button.layer.masksToBounds=YES;
    [button setTitleColor:kColor333 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [ button  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(title.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@44);
        make.left.offset(30);
        make.right.offset(-30);
    }];
    if (self.fromType==2) {
          [button setTitle: @"保存并使用" forState:UIControlStateNormal];
    }
    else{
         [button setTitle: @"保存" forState:UIControlStateNormal];
    }
    
    
   
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.listArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [(NSArray*)[self.listArr objectAtIndex:section]count] ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *SimpleTableIdentifier = [NSString stringWithFormat:@"cell%@",[[self.listArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        if(cell.contentView){};//这里调用点语法,为了兼容xcode12及以上
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
               
                self.nametextField= [[UITextField alloc]init];
                self.nametextField.backgroundColor=[UIColor clearColor];
                self.nametextField.delegate=self;
                self.nametextField.textAlignment = NSTextAlignmentLeft;
                self.nametextField.borderStyle = UITextBorderStyleNone;//边框样式
                 self.nametextField.userInteractionEnabled = YES;//边框样式
                self.nametextField.font=[UIFont fontWithName:kFontMedium size:14];
                self.nametextField.textColor=kColor333;
                 self.nametextField.placeholder = @"请填写收货人姓名";
                 self.nametextField.returnKeyType =UIReturnKeyDone;
                [cell addSubview:self.nametextField];
                
                [self.nametextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                     make.left.equalTo(cell).offset(87);
                     make.right.equalTo(cell).offset(-20);
                     make.top.bottom.equalTo(cell);
                    
                }];
                
                JHCustomLine *line = [JHUIFactory createLine];
                [cell addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell).offset(0);
                    make.height.equalTo(@1);
                    make.left.offset(0);
                    make.right.offset(0);
                }];
                
            }
            if (indexPath.row==1) {
                
                UILabel * title=[[UILabel alloc]init];
                title.text=@"+86";
                title.font=[UIFont fontWithName:kFontMedium size:15];
                title.textColor=kColor333;
                title.numberOfLines = 1;
                [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
                [title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
                title.textAlignment = NSTextAlignmentLeft;
                title.lineBreakMode = NSLineBreakByWordWrapping;
                [cell addSubview:title];
                [cell addSubview:self.phoneNumtextField];
                
                [title mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(cell).offset(90);
                    make.top.bottom.equalTo(cell);
                    
                }];
                
                self.phoneNumtextField= [[UITextField alloc]init];
                self.phoneNumtextField.delegate=self;
                self.phoneNumtextField.userInteractionEnabled = YES;//边框样式
                self.phoneNumtextField.font=[UIFont fontWithName:kFontMedium size:14];
                self.phoneNumtextField.textAlignment = NSTextAlignmentLeft;
                self.phoneNumtextField.borderStyle = UITextBorderStyleNone;//边框样式
                self.phoneNumtextField.placeholder = @"请填写收货人手机号";
                 self.phoneNumtextField.textColor=kColor333;
                 self.phoneNumtextField.returnKeyType =UIReturnKeyDone;
                 self.phoneNumtextField.keyboardType = UIKeyboardTypeNumberPad;
                [ self.phoneNumtextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
                [cell addSubview:self.phoneNumtextField];
                
                [self.phoneNumtextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(title.mas_right).offset(20);
                    make.right.equalTo(cell).offset(-20);
                    make.top.bottom.equalTo(cell);
                    
                }];
            }
            
            if (indexPath.row==2) {
                
                  UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addadress_choose_icon"]];
                   [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
                   [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
                   indicator.contentMode = UIViewContentModeScaleAspectFit;
                   [cell addSubview:indicator];
                   [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.right.equalTo(cell).offset(-15);
                       make.centerY.equalTo(cell);
                   }];
                
                UILabel * title=[[UILabel alloc]init];
                title.text=@"请选择";
                title.font=[UIFont fontWithName:kFontNormal size:15];
                title.textColor=kColor333;
                title.numberOfLines = 1;
                [title setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
                [title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
                title.textAlignment = NSTextAlignmentLeft;
                title.lineBreakMode = NSLineBreakByWordWrapping;
                [cell addSubview:title];
                
                [title mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(indicator.mas_left).offset(-10);
                    make.top.bottom.equalTo(cell);
                    
                }];
                
                self.provinceData=[[UITextField alloc]init];
                self.provinceData.placeholder = @"省市区县等";
                self.provinceData.font=[UIFont fontWithName:kFontMedium size:14];
                self.provinceData.backgroundColor=[UIColor clearColor];
                self.provinceData.textColor=kColor333;
                self.provinceData.userInteractionEnabled = NO;
                self.provinceData.textAlignment = NSTextAlignmentLeft;
                [cell addSubview:self.provinceData];
                
                [self.provinceData mas_makeConstraints:^(MASConstraintMaker *make) {
                      make.top.bottom.equalTo(cell);
                      make.left.equalTo(cell).offset(90);
                    make.right.equalTo(title.mas_left).offset(-10);
                }];
            }
            
            if (indexPath.row==3) {
                
                UILabel * title=[[UILabel alloc]init];
                title.text=@"详细地址";
                title.font=[UIFont systemFontOfSize:14];
                title.backgroundColor=[UIColor clearColor];
                title.textColor=kColor333;
                title.numberOfLines = 1;
                title.textAlignment = NSTextAlignmentLeft;
                title.lineBreakMode = NSLineBreakByWordWrapping;
                [cell addSubview:title];
                
                self.detailAdress=[[UITextView alloc]init];
                self.detailAdress.backgroundColor=[UIColor clearColor];
               
                self.detailAdress.font = [UIFont fontWithName:kFontMedium size:14];
                self.detailAdress.textColor=kColor333;
                self.detailAdress.alpha=1.0;
                self.detailAdress.delegate=self;
                [self.detailAdress setScrollEnabled:YES];
                self.detailAdress.autocorrectionType = UITextAutocorrectionTypeYes;
                self.detailAdress.autocapitalizationType = UITextAutocapitalizationTypeNone;
                self.detailAdress.keyboardType = UIKeyboardTypeDefault;
                self.detailAdress.returnKeyType = UIReturnKeyDone;
                [cell addSubview:self.detailAdress];
                
                [title mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell).offset(10);
                    make.left.equalTo(cell).offset(18);
                }];
                
                   titleTip=[[UILabel alloc]init];
                   titleTip.text=@"请填写街道，小区，楼牌号等";
                   titleTip.font=[UIFont systemFontOfSize:15];
                   titleTip.backgroundColor=[UIColor clearColor];
                   titleTip.textColor=kColor999;
                   titleTip.numberOfLines = 1;
                   titleTip.textAlignment = NSTextAlignmentLeft;
                   titleTip.lineBreakMode = NSLineBreakByWordWrapping;
                   [self.detailAdress addSubview:titleTip];
                   
                    [titleTip mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.top.equalTo(self.detailAdress).offset(9);
                       make.left.equalTo(self.detailAdress).offset(5);
                       make.width.equalTo(self.detailAdress);
                   }];
                
                [self.detailAdress mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell).offset(0.5);
                    make.left.equalTo(title.mas_right).offset(5);
                    make.right.equalTo(cell).offset(-5);
                    make.bottom.equalTo(cell).offset(-10);
                }];
            }
            
            
            JHCustomLine *line = [[JHCustomLine alloc] initWithFrame:CGRectZero andColor:HEXCOLOR(0xF5F6FA)];
            [cell addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell).offset(-1);
                make.height.equalTo(@0.5);
                make.left.offset(15);
                make.right.offset(0);
            }];
            
        }
        
        if (indexPath.section==1) {
            
            if (indexPath.row==0) {
                
                UILabel * title=[[UILabel alloc]init];
                title.text=@"设置默认地址";
                title.font=[UIFont fontWithName:kFontNormal size:15];
                title.backgroundColor=[UIColor clearColor];
                title.textColor=kColor333;
                title.numberOfLines = 1;
                title.textAlignment = NSTextAlignmentLeft;
                title.lineBreakMode = NSLineBreakByWordWrapping;
                [cell addSubview:title];
                [title mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell).offset(-14);
                    make.left.equalTo(cell).offset(20);
                }];
                
                UILabel * tip=[[UILabel alloc]init];
                tip.text=@"提醒：每次下单会默认推荐使用该地址";
                tip.font=[UIFont fontWithName:kFontNormal size:12];
                tip.backgroundColor=[UIColor clearColor];
                tip.textColor=kColor999;
                tip.numberOfLines = 1;
                tip.textAlignment = NSTextAlignmentLeft;
                tip.lineBreakMode = NSLineBreakByWordWrapping;
                [cell addSubview:tip];
                [tip mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell).offset(14);
                    make.left.equalTo(cell).offset(20);
                }];
                
                _switchView=[[UISwitch alloc]init];
               // _switchView.center=CGPointMake(ScreenW-50, cell.center.y);
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                _switchView.onTintColor= [CommHelp toUIColorByStr:@"#ffe300"];
                [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:_switchView];
                [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell);
                    make.right.equalTo(cell).offset(-20);
                }];
                
            }
        }
        
        if (self.adress.receiverName&&_adress.phone) {
            self.nametextField.text=_adress.receiverName;
            self.phoneNumtextField.text=_adress.phone;
            self.detailAdress.text=_adress.detail;
            self.provinceData.text=[NSString stringWithFormat:@"%@ %@ %@",_adress.province,_adress.city,_adress.county];
             [titleTip setHidden:YES];
            
        }
        if (_adress.isDefault) {
            _switchView.on=YES;
        }
        else{
            _switchView.on=NO;
        }
    }
    
    cell.textLabel.text=[[self.listArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:kFontNormal size:15];
    cell.textLabel.textColor=kColor333;

    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==0) {
        
        return 10;
    }
     return CGFLOAT_MIN;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section==0) {
        
        if (indexPath.row==3) {
            return 70;
        }
    }
    if (indexPath.section==1) {
           
           if (indexPath.row==0) {
               return 100;
           }
       }
    
    return 50;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=kColorF5F6FA;
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor clearColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        
        if (indexPath.row==2) {
           
//            [self addPickView];
            [self loadAddressData];
        }
    }
}
-(void)buttonPress:(UIButton*)button{
    

    if (self.fromType==2){
        [JHGrowingIO trackEventId:JHTrackCreatAddressSaveandUseClick];
    }
    if ([self.nametextField.text length]==0) {
          [self.view makeToast:@"请填写收货人姓名"duration:1.0 position:CSToastPositionCenter];
      
        return;
    }
   
    if ([self.phoneNumtextField.text length]!=11||![CommHelp isNum:self.phoneNumtextField.text]) {
          [self.view makeToast:@"请填写正确的手机号"duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (![[self.phoneNumtextField.text substringToIndex:1] isEqualToString:@"1"]) {
             [self.view makeToast:@"请填写正确的手机号"duration:1.0 position:CSToastPositionCenter];
           return;
       }
    if ([self.detailAdress.text length]==0) {
         [self.view makeToast:@"请输入收货人详细地址"duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if ([self.provinceData.text length]==0) {
        [self.view makeToast:@"请选择省市地区"duration:1.0 position:CSToastPositionCenter];
        return;
    }
   
//    if ([CommHelp isIncludeSpecialCharact:self.detailAdress.text]||
//         [CommHelp stringContainsEmoji:self.detailAdress.text]||
//        [CommHelp stringContainsEmoji:self.nametextField.text]||
//        [CommHelp isIncludeSpecialCharact:self.nametextField.text]) {
//        [UITipView showTipStr:@"包含非法字符，请填写正确的地址"];
//        return;
//    }
    if (!_adress) {
      _adress=[[AdressMode alloc]init];
    }
    
    self.adress.receiverName=self.nametextField.text;
    self.adress.phone=self.phoneNumtextField.text;
    self.adress.detail=self.detailAdress.text;
    self.isUpdateAdress? [self updateAdress]: [self addAdress];
    
}
-(void)switchAction:(UISwitch*)aSwitch{
    
    if (!self.adress) {
        self.adressMode=[[AdressMode alloc]init];
    }
      self.adress.isDefault=aSwitch.on?YES:NO;

}
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    self.contentTalbe.frame=CGRectMake(0,UI.statusAndNavBarHeight, self.view.frame.size.width, self.view.frame.size.height-UI.statusAndNavBarHeight-keyboardRect.size.height) ;
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    self.contentTalbe.frame=CGRectMake(0,UI.statusAndNavBarHeight, self.view.frame.size.width, self.view.frame.size.height-UI.statusAndNavBarHeight) ;
    
}

#pragma mark
- (void)showPickView:(UIButton *)sender {
    [self addPickView];
}
#pragma mark
-(void)addPickView{
    
      __weak __typeof(self) weakSelf = self;
    
    pickArea=[[CusDatePickerWithArea alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH+240) cityData:weakSelf.cityModel];
    
    if (self.adress) {
          NSInteger provinceIndex=[self.adress.province integerValue];
          NSInteger cityIndex=    [self.adress.city integerValue];
          NSInteger districtIndex=[self.adress.county integerValue];
          [pickArea scrollToProvince:provinceIndex city:cityIndex dictrict:districtIndex];  // 没有选择的情况下,默认滚动到北京
        }
    else{
             [pickArea scrollToProvince:1 city:1 dictrict:5];  // 没有选择的情况下,默认滚动到北京
    }
      UIWindow *myWindow=[[UIApplication sharedApplication]keyWindow];
      [myWindow addSubview:pickArea];
   
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = pickArea.center;
        point.y      -= 240;
        pickArea.center   = point;
    } completion:^(BOOL finished) {
    }];
    [myWindow addSubview:pickArea];
    
    pickArea.areaValue=^(NSDictionary *area){  //Block回调传
        
        if (!weakSelf.adress) {
            weakSelf.adress=[[AdressMode alloc]init];
        }
          weakSelf.adress.province=area[@"province"];
          weakSelf.adress.city=area[@"city"];
          weakSelf.adress.county=area[@"dictrict"];
          weakSelf.provinceData.text=[NSString stringWithFormat:@"%@%@%@", weakSelf.adress.province, weakSelf.adress.city, weakSelf.adress.county];
    };
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [titleTip setHidden:NO];
    }else{
        [titleTip setHidden:YES];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //空格键
    if ([string isEqualToString:@" "]) {
         return NO;
      }
    
     return YES;
}
-(void)textFieldTextChange:(UITextField *)textField{

    if (textField ==self.phoneNumtextField) {
         if (textField.text.length > 11){
         textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
    }
 }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //回车键
    if ([text isEqualToString:@"\n"]){
          [textView resignFirstResponder];
          return NO;
    }
    //空格键
    if ([text isEqualToString:@" "]) {
        return NO;
    }
   
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestAddress{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/address/default") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        AdressMode *addressMode = [AdressMode  mj_objectWithKeyValues: respondObject.data];
        [self alterOrderAddress:addressMode.ID];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
-(void)alterOrderAddress:(NSString*)addressId{
    [JHOrderViewModel alterOrderAddressByOrderId:self.orderId andAddressId:addressId completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
            [[UIApplication sharedApplication].keyWindow makeToast:@"修改地址成功" duration:2 position:CSToastPositionCenter];
             BOOL isPopOrderVC=NO;
            for (UIViewController* vc in self.navigationController.viewControllers) {
                
                if ([vc isKindOfClass: [JHOrderListViewController class]]) {
                    isPopOrderVC=YES;
                    [self.navigationController popToViewController:vc animated:YES];
                }
              else  if ([vc isKindOfClass: [JHOrderDetailViewController class]]) {
                    isPopOrderVC=YES;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            if (!isPopOrderVC) {
                [self.navigationController  popViewControllerAnimated:YES];
            }
        }
        else{
            [self.view makeToast:respondObject.message duration:2 position:CSToastPositionCenter];
        }
    }];
        [SVProgressHUD show];
}
-(AdressMode*)adress{
   
    if (!_adress) {
        _adress = [[AdressMode alloc]init];
    }
    return _adress;
}
@end
