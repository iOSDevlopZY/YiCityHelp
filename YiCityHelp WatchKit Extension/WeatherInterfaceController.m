//
//  WeatherInterfaceController.m
//  YiCityHelp
//
//  Created by Developer_Yi on 2016/12/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WeatherInterfaceController.h"

@interface WeatherInterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *updateTimeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *tempLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *weatherDirLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *weatherSpeedLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *humidityLabel;
@property (nonatomic,copy)NSString *locCity;
@property (nonatomic,strong)NSDictionary *weatherDict;


@end

@implementation WeatherInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.locCity=context;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getWeatherData];
    });
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
#pragma mark - 网络获取天气数据
- (void)getWeatherData
{
    NSURLSession *session=[NSURLSession sharedSession];
    NSString *urlStr=[NSString stringWithFormat:@"http://v.juhe.cn/weather/index?&dtype=json&format=1&cityname=%@&key=45613f40e8c3fd0cee28a9ee4cee5a25",self.locCity];
    //避免中文问题
    NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:urlStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *weatherDict=dict[@"result"];
        
        if(weatherDict.count>0)
        {
            self.weatherDict=weatherDict;
            
            if([dict[@"resultcode"] isEqual:@"200"])
            {
                
                //温度赋值
                [self.tempLabel setText:[NSString stringWithFormat:@"%@℃",self.weatherDict[@"sk"][@"temp"]]];
                //风向赋值
                [self.weatherDirLabel setText:[NSString stringWithFormat:@"%@",self.weatherDict[@"sk"][@"wind_direction"]]];
                //更新时间表
                [self.updateTimeLabel setText:[NSString stringWithFormat:@"%@",self.weatherDict[@"sk"][@"time"]]];
                //风速赋值
                [self.weatherSpeedLabel setText:[NSString stringWithFormat:@"%@",self.weatherDict[@"sk"][@"wind_strength"]]];
                //空气湿度赋值
                [self.humidityLabel setText:[NSString stringWithFormat:@"%@",self.weatherDict[@"sk"][@"humidity"]]];
                
                
            }else{
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
#pragma mark - 将定位城市作为上下文传递
-(id)contextForSegueWithIdentifier:(NSString *)segueIdentifier
{
    if([segueIdentifier isEqualToString:@"FutureWeather"])
    {
        return self.locCity;
    }
    else
    {
        return nil;
    }
}
@end



