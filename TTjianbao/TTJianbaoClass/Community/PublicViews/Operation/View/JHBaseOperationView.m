//
//  JHBaseOperationView.m
//  TTjianbao
//
//  Created by apple on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseOperationView.h"
#import "JHUIFactory.h"
@interface JHBaseOperationView ()

@property (nonatomic, strong) UIView *operationView;

@property (nonatomic, copy) void(^ operationBlock)(JHOperationType operationType);

@property (nonatomic, copy) dispatch_block_t cancleBlock;

@end

@implementation JHBaseOperationView

-(void)dealloc{
    NSLog(@"🔥");
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        self.frame = JHKeyWindow.frame;
        UIButton *button = [UIButton jh_buttonWithTarget:self action:@selector(dismiss) addToSuperView:self];
           [button mas_makeConstraints:^(MASConstraintMaker *make) {
               make.edges.equalTo(self);
               }];
        _operationView = [UIView jh_viewWithColor:[UIColor whiteColor] addToSuperview:self];
        [_operationView jh_cornerRadius:12];
        [_operationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.offset(self.height);
        }];
        
        UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:_operationView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_operationView);
            make.height.mas_equalTo(UI.tabBarAndBottomSafeAreaHeight);
        }];
        
        UIButton *cancleButton = [UIButton jh_buttonWithTitle:@"取消" fontSize:18 textColor:RGB102102102 target:self action:@selector(cancleMethod) addToSuperView:whiteView];
        [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(whiteView);
            make.height.mas_equalTo(50.f);
        }];
        
        JHCustomLine *line = [JHUIFactory createLine];
        [whiteView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(0);
            make.height.offset(.5);
            make.left.offset(0);
            make.right.offset(0);
        }];

    }
    return self;
}

- (JHBaseOperationViewCollectionView *)creatCollectionView
{
    JHBaseOperationViewCollectionView *collectionView = [JHBaseOperationViewCollectionView new];
    [_operationView addSubview:collectionView];
    @weakify(self);
    collectionView.operationBlock = ^(JHOperationType operationType) {
        @strongify(self);
        if(self.operationBlock){
            self.operationBlock(operationType);
            [self dismiss];
        }
    };
    return collectionView;
}

- (void)cancleMethod {
    if(self.cancleBlock) {
        self.cancleBlock();
    }
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25f animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self.operationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(219 + UI.tabBarAndBottomSafeAreaHeight);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)show
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [UIView animateWithDuration:0.25 animations:^{
               self.operationView.bottom = self.height;
           }];
    });
   
}
+ (JHBaseOperationView *)operationWithUpOperationType:(JHOperationType)upOperationType
                  midOperationType:(JHOperationType)midOperationType
                   downOperationType:(JHOperationType)downOperationType
                   operationBlock:(void (^)(JHOperationType))operationBlock
{
    UIView * window = JHKeyWindow;
    
    JHBaseOperationView *operationViewBg = [JHBaseOperationView new];
    [window addSubview:operationViewBg];
    operationViewBg.operationBlock = operationBlock;
    [operationViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
     UIView *super_view = operationViewBg.operationView;
    
     JHBaseOperationViewCollectionView *upCollectionView = [operationViewBg creatCollectionView];
     upCollectionView.operationType = upOperationType;
    
    JHCustomLine *line = [JHUIFactory createLine];
    [super_view addSubview:line];
  
     JHBaseOperationViewCollectionView *midCollectionView = [operationViewBg creatCollectionView];
      midCollectionView.operationType = midOperationType;
    
     JHBaseOperationViewCollectionView *downCollectionView = [operationViewBg creatCollectionView];
      downCollectionView.operationType = downOperationType;
      downCollectionView.showHeader = YES;
    [upCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(super_view);
        make.top.equalTo(super_view).offset(0);
        make.height.mas_equalTo(0);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(upCollectionView.mas_bottom).offset(0);
          make.height.offset(0);
          make.left.offset(15);
          make.right.offset(-15);
      }];
    
    [midCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(super_view);
         make.top.equalTo(line.mas_bottom).offset(0);
        make.height.mas_equalTo(0);
       }];
    
    [downCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(super_view);
        make.top.equalTo(midCollectionView.mas_bottom).offset(0);
          make.bottom.equalTo(super_view.mas_bottom).offset(-UI.tabBarAndBottomSafeAreaHeight);
        make.height.mas_equalTo(0);
    }];
    
    
    if (upOperationType > JHOperationTypeNone) {
        [upCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(operationCellHeight+20);
        }];
    }
    if (midOperationType > JHOperationTypeNone) {
        [midCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(operationCellHeight+20);
        }];
       }
    if (downOperationType > JHOperationTypeNone) {
      
        NSInteger num = downCollectionView.dataArray.count/5;
       if (downCollectionView.dataArray.count%5==0) {
           num=num-1;
        }
        CGFloat cellheight =operationCellHeight+operationCellHeight*num;
        
    [downCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(cellheight+operationHeaderHeight+20);
     }];
    }
    if (midOperationType > JHOperationTypeNone&&
           midOperationType > JHOperationTypeNone) {
           [line mas_updateConstraints:^(MASConstraintMaker *make) {
               make.height.offset(.5);
           }];
       }
    [operationViewBg show];
    return operationViewBg;
}

