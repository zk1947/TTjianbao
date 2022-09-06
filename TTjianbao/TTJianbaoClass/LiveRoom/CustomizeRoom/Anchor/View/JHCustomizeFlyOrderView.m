//
//  JHCustomizeFlyOrderView.m
//  TTjianbao
//
//  Created by lihang on 2020/11/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeFlyOrderView.h"
#import "IQKeyboardManager.h"
#import "TZImagePickerController.h"
#import "UITextField+PlaceHolderColor.h"
#import "JHTitleTextItemView.h"
#import "JHPickerView.h"
#import "UserInfoRequestManager.h"
#import "JHCustomizeFlyOrderTagsView.h"
#import "JHCustomizeFlyOrderCountPickerView.h"
#import "JHCustomizeFlyOrderCountCategoryModel.h"
#import "NTESGrowingInternalTextView.h"
#import "UIView+JHGradient.h"
#import "JHSendOrderModel.h"
#import "JHAntiFraud.h"
#import "NOSUpImageTool.h"
#import "JHImagePickerPublishManager.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "UIView+JHToast.h"
#import "CommAlertView.h"
#import "JHCustomizePackageFlyOrderModel.h"

#define backWidth  260
@interface JHCustomizeFlyOrderView()<STPickerSingleDelegate,JHCustomizeFlyOrderTagsViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIView *screenImageBGView;
@property (nonatomic, strong) UIScrollView *imagesBGView;

@property (nonatomic, copy) NSString *screenImageUrl;
@property (nonatomic, strong) NSMutableArray *imagesArray;//里面存{@"image":(UIImage*),@"url":(NSString*),@"isUpload":(NSString*)}
@property (nonatomic, strong) UITextField *yuFuKuanField;

@property (nonatomic, strong) JHPickerView *picker;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) UITextField *categoryField;//只展示
@property (nonatomic, strong) JHCustomizeFlyOrderTagsView *countTagsView;
@property (nonatomic, strong) NSArray *countNumArray;
@property (nonatomic, strong) NSMutableArray *selectedCountArray;
@property (nonatomic, strong) JHCustomizeFlyOrderCountPickerView *countPicker;
@property (nonatomic, strong) UIButton *addCountBtn;
@property (strong, nonatomic) NTESGrowingInternalTextView *descTextView;
@property (nonatomic, strong) NSMutableArray *allImagesArray;//截屏加images,最后提交订单时候汇总起来
@property (nonatomic, strong) NSString *customizePackageFirstImg;
@end

@implementation JHCustomizeFlyOrderView

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)showAlert {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;
    
    [self initImageArray];//初始化图片
    [self initCountArray];//初始化定制个数
    [self makeUI];
    if (self.customizeType != JHCustomizedAndNormalOrder) {
        [self getCateAll];
    }
    [self getCountAll];
    [super showAlert];
}

- (void)initImageArray {
    if(self.imageUrl) {
        NSArray *array = [self.imageUrl componentsSeparatedByString:@","];
        for (NSString* url in array) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:url forKey:@"url"];
            [dic setValue:@"1" forKey:@"isUpload"];
            [self.imagesArray addObject:dic];
        }
    }
}

- (void)initCountArray {
    if(self.customizeFeeId.length > 0 && self.customizeFeeId.intValue > 0){
        NSArray *array = [self.customizeFeeId componentsSeparatedByString:@","];
        for (NSString* subId in array) {
            JHCustomizeFlyOrderCountCategoryModel *subModel = [[JHCustomizeFlyOrderCountCategoryModel alloc]init];
            subModel.customizeFeeId = subId;
            subModel.count = @"1";
            
            // 获取名字
            for (JHCustomizeFlyOrderCountCategoryModel *model in self.countCategaryArray) {
                if([subId isEqualToString:model.customizeFeeId]){
                    subModel.customizeFeeName = model.customizeFeeName;
                    break;
                }
            }
            [self.selectedCountArray addObject:subModel];
        }
    }
}


