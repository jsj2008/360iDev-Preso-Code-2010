//
//  Reachability+Extensions.m
//  Mango Languages-Henry
//
//  Created by Henry Balanon on 9/5/10.
//  Copyright 2010 Bickbot.com. All rights reserved.
//

#import "Reachability+Extensions.h"


@implementation Reachability (Extensions)

+ (BOOL)isNetworkReachableViaWWAN
{
	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);	
}

+ (BOOL)isNetworkReachableViaWifi
{
	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi);	
}

+ (BOOL)isNetworkReachable
{
	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);	
}

+ (BOOL)isNetworkReachableToUrl:(NSString*)url
{
	BOOL reachableViaWwan = [self isNetworkReachableViaWWAN];
	BOOL reachableViaWifi = [self isNetworkReachableViaWifi];
	BOOL isReachable = ([[Reachability reachabilityWithHostName:url] currentReachabilityStatus] != NotReachable);
	
	return reachableViaWwan || reachableViaWifi || isReachable;	
}

@end
