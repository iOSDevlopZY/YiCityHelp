//
//  TableRowController.h
//  YiCityHelp
//
//  Created by Developer_Yi on 2016/12/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>
@interface TableRowController : NSObject

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *weekLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *weatherLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *tempLabel;



@end
