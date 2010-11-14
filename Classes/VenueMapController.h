#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Venue.h"


@interface VenueMapController : UIViewController {
  MKMapView *mapView;
  Venue *venue;
}

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) Venue *venue;

@end