- (void)makeUI {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@backWidth);
        make.height.equalTo(@595);
    }];
    self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    //添加标题
    UILabel *topTitleLabel = [[UILabel alloc]init];
    topTitleLabel.font = [UIFont fontWithName:kFontNormal size:18];
    topTitleLabel.textColor = kColorFFF;
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    topTitleLabel.text = @"定制订单";
    [self.backView addSubview:topTitleLabel];
    [topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@20);
    }];
    
    [self.closeBtn setImage:[UIImage imageNamed:@"icon_close_white"] forState:UIControlStateNormal];
    
    //添加截屏
    [self.backView addSubview:self.screenImageBGView];
    [self.screenImageBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topTitleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@240);
    }];
    [self reloadScreenImageBGView];
    
    
    //添加图片
    [self.backView addSubview:self.imagesBGView];
    [self.imagesBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.screenImageBGView.mas_bottom).offset(10);
        make.left.right.equalTo(self.screenImageBGView);
        make.height.equalTo(@60);
    }];
    [self reloadImagesBGView];
    
    //添加预付款
    UIView *yuFuKuanView = [[UIView alloc] init];
    [self.backView addSubview:yuFuKuanView];
    yuFuKuanView.frame = CGRectMake(0, 370, backWidth, 37);
    
    
    JHTitleTextItemView *yuFuKuanItemView = [[JHTitleTextItemView alloc] initWithTitle:@"预付款:    " textPlace:@"¥请输入金额" isEdit:YES isShowLine:YES];
    [yuFuKuanView addSubview:yuFuKuanItemView];
    [yuFuKuanItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    yuFuKuanItemView.isCarryTwoDote = YES;
    yuFuKuanItemView.line.backgroundColor = [UIColor colorWithHexString:@"#F5F6FA"];
    yuFuKuanItemView.line.hidden = NO;
    [yuFuKuanItemView.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
    }];
    yuFuKuanItemView.titleLabel.font = [UIFont systemFontOfSize:13];
    yuFuKuanItemView.titleLabel.textColor = kColorFFF;
    
    self.yuFuKuanField = yuFuKuanItemView.textField;
