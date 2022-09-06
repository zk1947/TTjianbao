//
//  JHActivityAlertView.m
//  TTjianbao
//
//  Created by apple on 2020/5/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHAppAlertViewManger.h"
#import "JHActivityAlertView.h"
#import "JHAppAlertBodyModel.h"
#import "JHWebViewController.h"
#import "UIImageView+JHWebImage.h"
#import "JHGrowingIO.h"

@interface JHActivityAlertView ()

@property (nonatomic, weak) UIButton *closeBtn;

@property (nonatomic, weak) UIImageView *activityImageView;

@property (nonatomic, strong) JHAppAlertBodyActivityModel *model;

@end

@implementation JHActivityAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
 
        self.backgroundColor = RGBA(0,0,0,0.5);
        
        _activityImageView = [UIImageView jh_imageViewAddToSuperview:self];
        [_activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(58);
            make.right.equalTo(self).offset(-58);
            make.centerY.equalTo(self).offset(20);
        }];
        @weakify(self);
        [_activityImageView jh_addTapGesture:^{
            @strongify(self);
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.urlString = self.model.url;
            [[JHRouterManager jh_getViewController].navigationController pushViewController:vc animated:YES];
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setValue:self.model.name forKey:@"popup_name"];
            [params setValue:@"1" forKey:@"is_next"];
            [JHGrowingIO trackEventId:self.model.isLiveRoom ? @"live_popup_show_click" : @"activities_popup_click" variables:params];
            
            // 埋点
            NSString *page = @"直播间外页";
            if (self.model.isLiveRoom) {
                page = @"直播间页";
            }
            
            NSDictionary *dict = @{
                @"page_position" : page,
                @"spm_type" : @"弹窗",
                @"content_url" : self.model.url ?: @"",
                @"position" : self.model.taskName ? self.model.taskDay : @"",
                @"open_name" : self.model.taskName ? @"7天首页弹框" : @"",
            };
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:dict type:JHStatisticsTypeSensors];
            
            [self removeFromSuperview];
            [JHAppAlertViewManger publishChangeTimeIntervalStatus];
            [self didClickRequest:true];
        }];
        
        _closeBtn = [UIButton jh_buttonWithImage:@"red_packet_guide_close" target:self action:@selector(closeMethod) addToSuperView:self];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.activityImageView.mas_top);
            make.size.mas_equalTo(CGSizeMake(58, 58));
            make.right.equalTo(self.activityImageView).offset(17);
        }];
    }
    return self;
}

-(void)closeMethod {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.model.name forKey:@"popup_name"];
    [params setValue:@"0" forKey:@"is_next"];
    
    [JHGrowingIO trackEventId:self.model.isLiveRoom ? @"live_popup_show_click" : @"activities_popup_click" variables:params];
    [self removeFromSuperview];
    [JHAppAlertViewManger publishChangeTimeIntervalStatus];
    [self didClickRequest:false];
}

+ (void)showAPPAlertViewWithModel:(JHAppAlertBodyActivityModel *)model{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    JHActivityAlertView * appAlertView = [[JHActivityAlertView alloc] initWithFrame:window.bounds];
    [window addSubview:appAlertView];
    appAlertView.model = model;
    @weakify(appAlertView);
    [appAlertView.activityImageView jhSetImageWithURL:[NSURL URLWithString:model.img] placeholder:nil options:(SDWebImageHighPriority) progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        @strongify(appAlertView);
        if(image && image.size.width > 0)
        {
            CGSize size = image.size;
            CGFloat s = (size.height/size.width) * (ScreenW - 116.f);
            [appAlertView.activityImageView
             mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(s);
            }];
        }
        else {
            [appAlertView removeFromSuperview];
        }
    }];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:appAlertView.model.name forKey:@"popup_name"];
    [JHGrowingIO trackEventId:appAlertView.model.isLiveRoom ? @"live_popup_show" : @"activities_popup" variables:params];
    [appAlertView reportOpen];
}

/// location 弹窗位置   1：全局      2：列表页    3：直播间
+ (void)getActivityAlertViewWithLocation:(NSInteger)location {

    if(location == 3){
        static BOOL first = YES;
        if(!first){
            return;
        }
        first = NO;
    }
    NSString *urlStr = FILE_BASE_STRING(@"/activity/api/dialog/show");
    [HttpRequestTool getWithURL:urlStr Parameters:@{@"location" : @(location)}  successBlock:^(RequestModel *respondObject) {
                
        if (IS_DICTIONARY(respondObject.data)) {
            
            NSArray *array = [respondObject.data valueForKey:@"dialogs"];
            if(IS_ARRAY(array)){
                for(NSDictionary *dic in array){
                    JHAppAlertModel *model = [JHAppAlertModel new];
                        model.type = JHAppAlertTypeActivity;
                        model.localType = (location == 3 ? JHAppAlertLocalTypeLiveRoom : JHAppAlertLocalTypeHome);
                    model.typeName = (location == 3 ? AppAlertActivityRoom : AppAlertActivity);
                    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [params setValue:(location == 3 ? @1 : @0) forKey:@"isLiveRoom"];
                        model.param = params;
                        [JHAppAlertViewManger addModelArray:@[model]];
                }
            }
        }
    } failureBlock:nil];
}

#pragma mark - Request

- (void)didClickRequest : (BOOL) optionFlag {
    if (self.model.activityId.length <= 0) return;
    
    NSDictionary *par = @{
        @"activityId" : self.model.activityId,
        @"optionFlag" : optionFlag ? @"1" : @"0" ,
    };
        
    NSString *url = FILE_BASE_STRING(@"/activity/api/cdk/auth/checkin/opt");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

#pragma mark - 埋点
- (void)reportOpen {
    NSString *page = @"直播间外页";
    if (self.model.isLiveRoom) {
        page = @"直播间页";
    }
    
    NSDictionary *dict = @{
        @"page_position" : page,
        @"content_url" : self.model.url ?: @"",
        @"position" : self.model.taskName ? self.model.taskDay : @"",
        @"open_name" : self.model.taskName ? @"7天首页弹框" : @"",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"epOpenLayer" params:dict type:JHStatisticsTypeSensors];
}
@end
