//
//  XgFlutterPlugin.h
//  XgFlutterPlugin
//
//  Created by rockzuo on 2019/12/3.
//  Copyright © 2019 XG of Tencent. All rights reserved.
//

#import <Flutter/Flutter.h>

/**
@brief TPNS Flutter Plugin
*/
@interface XgFlutterPlugin : NSObject<FlutterPlugin>

// channel调用iOS API
@property FlutterMethodChannel *channel;

@end
