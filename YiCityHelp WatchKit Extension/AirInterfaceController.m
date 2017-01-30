//
//  AirInterfaceController.m
//  YiCityHelp
//
//  Created by Developer_Yi on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "AirInterfaceController.h"

@interface AirInterfaceController ()<CLLocationManagerDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *updateTimeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *cityLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *AQILabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *airQualityLabel;
//定位服务管理器
@property (nonatomic,strong)CLLocationManager *manager;
//定位城市
@property (nonatomic,copy)NSString *locCity;
@property (nonatomic,strong)NSArray *airArr;
@end

@implementation AirInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.locCity=context;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getAirData];
    });
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
#pragma mark - 网络获取空气数据
- (void)getAirData
{
    NSURLSession *session=[NSURLSession sharedSession];
    NSString *urlStr=[NSString stringWithFormat:@"http://web.juhe.cn:8080/environment/air/cityair?city=%@&key=42e9f1896e979879fd00c081642b590f",self.locCity];
    //避免中文问题
    NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:urlStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *airArr=dict[@"result"];
        if(airArr.count>0)
        {
            self.airArr=airArr;
           
            if([dict[@"resultcode"] isEqual:@"200"])
            {
                
                //城市赋值
                [self.cityLabel setText:[NSString stringWithFormat:@"%@",self.airArr[0][@"citynow"][@"city"]]];
                //AQI赋值
                [self.AQILabel setText:[NSString stringWithFormat:@"%@",self.airArr[0][@"citynow"][@"AQI"]]];
                //更新时间表
                [self.updateTimeLabel setText:[NSString stringWithFormat:@"%@",self.airArr[0][@"citynow"][@"date"]]];
                //空气质量赋值
                [self.airQualityLabel setText:[NSString stringWithFormat:@"%@",self.airArr[0][@"citynow"][@"quality"]]];
              
                
            }else{
                WKAlertAction *action=[WKAlertAction actionWithTitle:@"好的" style:WKAlertActionStyleDefault handler:^{
                    
                }];
                NSString *error=[NSString stringWithFormat:@"错误代码：%@",dict[@"reason"]];
                [self presentAlertControllerWithTitle:@"抱歉" message:error preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
            }
        }
        else
        {
            WKAlertAction *action=[WKAlertAction actionWithTitle:@"好的" style:WKAlertActionStyleDefault handler:^{
                
            }];
            [self presentAlertControllerWithTitle:@"抱歉" message:@"连接出错" preferredStyle:WKAlertControllerStyleAlert actions:@[action]];
        }
    }];
    //一定要加上这句，否则任务无法执行
    [dataTask resume];
    
}

@end



