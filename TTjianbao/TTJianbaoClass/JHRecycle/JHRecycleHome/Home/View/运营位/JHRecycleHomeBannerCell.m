//
//  JHRecycleHomeBannerCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeBannerCell.h"
#import "JHRecycleHomeModel.h"
#import "JHRecycleItemViewModel.h"

@interface JHRecycleHomeBannerCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) JHHomeOperatingPositionModel *positionModel;


@end

@implementation JHRecycleHomeBannerCell

- (void)configUI{

    [self.backView addSubview:self.imgView];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.backView);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
    }];
    
    //图片点击
    @weakify(self)
    [self.imgView jh_addTapGesture:^{
        @strongify(self)
        [JHRootController toNativeVC:self.positionModel.target.vc withParam:self.positionModel.target.params from:@""];
        
        NSString *content_url = @"";
        if ([self.positionModel.target.vc isEqualToString:@"WebDialog"]||
            [self.positionModel.target.vc isEqualToString:@"JHWebViewController"]) {
            content_url = self.positionModel.target.params[@"urlString"];
        }
        else{
            content_url = self.positionModel.target.vc;
        }
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:@{
            @"spm_type":@"banner",
            @"spm_id":self.positionModel.detailsId,
            @"content_url":content_url,
            @"page_position":@"recycleHome"
        } type:JHStatisticsTypeSensors];
    }];

   
}

- (void)bindViewModel:(id)dataModel{
    JHRecycleItemViewModel *itemViewModel = dataModel;
    self.positionModel = itemViewModel.dataModel;

    [self.imgView jh_setImageWithUrl:self.positionModel.imageUrl placeHolder:@"newStore_default_placehold"];


}


- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = UIColor.lightGrayColor;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.cornerRadius = 5;
        _imgView.clipsToBounds = YES;

    }
    return _imgView;
}
@end
