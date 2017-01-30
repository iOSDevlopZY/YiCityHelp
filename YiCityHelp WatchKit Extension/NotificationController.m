//
//  NotificationController.m
//  YiCityHelp WatchKit Extension
//
//  Created by Developer_Yi on 2016/12/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NotificationController.h"


@interface NotificationController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *messageLabel;

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
        // Initialize variables here.
        // Configure interface objects here.
        
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



