#import "Venue.h"

@implementation Venue 

@dynamic lattitude;
@dynamic longitude;
@dynamic name;

- (CLLocationCoordinate2D)coordinate {
  CLLocationCoordinate2D coordinate;
  coordinate.latitude = [self.lattitude doubleValue];
  coordinate.longitude = [self.longitude doubleValue];
  return coordinate;
}

- (NSString *)title {
  return self.name ;
}

@end
