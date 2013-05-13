//
//  ConcertMapView.m
//  ConcertFinder
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import "ConcertMapView.h"
#import "Annotation.h"

@interface ConcertMapView ()

@end

@implementation ConcertMapView
@synthesize mapView;
@synthesize concertAddress;
@synthesize concertName;
@synthesize artistName;
@synthesize placeMark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 This function is used to set the address from the previous view.
 @param address - the address to be displayed in maps
 @return none
 */
- (void)feedAddress:(NSString *)address{
    
    concertAddress = address;
    
}

/**
 This generates the placemarks for the location address passed.
 @param address - the address whose placemarks are to be generated
 @return none
 */
- (void)geoLocationMapView:(NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            //NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        
        //NSLog(@"Received placemarks: %@", placemarks);
        [self displayPlacemarks:placemarks];
    }];
    
}
// display a given NSError in an UIAlertView
- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {
        
        NSString *message;
        switch ([error code])
        {
            case kCLErrorGeocodeFoundNoResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled:
                message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult:
                message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default:
                message = [error description];
                break;
        }
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
    });
}

- (IBAction)viewInMapsButton:(id)sender {
    
    
    NSString *locationLoader = [NSString stringWithFormat:@"%f,%f",
                    placeMark.location.coordinate.latitude,
                    placeMark.location.coordinate.longitude];
    locationLoader = [locationLoader stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?ll=%@",locationLoader];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    

}

- (void)displayPlacemarks:(NSArray *)placemarks
{
    
    //Placemark
    placeMark = [placemarks objectAtIndex:0];
    
    //Concert Region for Map
    MKCoordinateRegion concertRegion;
    
    //Center for Map Region
    CLLocationCoordinate2D concertCenter;
    
    concertCenter.longitude = placeMark.location.coordinate.longitude;
    concertCenter.latitude = placeMark.location.coordinate.latitude;
    
    //Span for the Map
    MKCoordinateSpan concertSpan;
    concertSpan.latitudeDelta = 0.003f;
    concertSpan.longitudeDelta = 0.003f;
    
    //Setting the View Map
    concertRegion.center = concertCenter;
    concertRegion.span = concertSpan;
    
    //Set our map View
    [mapView setRegion:concertRegion animated:YES];
    
    //Annotation
    
    //Coordinate
    CLLocationCoordinate2D concertLocation;
    concertLocation.latitude = concertCenter.latitude;
    concertLocation.longitude = concertCenter.longitude;
    
    Annotation *concertAnnotaion = [Annotation alloc];
    concertAnnotaion.coordinate = concertLocation;
    concertAnnotaion.title = concertName;
    concertAnnotaion.subtitle = artistName;
    
    [mapView addAnnotation:concertAnnotaion];
    
    
    dispatch_async(dispatch_get_main_queue(),^ {
        
        //CLPlacemark *place = [placemarks objectAtIndex:0];
        //NSLog(@"%f",place.location.coordinate.longitude);
        
    });
}

- (void)viewDidLoad
{
    
    [self geoLocationMapView:concertAddress];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
