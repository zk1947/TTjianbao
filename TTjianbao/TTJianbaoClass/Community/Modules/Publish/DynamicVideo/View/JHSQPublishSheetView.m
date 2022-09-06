//
//  JHSQPublishSheetView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHTopicDetailController.h"
#import "JHSQPublishViewController.h"
#import "JHAnchorStyleViewController.h"
#import "JHSQPublishSheetView.h"
#import "JHImagePickerPublishManager.h"
#import "JHVideoCropViewController.h"
#import "JHRichTextEditViewController.h"
#import "JHCustomizeChooseListViewController.h"

@interface JHSQPublishSheetButtonView : UIView

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation JHSQPublishSheetButtonView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        _imageView = [UIImageView jh_imageViewAddToSuperview:self];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(6);
            make.width.height.mas_equalTo(20);
        }];
        
        _titleLabel = [UILabel jh_labelWithText:@"" font:10 textColor:[UIColor colorWithHexString:@"#666666"] textAlignment:1 addToSuperView:self];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-6);
            make.centerX.equalTo(self.imageView);
        }];
    }
    return self;
}

+ (JHSQPublishSheetButtonView *)creatButtonViewWithTitle:(NSString *)title icon:(NSString *)icon ToSuperview:(UIView *)sender {
    
    JHSQPublishSheetButtonView *view = [JHSQPublishSheetButtonView new];
    [sender addSubview:view];
    view.titleLabel.text = title;
    view.imageView.image = JHImageNamed(icon);
    return view;
}

@end

@interface JHSQPublishSheetView ()

/// 话题进来
@property (nonatomic, strong) JHPublishTopicDetailModel *topic;

/// 板块进来
@property (nonatomic, strong) JHPlateSelectData *plate;

@end

@implementation JHSQPublishSheetView

- (void)dealloc {
    NSLog(@"🔥 JHSQPublishSheetView");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        @weakify(self);
        [self jh_addTapGesture:^{
            @strongify(self);
            [self dissmiss];
        }];

        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 24.5;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = RGB(218, 218, 218).CGColor;
        self.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 6;
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews {
    
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:24.5];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    JHSQPublishSheetButtonView *dynamicView = [JHSQPublishSheetButtonView creatButtonViewWithTitle:@"发动态" icon:@"publish_dynamic_icon" ToSuperview:whiteView];

    
    JHSQPublishSheetButtonView *artcleView = [JHSQPublishSheetButtonView creatButtonViewWithTitle:@"写文章" icon:@"publish_artcle_icon" ToSuperview:whiteView];
    
    JHSQPublishSheetButtonView *videoView = [JHSQPublishSheetButtonView creatButtonViewWithTitle:@"小视频" icon:@"publish_video_icon" ToSuperview:whiteView];
    
    NSArray *array = @[dynamicView, artcleView, videoView];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).offset(0);
        make.height.mas_equalTo(49);
    }];
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:5 tailSpacing:5];
    
    @weakify(self);
    [dynamicView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:1];
    }];
    
    [artcleView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:2];
    }];
    
    [videoView jh_addTapGesture:^{
        @strongify(self);
        [self didSelected:3];
    }];
}

- (void)didSelected:(NSUInteger)index
{
    NSString *position;
    if (self.type == 1) {
        position = @"话题首页";
    }
    else if (self.type == 2) {
        position = @"板块首页";
    }
    else {
        position = @"底部导航";
    }

    NSString *eventId = @"";
    switch (index) {
        case 1:
        {
            if(IS_LOGIN){
                
                JHSQPublishViewController *vc = [JHSQPublishViewController new];
                vc.topic = _topic;
                vc.plate = _plate;
                vc.type = 1;
                vc.pageFrom = position;
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            }
            eventId = @"community_write_Twitter_enter";
        }
            break;
            
        case 2:
        {
            if(IS_LOGIN){
                JHRichTextEditViewController * editor = [JHRichTextEditViewController new];
                editor.topic = _topic;
                editor.plate = _plate;
                editor.pageFrom = position;
                [[JHRootController currentViewController].navigationController pushViewController:editor animated:YES];
            }
            eventId = @"community_write_article_enter";
        }
            break;
            
        case 3:
        {
            if(IS_LOGIN){
                [JHImagePickerPublishManager showImagePickerViewWithType:2 maxImagesCount:1 assetArray:@[] viewController:JHRootController photoSelectedBlock:nil videoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
                    JHAlbumPickerModel *model = dataArray.firstObject;
                    [JHImagePickerPublishManager getOutPutPath:model.asset block:^(NSString * _Nonnull outPath) {
                        [self pushCorpVideoWithoutPath:outPath];
                    }];
                }];
            }
            eventId = @"community_write_video_enter";
        }
            break;
            
        default:
            break;
    }
    [JHAllStatistics jh_allStatisticsWithEventId:eventId type:(JHStatisticsTypeGrowing | JHStatisticsTypeSensors)];
}

- (void)pushCorpVideoWithoutPath:(NSString *)outPutPath {
    JHVideoCropViewController *vc = [[JHVideoCropViewController alloc] initWithVideoWithOutPutPath:outPutPath];
    vc.topic = _topic;
    vc.plate = _plate;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:NO];
}

+ (void)showPublishSheetViewWithType:(NSInteger)type
                               topic:(JHPublishTopicDetailModel * _Nullable)topic
                               plate:(JHPlateSelectData * _Nullable)plate
                        addSuperView:(UIView *)superView
{
    JHSQPublishSheetView *sheetView = [JHSQPublishSheetView new];
    [superView addSubview:sheetView];
    [sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.bottom.equalTo(superView).offset((type == 0) ? -12 : -54);
        make.size.mas_equalTo(CGSizeMake(174, 49));
    }];
    sheetView.type = type;
    sheetView.topic = topic;
    sheetView.plate = plate;
}

@end