//    self.yuFuKuanField.delegate = self;
    [self.yuFuKuanField placeHolderColor:[UIColor colorWithHexString:@"#CCCCCC"]];
    self.yuFuKuanField.textColor = kColorFFF;
    self.yuFuKuanField.font = [UIFont systemFontOfSize:13];
    self.yuFuKuanField.backgroundColor = [UIColor clearColor];
    self.yuFuKuanField.returnKeyType = UIReturnKeyDone;
    self.yuFuKuanField.keyboardType = UIKeyboardTypeDecimalPad;
    
    
    //选择类别
    UIView *categoryView = [[UIView alloc] init];
    [self.backView addSubview:categoryView];
    categoryView.frame = CGRectMake(0, 370+37, backWidth, 37);
    
    
    JHTitleTextItemView *categoryItemView = [[JHTitleTextItemView alloc] initWithTitle:@"原料类别:" textPlace:@"请选择类别" isEdit:YES isShowLine:YES];
    [categoryView addSubview:categoryItemView];
    [categoryItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    categoryItemView.line.backgroundColor = [UIColor colorWithHexString:@"#F5F6FA"];
    categoryItemView.line.hidden = NO;
    [categoryItemView.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
    }];
    categoryItemView.titleLabel.font = [UIFont systemFontOfSize:13];
    categoryItemView.titleLabel.textColor = kColorFFF;
    
    self.categoryField = categoryItemView.textField;
    [self.categoryField placeHolderColor:[UIColor colorWithHexString:@"#CCCCCC"]];
    self.categoryField.textColor = kColorFFF;
    self.categoryField.font = [UIFont systemFontOfSize:13];
    self.categoryField.enabled = NO;
    if (self.customizeType == JHCustomizedAndNormalOrder) {
        self.categoryField.userInteractionEnabled = NO;
    } else {
        self.categoryField.userInteractionEnabled = YES;
        if (self.selectedCate[@"id"]) {
            self.categoryField.text = self.selectedCate[@"name"];
        } else {
            UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [categoryBtn setImage:[UIImage imageNamed:@"dis_tag_icon_arrow"] forState:UIControlStateNormal];
            categoryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [categoryBtn addTarget:self action:@selector(showCategoryPicker:) forControlEvents:UIControlEventTouchUpInside];
            [categoryItemView addSubview:categoryBtn];
            [categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(categoryItemView.textField);
                make.right.equalTo(categoryItemView.line.mas_right);
            }];
        }
    }
    
    
    //定制件数
    UIView *countView = [[UIView alloc] init];
    [self.backView addSubview:countView];
    countView.frame = CGRectMake(0, 370+37+37, backWidth, 44);
    
    JHTitleTextItemView *countItemView = [[JHTitleTextItemView alloc] initWithTitle:@"定制件数:" textPlace:@"" isEdit:YES isShowLine:YES];
    [countView addSubview:countItemView];
    [countItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    countItemView.line.hidden = YES;
    countItemView.titleLabel.font = [UIFont systemFontOfSize:13];
    countItemView.titleLabel.textColor = kColorFFF;
    countItemView.textField.enabled = NO;
    
    UIButton *addCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCountBtn setImage:[UIImage imageNamed:@"customizev_fly_add_count"] forState:UIControlStateNormal];
    [addCountBtn addTarget:self action:@selector(showCountPicker:) forControlEvents:UIControlEventTouchUpInside];
    [countItemView addSubview:addCountBtn];
    [addCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(countItemView.textField);
        make.width.equalTo(@18);
    }];
    self.addCountBtn = addCountBtn;
    
    [countItemView addSubview:self.countTagsView];
    self.countTagsView.frame = CGRectMake(105, 0, backWidth-105-20, 44);
    
    [self reloadCountView];
    
    //定制说明
    UIView *descView = [[UIView alloc] init];
    [self.backView addSubview:descView];
    descView.frame = CGRectMake(0, 370+37+37+44, backWidth, 40);
    
    UILabel *descTitlelabel = [[UILabel alloc]init];
    descTitlelabel.font = [UIFont systemFontOfSize:13];
    descTitlelabel.textColor = kColorFFF;
    descTitlelabel.text = @"定制说明";
    [descView addSubview:descTitlelabel];
    [descTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@7.5);
    }];
    
    UIView *descLine = [[UIView alloc] init];
    descLine.backgroundColor = [UIColor colorWithHexString:@"#F5F6FA"];
    [descView addSubview:descLine];
    [descLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descTitlelabel.mas_right).offset(15);
        make.bottom.equalTo(@0);
        make.right.equalTo(@-20);
        make.height.equalTo(@0.5);
    }];
    
    [descView addSubview:self.descTextView];
    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(descLine);
        make.bottom.equalTo(descLine.mas_top);
        make.top.equalTo(@0);
    }];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"确认发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    sendBtn.layer.cornerRadius = 19;
    sendBtn.layer.masksToBounds = YES;
    [self.backView addSubview:sendBtn];
    
    if (self.customizeType == JHCustomizedAndNormalOrder) {
        UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lastBtn addTarget:self action:@selector(lastBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [lastBtn setTitle:@"上一步" forState:UIControlStateNormal];
        [lastBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        lastBtn.titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:15.f];
        lastBtn.layer.cornerRadius = 19;
        lastBtn.layer.masksToBounds = YES;
        lastBtn.layer.borderWidth = 0.5f;
        lastBtn.layer.borderColor = HEXCOLOR(0xFFFFFF).CGColor;
        [self.backView addSubview:lastBtn];
        
        [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.width.mas_equalTo((backWidth-30.f)/2.f);
            make.height.equalTo(@38);
            make.bottom.equalTo(@-15);
        }];
        
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastBtn.mas_right).offset(10.f);
            make.width.mas_equalTo((backWidth-30.f)/2.f);
            make.height.equalTo(@38);
            make.bottom.equalTo(@-15);
        }];
        
    } else {
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.height.equalTo(@38);
            make.bottom.equalTo(@-15);
        }];
    }
}

- (void)setCagetoryInfoTextField:(NSDictionary *)cagetoryInfo {
    if (self.customizeType == JHCustomizedAndNormalOrder) {
        self.categoryField.text = cagetoryInfo[@"name"];
        self.selectedCate = cagetoryInfo;
    }
}

- (void)setImgInfo:(NSString *)ImgInfoString {
    if (self.customizeType == JHCustomizedAndNormalOrder) {
        self.customizePackageFirstImg = ImgInfoString;
        NSDictionary *dict = @{
            @"isUpload":@"1",
            @"url":ImgInfoString
        };
        [self.imagesArray insertObject:dict atIndex:0];
    }
}


