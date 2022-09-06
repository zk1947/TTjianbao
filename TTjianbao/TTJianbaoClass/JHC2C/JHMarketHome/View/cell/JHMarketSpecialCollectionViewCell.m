//
//  JHMarketSpecialCollectionViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketSpecialCollectionViewCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHMarketHomeDataReport.h"

@interface JHMarketSpecialCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JHMarketSpecialCollectionViewCell

+ (CGSize)viewSize {
    CGFloat w = (ScreenW - 24.f);
    return CGSizeMake(w, 60.f);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self.contentView addSubview:self.imageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
//        .insets(UIEdgeInsetsMake(0, 0.f, 0, 0.f))
    }];
}

- (void)setModel:(JHMarketHomeSpecialItemModel *)model{
    _model = model;
    [self.imageView jhSetImageWithURL:[NSURL URLWithString:model.moreHotImgUrl] placeholder:[UIImage imageNamed:@"newStore_default_placehold"]];
    //一图多触点
    if (_model.definiType == 5) {
        [self creatSubButtonsView];
    }
}

- (void)creatSubButtonsView{
    for (UIView *view in self.imageView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *btnsArr = [_model.moreHotImgProportion componentsSeparatedByString:@":"];
    CGFloat btnX = 0.f;
    for (int index = 0; index < btnsArr.count; index++) {
        CGFloat btnW = [btnsArr[index] floatValue]/10.f*self.width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 2021 + index;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnX);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(self.height);
        }];
        btnX += btnW;
    }
}

- (void)buttonAction:(UIButton *)button{
    if (button.tag - 2021 < self.model.definiDetails.count) {
        JHMarketHomeSpecialSubItemModel *subModel = self.model.definiDetails[button.tag - 2021];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:@(self.model.definiSerial) forKey:@"position"];
        [params setValue:subModel.detailsId forKey:@"areaId"];
                
        if (subModel.landingTarget) {
            NSDictionary *subDic = [self strToDic:subModel.landingTarget];
            if (subDic) {
                JHMarketHomeSpecialSubTowItemModel *subTowModel = [JHMarketHomeSpecialSubTowItemModel mj_objectWithKeyValues:subDic];
                //上报
                if ([subTowModel.vc isEqualToString:@"JHWebViewController"]) {
                    [JHMarketHomeDataReport specialTouchReport:subTowModel.params[@"url"] type:subTowModel.type];
                }else{
                    [JHMarketHomeDataReport specialTouchReport:subTowModel.vc type:subTowModel.type];
                }
                [JHRootController toNativeVC:subTowModel.vc withParam:subTowModel.params from:JHFromHomeSourceBuy];
//                NSArray *arrKeys = [subTowModel.params allKeys];
//                if ([subTowModel.vc isEqualToString:@"JHHomeTabController"]) {
//                    if ([arrKeys containsObject:@"selectedIndex"] && [arrKeys containsObject:@"item_type"]) {
//                        if ([subTowModel.params[@"selectedIndex"] isEqualToString:@"0"] && [subTowModel.params[@"item_type"] isEqualToString:@"1"]) {
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMarketSelect" object:self];
//                        }
//                    }
//                }
            }
        }
    }
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

#pragma mark -字符串转字典
- (NSDictionary *)strToDic:(NSString *)string{
    if (string == nil){
        return nil;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
