//
//  JHCalendarEvent.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/9/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCalendarEvent.h"
#import <EventKit/EventKit.h>
#import "JHAlertView.h"

@interface JHCalendarEvent()
@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic, copy) SuccessHandler successHandler;

@property (nonatomic, assign) BOOL isShowAlert;
@end

@implementation JHCalendarEvent

#pragma  mark - Public
+ (instancetype)shared
{
    static JHCalendarEvent *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHCalendarEvent alloc] init];
    });
    return instance;
}

+ (void)addEventWithModels : (NSArray<JHCalendarEventModel*> *)models successHandler : (SuccessHandler)successHandler{
    JHCalendarEvent *calendarEvent = [JHCalendarEvent shared];
    calendarEvent.successHandler = successHandler;
    NSInteger i = 0;
    for (JHCalendarEventModel *model in models) {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.startTime / 1000];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:model.endTime / 1000];
        NSString *text = @"";
        if (i == models.count - 1) {
            text = @"已开启提醒";
        }
        [calendarEvent addEventTitle:model.title
                            location:@""
                           startDate:startDate
                             endDate:endDate
                              allDay:false
                          alarmArray:model.alarmArray
                         successText:text];
        i += 1;
    }
}

+ (void)addEventTitle : (NSString *)title
            startTime : (NSInteger)startTime
              endTime : (NSInteger)endTime
           alarmArray : (NSArray<NSString *> *)alarmArray{
    
    JHCalendarEvent *calendarEvent = [JHCalendarEvent shared];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    
    [calendarEvent addEventTitle:title
                        location:@""
                       startDate:startDate
                         endDate:endDate
                          allDay:false
                      alarmArray:alarmArray
                     successText:@"添加成功"];
}

- (void)addEventTitle : (NSString *)title
             location : (NSString *)location
            startDate : (NSDate *)startDate
              endDate : (NSDate *)endDate
               allDay : (BOOL)allDay
           alarmArray : (NSArray<NSString *> *)alarmArray
          successText : (NSString *)text{
    
    @weakify(self)
    if (![self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) return;
    // 获取访问权限
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        @strongify(self)
        if (error){
            //报错啦
            JHTOAST(@"添加失败，请稍后重试");
        }else if (!granted){
            // 被用户拒绝，不允许访问日历
            [self showAlertView];
            if (self.successHandler) {
                self.successHandler(false);
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 用户既然允许事件保存到日历，那就去保存吧
                [self addEventRemindTitle:title
                                 location:location
                                startDate:startDate
                                  endDate:endDate
                                   allDay:allDay
                               alarmArray:alarmArray
                              successText:text];
            });
        }
    }];
}

#pragma mark - Private
- (void)addEventRemindTitle : (NSString *)title
                   location : (NSString *)location
                  startDate : (NSDate *)startDate
                    endDate : (NSDate *)endDate
                     allDay : (BOOL)allDay
                 alarmArray : (NSArray<NSString *> *)alarmArray
                successText : (NSString *)text {
    //创建一个新事件
    EKEvent *event = [self getEventItemTitle:title
                                    location:location
                                   startDate:startDate
                                     endDate:endDate
                                      allDay:allDay];
    
    NSArray *alarms = [self getAlarm:alarmArray];
    
    for (EKAlarm *alarm in alarms) {
        [event addAlarm:alarm];
    }
    
    NSError *error;
    [self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    if (error == nil) {
        if (text.length > 0) {
            JHTOAST(text);
        }
        
        if (self.successHandler) {
            self.successHandler(true);
        }
    }else {
        if (error.code == 1) {
            JHTOAST(error.localizedDescription);
        }
        if (self.successHandler) {
            self.successHandler(false);
        }
    }
    
}

- (EKEvent *)getEventItemTitle : (NSString *)title
                      location : (NSString *)location
                     startDate : (NSDate *)startDate
                       endDate : (NSDate *)endDate
                        allDay : (BOOL)allDay{

    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = title;
    event.location = location ?: @"";
    event.startDate = startDate;
    event.endDate = endDate;
    event.allDay = allDay;
    event.calendar = [self getCalendar];
    return event;
}

- (EKCalendar *)getCalendar{
    EKCalendar *calendar = [self.eventStore defaultCalendarForNewEvents];
    if (calendar != nil) {
        return calendar;
    }
    
    BOOL needAdd = true;
    for (EKCalendar *ekcalendar in [self.eventStore calendarsForEntityType:EKEntityTypeEvent]) {
        if ([ekcalendar.title isEqualToString:@"My calendar"]) {
            needAdd = false;
            calendar = ekcalendar;
            break;
        }
    }

    if (needAdd) {
        EKSource *localSource = nil;
        for (EKSource *source in self.eventStore.sources){
            //iCloud 是否存在
            if (source.sourceType ==EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"]){
                localSource = source;
                break;
            }
        }

        if (localSource == nil){
            //本地 是否存在
            for (EKSource *source in self.eventStore.sources) {
                if (source.sourceType == EKSourceTypeLocal){
                    localSource = source;
                    break;
                }
            }
        }

        if (localSource) {
            calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.eventStore];
            calendar.source = localSource;
            calendar.title = @"日历";//自定义日历标题
            calendar.CGColor = HEXCOLOR(0x1aacf8).CGColor;//自定义日历颜色
            NSError* error;
            [self.eventStore saveCalendar:calendar commit:YES error:&error];
        }
    }
    return calendar;
}

- (NSArray *)getAlarm : (NSArray<NSString *> *)alarms {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSString *time in alarms) {
        
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:-[time integerValue]];
        [list appendObject:alarm];
    }
    return list;
}
- (void)showAlertView {
    if (self.isShowAlert == true) return;
    self.isShowAlert = true;
    [JHAlertView showWithTitle:@"开启日历权限" desc:@"添加提醒" handler:^{
        [self openSettingsView];
        self.isShowAlert = false;
    } closeHandler:^{
        self.isShowAlert = false;
    }];
}

- (void)openSettingsView {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - LAZY
- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}
@end
