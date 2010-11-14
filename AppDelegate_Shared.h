#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "TBXML.h"

@protocol FoursquareDataLoadDelegate <NSObject>

- (void)didFinishLoadingDataFromFoursquare;

@end


@interface AppDelegate_Shared : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    
  NSManagedObjectModel *managedObjectModel;
  NSManagedObjectContext *managedObjectContext;	    
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
  
  UIWindow *window;

  CLLocationManager *locationManager;
  NSMutableData *receivedNetworkData;
  
  id<FoursquareDataLoadDelegate> foursquareDelegate;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, readonly) CLLocationManager *locationManager;

@property (nonatomic, assign) id<FoursquareDataLoadDelegate> foursquareDelegate;

- (NSString *)applicationDocumentsDirectory;
- (void)reloadVenueData;

@end