+ (void)creatSQOperationView:(JHPostData*)mode  Block:(void (^)(JHOperationType operationType))operationBlock{
    
    JHOperationType section1Type = JHOperationTypeNone;
    
    if (mode.item_type != 6&&
        mode.item_type != 61&&
        mode.item_type != 7) {
        if(mode.item_type == 20 || mode.item_type == 30 || mode.item_type == 40) {///帖子增加生成长图
            section1Type = (JHOperationTypeMakeLongImage | JHOperationTypeWechatSession | JHOperationTypeWechatTimeLine);
        }
        else {
            section1Type = (JHOperationTypeMakeLongImage | JHOperationTypeWechatSession | JHOperationTypeWechatTimeLine);
        }
    }
  
    JHOperationType collectType = JHOperationTypeNone;
    //直播间不显示收藏
    if (mode.item_type != JHPostItemTypeLiveRoom) {
        collectType = mode.is_collect ? JHOperationTypeCancleColloct : JHOperationTypeColloct;
    }
    
    JHOperationType deleteType = JHOperationTypeNone;
    JHOperationType report = JHOperationTypeReport;
    
    
    JHOperationType backType = JHOperationTypeNone ;
    if (JHRootController.navViewControllers.count>1) {
        backType = JHOperationTypeBack;
    }
    
    NSString * customerId = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
//    NSString * user_id = mode.plate_info.owner.user_id?:@"";
    NSMutableArray * userid_array = [[NSMutableArray alloc] init];
    for (JHOwnerInfo *info in mode.plate_info.owners) {
        if ((OBJ_TO_STRING(info.user_id)).length>0) {
            [userid_array addObject:OBJ_TO_STRING(info.user_id)];
        }
    }

    JHOperationType copyType = JHOperationTypeNone;
    if (mode.item_type != 6&&
        mode.item_type != 61&&
        mode.item_type != 7) {
        copyType = JHOperationTypeCopyUrl;
    }
    //自己发的帖子
    if (mode.is_self) {
        deleteType = JHOperationTypeDelete;
        report = JHOperationTypeNone;
    }else if ([userid_array containsObject:customerId] && ![userid_array containsObject:mode.publisher.user_id]){
        deleteType = JHOperationTypeNone;
        report = JHOperationTypeNone;
    }
    JHOperationType editType = JHOperationTypeNone;
    /// 自己发送的显示编辑按钮
    if(mode.is_self) {
        editType = JHOperationTypeEdit;
    }
    else if([userid_array containsObject:customerId] &&
            [customerId length]>0 && ![userid_array containsObject:mode.publisher.user_id]){
        /// 版主显示编辑按钮
        editType = JHOperationTypeEdit;
    }
    JHOperationType section2Type = (copyType | collectType | deleteType | report | backType | editType);
    
    JHOperationType section3Type = JHOperationTypeNone;
    
    //版主
    if (!mode.is_self &&
        [userid_array containsObject:customerId] &&
        [customerId length]>0 && ![userid_array containsObject:mode.publisher.user_id])
    {
        
       JHOperationType typeGood =mode.content_level==1?JHOperationTypeCancleSetGood:JHOperationTypeSetGood;
        
        JHOperationType typeTop= JHOperationTypeNone;
        JHOperationType typeNotice= JHOperationTypeNone;
        if (mode.content_style==0) {
            typeTop= JHOperationTypeSetTop;
            typeNotice = JHOperationTypeNoice;
        }
        if (mode.content_style==2) {
            typeTop=JHOperationTypeCancleSetTop;
              typeNotice = JHOperationTypeNoice;
        }
        if (mode.content_style==3) {
            typeTop=JHOperationTypeSetTop;
           typeNotice = JHOperationTypeCancleNotice;
        }
        section3Type = (typeGood | typeTop |
                                        typeNotice| JHOperationTypeDelete |
                                        JHOperationTypeWaring| JHOperationTypeMute
                                        );//JHOperationTypeSealAccount  这版暂时不加
       
    }
      
   [JHBaseOperationView operationWithUpOperationType:section1Type midOperationType:section2Type  downOperationType:section3Type operationBlock:^(JHOperationType operationType) {
       operationBlock(operationType);
       
   }];
}

