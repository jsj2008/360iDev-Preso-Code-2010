//
//  Henry_360iDevAppDelegate.h
//  Henry-360iDev
//
//  Created by Henry Balanon on 11/8/10.
//  Copyright 2010 Bickbot.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"

@class Henry_360iDevViewController;

@interface Henry_360iDevAppDelegate : AppDelegate_Shared {
    //UIWindow *window;
    Henry_360iDevViewController *viewController;
	UINavigationController *navigationController;
}

//@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet Henry_360iDevViewController *viewController;

@end

