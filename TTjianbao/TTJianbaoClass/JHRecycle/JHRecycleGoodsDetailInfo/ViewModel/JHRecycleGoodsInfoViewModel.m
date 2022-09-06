//
//  JHRecycleGoodsInfoViewModel.m
//  TTjianbao
//
//  Created by user on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsInfoViewModel.h"

@implementation JHRecycleGoodsInfoCellStyle_PictsBannerViewModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"productImgUrls" : [JHRecycleDetailInfoProductImgUrlsModel class]
    };
}

+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model {
    JHRecycleGoodsInfoCellStyle_PictsBannerViewModel *viewModel = [[JHRecycleGoodsInfoCellStyle_PictsBannerViewModel alloc] init];
    viewModel.productImgUrls = model.productImgUrls;
    viewModel.cellStyle = JHRecycleGoodsInfoCellStyle_PictsBanner;
    return viewModel;
}
@end


@implementation JHRecycleGoodsInfoShowViewModel
@end

@implementation JHRecycleGoodsInfoCellStyle_InfoViewModel
+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model {
    JHRecycleGoodsInfoCellStyle_InfoViewModel *viewModel = [[JHRecycleGoodsInfoCellStyle_InfoViewModel alloc] init];
    JHRecycleGoodsInfoShowViewModel *infoModel = [[JHRecycleGoodsInfoShowViewModel alloc] init];
    infoModel.productPrice = model.productPrice;
    infoModel.customerImg = model.customerImg;
    infoModel.customerName = model.customerName;
    infoModel.productName = model.productName;
    
    viewModel.infoModel = infoModel;
    viewModel.cellStyle = JHRecycleGoodsInfoCellStyle_Info;
    return viewModel;
}
@end


@implementation JHRecycleGoodsInfoCellStyle_DescViewModel
+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model {
    JHRecycleGoodsInfoCellStyle_DescViewModel *viewModel = [[JHRecycleGoodsInfoCellStyle_DescViewModel alloc] init];
    viewModel.productDesc = model.productDesc;
    viewModel.cellStyle = JHRecycleGoodsInfoCellStyle_Desc;
    return viewModel;
}
@end


@implementation JHRecycleGoodsInfoCellStyle_PictNameViewModel
+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model {
    JHRecycleGoodsInfoCellStyle_PictNameViewModel *viewModel = [[JHRecycleGoodsInfoCellStyle_PictNameViewModel alloc] init];
    viewModel.pictTitleName = @"商品细节图";
    viewModel.cellStyle = JHRecycleGoodsInfoCellStyle_PictName;
    return viewModel;
}
@end

@implementation JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"productDetailUrls" : [JHRecycleDetailInfoProductDetailUrlsModel class]
    };
}
+ (instancetype)viewModel:(JHRecycleDetailInfoProductDetailUrlsModel *)model {
    JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel *viewModel = [[JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel alloc] init];
    viewModel.detailUrlsModel = model;
    viewModel.cellStyle = JHRecycleGoodsInfoCellStyle_PictAndVideo;
    return viewModel;
}
@end



@implementation JHRecycleGoodsInfoViewModel

+ (instancetype)viewModel:(JHRecycleGoodsInfoModel *)model {
    JHRecycleGoodsInfoViewModel *viewModel = [[JHRecycleGoodsInfoViewModel alloc] init];
    viewModel.navName = NONNULL_STR(model.productName);
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
    
    if (model.productImgUrls.count >0) {
        JHRecycleGoodsInfoCellStyle_PictsBannerViewModel *viewModel1 = [JHRecycleGoodsInfoCellStyle_PictsBannerViewModel viewModel:model];
        [arr1 addObject:viewModel1];
    }
    
    JHRecycleGoodsInfoCellStyle_InfoViewModel *viewModel2 = [JHRecycleGoodsInfoCellStyle_InfoViewModel viewModel:model];
    [arr1 addObject:viewModel2];

    
    NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
    if (!isEmpty(model.productDesc)) {
        JHRecycleGoodsInfoCellStyle_DescViewModel *viewModel3 = [JHRecycleGoodsInfoCellStyle_DescViewModel viewModel:model];
        [arr2 addObject:viewModel3];
    }
    if (model.productDetailUrls.count >0) {
        JHRecycleGoodsInfoCellStyle_PictNameViewModel *viewModel4 = [JHRecycleGoodsInfoCellStyle_PictNameViewModel viewModel:model];
        [arr2 addObject:viewModel4];
        
        NSArray<JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel *>*picsAndVideos = [model.productDetailUrls jh_map:^id _Nonnull(JHRecycleDetailInfoProductDetailUrlsModel * _Nonnull obj, NSUInteger idx) {
            JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel *viewModel5 = [JHRecycleGoodsInfoCellStyle_PictAndVideoViewModel viewModel:obj];
            viewModel5.productDetailMedium = model.productDetailMedium;
            viewModel5.productDetailOrigin = model.productDetailOrigin;
            return viewModel5;
        }];
        [arr2 addObjectsFromArray:picsAndVideos];
    }
    
    viewModel.dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    if (arr1.count >0) {
        [viewModel.dataSourceArray addObject:arr1];
    }
    if (arr2.count >0) {
        [viewModel.dataSourceArray addObject:arr2];
    }
    return viewModel;
}

@end