- (void)closeAction:(UIButton *)btn {
    if (self.customizeType == JHCustomizedAndNormalOrder) {
        CommAlertView *alertView = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"关闭后，编辑的内容不会被保存，请您确认操作" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
        [self addSubview:alertView];
        alertView.handle = ^{
            [super closeAction:btn];
        };
    } else {
        [super closeAction:btn];
    }
}

- (void)lastBtnClick:(UIButton *)sender {
    if (self.lastAction) {
        self.lastAction();
    }
}

- (void)getCateAll {
    if ([UserInfoRequestManager sharedInstance].pickerDataArray) {
        self.categoryArray = [UserInfoRequestManager sharedInstance].pickerDataArray;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in self.categoryArray) {
            [array addObject:dic[@"name"]];
        }
        self.picker.arrayData = array;
        
        return;
    }
    [[UserInfoRequestManager sharedInstance] getCateAllWithType:1 successBlock:^(RequestModel * _Nullable respondObject) {
       self.categoryArray = respondObject.data;
       NSMutableArray *array = [NSMutableArray array];
       for (NSDictionary *dic in self.categoryArray) {
           [array addObject:dic[@"name"]];
       }
       self.picker.arrayData = array;
       [UserInfoRequestManager sharedInstance].pickerDataArray = respondObject.data;
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
   
}

-(void)getCountAll {
    if(self.countCategaryArray.count > 0){
        self.countNumArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.countCategaryArray.count];
        for (JHCustomizeFlyOrderCountCategoryModel *model in self.countCategaryArray) {
            [arrayM addObject:model.customizeFeeName];
        }
        self.countPicker.arrayData_0 = arrayM;
        self.countPicker.arrayData_1 = self.countNumArray;

        return;
    }
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/anon/customize/fee/template-list") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        self.countCategaryArray = [JHCustomizeFlyOrderCountCategoryModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        self.countNumArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.countCategaryArray.count];
        for (JHCustomizeFlyOrderCountCategoryModel *model in self.countCategaryArray) {
            [arrayM addObject:model.customizeFeeName];
        }
        self.countPicker.arrayData_0 = arrayM;
        self.countPicker.arrayData_1 = self.countNumArray;
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}


- (void)showCategoryPicker:(UIButton *)btn {
    [self endEditing:YES];
    [self.picker show];
}

- (void)showCountPicker:(UIButton *)btn {
    [self endEditing:YES];
    [self.countPicker show];
    @weakify(self)
    self.countPicker.sureClickBlock = ^(NSInteger selectedIndex_0, NSInteger selectedIndex_1) {
        @strongify(self);
        JHCustomizeFlyOrderCountCategoryModel *model = self.countCategaryArray[selectedIndex_0];
        
        BOOL isHas = NO;
        for (JHCustomizeFlyOrderCountCategoryModel *subModel in self.selectedCountArray) {
            if([model.customizeFeeId isEqualToString:subModel.customizeFeeId]){
                subModel.count = self.countNumArray[selectedIndex_1];
                isHas = YES;
                break;
            }
        }
        if(!isHas){
            model.count = self.countNumArray[selectedIndex_1];
            [self.selectedCountArray addObject:model];
        }
        
        [self reloadCountView];
    };
}


-(void)reloadCountView{
    //判断是否大于等于5个
    if(self.selectedCountArray.count >= 5){
        self.addCountBtn.hidden = YES;
        self.countTagsView.frame = CGRectMake(105-18-5, 0, backWidth-105-20+18+5, 44);
    }else{
        self.addCountBtn.hidden = NO;
        self.countTagsView.frame = CGRectMake(105, 0, backWidth-105-20, 44);
    }
    
    NSMutableArray *tagsArray = [NSMutableArray array];
    for (JHCustomizeFlyOrderCountCategoryModel *subModel in self.selectedCountArray) {
        NSDictionary *dic = @{
            @"title":[NSString stringWithFormat:@"%@×%@",subModel.customizeFeeName,subModel.count],
            @"id":subModel.customizeFeeId
        };
        [tagsArray addObject:dic];
    }
    [self.countTagsView setTagAry:tagsArray delegate:self];
}


