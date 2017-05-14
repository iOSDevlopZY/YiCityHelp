//
//  InterfaceController.m
//  YiCityHelp WatchKit Extension
//
//  Created by Developer_Yi on 2016/12/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()<CLLocationManagerDelegate>
//定位城市标签
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *locCityLabel;
//时间日期显示器
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceDate *timeAndDate;

//定位城市
@property (nonatomic,copy)NSString *locCity;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
#pragma mark - 语音输入城市
- (IBAction)speak {
    //语音输入
    [self presentTextInputControllerWithSuggestions:nil allowedInputMode:WKTextInputModePlain completion:^(NSArray * _Nullable results) {
        //返回结果
        self.locCity=[results objectAtIndex:0];
        [self.locCityLabel setText:self.locCity];
        }];
}
#pragma mark -手写输入城市
- (IBAction)handWrite {
    [self presentTextInputControllerWithSuggestions:nil allowedInputMode:WKTextInputModeAllowEmoji completion:^(NSArray * _Nullable results) {
        //返回结果
        self.locCity=[results objectAtIndex:0];
        [self.locCityLabel setText:self.locCity];
    }];
}
#pragma mark -传递数据
-(id)contextForSegueWithIdentifier:(NSString *)segueIdentifier
{
    if([segueIdentifier isEqualToString:@"Water"])
    {
        return @"黄河流域";
    }
    else
    {
        return self.locCity;
    }
}
@end



