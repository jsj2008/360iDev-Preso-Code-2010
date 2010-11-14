#import "VenueMapController.h"

@implementation VenueMapController

@synthesize venue;
@synthesize mapView;  

- (void)viewDidAppear:(BOOL)animated {
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.venue.coordinate, 500., 500.);  
  [self.mapView setRegion:region];
   [self.mapView addAnnotation:self.venue];
}

- (void)dealloc {
  self.mapView = nil;
  [super dealloc];
}


@end
