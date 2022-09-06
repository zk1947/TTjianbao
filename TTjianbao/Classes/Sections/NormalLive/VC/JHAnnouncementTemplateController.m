//
//  JHPublishAnnouncementController.m
//  TTjianbao
//
//  Created by Donto on 2020/7/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnnouncementTemplateController.h"
#import "JHAnnouncementTemplateAddTextCell.h"
#import "JHSQHelper.h"
#import "JHWebImage.h"
#import <IQKeyboardManager.h>
#import "NSString+Extension.h"

@interface JHAnnouncementTemplateController ()<UITableViewDataSource,JHAnnouncementTemplateAddTextCellDelegate>

@property (nonatomic, strong) UIView *announcementView;
@property (nonatomic, strong) UIImageView *announcementImageView;
@property (nonatomic, strong) UILabel *contentsLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHaderView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *rightNavItem;
@property (nonatomic, assign) CGFloat templateImageOriginHeight;

@end

@implementation JHAnnouncementTemplateController

- (void)dealloc
{
    [IQKeyboardManager.sharedManager setEnable:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = @[@""].mutableCopy;
    self.title = @"添加公告";
//    [self setupToolBarWithTitle:@"添加公告" backgroundColor:UIColor.whiteColor];
    UIButton *rightNavItem = [[UIButton alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - 70, UI.statusBarHeight, 56, 44)];
    [rightNavItem setTitle:@"保存" forState:UIControlStateNormal];
    rightNavItem.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightNavItem setTitleColor:kColorTopicTitle forState:UIControlStateNormal];
    [rightNavItem setTitleColor:kColor999 forState:UIControlStateDisabled];
    [rightNavItem addTarget:self action:@selector(finishAddAction) forControlEvents:UIControlEventTouchUpInside];
    rightNavItem.enabled = NO;
    _rightNavItem = rightNavItem;
    [self.jhNavView addSubview:rightNavItem];
    
    [self initContentViews];
    
    [IQKeyboardManager.sharedManager setEnable:YES];
    [self fetchTemplateAnnoucement];
}

- (void)initContentViews {
    
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    
    CGFloat top = UI.statusAndNavBarHeight;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, top, screenWidth, screenHeight-top) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.rowHeight = 54;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = UIColor.whiteColor;
    tableView.tableHeaderView = self.tableHaderView;
    _tableView = tableView;

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard:)];
    [tableView addGestureRecognizer:tapGes];
    [self.view addSubview:tableView];
}

- (void)fetchTemplateAnnoucement {
    
    NSString *url = FILE_BASE_STRING(@"/anon/channel/announce-template/detail");
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel * _Nullable respondObject) {
        NSString *imageUrl = respondObject.data[@"imageUrl"];
        [SVProgressHUD show];
        JH_WEAK(self)
        [JHWebImage loadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
            [self handleTemplateImage:image];
            [SVProgressHUD dismiss];
        }];


    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

- (void)handleTemplateImage:(UIImage *)image {
    //! 图片宽度尺寸处理成和控件宽度一样
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *stretchImage = [UIImage imageWithData:imageData scale:(image.size.width/90.0)];
    stretchImage = [stretchImage stretchableImageWithLeftCapWidth:stretchImage.size.width/2.0 topCapHeight:30];
    
    _announcementImageView.image = stretchImage;
    _templateImageOriginHeight = stretchImage.size.height - 27;
    _announcementImageView.height = _templateImageOriginHeight+27;
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHAnnouncementTemplateAddTextCell *cell = [JHAnnouncementTemplateAddTextCell dequeueReusableCellWithTableView:tableView];
    cell.onlyOneLine = (_dataSource.count == 1);
    cell.textField.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)hiddenKeyBoard:(UITapGestureRecognizer *)ges {
    [self.tableView endEditing:YES];
}

#pragma mark -- Actions

- (void)finishAddAction {
    
    if (_selectedTemplateCompletion) {
        [SVProgressHUD show];
        UIImage*image = [self generateNewImage];
        if (image) {
            _selectedTemplateCompletion(_contentsLabel.text, image);
        }
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (UIImage *)generateNewImage {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(_announcementImageView.bounds.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [_announcementImageView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGFloat x= _announcementImageView.frame.origin.x*scale,y=_announcementImageView.frame.origin.y*scale,w=_announcementImageView.frame.size.width*scale,h=_announcementImageView.frame.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    return newImage;
}

#pragma mark -- JHAnnouncementTemplateAddTextCell
- (void)addLine:(JHAnnouncementTemplateAddTextCell *)cell {
    if (self.dataSource.count < 5) {
        NSInteger line = [self.tableView indexPathForCell:cell].row;
        [self.dataSource insertObject:@"" atIndex:line+1];
        [self.tableView reloadData];
    }
}

- (void)deleteLine:(JHAnnouncementTemplateAddTextCell *)cell {
    NSInteger line = [self.tableView indexPathForCell:cell].row;
    [self.dataSource removeObjectAtIndex:line];
    [self.tableView reloadData];
    [self updateContentLableText];
}

- (void)editingLine:(JHAnnouncementTemplateAddTextCell *)cell changedText:(NSString *)text {
    NSInteger line = [self.tableView indexPathForCell:cell].row;
    [self.dataSource replaceObjectAtIndex:line withObject:text];
    [self updateContentLableText];
}

- (void)updateContentLableText {
    NSString *content = @"";
    for (NSString *text in self.dataSource) {
        if (text.length > 0) {
            content = [NSString stringWithFormat:@"%@%@\n",content,text];
        }
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3.5];
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:self.contentsLabel.font};
    CGSize labelSize = [content boundingRectWithSize:CGSizeMake(82, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    self.contentsLabel.attributedText = [[NSAttributedString alloc] initWithString:content?:@"" attributes:attributes];

    CGFloat height = labelSize.height;
    if (height > 260) {
        height = 260;
    }
    if (height < _templateImageOriginHeight) {
        height = _templateImageOriginHeight;
    }
    _contentsLabel.frame = CGRectMake(4, 27, 82, labelSize.height);
    self.announcementImageView.height = height + 27;
    self.rightNavItem.enabled = content.length > 0;
}

- (UIView *)tableHaderView {
    if (!_tableHaderView) {
        CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
        UIView *tableHaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 305)];

        UIView *announcementView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2.0-45,15,90, 280)];
        _announcementView = announcementView;

        UIImageView *announcementImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 150)];
        announcementImageView.backgroundColor = UIColor.clearColor;
        _announcementImageView = announcementImageView;
        
        UILabel *contentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 27, 82, 30)];
        contentsLabel.font = [UIFont systemFontOfSize:11];
        contentsLabel.textColor = [UIColor whiteColor];
        contentsLabel.numberOfLines = 0;
        _contentsLabel = contentsLabel;
        
        [announcementView addSubview:announcementImageView];
        [announcementImageView addSubview:contentsLabel];
        [tableHaderView addSubview:announcementView];

        _tableHaderView = tableHaderView;
    }
    return _tableHaderView;;
}

@end
