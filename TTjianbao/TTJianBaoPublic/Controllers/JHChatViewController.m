//
//  JHChatViewController.m
//  TTjianbao
//
//  Created by YJ on 2021/1/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatViewController.h"
#import "JHChatKeyBoardView.h"
#import "JHSQPublishBottomView.h"
#import "JHEmojiManager.h"
#import "TTJianBaoColor.h"
#import "JHImagePickerPublishManager.h"
#import "JHChatConst.h"
#import "JHChatModel.h"
#import "JHMeChatCell.h"
#import "JHOtherChatCell.h"
#import "JHWebViewController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "UserInfoRequestManager.h"
#import "JHImagePickerPublishManager.h"
#import "JHAiyunOSSManager.h"
#import "NOSUpImageTool.h"
#import "JHUploadManager.h"
#import "MBProgressHUD.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import "JHUploadManager.h"
#import "YYKit.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "JHAttributeStringTool.h"
#import "IQKeyboardManager.h"

#define USER_ID 100
#define WEAKSELF_DEFINE __weak __typeof(self)weakSelf = self;

@interface JHChatViewController ()<UITableViewDelegate,UITableViewDataSource,JHChatKeyBoardViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
{
    BOOL isShow;
    CGFloat offsetY;
    CGFloat origin_Y;
    int page;
    BOOL isScrollBottom;
    CGFloat keyBoard_height;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) JHSQPublishBottomView *bottomView;
@property (strong, nonatomic) JHChatKeyBoardView *keyBoardView;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSMutableArray  *heightArray;
@property (nonatomic, strong) TZImagePickerController *imagePickerController;

@end

@implementation JHChatViewController

- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.jhNavView];
    [self.view bringSubviewToFront:self.keyBoardView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    isScrollBottom = NO;
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.jhTitleLabel.text = self.name;
    self.view.backgroundColor = USELECTED_COLOR;
    
    isShow = NO;
    keyBoard_height = 0;
    origin_Y = 0;
    page = 1;
    isScrollBottom = YES;
    
    self.keyBoardView = [[JHChatKeyBoardView alloc] initWithFrame:CGRectMake(0, ScreenH - SENDVIEW_HEIGHT - UI.bottomSafeAreaHeight, ScreenW, SENDVIEW_HEIGHT + UI.bottomSafeAreaHeight)];
    self.keyBoardView.delegate = self;
    @weakify(self);
    self.keyBoardView.block = ^(BOOL isYes)
    {
        @strongify(self);
        [self showImagePicker];
    };
    self.keyBoardView.sendBlock = ^(NSString * _Nonnull text)
    {
        @strongify(self);
        if (text.length > 0)
        {
            [self sendContentMessage:text];
        }
    };
    [self.view addSubview:self.keyBoardView];
    
    self.messageArray = [NSMutableArray new];
    self.heightArray = [NSMutableArray new];
    
    [self setupMJRefresh];
}

-(void)setupMJRefresh
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHistoryData)];
    self.tableView.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [self getMessageListDat];
}

