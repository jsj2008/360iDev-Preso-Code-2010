#import "AppDelegate_Shared.h"
#import "Venue.h"
#import "NSManagedObjectContext-EasyFetch.h"
#import "ASIHTTPRequest.h"

@implementation AppDelegate_Shared

@synthesize window;
@synthesize foursquareDelegate;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	
	[locationManager release];
	[receivedNetworkData release];
	
	[window release];
	[super dealloc];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 
 Conditionalize for the current platform, or override in the platform-specific subclass if appropriate.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}

#pragma mark -
#pragma mark Core Location

- (void)reloadVenueData {
	[self.locationManager startUpdatingLocation];
}

- (CLLocationManager *)locationManager {
	if(!locationManager) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
	}
	return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[self.locationManager stopUpdatingLocation];
	
	
	CLLocationDegrees latitude = newLocation.coordinate.latitude;
	CLLocationDegrees longitude = newLocation.coordinate.longitude;
	
	
	NSString *urlString = [NSString stringWithFormat:@"http://api.foursquare.com/v1/venues?geolat=%f&geolong=%f&l=50", 
						   latitude, 
						   longitude];
	
	

	NSURL *url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
	

	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Location Manager Error: %@", [error localizedDescription]);
	
}

#pragma mark -
#pragma mark processFoursquareXMLResponse

- (void) processFoursquareData: (NSString *) xmlString  {
	
	TBXML * tbxml = [[TBXML tbxmlWithXMLString:xmlString] retain];
	
	TBXMLElement * rootXMLElement = tbxml.rootXMLElement;
	
	TBXMLElement * groupXMLElement = [TBXML childElementNamed:@"group" parentElement:rootXMLElement];
	TBXMLElement * venueXMLElement = [TBXML childElementNamed:@"venue" parentElement:groupXMLElement];
	
	while (venueXMLElement) {
		
		TBXMLElement * nameXMLElement = [TBXML childElementNamed:@"name" parentElement:venueXMLElement];
		
		TBXMLElement * geolatXMLElement = [TBXML childElementNamed:@"geolat" parentElement:venueXMLElement];
		
		TBXMLElement * geolongXMLElement = [TBXML childElementNamed:@"geolong" parentElement:venueXMLElement];
		
		NSString* name = [TBXML textForElement:nameXMLElement];
		NSNumber* geolatNumber = [NSNumber numberWithFloat:[[TBXML textForElement:geolatXMLElement] floatValue]];
		NSNumber* geolongNumber = [NSNumber numberWithFloat:[[TBXML textForElement:geolongXMLElement] floatValue]];
		
		
		
		NSUInteger count = [managedObjectContext countFetchObjectsForEntityName:@"Venue" predicateWithFormat:@"name = %@", name];
		
		if(!count) {
			Venue *venue = [NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:self.managedObjectContext];
			venue.name = name;
			venue.lattitude = geolatNumber;
			venue.longitude = geolongNumber;
			NSLog(@"%@", venue);
		}
		
		
		// find the next sibling element named "course"
		venueXMLElement = [TBXML nextSiblingNamed:@"venue" searchFromElement:venueXMLElement];
	}
	
	NSError *error;
	if(![self.managedObjectContext save:&error]) {
		NSLog(@"Error saving MOC: %@", [error localizedDescription]);
	}
	if(self.foursquareDelegate) {
		if ([self.foursquareDelegate respondsToSelector:@selector(didFinishLoadingDataFromFoursquare)]) {
			[self.foursquareDelegate didFinishLoadingDataFromFoursquare];
		}
	}
	
	[tbxml release];
	
}

#pragma mark -
#pragma mark ASIHTTPRequest 


- (void)requestFinished:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	// Use when fetching text data
	NSString *responseString = [request responseString];
	
	[self processFoursquareData:responseString];
	
	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Connection Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alertView show];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
}

 


#pragma mark -
#pragma mark NSURLConnection stuff





#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 
 Conditionalize for the current platform, or override in the platform-specific subclass if appropriate.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Foursquared.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end