+ (void)creatSQPostDetailOperationView:(JHPostDetailModel*)mode  Block:(void (^)(JHOperationType operationType))operationBlock {
    JHOperationType section1Type = JHOperationTypeNone;
    
    if (mode.item_type != 6 &&
        mode.item_type != 61 &&
        mode.item_type != 7) {
      section1Type = (JHOperationTypeMakeLongImage | JHOperationTypeWechatSession | JHOperationTypeWechatTimeLine);
    }
  
    JHOperationType collectType = JHOperationTypeNone;
    //直播间不显示收藏
    if (mode.item_type != JHPostItemTypeLiveRoom) {
        collectType = mode.is_collect ? JHOperationTypeCancleColloct : JHOperationTypeColloct;
    }
    
    JHOperationType deleteType = JHOperationTypeNone;
    JHOperationType report = JHOperationTypeReport;
    
    JHOperationType backType = JHOperationTypeNone ;
    if (JHRootController.navViewControllers.count>1) {
        backType = JHOperationTypeBack;
    }
    
    NSString * customerId = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
//    NSString * user_id = mode.plate_info.owner.user_id?:@"";
    NSMutableArray * userid_array = [[NSMutableArray alloc] init];
    for (JHOwnerInfo *info in mode.plate_info.owners) {
        if ((OBJ_TO_STRING(info.user_id)).length>0) {
            [userid_array addObject:OBJ_TO_STRING(info.user_id)];
        }
    }

    JHOperationType copyType = JHOperationTypeNone;
    if (mode.item_type != 6 &&
        mode.item_type != 61 &&
        mode.item_type != 7) {
        copyType = JHOperationTypeCopyUrl;
    }
    
    JHOperationType editType = JHOperationTypeNone;
    //自己发的帖子
    if (mode.is_self) {
        deleteType = JHOperationTypeDelete;
        report = JHOperationTypeNone;
        editType = JHOperationTypeEdit;
    }else if ([userid_array containsObject:customerId] && ![userid_array containsObject:mode.publisher.user_id]){
        deleteType = JHOperationTypeNone;
        report = JHOperationTypeNone;
        /// 版主显示编辑按钮
        editType = JHOperationTypeEdit;
    }
    
    JHOperationType section2Type = (copyType | collectType | deleteType | report | backType | editType);
    
    JHOperationType section3Type = JHOperationTypeNone;
    
    //版主
    if (!mode.is_self &&
        [userid_array containsObject:customerId] &&
        [customerId length]>0 && ![userid_array containsObject:mode.publisher.user_id])
    {
        
       JHOperationType typeGood =mode.content_level==1?JHOperationTypeCancleSetGood:JHOperationTypeSetGood;
        
        JHOperationType typeTop= JHOperationTypeNone;
        JHOperationType typeNotice= JHOperationTypeNone;
        if (mode.content_style==0) {
            typeTop= JHOperationTypeSetTop;
            typeNotice = JHOperationTypeNoice;
        }
        if (mode.content_style==2) {
            typeTop=JHOperationTypeCancleSetTop;
              typeNotice = JHOperationTypeNoice;
        }
        if (mode.content_style==3) {
            typeTop=JHOperationTypeSetTop;
           typeNotice = JHOperationTypeCancleNotice;
        }
        section3Type = (typeGood | typeTop |
                                        typeNotice| JHOperationTypeDelete |
                                        JHOperationTypeWaring| JHOperationTypeMute
                                        );//JHOperationTypeSealAccount  这版暂时不加
       
    }
      
       [JHBaseOperationView operationWithUpOperationType:section1Type midOperationType:section2Type  downOperationType:section3Type operationBlock:^(JHOperationType operationType) {
           operationBlock(operationType);
           
       }];
}