-(void)addScreenPicTapClick:(UIGestureRecognizer*)tap {
    if(self.customizeType == JHCustomizedNormalOrder || self.customizeType == JHCustomizedAndNormalOrder) {
        [self makeToast:@"已购单定制不需要截取用户当前画面" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(!self.isConnecting){
        [self makeToast:@"需与用户连麦，才能截取用户当前画面" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(self.snapShotCallBack){
        self.snapShotCallBack(self);
    }
}

-(void)reloadScreenImageBGView {
    [self.screenImageBGView removeAllSubviews];
    if(self.screenImage == nil){
        //添加截屏按钮
        
        UIView *addView = [[UIView alloc] init];
        [self.screenImageBGView addSubview:addView];
        [addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        UITapGestureRecognizer* screenImageBGViewTap = [[UITapGestureRecognizer alloc]init];
        [screenImageBGViewTap addTarget:self action:@selector(addScreenPicTapClick:)];
        [addView addGestureRecognizer:screenImageBGViewTap];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"customize_add_screen"];
        [self.screenImageBGView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.bottom.equalTo(self.screenImageBGView.mas_centerY).offset(-7.5);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        label.text = @"点击截取用户当前画面";
        [self.screenImageBGView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(self.screenImageBGView.mas_centerY).offset(7.5);
        }];
        
    }else{
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = self.screenImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.screenImageBGView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        imageView.userInteractionEnabled = YES;
        @weakify(self);
        UITapGestureRecognizer* screenImageViewTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            [self checkImageWithIndex:0];
        }];
        [imageView addGestureRecognizer:screenImageViewTap];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImage:[UIImage imageNamed:@"customizev_fly_del_pic"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delScreenImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(@0);
            make.width.height.equalTo(@20);
        }];
        
    }
}
-(void)addPicViewTapClick:(UIGestureRecognizer*)tap {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-self.imagesArray.count delegate:nil];
    imagePickerVc.alwaysEnableDoneBtn = YES;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.allowPreview = YES;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        for (UIImage *image in photos) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:image forKey:@"image"];
            [dic setValue:@"0" forKey:@"isUpload"];
            [self.imagesArray addObject:dic];
        }
        [self reloadImagesBGView];
    }];
    
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
}


-(void)reloadImagesBGView {
    [self.imagesBGView removeAllSubviews];
    CGFloat imageW = 60;
    CGFloat imageH = 60;
    [self.imagesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary*)obj;
        UIImageView *imageView = [[UIImageView alloc] init];
        if(((NSString *)dic[@"isUpload"]).intValue){
            if(dic[@"image"] != nil){
                imageView.image = (UIImage*)dic[@"image"];
            }else{
                [imageView jh_setImageWithUrl:dic[@"url"]];
            }
        }else{
            imageView.image = (UIImage*)dic[@"image"];
        }
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 8;
        imageView.layer.masksToBounds = YES;
        [self.imagesBGView addSubview:imageView];
        imageView.frame = CGRectMake(idx*(imageW+10), 0, imageW, imageH);
        imageView.userInteractionEnabled = YES;
        imageView.tag = 10+idx;
        @weakify(self);
        UITapGestureRecognizer* screenImageViewTap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            if(self.screenImage){
                [self checkImageWithIndex:1+idx];
            }else{
                [self checkImageWithIndex:idx];
            }
        }];
        [imageView addGestureRecognizer:screenImageViewTap];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImage:[UIImage imageNamed:@"customizev_fly_del_pic"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(delImagesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(@0);
            make.width.height.equalTo(@20);
        }];
        delBtn.tag = 1000+idx;
    }];
    
    //添加照片按钮
    UIView *addPicView = [[UIView alloc] init];
    addPicView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    addPicView.layer.cornerRadius = 8;
    addPicView.layer.masksToBounds = YES;
    UITapGestureRecognizer *addPicViewTap = [[UITapGestureRecognizer alloc]init];
    [addPicViewTap addTarget:self action:@selector(addPicViewTapClick:)];
    [addPicView addGestureRecognizer:addPicViewTap];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"customizev_fly_add_pic"];
    [addPicView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(addPicView.mas_centerY).offset(-2.5);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.text = @"添加原料图";
    [addPicView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(addPicView.mas_centerY).offset(2.5);
    }];
    
    [self.imagesBGView addSubview:addPicView];
    addPicView.frame = CGRectMake(self.imagesArray.count*(imageW+10), 0, imageW, imageH);
    if (self.imagesArray.count >= 9) {
        addPicView.hidden = YES;
        self.imagesBGView.contentSize = CGSizeMake(self.imagesArray.count*(imageW+10)-10, 0);
    } else {
        addPicView.hidden = NO;
        self.imagesBGView.contentSize = CGSizeMake(self.imagesArray.count*(imageW+10)+imageW, 0);
    }
}

