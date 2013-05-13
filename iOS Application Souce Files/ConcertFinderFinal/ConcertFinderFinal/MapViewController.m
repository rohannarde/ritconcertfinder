//
//  MapViewController.m
//  ConcertFinder
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"
#import "ConcertDetailViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize concertMapView;
@synthesize concertAddress;
@synthesize theTableView;
@synthesize favoriteConcerts;
@synthesize concertName;
@synthesize artistName;
@synthesize currentPlaceMark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tabBarItem = [self tabBarItem];
        [tabBarItem setTitle:@"Map View"];
        tabBarItem.image = [UIImage imageNamed:@"MapIcon.png"];
        favoriteConcerts = [[NSMutableArray alloc] init];
        concertAddress = [[NSMutableString alloc] init];
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    self.title = @"Favorite Concerts";
    
    [self.theTableView registerNib:[UINib nibWithNibName:@"FavoriteCell" bundle:nil]
            forCellReuseIdentifier:@"FavoriteCell"];
    if(concertAddress.length > 0) {
        [self geoLocationMapView:concertAddress];
    }
    
 
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

/**
 This generates the placemarks for the location address passed.
 @param address - the address whose placemarks are to be generated
 @return none
 */
- (void)geoLocationMapView:(NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"geocodeAddressString:completionHandler: Completion Handler called!");
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

- (void)displayPlacemarks:(NSArray *)placemarks
{
    
    //Placemark
    CLPlacemark *placeMark = [placemarks objectAtIndex:0];
    currentPlaceMark = placeMark;
    
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
    [concertMapView setRegion:concertRegion animated:YES];
    
    //Annotation
    
    //Coordinate
    CLLocationCoordinate2D concertLocation;
    concertLocation.latitude = concertCenter.latitude;
    concertLocation.longitude = concertCenter.longitude;
    
    Annotation *concertAnnotaion = [Annotation alloc];
    concertAnnotaion.coordinate = concertLocation;
    concertAnnotaion.title = [concertName copy];
    concertAnnotaion.subtitle = [artistName copy];
    
    [self.concertMapView addAnnotation:concertAnnotaion];
    
    
    dispatch_async(dispatch_get_main_queue(),^ {

    });
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

-(void)viewDidAppear:(BOOL)animated
{
    
    [self.theTableView reloadData];
    
}

- (void)viewDidUnload
{
    [self setConcertMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [favoriteConcerts removeObjectAtIndex:indexPath.row];
    }
    [theTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [favoriteConcerts count];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
   ConcertDetailViewController *concertDetail = [[ConcertDetailViewController alloc] initWithNibName:@"ConcertDetailViewController" bundle:nil];
    concertDetail.selectedConcert = [favoriteConcerts objectAtIndex:indexPath.row];
    concertDetail.searchType = NO;
    
    [self.navigationController pushViewController:concertDetail animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavoriteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //NSLog(@"Favourite %d",favoriteConcerts.count);
    cell.textLabel.text = [[favoriteConcerts objectAtIndex:indexPath.row] objectForKey:@"artist_name"];
    cell.detailTextLabel.text = [[favoriteConcerts objectAtIndex:indexPath.row] objectForKey:@"venue_name"];
    
    // Configure the cell...
    
    //contents of the cell
//    switch (indexPath.section) {
//        case 0:{
//            // cell.textLabel.text = [[self.concertArray objectAtIndex:indexPath.row] objectForKey:@"artist_name"];
//            cell.textLabel.text = [[concertResults objectAtIndex:indexPath.row] objectForKey:@"artist_name"];
//            cell.detailTextLabel.text = [[concertResults objectAtIndex:indexPath.row] objectForKey:@"venue_name"];
//            break;
//        }
//            
//            
//        case 1:
//            cell.textLabel.text = @"LinkinPark Concert";
//            break;
//            
//        default:
//            break;
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // These are the hard coded locations for the two favorite locations
        [concertAddress setString:@""];
        concertName = [[favoriteConcerts objectAtIndex:indexPath.row] objectForKey:@"venue_name"];
        artistName = [[favoriteConcerts objectAtIndex:indexPath.row] objectForKey:@"artist_name"];
    
        [concertAddress appendString:[[favoriteConcerts objectAtIndex:indexPath.row] objectForKey:@"venue_name"]];
    
        [concertAddress appendString:@" "];
        [concertAddress appendString:[[favoriteConcerts objectAtIndex:indexPath.row] objectForKey:@"venue_city"]];
        [concertAddress appendString:@" "];
        [concertAddress appendString:[[favoriteConcerts objectAtIndex:indexPath.row] objectForKey:@"venue_state"]];
        [concertAddress appendString:@" "];
        [concertAddress appendString:[[favoriteConcerts objectAtIndex:indexPath.row] objectForKey:@"venue_zip"]];
    
        [self geoLocationMapView:concertAddress];
        
}

- (IBAction)viewInGoogleMaps:(id)sender {


    NSString *locationLoader = [NSString stringWithFormat:@"%f,%f",
                                currentPlaceMark.location.coordinate.latitude,
                                currentPlaceMark.location.coordinate.longitude];
    locationLoader = [locationLoader stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?ll=%@",locationLoader];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    



}
@end
