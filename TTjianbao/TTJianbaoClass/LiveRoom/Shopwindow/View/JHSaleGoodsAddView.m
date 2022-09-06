//
//  JHSaleGoodsAddView.m
//  TTjianbao
//
//  Created by jesee on 16/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSaleGoodsAddView.h"
#import "VideoCateMode.h"
#import "JHUploadManager.h"
#import "JHImagePickerPublishManager.h"
#import "JHShopwindowRequest.h"
#import <YYKit/YYKit.h>
#import "SVProgressHUD.h"

@interface JHSaleGoodsAddView ()
@property (nonatomic, strong) NSMutableArray* pickerArray;
@property (nonatomic, strong) JHSaleGoodsCateModel* selectedCateModel; //选中类别model
@property (nonatomic, strong) NSString* ossImageKey;
@end

@implementation JHSaleGoodsAddView

- (instancetype)initWithData:(JHShopwindowGoodsListModel*)model
{
    if(self = [super initWithData:model])
    {
        [self reloadCatePickerData:NO];
    }
    return self;
}

- (void)showCatePicker:(UIButton *)button
{
    [super showCatePicker:button];
    if ([self.catePicker.arrayData count] > 0)
    {
        [self.catePicker show];
    }
    else
    {
        [self reloadCatePickerData:YES];
    }
}




///更换新分类
- (void)reloadCatePickerData:(BOOL)toRefresh
{
    JH_WEAK(self)
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/shop-lines-contract/contractCategory") Parameters:nil successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        self.pickerArray = [JHSaleGoodsCateModel convertData:respondObject.data];
        NSMutableArray* titles = [NSMutableArray array];
        for (JHSaleGoodsCateModel* model in self.pickerArray) {
            [titles addObject:model.name];
        }
        self.catePicker.arrayData = titles;
        if(toRefresh)
            [self.catePicker show];
    } failureBlock:^(RequestModel *respondObject) {
    
    }];
}

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    [super pickerSingle:pickerSingle selectedTitle:selectedTitle];
    self.selectedCateModel = self.pickerArray[ pickerSingle.selectedIndex];
}

#pragma mark - request
- (void)updateAlbumIcon:(JHAlbumPickerModel*)albumModel
{
    [self setSelectedAlbumIcon:albumModel.image];
    self.ossImageKey = nil;
    JH_WEAK(self)
    [[JHUploadManager shareInstance] uploadSingleImage:albumModel.image filePath:kJHAiyunRoomSaleGoodsPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
        JH_STRONG(self)
        ///已经上传完成
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isFinished && [imgKey isNotBlank])
            {
                self.ossImageKey = imgKey;
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"图片上传失败，请重试"];
            }
        });
    }];

}
#pragma mark - event
- (void)addImageAction:(UIButton *)button
{
    JH_WEAK(self)
    [JHImagePickerPublishManager showImagePickerWithViewController:[JHRootController currentViewController] photoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        JH_STRONG(self)
        if(dataArray.count > 0)
            [self updateAlbumIcon:dataArray[0]];
    }];
}

- (BOOL)finishAction:(UIButton *)button
{
    BOOL ret = [super finishAction:button];
    if(ret)
    {
        JHShopwindowGoodsListModel* goodsModel = [self goodsAddInfos];
        ///如果为空,认为是添加按钮来的,需要传imageKey,否则需要完整Image URL
        if(goodsModel.Id)
        {//edit
            if(self.ossImageKey)
                goodsModel.listImage = self.ossImageKey;
            if(self.selectedCateModel.cateId)
                goodsModel.goodsCateId = self.selectedCateModel.cateId; //这里修正一下
        }
        else
        {//add
            goodsModel.listImage = self.ossImageKey;
            goodsModel.goodsCateId = self.selectedCateModel.cateId; //这里修正一下
        }
        [JHShopwindowRequest requestAddGoods:goodsModel successBlock:^{
            if(self.hiddenBlock)
            {
                self.hiddenBlock(NO);
            }
            if(goodsModel.Id)
            {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
            }
        }];
        [self dismiss];
    }
    return YES;
}

- (void)closeButtonAction:(UIButton *)button
{
    [self dismiss];
}

@end

@implementation JHSaleGoodsCateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cateId":@"id"};
}

@end
