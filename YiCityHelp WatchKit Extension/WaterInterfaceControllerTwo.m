//
//  WaterInterfaceControllerTwo.m
//  YiCityHelp
//
//  Created by Developer_Yi on 2016/12/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "WaterInterfaceControllerTwo.h"

@interface WaterInterfaceControllerTwo ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *updateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *oxygenLabel;
//PH标签表
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *oxygenWaterLabel;
@property (nonatomic,strong)NSArray *riverArr;
@end

@implementation WaterInterfaceControllerTwo

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    //获取数据
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getRiverData];
    });

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if(self.riverArr.count>0)
    {
    //溶解氧赋值
    [self.oxygenLabel setText:[NSString stringWithFormat:@"%@",self.riverArr[0][@"山东济南泺口"][@"oxygen"]]];
    //溶解氧水质赋值
    [self.oxygenWaterLabel setText:[NSString stringWithFormat:@"%@",self.riverArr[0][@"山东济南泺口"][@"oxygenquality"]]];
    //更新时间表
    [self.updateLabel setText:[NSString stringWithFormat:@"%@",self.riverArr[0][@"山东济南泺口"][@"date"]]];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
#pragma mark - 网络获取河流数据
- (void)getRiverData
{
    NSURLSession *session=[NSURLSession sharedSession];
    NSString *urlStr=[NSString stringWithFormat:@"http://web.juhe.cn:8080/environment/water/river?river=%@&key=8561731ffcb78be580514307ab85370f",@"黄河流域"];
    //避免中文问题
    NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:urlStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *riverArr=dict[@"result"];
        
        
        if(dict.count>0)
        {
            self.riverArr=riverArr;
            if([dict[@"resultcode"] isEqual:@"200"])
            {
                
                
                
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



