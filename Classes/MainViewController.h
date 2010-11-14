//
//  MainViewController.h
//  Henry-360iDev
//
//  Created by Henry Balanon on 11/9/10.
//  Copyright 2010 Bickbot.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapkuLibrary/TapkuLibrary.h"
#import "NearbyVenuesController.h"


@interface MainViewController : UIViewController {
	TKEmptyView *emptyView;
	NearbyVenuesController *venuesController;
}

@property (nonatomic,retain) NearbyVenuesController *venuesController;

-(IBAction)buttonPressed;


@end