/// 板块交互弹窗
/// @param mode mode description
+ (void)creatPlateOperationView:(JHPostData*)shareInfo  Block:(void (^)(JHOperationType operationType))operationBlock{
    JHOperationType section1Type = (JHOperationTypeWechatSession | JHOperationTypeWechatTimeLine);
    JHOperationType section2Type = (JHOperationTypeCopyUrl | JHOperationTypeBack);
    JHOperationType section3Type = JHOperationTypeNone;
    [JHBaseOperationView operationWithUpOperationType:section1Type midOperationType:section2Type  downOperationType:section3Type operationBlock:^(JHOperationType operationType) {
        operationBlock(operationType);
        
    }];
}
+ (void)creatShareOperationView:(JHShareInfo*)shareInfo object_flag:(NSString *)object_flag{
    
    JHOperationType section1Type = (JHOperationTypeWechatSession | JHOperationTypeWechatTimeLine);
    JHOperationType section2Type = JHOperationTypeNone;
    JHOperationType section3Type = JHOperationTypeNone;
    
    JHBaseOperationView *view = [JHBaseOperationView operationWithUpOperationType:section1Type midOperationType:section2Type  downOperationType:section3Type operationBlock:^(JHOperationType operationType) {
        
        if(shareInfo.pageFrom == JHPageFromTypeOnlineAppraiseVideoDetailOperate || JHPageFromTypeOnlineAppraiseVideoDetailMore) {
                [self sa_shareMethodWithModel:shareInfo.extenseData type:operationType];
        }
        [JHBaseOperationAction toShare:operationType operationShareInfo:shareInfo object_flag:object_flag];
    }];
    view.cancleBlock = ^{
        if(shareInfo.eventId) {
            [JHAllStatistics jh_allStatisticsWithEventId:shareInfo.eventId type:(JHStatisticsTypeSensors | JHStatisticsTypeGrowing)];
        }
        
    };
}

+ (void)sa_shareMethodWithModel:(id)model type:(JHOperationType)type {
    if(IS_DICTIONARY(model)) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)model];
        if(type == JHOperationTypeWechatSession) {
            [params setValue:@"微信分享" forKey:@"operation_type"];
            //微信埋点
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_share_wechat_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
        }
        else if(type == JHOperationTypeWechatTimeLine){
            [params setValue:@"微信朋友圈分享" forKey:@"operation_type"];
            //朋友圈埋点
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_share_moments_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
        }
        [JHAllStatistics jh_allStatisticsWithEventId:@"jdsphdShare" params:params type:JHStatisticsTypeSensors];
    }
}


/**新增分享接口:webPage，替换umeng分享，跟原来不冲突
 * 跟creatShareOperationView基本一致,除了最后一个参数类型不同
*/
+ (void)showShareView:(JHShareInfo*)shareInfo objectFlag:(id)objectFlag
{
    JHOperationType section1Type = (JHOperationTypeWechatSession | JHOperationTypeWechatTimeLine);
    JHOperationType section2Type = JHOperationTypeNone;
    JHOperationType section3Type = JHOperationTypeNone;
    
    [JHBaseOperationView operationWithUpOperationType:section1Type midOperationType:section2Type  downOperationType:section3Type operationBlock:^(JHOperationType operationType) {
        
        [JHBaseOperationAction toShare:operationType operationShareInfo:shareInfo object_flag:objectFlag];
    }];
}

/**新增分享接口:webPage，替换umeng分享，跟原来不冲突
 * 跟creatShareOperationView基本一致,除了最后一个参数类型不同
*/
+ (void)showShareView:(JHShareInfo*)shareInfo objectFlag:(id)objectFlag completion:(void(^)(JHOperationType operationType))block
{
    JHOperationType section1Type = (JHOperationTypeWechatSession | JHOperationTypeWechatTimeLine);
    JHOperationType section2Type = JHOperationTypeNone;
    JHOperationType section3Type = JHOperationTypeNone;
    
    [JHBaseOperationView operationWithUpOperationType:section1Type midOperationType:section2Type  downOperationType:section3Type operationBlock:^(JHOperationType operationType) {
        if (block) {
            block(operationType);
        }
    }];
}


+ (void)showShareImageView:(JHShareInfo*)shareInfo objectFlag:(id)objectFlag
{
    JHOperationType section1Type = (JHOperationTypeWechatSession | JHOperationTypeWechatTimeLine);
    JHOperationType section2Type = JHOperationTypeNone;
    JHOperationType section3Type = JHOperationTypeNone;
    
    [JHBaseOperationView operationWithUpOperationType:section1Type midOperationType:section2Type  downOperationType:section3Type operationBlock:^(JHOperationType operationType) {
        
        [JHBaseOperationAction toShareImage:operationType shareInfo:shareInfo];
    }];
}

@end
