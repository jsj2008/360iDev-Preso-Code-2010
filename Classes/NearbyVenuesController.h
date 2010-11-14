#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Henry_360iDevAppDelegate.h"


@interface NearbyVenuesController : UITableViewController <NSFetchedResultsControllerDelegate, FoursquareDataLoadDelegate> {
  NSFetchedResultsController *fetchedResultsController;
}

@property (readonly) NSFetchedResultsController *fetchedResultsController;

@end