//获取聊天消息列表
- (void)getMessageListDat {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = @"";
    if ([self.pageType isEqualToString:@"community_official"]) {
        url = [NSString  stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/chatInfos/%@/%@"),self.userId,[[NSNumber numberWithInt:page] stringValue]];
    } else {
        url = [NSString  stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/chatInfos/%@/%@/1"),self.userId,[[NSNumber numberWithInt:page] stringValue]];
    }
    
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSArray *dataArray = respondObject.data;
        if (dataArray.count > 0)
        {
            NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
            
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                JHChatModel *model = [JHChatModel mj_objectWithKeyValues:obj];
                [self.messageArray addObject:model];

                CGFloat cellHeight = 0;
                if ([model.from_user_info.code intValue] == [customerId intValue])
                {
                    cellHeight = [JHMeChatCell heightWithModel:model];
                }
                else
                {
                    cellHeight = [JHOtherChatCell heightWithModel:model];
                }
                [self.heightArray addObject:[NSNumber numberWithFloat:cellHeight]];
            }];
            
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                if(self.messageArray.count > 0)
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.messageArray.count - 1) inSection:0];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            });
        }
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        NSLog("error");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UITipView showTipStr:respondObject.message?:@"网络请求失败"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    JHChatModel *model = [self.messageArray objectAtIndex:indexPath.row];
    if ([model.from_user_info.code intValue] == [customerId intValue])
    {
        NSString *chat_Identity = [NSString stringWithFormat:@"cell_%ld_%ld", (long)[indexPath section], (long)[indexPath row]];
        JHMeChatCell *cell = [[JHMeChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chat_Identity];
        cell.model = model;
        cell.block = ^(NSString * _Nonnull urlString)
        {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = urlString;
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        };
        return cell;
    }
    else
    {
        NSString *other_Identity = [NSString stringWithFormat:@"other_cell_%ld_%ld", (long)[indexPath section], (long)[indexPath row]];  
        JHOtherChatCell *cell = [[JHOtherChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:other_Identity];
        cell.model = model;
        cell.block = ^(NSString * _Nonnull urlString)
        {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = urlString;
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        };
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *cellHeight = self.heightArray[indexPath.row];
    return cellHeight.floatValue;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH - UI.statusAndNavBarHeight -  SENDVIEW_HEIGHT - UI.bottomSafeAreaHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = USELECTED_COLOR;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100.0f;
        [_tableView.panGestureRecognizer addTarget:self action:@selector(handleSwipe:)];
        //[_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)]];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)chatKeyBoardiewWithoriginY:(CGFloat)originY keyBoardHeight:(CGFloat)height resetFrame:(BOOL)isYes
{
    isShow = isYes;
    origin_Y = originY;
    keyBoard_height = height;
    
    if (isYes)
    {
        if ([self isScroll])
        {
            if ([self sumHeight] < ScreenH - UI.statusAndNavBarHeight - SENDVIEW_HEIGHT - UI.bottomSafeAreaHeight)
            {
                CGRect newFrame = self.tableView.frame;
                //newFrame.origin.y = - (height + SENDVIEW_HEIGHT + UI.statusAndNavBarHeight + self.tableView.contentSize.height - ScreenH);
                newFrame.origin.y = - (height + SENDVIEW_HEIGHT + [self sumHeight] - ScreenH);
                [UIView animateWithDuration:kAnimationTime animations:^{
                    self.tableView.frame = newFrame;
                } completion:^(BOOL finished)
                {
                    if (self.messageArray.count > 0)
                    {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                }];
            }
            else
            {
                CGRect newFrame = self.tableView.frame;
                newFrame.origin.y = - (newFrame.size.height - originY);
                [UIView animateWithDuration:kAnimationTime animations:^{
                    self.tableView.frame = newFrame;
                } completion:^(BOOL finished)
                {
                    if (self.messageArray.count > 0)
                    {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                }];
            }
        }
        else
        {
            CGRect newFrame = self.tableView.frame;
            self.tableView.frame = newFrame;
            if (self.messageArray.count > 0)
            {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }
    else
    {
        CGRect newFrame = self.tableView.frame;
        newFrame.origin.y = UI.statusAndNavBarHeight;
        [UIView animateWithDuration:kAnimationTime animations:^{
            self.tableView.frame = newFrame;
        }];
    }
}
- (BOOL)isScroll
{
    if ([self sumHeight] > ScreenH - UI.statusAndNavBarHeight - SENDVIEW_HEIGHT - keyBoard_height)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (CGFloat)sumHeight
{
    CGFloat sum = [[self.heightArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    return sum;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    offsetY = self.tableView.contentOffset.y;
}

- (void)showImagePicker
{
    //判断相册是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        imagePickerVc.alwaysEnableDoneBtn = YES;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.sortAscendingByModificationDate = NO;
        imagePickerVc.allowPreview = YES;
        imagePickerVc.showSelectedIndex = NO;
        imagePickerVc.allowTakePicture = YES;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerVc.pickerDelegate = self;
        imagePickerVc.allowPickingGif = YES;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        [JHRootController presentViewController:imagePickerVc animated:YES completion:^{
            NSLog(@"1");
        }];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
       
    }];
    if (photos && photos.count > 0)
    {
        UIImage *image = [photos lastObject];
        [self uploadImage:image];
    }
}

// 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
       
    }];
    
    if (animatedImage)
    {
        [self transferGifImagesSourceData:asset];
        NSLog(@"11111");
    }
}

- (void)transferGifImagesSourceData:(PHAsset *)asset
{
    CGSize targetSize = CGSizeMake(MAXFLOAT,MAXFLOAT);
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = YES;
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    @weakify(self);
    [imageManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info)
    {
        //gif 图片
        @strongify(self);
        if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF])
        {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && imageData)
            {
                NSData *selectedImageData = imageData;
                [self uploadGIFImage:selectedImageData];
            }
        }
        else
        {
            NSLog(@"11111");
        }
    }];
    
}

//上传图片
- (void)uploadImage:(UIImage *)image
{
    NSString *const aliUploadPath = @"client_publish/customize/program/";
    [[JHUploadManager shareInstance] uploadSingleImage:image filePath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey)
    {
        if (isFinished)
        {
            [self sendImageMessage:imgKey];
        }
        else
        {
            //[UITipView showTipStr:@"发送失败"];
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
    }];
}

//上传GIF图片
- (void)uploadGIFImage:(NSData *)data {
    NSString *const aliUploadPath = @"client_publish/customize/program/";
    [[JHUploadManager shareInstance] uploadGifImage:data filePath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey)
    {
        if (isFinished)
        {
            [self sendImageMessage:imgKey];
        }
        else
        {
            //[UITipView showTipStr:@"发送失败"];
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
    }];
}

//发送文本消息
- (void)sendContentMessage:(NSString *)text {
    NSInteger customerId = [[UserInfoRequestManager sharedInstance].user.customerId integerValue];
    NSInteger other_uid = [self.userId integerValue];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@(customerId) forKey:@"from_uid"];
    //[parameters setValue:@(16669136) forKey:@"to_uid"];
    [parameters setValue:@(other_uid) forKey:@"to_uid"];
    [parameters setValue:text forKey:@"content"];
    [parameters setValue:@"" forKey:@"image_url"];
    [parameters setValue:@(0) forKey:@"type"];
    
    if ([self.pageType isEqualToString:@"community_official"]) {
        [parameters setValue:@(0) forKey:@"chat_type"];
    } else if ([self.pageType isEqualToString:@"recycle_community"]) {
        [parameters setValue:@(1) forKey:@"chat_type"];
    }
     
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/auth/user/chat");
    [HttpRequestTool postWithURL:url Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject)  {
        NSDictionary *dic = respondObject.data;
        JHChatModel *model = [JHChatModel mj_objectWithKeyValues:dic];
        [self.messageArray addObject:model];

        CGFloat cellHeight = [JHMeChatCell heightWithModel:model];
        [self.heightArray addObject:[NSNumber numberWithFloat:cellHeight]];

        [self updateTableViewOrigin];
        
        if (self.messageArray.count > 0)
        {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messageArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        NSLog("error");
        //[UITipView showTipStr:@"发送失败"];
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}

//发送图片消息
- (void)sendImageMessage:(NSString *)imgKey {
    NSInteger customerId = [[UserInfoRequestManager sharedInstance].user.customerId integerValue];
    NSInteger other_uid = [self.userId integerValue];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setValue:@(customerId) forKey:@"from_uid"];
    [parameters setValue:@(other_uid) forKey:@"to_uid"];
    [parameters setValue:@"" forKey:@"content"];
    [parameters setValue:imgKey forKey:@"image_url"];
    [parameters setValue:@(1) forKey:@"type"];
    if ([self.pageType isEqualToString:@"community_official"]) {
        [parameters setValue:@(0) forKey:@"chat_type"];
    } else if ([self.pageType isEqualToString:@"recycle_community"]) {
        [parameters setValue:@(1) forKey:@"chat_type"];
    }
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/auth/user/chat");
    [HttpRequestTool postWithURL:url Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject)
    {
        NSDictionary *dic = respondObject.data;
        JHChatModel *model = [JHChatModel mj_objectWithKeyValues:dic];
        [self.messageArray addObject:model];

        CGFloat cellHeight = [JHMeChatCell heightWithModel:model];
        [self.heightArray addObject:[NSNumber numberWithFloat:cellHeight]];

        [self updateTableViewOrigin];
        
        if (self.messageArray.count > 0)
        {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messageArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        NSLog("error");
        //[UITipView showTipStr:@"发送失败"];
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}

- (void)updateTableViewOrigin
{
    if (isShow)
    {
        if ([self isScroll])
        {
//            CGRect newFrame = self.tableView.frame;
//            newFrame.origin.y = - (newFrame.size.height - origin_Y);
//
//            [UIView animateWithDuration:kAnimationTime animations:^{
//                self.tableView.frame = newFrame;
//            } completion:^(BOOL finished)
//            {
//            }];
            
            if ([self sumHeight] < ScreenH - UI.statusAndNavBarHeight - SENDVIEW_HEIGHT - UI.bottomSafeAreaHeight)
            {
                CGRect newFrame = self.tableView.frame;
                newFrame.origin.y = - (keyBoard_height + SENDVIEW_HEIGHT + [self sumHeight] - ScreenH);
                [UIView animateWithDuration:kAnimationTime animations:^{
                    self.tableView.frame = newFrame;
                } completion:^(BOOL finished)
                {
                }];
            }
            else
            {
                CGRect newFrame = self.tableView.frame;
                newFrame.origin.y = - (newFrame.size.height - origin_Y);
                [UIView animateWithDuration:kAnimationTime animations:^{
                    self.tableView.frame = newFrame;
                } completion:^(BOOL finished)
                {
                }];
            }
        }
        else
        {
            CGRect newFrame = self.tableView.frame;
            self.tableView.frame = newFrame;
        }
    }
}

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe
{
    if (swipe.state == UIGestureRecognizerStateChanged)
    {
        [self commitTranslation:[swipe translationInView:self.view]];
    }
}

/**
 *   判断手势方向
 */
- (void)commitTranslation:(CGPoint)translation
{
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);

    if (MAX(absX, absY) < 10)
        return;
    
    if (absY > absX)
    {
        if (translation.y<0)
        {
            //向上滑动
        }
        else
        {
            //向下滑动
            [self.keyBoardView dismiss];
        }
    }
}

- (void)tapView
{
    [self.keyBoardView dismiss];
}

//底部工具
- (JHSQPublishBottomView *)bottomView
{
    if(!_bottomView)
    {
        CGSize size = [JHSQPublishBottomView viewSize];
        _bottomView = [JHSQPublishBottomView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
        _bottomView.frame = CGRectMake(0, ScreenH - UI.bottomSafeAreaHeight - size.height, size.width, size.height);
        _bottomView.addAlbumBlock = ^{
          
            [JHGrowingIO trackEventId:JHSQPublishAddSourcesButtonClick];
        };
        _bottomView.keybordSwitchBlock = ^(BOOL showEmoji)
        {
            [[JHEmojiManager sharedInstance] changeKeyboardTo:showEmoji];
        };
    }
    return _bottomView;
}

- (void)loadHistoryData {
    page = page + 1;
    NSString *url = @"";
    if ([self.pageType isEqualToString:@"community_official"]) {
        url = [NSString  stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/chatInfos/%@/%@"),self.userId,[[NSNumber numberWithInt:page] stringValue]];
    } else {
        url = [NSString  stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/chatInfos/%@/%@/1"),self.userId,[[NSNumber numberWithInt:page] stringValue]];
    }
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *dataArray = respondObject.data;
        if (dataArray.count > 0)
        {
            NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
            
            NSMutableArray *modelArr = [NSMutableArray new];
            NSMutableArray *heightArr = [NSMutableArray new];
            
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                JHChatModel *model = [JHChatModel mj_objectWithKeyValues:obj];
                [modelArr addObject:model];

                CGFloat cellHeight = 0;
                if ([model.from_user_info.code intValue] == [customerId intValue])
                {
                    cellHeight = [JHMeChatCell heightWithModel:model];
                }
                else
                {
                    cellHeight = [JHOtherChatCell heightWithModel:model];
                }
                [heightArr addObject:[NSNumber numberWithFloat:cellHeight]];
            }];
            
            if (modelArr.count == heightArr.count && modelArr.count > 0)
            {
                NSMutableIndexSet  *model_indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, modelArr.count)];
                [self.messageArray insertObjects:modelArr atIndexes:model_indexes];

                NSMutableIndexSet  *height_indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, heightArr.count)];
                [self.heightArray insertObjects:heightArr atIndexes:height_indexes];
            }
            
            [self.tableView reloadData];
        }
       
    } failureBlock:^(RequestModel * _Nullable respondObject)
    {
        NSLog("error");
    }];
    
    [self.tableView.mj_header endRefreshing];
}

