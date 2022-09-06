//
//  JHBaseOperationModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseOperationModel.h"

@implementation JHBaseOperationModel

+ (NSMutableArray<JHBaseOperationModel *> *)getOperationTypeArrayWith:(JHOperationType)operationType{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:8];
    
    if(operationType & JHOperationTypeMakeLongImage){
           [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeMakeLongImage title:@"生成长图" icon:@"operation_make_image"]];
    }
    
    if(operationType & JHOperationTypeWechatSession){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeWechatSession title:@"微信" icon:@"operation_weixin_icon"]];
    }
    
    if(operationType & JHOperationTypeWechatTimeLine){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeWechatTimeLine title:@"朋友圈" icon:@"operation_quan_icon"]];
    }
    
    if(operationType & JHOperationTypeCopyUrl){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeCopyUrl title:@"复制链接" icon:@"operation_copyLink_icon"]];
    }
    
    if(operationType & JHOperationTypeColloct){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeColloct title:@"收藏" icon:@"operation_collect_icon"]];
    }
    if(operationType & JHOperationTypeCancleColloct){
             [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeCancleColloct title:@"取消收藏" icon:@"operation_canclecollect_icon"]];
         }
    
    if(operationType & JHOperationTypeReport){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeReport title:@"举报" icon:@"operation_waring_icon"]];
    }
   
    if(operationType & JHOperationTypeSetGood){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeSetGood title:@"设为精华" icon:@"operation_good_icon"]];
    }
    if(operationType & JHOperationTypeCancleSetGood){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeCancleSetGood title:@"取消精华" icon:@"operation_canclegood_icon"]];
    }
    
    if(operationType & JHOperationTypeSetTop){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeSetTop title:@"置顶" icon:@"operation_top_icon"]];
    }
    if(operationType & JHOperationTypeCancleSetTop){
              [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeCancleSetTop title:@"取消置顶" icon:@"operation_cancletop_icon"]];
          }
    
    if(operationType & JHOperationTypeNoice){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeNoice title:@"公告" icon:@"operation_notice_icon"]];
    }
    if(operationType & JHOperationTypeCancleNotice){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeCancleNotice title:@"取消公告" icon:@"operation_canclenotice_icon"]];
    }
    
    if(operationType & JHOperationTypeDelete){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeDelete title:@"删除" icon:@"operation_delete_icon"]];
    }
    
    if(operationType & JHOperationTypeEdit){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeEdit title:@"编辑" icon:@"operation_edit_icon"]];
    }
    
    if(operationType & JHOperationTypeWaring){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeWaring title:@"警告" icon:@"operation_waring_icon"]];
    }
    
    if(operationType & JHOperationTypeMute){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeMute title:@"禁言" icon:@"operation_mute_icon"]];
    }
    
    if(operationType & JHOperationTypeSealAccount){
        [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeSealAccount title:@"封号" icon:@"operation_feng_icon"]];
    }
    
  if(operationType & JHOperationTypeBack){
         [array addObject:[JHBaseOperationModel creatModelWithType:JHOperationTypeBack title:@"返回首页" icon:@"operation_back_icon"]];
     }
    
    return array;
}

+ (JHBaseOperationModel *)creatModelWithType:(JHOperationType)type title:(NSString *)title icon:(NSString *)icon{
    JHBaseOperationModel *model = [JHBaseOperationModel new];
    model.title = title;
    model.icon = icon;
    model.operationType = type;
    return model;
}

@end
