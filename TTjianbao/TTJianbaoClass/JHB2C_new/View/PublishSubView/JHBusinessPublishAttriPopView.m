//
//  JHBusinessPublishAttriPopView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishAttriPopView.h"
#import "UIImage+JHColor.h"
#import "UIView+CornerRadius.h"
#import "JHBusinessPublishAttributeCell.h"
#import "JHBusinessGoodsAttributeModel.h"

@interface JHBusinessPublishAttriPopView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)  UIButton* sureBtn;
@property(nonatomic,strong) UILabel * titleLabel;

@property(nonatomic,strong) UIView * topView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray * array;
@property(nonatomic,assign) NSInteger type;
@end
@implementation JHBusinessPublishAttriPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor= HEXCOLORA(0x000000, 0.5);
        [self addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _bar =  [[UIView alloc]init];
        _bar.backgroundColor= [CommHelp toUIColorByStr:@"#5D4A4A"];
        _bar.userInteractionEnabled = YES;
        _bar.layer.masksToBounds = YES;
        _bar.frame= CGRectMake(10, 0, ScreenW-20, 300 + UI.bottomSafeAreaHeight);
        [_bar yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
        [self addSubview:_bar];

        self.topView =  [[UIView alloc] init];
        // topView.frame = CGRectMake(0,0,375,50);
        self.topView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        self.topView.layer.cornerRadius = 0;
        self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        self.topView.layer.shadowOffset = CGSizeMake(0,1);
        self.topView.layer.shadowOpacity = 1;
        self.topView.layer.shadowRadius = 5;
        [_bar addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((_bar)).offset(0);
            make.left.right.equalTo(_bar);
            make.height.offset(50);

        }];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x999999);
        _titleLabel.text=@"请选择属性值";
        _titleLabel.font = JHFont(12);
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.topView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.top.equalTo((_bar)).offset(15);
            make.center.equalTo(self.topView);
        }];

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal ];
        closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:closeButton];


        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.right.equalTo(self.topView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        
        [_bar addSubview:self.tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bar);
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.bottom.mas_equalTo(_bar.mas_bottom).offset(0);
                    
        }];
        

        UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 62+UI.bottomSafeAreaHeight+20)];
        footView.backgroundColor = [UIColor clearColor];
        _sureBtn = [[UIButton alloc]init];
        _sureBtn.backgroundColor = UIColor.whiteColor;
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = JHMediumFont(15);
        [_sureBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 12;
        _sureBtn.clipsToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footView);
            make.top.equalTo(footView).offset(10);
            make.size.mas_equalTo(CGSizeMake(320, 52));
        }];
        
        _tableView.tableFooterView = footView;
        
        [_bar bringSubviewToFront:self.topView];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 3 && indexPath.row == self.array.count-1) {
        JHBusinessGoodsAttributeSelectModel * model = self.array[indexPath.row];
        if (model.isSelect) {
            return 90;
        }
        return 45;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBusinessPublishAttributeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellPop"];
    if (!cell) {
        cell = [[JHBusinessPublishAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPop"];
    }
    JHBusinessGoodsAttributeSelectModel * model = self.array[indexPath.row];
    [cell setCellModel:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHBusinessGoodsAttributeSelectModel * model = self.array[indexPath.row];
    //（0单选项、1自定义、2枚举值、3单选项+自定义、4复选项）
    if (self.type == 0 || self.type == 3 || self.type == 2) {
        for (JHBusinessGoodsAttributeSelectModel*temp in self.array) {
            temp.isSelect = NO;
        }
        model.isSelect = !model.isSelect;
    }else if(self.type == 4){
        model.isSelect = !model.isSelect;
    }
    [self.tableView reloadData];
//    JHBusinessPublishAttributeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
}
- (void)setArrayModel:(NSMutableArray *)modelArray andSeletype:(NSInteger)type{
    self.type = type;
    self.array = modelArray;
    [self.tableView reloadData];
}
- (void)close
{
    [self hiddenAlert];
}
- (void)cancelClick:(UIButton *)sender{
    
    [self hiddenAlert];
    
}
-(void)sureClick:(UIButton *)sender{
    if (self.sureClickBlock) {
        NSMutableString *showStr = [[NSMutableString alloc]init];
        for (JHBusinessGoodsAttributeSelectModel*temp in self.array) {
            if (temp.isSelect) {
                
                if (temp == self.array.lastObject) {
                    if (temp.textStr.length>0) {
                        [showStr appendString:temp.attrName];
                        [showStr appendString:@"-"];
                        [showStr appendString:temp.textStr];
                        [showStr appendString:@","];
                    }else{
                        [showStr appendString:temp.attrName];
                        [showStr appendString:@","];
                    }
                }else{
                    [showStr appendString:temp.attrName];
                    [showStr appendString:@","];
                }
            }
        }
        if (showStr.length>0) {
            showStr = [showStr substringToIndex:showStr.length-1];
        }
        if (showStr.length>0) {
            self.sureClickBlock(showStr);
        }
        
    }
    [self hiddenAlert];
}
- (void)showAlert
{
    self.isShow = YES;
    self.bar.top =  self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom =  self.height;
    }];
}

- (void)dismiss
{
    self.isShow = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)hiddenAlert{
    self.isShow = NO;
   [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
