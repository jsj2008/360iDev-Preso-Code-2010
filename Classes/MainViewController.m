//
//  MainViewController.m
//  Henry-360iDev
//
//  Created by Henry Balanon on 11/9/10.
//  Copyright 2010 Bickbot.com. All rights reserved.
//

#import "MainViewController.h"
#import "Reachability+Extensions.h"

@implementation MainViewController

@synthesize venuesController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(IBAction)buttonPressed {
	venuesController = [[NearbyVenuesController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:venuesController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	

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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"black-on-blue-iphone-wallpapers.png"]];

	
	

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[venuesController dealloc];
    [super dealloc];
}


@end