// 删除截屏
- (void)delScreenImageBtnClick:(UIButton *)sender {
    self.screenImage = nil;
    [self reloadScreenImageBGView];
}

//删除图片
- (void)delImagesBtnClick:(UIButton*)sender {
    [self.imagesArray removeObjectAtIndex:sender.tag-1000];
    [self reloadImagesBGView];
}

#pragma mark - 查看图片
- (void)checkImageWithIndex:(NSInteger)index {
    NSMutableArray *photoList = [NSMutableArray array];
    if(self.screenImage){
        GKPhoto *photo = [[GKPhoto alloc]init];
        photo.image = self.screenImage;
        [photoList addObject:photo];
    }
    for (NSDictionary *dic in self.imagesArray) {
        if(((NSString*)dic[@"isUpload"]).intValue){
            GKPhoto *photo = [GKPhoto new];
            if(dic[@"image"] != nil){
                photo.image = dic[@"image"];
            }else{
                //url
                photo.url = [NSURL URLWithString:((NSString*)dic[@"url"])];
            }
            [photoList addObject:photo];
        }else{
            //image
            GKPhoto *photo = [GKPhoto new];
            photo.image = dic[@"image"];
            [photoList addObject:photo];
        }
    }
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
    browser.isStatusBarShow = YES;
    browser.isScreenRotateDisabled = YES;
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:self.viewController];
}

