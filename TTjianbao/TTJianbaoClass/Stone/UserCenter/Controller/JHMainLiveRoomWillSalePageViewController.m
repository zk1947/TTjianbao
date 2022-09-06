//
//  JHMainLiveRoomWillSalePageViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMainLiveRoomWillSalePageViewController.h"
#import "JHMainLiveRoomTabSubviewController.h"
#import "JHRestoneTableViewCell.h"
#import "JHEditPriceViewController.h"
#import "JHPutawayViewController.h"
#import "JHBackUpLoadManage.h"
#import "JHPrinterManager.h"

@interface JHMainLiveRoomWillSalePageViewController ()<JHTableViewCellDelegate>
{
    JHMainLiveRoomTabSubviewController* controller;
}
@property (nonatomic, strong) JHMainLiveRoomTabSubviewController* controller;
@end

@implementation JHMainLiveRoomWillSalePageViewController
@synthesize controller;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //title
//    [self setupToolBarWithTitle:@"待上架原石"];
    self.title = @"待上架原石";
    //content view
    [self drawView];
}

- (void)drawView
{
    self.view.backgroundColor = HEXCOLOR(0xf8f8f8);
    
    controller = [[JHMainLiveRoomTabSubviewController alloc] initWithPageType:JHMainLiveRoomTabTypeWillSaleFromUserCenter channelId:@""];
    controller.delegate = self;
    UIView *contentView = controller.view;
    contentView.frame = CGRectMake(0, UI.statusAndNavBarHeight+10, self.view.width, self.view.height - UI.statusAndNavBarHeight - 10);
    [self.view addSubview:contentView];
}

- (void)pressButtonType:(RequestType)type dataModel:(JHLastSaleGoodsModel *)model indexPath:(NSIndexPath *)indexPath {
    switch (type) {
        case RequestTypeEdit:{
            JHEditPriceViewController *vc = [[JHEditPriceViewController alloc] init];
            vc.stoneId = model.stoneRestoreId?:model.stoneId;
            vc.price = model.salePrice;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case RequestTypePutShelf: {
            if(model.shelfState == JHShelvShowStatusShelveButton)
            {
                JHPutawayViewController *vc = [[JHPutawayViewController alloc] init];
                JH_WEAK(self)
                vc.baseFinishBlock = ^(id sender) {
                    JH_STRONG(self)
                    [self.controller callbackRefreshData];
                };
                vc.stoneRestoreId = model.stoneRestoreId;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if(model.shelfState == JHShelvShowStatusShelveFail)
            {
                [[JHBackUpLoadManage shareInstance] startUpLoadWithStoneId:model.stoneRestoreId];
            }
        }
            break;
            
        case RequestTypePrintGoodCode:{
            [[JHPrinterManager sharedInstance] printStoneBarCode:model.goodsCode andResult:^(BOOL success, NSString *desc) {
                if(success)
                    [SVProgressHUD showSuccessWithStatus:@"打印成功"];
                else
                    [SVProgressHUD showErrorWithStatus:desc];
                    
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
