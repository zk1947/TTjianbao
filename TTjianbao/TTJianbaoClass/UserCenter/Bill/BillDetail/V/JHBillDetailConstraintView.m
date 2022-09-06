//
//  JHBillDetailConstraintView.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillDetailConstraintView.h"
@interface JHBillDetailConstraintView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSArray *results;



@property(nonatomic, strong) UICollectionView * collectView;

@property (nonatomic, strong) NSArray<NSDictionary*> *resDataArr;

@end


@implementation JHBillDetailConstraintView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        _result = 0;
        
//        [self addSubview:self.collectView];
//        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self);
//            make.height.mas_equalTo(39.f);
//        }];
        
        
        [self getData];
        
        
    }
    
    
    return self;
}


- (void)getData{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/account-info/detailType") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            self.resDataArr = respondObject.data;
            [self addItems];
            
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
    }];

    
}

- (void)addItems{
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
    }];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *resultarray = [NSMutableArray arrayWithCapacity:0];

    [self.resDataArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj[@"msg"]];
        NSNumber *aa = obj[@"code"];
        [resultarray addObject:aa.stringValue];
    }];
    self.results = resultarray.copy;
    UIView *lastView = nil;
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton jh_buttonWithTitle:array[i] fontSize:12 textColor:RGB(102, 102, 102) target:self action:@selector(swithMethod:) addToSuperView:whiteView];
        [button jh_cornerRadius:4.f borderColor:RGB(238, 238, 238) borderWidth:1.0];
        button.backgroundColor = RGB(238, 238, 238);
        button.tag = 1000+i;
        [self.buttonArray addObject:button];
        CGFloat wide = (kScreenWidth - 100.f)/4.f;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(@0).offset(10.f);
                make.left.equalTo(@0).offset(20.f);
            }else if(i%4 == 0){
                make.top.equalTo(lastView.mas_bottom).offset(20.f);
                make.left.equalTo(@0).offset(20.f);
            }else{
                make.top.equalTo(lastView);
                make.left.equalTo(lastView.mas_right).offset(20.f);
            }
            make.size.mas_equalTo(CGSizeMake(wide, 30));
            if (i + 1 == array.count) {
                make.bottom.equalTo(@0).offset(-70.f);
            }
        }];
        lastView = button;
    }
    
    
    UIButton *cancleButton = [UIButton jh_buttonWithTitle:@"重置" fontSize:13 textColor:UIColor.blackColor target:self action:@selector(cancleMethod) addToSuperView:whiteView];
    [cancleButton jh_cornerRadius:17.5];
    cancleButton.backgroundColor = RGB(238, 238, 238);
    UIButton *sureButton = [UIButton jh_buttonWithTitle:@"确定" fontSize:13 textColor:UIColor.whiteColor target:self action:@selector(makeSureMethod) addToSuperView:whiteView];
    [sureButton jh_cornerRadius:17.5];
    sureButton.backgroundColor = RGB(253,161,0);

    NSArray *bottomButtonArray = @[cancleButton,sureButton];
    [bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:50 leadSpacing:53 tailSpacing:53];
    [bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(whiteView).offset(-15);
        make.height.mas_equalTo(35);
    }];

}


#pragma mark ---------------------------- method ----------------------------
-(void)cancleMethod
{
    _result = -1;
    
    [self reloadSelfView:-1];
}

-(void)makeSureMethod
{
    if (_resultBlock) {
        _resultBlock(_result);
    }
    
    [self removeFromSuperview];
}

-(void)swithMethod:(UIButton *)sender
{
   // _result = sender.tag - 1000;
    
    
    _result = [self.results[sender.tag - 1000] intValue];
    [self reloadSelfView:sender.tag - 1000];
   
}

-(void)reloadSelfView:(NSInteger)index
{
    
    for (int i = 0; i< self.buttonArray.count; i++) {
        UIButton *button = self.buttonArray[i];
        if (i == index ) {
            button.layer.borderColor = RGB(253,161,0).CGColor;
            button.backgroundColor = UIColor.whiteColor;
        }
        else
        {
            button.layer.borderColor = RGB(238, 238, 238).CGColor;
            button.backgroundColor = RGB(238, 238, 238);
        }
    }
    
}

-(NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray new];
    }
    return _buttonArray;
}

- (UICollectionView *)collectView{
    if (!_collectView) {
        UICollectionViewFlowLayout *layout =  [UICollectionViewFlowLayout new];
        layout.scrollDirection = 1;
        layout.itemSize = CGSizeMake(60, 30);
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = UIColor.whiteColor;
        view.contentInset = UIEdgeInsetsMake(4, 10, 4, 10);
        [view registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"UICollectionViewCell"];
        _collectView = view;
    }
    return _collectView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.getRandomColor;
    
    return cell;
}

@end
