//
//  Reachability+Extensions.h
//  Mango Languages-Henry
//
//  Created by Henry Balanon on 9/5/10.
//  Copyright 2010 Bickbot.com. All rights reserved.
//

#import "Reachability.h"

@interface Reachability (Extensions)

+ (BOOL)isNetworkReachableViaWWAN;
+ (BOOL)isNetworkReachable;
+ (BOOL)isNetworkReachableToUrl:(NSString*)url;
+ (BOOL)isNetworkReachableViaWifi;

@end
