//
//  MapViewController.h
//  ConcertFinder
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

/**
 This class displays the view when the user clicks on the Map tab on the main app screen
 */
@interface MapViewController : UIViewController <CLLocationManagerDelegate>


@property (nonatomic,copy) NSMutableString *concertAddress;
@property (weak, nonatomic) IBOutlet MKMapView *concertMapView;
@property (nonatomic) NSMutableArray *favoriteConcerts;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic,copy)NSString *concertName;
@property (nonatomic,copy)NSString *artistName;
@property (nonatomic) CLPlacemark *currentPlaceMark;

/**
 This function loads the google maps for the concert location
 @param: id -the button pressed.
 @return: IBAction
 */
- (IBAction)viewInGoogleMaps:(id)sender;


/**
 This class finds and displays all the placemarks of the location requested
 @param placemarks - array containing the placemark of locations
 @return none
 */
- (void)displayPlacemarks:(NSArray *)placemarks;

/**
 This class displays error incase the location is not found
 @param error - the standard error
 @return none
 */
- (void)displayError:(NSError*)error;

@end
