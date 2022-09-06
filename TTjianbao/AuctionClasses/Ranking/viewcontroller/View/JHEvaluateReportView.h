//
//  JHEvaluateReportView.h
//  TTjianbao
//
//  Created by Jesse on 2020/7/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHEvaluateReportView : UIView

@property (nonatomic, copy) JHActionBlock callbackAction;

- (void)preLoadData:(id)model helpful:(BOOL)helpful;
@end