//-(void)chatKeyBoardiewWithoriginY:(CGFloat)originY resetFrame:(BOOL)isYes
//{
//    isShow = isYes;
//    origin_Y = originY;
//    CGFloat KeyBoard_Height = ScreenH - SENDVIEW_HEIGHT - originY;
//    //originY = ScreenH - SENDVIEW_HEIGHT - keyboardSize.height
//
//    if (isYes)
//    {
//        if ([self sumHeight] > originY)
//        {
//            CGRect newFrame = self.tableView.frame;
//            newFrame.origin.y = - (newFrame.size.height - originY);
//
//            [UIView animateWithDuration:kAnimationTime animations:^{
//                self.tableView.frame = newFrame;
//            } completion:^(BOOL finished)
//            {
//                if (self.messageArray.count > 0)
//                {
//                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                }
//            }];
//        }
//    }
//    else
//    {
//        CGRect newFrame = self.tableView.frame;
//        newFrame.origin.y = UI.statusAndNavBarHeight;
//        [UIView animateWithDuration:kAnimationTime animations:^{
//            self.tableView.frame = newFrame;
//        }];
//    }
//}

//- (void)showImagePicker
//{
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePicker.delegate = self;
//    imagePicker.allowsEditing = NO;
//    imagePicker.modalPresentationStyle  = UIModalPresentationCustom;
//    [self dismissViewControllerAnimated:NO completion:nil];
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//
////    NSString *assetString = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
////    //NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
////    //assets-library://asset/asset.GIF?id=E670F847-4D88-4BE5-9B3B-C51F9058FCBD&ext=GIF
////    //assets-library://asset/asset.JPG?id=8268E2BF-6DBE-46DE-B109-FE26F5CFC769&ext=JPG
////    if (assetString.length > 3)
////    {
////        assetString = [assetString substringFromIndex:assetString.length - 3];
////    }
////
////    if ([assetString isEqualToString:@"GIF"])
////    {
////        //动图
////        //NSData *data = [[NSData alloc] initWithContentsOfFile:assetString];
////        //[self uploadGIFImage:imageData];
////    }
////    else
////    {
////        //非动图
////        [self uploadImage:image];
////    }
//
//    [self uploadImage:image];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