//发送订单
-(void)sendBtnClick:(UIButton*)sender{
    [self endEditing:YES];
    if(self.customizeType == JHCustomizedIntentionOrder){
        if(self.screenImage == nil){
            [self makeToast:@"请点击截取用户当前画面" duration:1.0 position:CSToastPositionCenter];
            return;
        }
    }

    if(self.imagesArray.count == 0){
        [self makeToast:@"请添加原料图" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(self.yuFuKuanField.text.length == 0){
        [self makeToast:@"请输入预付款" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(self.selectedCate == nil){
        [self makeToast:@"请添加原料类别" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(self.selectedCountArray.count == 0){
        [self makeToast:@"请选择定制件数" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    //最后把截屏和image放一个数组中处理
    self.allImagesArray = [NSMutableArray arrayWithArray:self.imagesArray];
    if(self.screenImage){
        NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.screenImage forKey:@"image"];
        [dic setValue:@"0" forKey:@"isUpload"];
        [self.allImagesArray insertObject:dic atIndex:0];
    }
    BOOL isAllUpload = YES;
    for (NSMutableDictionary *dic in self.allImagesArray) {
        if(!((NSString*)dic[@"isUpload"]).intValue){
            isAllUpload = NO;
            break;
        }
    }
    if(isAllUpload){
        if (self.customizeType == JHCustomizedAndNormalOrder) {
            [self creatCustomizePackageOrder];
        } else {
            [self creatOrder];
        }
    }else{
        //上传图片
        for (NSMutableDictionary *dic in self.allImagesArray) {
            [self uploadImage:dic];
        }
    }
}


#pragma mark - 上传images图片
-(void)uploadImage:(NSMutableDictionary *)dic{
    if(((NSString*)dic[@"isUpload"]).intValue){
        return;
    }
    NOSFormData * data = [[NOSFormData alloc]init];
    data.fileImage = dic[@"image"];
    data.fileDir = @"goods";
    [self showProgressHUDWithProgress:0.0 WithTitle:@"上传中"];
    @weakify(self)
    //这里涉及多张图片上传,完成后修改各自的状态,所以不能用单例,用new对象
    [[NOSUpImageTool new] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [dic setValue:respondObject.data forKey:@"url"];
            [dic setValue:@"1" forKey:@"isUpload"];
//            [SVProgressHUD dismiss];
            //计算上传进度
            int finishedNum = 0;
            for (NSDictionary *subDic in self.allImagesArray) {
                if(((NSString*)subDic[@"isUpload"]).intValue){
                    finishedNum++;
                }
            }
            CGFloat progress = 1.0 * finishedNum / (self.allImagesArray.count > 0 ? self.allImagesArray.count : 1);
            [self showProgressHUDWithProgress:progress WithTitle:@"上传中"];
            [self panDuanImagesIsUpload];
        });
        
        
    } failureBlock:^(RequestModel *respondObject) {
        [self hideProgressHUD];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

-(void)panDuanImagesIsUpload {
    for (NSDictionary *dic in self.allImagesArray) {
        if(!((NSString*)dic[@"isUpload"]).intValue){
            return;
        }
    }
    [self hideProgressHUD];
    // imageArray都上传完,进行下一步
    if (self.customizeType == JHCustomizedAndNormalOrder) {
        [self creatCustomizePackageOrder];
    } else {
        [self creatOrder];
    }
}

-(void)creatOrder {
    JHSendOrderModel *model = [[JHSendOrderModel alloc]init];
    NSMutableArray* imageUrlArray = [NSMutableArray array];
    for (NSDictionary *dic in self.allImagesArray) {
        NSString *url = dic[@"url"];
        if(url){
            [imageUrlArray addObject:url];
        }
    }
    
    model.goodsImg = [imageUrlArray componentsJoinedByString:@","];//以","隔开
    model.orderPrice = self.yuFuKuanField.text;
    model.goodsCateId = self.selectedCate[@"id"];
    
    NSMutableArray *dicArray = [NSMutableArray array];
    for (JHCustomizeFlyOrderCountCategoryModel *subModel in self.selectedCountArray) {
        NSDictionary *dic = @{
            @"count": subModel.count,
            @"customizeFeeId": subModel.customizeFeeId,
            @"customizeFeeName": subModel.customizeFeeName
        };
        [dicArray addObject:dic];
    }
    model.customizeFeeList = dicArray;
    model.processingDes    = self.descTextView.text;
    model.orderType        = @8;
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    model.sm_deviceId      = sm_deviceId ? : @"";
    model.parentOrderId    = self.parentOrderId;
    model.anchorId         = self.anchorId;
    model.orderCategory    = self.orderCategory;
    model.viewerId         = self.viewerId;
    [self requestDataWithModel:model];
}

- (void)requestDataWithModel:(JHSendOrderModel *)model {
//    NSMutableDictionary *dic = [model mj_keyValuesWithIgnoredKeys:@[@"customizeFeeList"]];
    NSMutableDictionary *dic = [model mj_keyValues];
//    [dic setValue:model.customizeFeeList forKey:@"customizeFeeList"];
    NSLog(@"*************%@",dic);
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [self hiddenAlert];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}


- (void)creatCustomizePackageOrder {
    JHCreateCustomizeNormalRequestModel *model = [[JHCreateCustomizeNormalRequestModel alloc] init];
    NSMutableArray *imageUrlArray = [NSMutableArray array];
    for (NSDictionary *dic in self.allImagesArray) {
        NSString *url = dic[@"url"];
        if (url) {
            [imageUrlArray addObject:url];
        }
    }
    /// 常规
    model.goodsImg         = self.customizePackageModel.goodsImg;//以","隔开
    model.orderType        = @"0";
    model.orderPrice       = self.customizePackageModel.orderPrice;
    model.orderCategory    = self.orderCategory;
    
    /// 定制
    model.customizeGoodsImg   = [imageUrlArray componentsJoinedByString:@","];//以","隔开
    model.customizeOrderType  = @"8";
    model.customizeOrderPrice = self.yuFuKuanField.text;
    model.customizeType       = @"2";
    model.goodsCateId         = self.selectedCate[@"id"];
    /// 新增飞单
    model.anewGoodsCateId     = self.selectedCate[@"newGoodsCateId"];

    model.processingDes       = self.descTextView.text;
    
//    model.personalCustomizeCategory = ???
    
    model.sm_deviceId      = NONNULL_STR([JHAntiFraud deviceId]);
    model.anchorId         = self.anchorId;
    model.viewerId         = self.viewerId;
    
    model.customizeFeeList = (NSArray<JHCreateCustomizeFeeListModel *>*)[self.selectedCountArray jh_map:^id _Nonnull(JHCustomizeFlyOrderCountCategoryModel *_Nonnull obj, NSUInteger idx) {
        JHCreateCustomizeFeeListModel *model = [[JHCreateCustomizeFeeListModel alloc] init];
        model.count            = obj.count;
        model.customizeFeeId   = obj.customizeFeeId;
        model.customizeFeeName = obj.customizeFeeName;
        return model;
    }];
    [self sendCustomizePackageWithModel:model];
}

/// 发送定制套餐（常规+定制）
- (void)sendCustomizePackageWithModel:(JHCreateCustomizeNormalRequestModel *)model {
    NSMutableDictionary *dic = [model mj_keyValues];
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/createCustomizeNormal") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [self hiddenAlert];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

#pragma mark - JHPickerView的代理方法
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    NSInteger index = pickerSingle.selectedIndex;
    if (self.categoryArray && self.categoryArray.count>index) {
        self.selectedCate = self.categoryArray[index];
        self.categoryField.text = self.selectedCate[@"name"];
    }
}

#pragma mark - JHCustomizeFlyOrderTagsView的代理方法
-(void)tagsViewDelButtonAction:(JHCustomizeFlyOrderTagsView *)tagsView button:(UIButton *)sender{
    for (JHCustomizeFlyOrderCountCategoryModel *subModel in self.selectedCountArray) {
        NSInteger tag = sender.tag;
        if(subModel.customizeFeeId.intValue == tag){
            [self.selectedCountArray removeObject:subModel];
            break;
        }
    }
    
    [self reloadCountView];
}


#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>50) {
        textView.text = [textView.text substringToIndex:50];
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(YES)];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(YES)];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self endEditing:YES];
        return NO;//这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (UIView *)screenImageBGView {
    if (!_screenImageBGView) {
        _screenImageBGView = [[UIView alloc] init];
        _screenImageBGView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _screenImageBGView.layer.cornerRadius = 8;
        _screenImageBGView.layer.masksToBounds = YES;
    }
    return _screenImageBGView;
}

- (UIScrollView *)imagesBGView {
    if (!_imagesBGView) {
        _imagesBGView = [[UIScrollView alloc] init];
        _imagesBGView.showsVerticalScrollIndicator = NO;
        _imagesBGView.showsHorizontalScrollIndicator = NO;
    }
    return _imagesBGView;
}

- (NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
        
    }

    return _picker;
}

- (JHCustomizeFlyOrderCountPickerView *)countPicker {
    if (!_countPicker) {
        _countPicker = [[JHCustomizeFlyOrderCountPickerView alloc] init];
        _countPicker.heightPicker = 240 + UI.bottomSafeAreaHeight;
    }

    return _countPicker;
}


- (UIView *)countTagsView {
    if (!_countTagsView) {
        _countTagsView = [[JHCustomizeFlyOrderTagsView alloc] init];
        _countTagsView.type = 1;
        _countTagsView.tagSpace = 9;
        _countTagsView.tagHeight = 18;
        _countTagsView.tagOriginX = 0;
        _countTagsView.tagOriginY = 13;
        _countTagsView.tagHorizontalSpace = 9;
        _countTagsView.tagVerticalSpace = 0;
        _countTagsView.masksToBounds = YES;
        _countTagsView.cornerRadius = 9;
        _countTagsView.titleSize = 11;
        _countTagsView.titleColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _countTagsView.borderColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _countTagsView.borderWidth = 0.5;
        _countTagsView.canDel = YES;
    }
    return _countTagsView;
}

- (NSMutableArray *)selectedCountArray {
    if (!_selectedCountArray) {
        _selectedCountArray = [NSMutableArray array];
    }
    return _selectedCountArray;
}

- (NTESGrowingInternalTextView *)descTextView{
    if (!_descTextView) {
        _descTextView = [[NTESGrowingInternalTextView alloc] init];
        _descTextView.backgroundColor = [UIColor clearColor];
        _descTextView.delegate = self;
        NSAttributedString * placestr = [[NSAttributedString alloc] initWithString:@"请输入定制情况说明" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CCCCCC"]}];
        _descTextView.placeholderAttributedText = placestr;
        _descTextView.font = [UIFont systemFontOfSize:13];
        _descTextView.textColor = kColorFFF;
    }
    return _descTextView;
}

@end
