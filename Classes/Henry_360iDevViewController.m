//
//  Henry_360iDevViewController.m
//  Henry-360iDev
//
//  Created by Henry Balanon on 11/8/10.
//  Copyright 2010 Bickbot.com. All rights reserved.
//

#import "Henry_360iDevViewController.h"
#import "Reachability+Extensions.h"

@implementation Henry_360iDevViewController



/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	if ([Reachability isNetworkReachableToUrl:@"http://foursquare.com"]) {
		NSLog(@"yes");
	}
	
	else {
		NSLog(@"no");
		
		emptyView = [[TKEmptyView alloc] initWithFrame:self.view.bounds 
										emptyViewImage:TKEmptyViewImageKey
												 title:@"No Internet"
											  subtitle:@"I can't find foursquare.com.  HALP!"];
		emptyView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		[self.view addSubview:emptyView];
	}
	
	
	
    [super viewDidLoad];
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[emptyView release];
    [super dealloc];
}

@end
