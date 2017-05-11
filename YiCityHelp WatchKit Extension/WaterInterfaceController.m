//
//  WaterInterfaceController.m
//  YiCityHelp
//
//  Created by Developer_Yi on 2016/12/12.
//  Copyright © 2016年 mac. All rights reserved.
//
#import <UserNotifications/UserNotifications.h>
#import "WaterInterfaceController.h"

@interface WaterInterfaceController ()
//更新时间标签
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *refreshTimeLabe;
//PH标签表
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *PHLabel;
//PH水质标签
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *PHWaterLabel;
//流域
@property (nonatomic,copy)NSString *river;
@end

@implementation WaterInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.river=context;
    //获取数据
    [self getRiverData];
    
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self getRiverData];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
#pragma mark -获取网络数据
- (void)getRiverData
{
    NSURLSession *session=[NSURLSession sharedSession];
    NSString *urlStr=[NSString stringWithFormat:@"http://web.juhe.cn:8080/environment/water/river?river=黄河流域&key=8561731ffcb78be580514307ab85370f"];
    //避免中文问题
    NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:urlStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *riverArr=dict[@"result"];
        
        if(dict.count>0)
        {
        if([dict[@"resultcode"] isEqual:@"200"])
        {
           

            //PH赋值
            [self.PHLabel setText:[NSString stringWithFormat:@"%@",riverArr[0][@"山东济南泺口"][@"ph"]]];
            //PH水质赋值
            [self.PHWaterLabel setText:[NSString stringWithFormat:@"%@",riverArr[0][@"山东济南泺口"][@"phquality"]]];
            //更新时间
             [self.refreshTimeLabe setText:[NSString stringWithFormat:@"%@",riverArr[0][@"山东济南泺口"][@"date"]]];
            
        }
        else{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                WKAlertAction *action=[WKAlertAction actionWithTitle:@"好的" style:WKAlertActionStyleDefault handler:^{
                    
                }];
                NSString *error=[NSString stringWithFormat:@"错误代码：%@",dict[@"reason"]];
                [self presentAlertControllerWithTitle:@"抱歉" message:error preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
            }); 
        }
        }
        else
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                WKAlertAction *action=[WKAlertAction actionWithTitle:@"好的" style:WKAlertActionStyleDefault handler:^{
                    
                }];
                [self presentAlertControllerWithTitle:@"抱歉" message:@"连接出错" preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
            });
          
        }
    }];
    //一定要加上这句，否则任务无法执行
    [dataTask resume];

}
@end



