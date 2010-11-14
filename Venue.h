#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface Venue :  NSManagedObject <MKAnnotation>
{
}

@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;

@end



