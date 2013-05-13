//
//  ConcertMapView.h
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
 This class displays the view when the user clicks on the mapView bar button in the ConcertDetailViewController screen.
 */
@interface ConcertMapView : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,copy) NSString *concertAddress;
@property (nonatomic,copy) NSString *artistName;
@property (nonatomic,copy) NSString *concertName;
@property (nonatomic) CLPlacemark *placeMark;

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

/**
 This class displays the concert location on google maps
 @param id
 @return IBAction - the view changes to googlemaps so that the user can get directions if requred.
 */
- (IBAction)viewInMapsButton:(id)sender;

@end
