#import "NearbyVenuesController.h"
#import "Venue.h"
#import "VenueMapController.h"

@implementation NearbyVenuesController


- (void)dealloc {
  [fetchedResultsController release], fetchedResultsController = nil;
  [super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Nearby Venues";
  NSError *error;
  if(![self.fetchedResultsController performFetch:&error]) {
    NSLog(@"NSFetchedResultsController was unable to do the initial fetch: %@", [error localizedDescription]);
  }
  Henry_360iDevAppDelegate *appDelegate = (Henry_360iDevAppDelegate *)[[UIApplication sharedApplication] delegate];
  appDelegate.foursquareDelegate = self;
	

  [appDelegate reloadVenueData];  
}


- (void)didFinishLoadingDataFromFoursquare {
  [self.fetchedResultsController performFetch:nil];
  [self.tableView reloadData];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
  if (fetchedResultsController != nil) {
    return fetchedResultsController;
  }
  
  NSManagedObjectContext *managedObjectContext = [(Henry_360iDevAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Venue" inManagedObjectContext:managedObjectContext];
  [fetchRequest setEntity:entity];
  
  [fetchRequest setFetchBatchSize:20];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
  fetchedResultsController.delegate = self;
  
  [fetchRequest release];
  [sortDescriptor release];
  [sortDescriptors release];
  
  return fetchedResultsController;
}    

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSInteger count = [[self.fetchedResultsController sections] count];
  return count == 0 ? 1 : count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *sections = [self.fetchedResultsController sections];
  NSUInteger count = 0;
  if ([sections count]) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    count = [sectionInfo numberOfObjects];
  }
  return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  Venue *venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = venue.name;
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", venue.lattitude, venue.longitude];
  
  return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  VenueMapController *mapController = [[VenueMapController alloc] initWithNibName:nil bundle:nil];
  [self.navigationController pushViewController:mapController animated:YES];
  
  mapController.venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [mapController release];
}

@end

