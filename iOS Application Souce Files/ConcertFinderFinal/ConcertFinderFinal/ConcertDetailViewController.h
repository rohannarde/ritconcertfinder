//
//  ConcertDetail.h
//  ConcertFinder
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ConcertMapView.h"


/**
 This interface contains the view when the user clicks on any concert result
 */
@interface ConcertDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
   ConcertMapView *_mapView;
    MapViewController *_tabBarMapView;
    
}

/**
 This function will display the concert location on a map
 @param id
 @return IBAction
 */
-(IBAction)goToMap:(id)sender;

/**
 This function will add the concert as an favorite to the map view
 @param id
 @return IBAction
 */
-(IBAction)addToFavorites:(id)sender;

@property (nonatomic) NSMutableDictionary *selectedConcert;
@property (nonatomic,copy) NSMutableString *concertAddress;
@property (nonatomic,copy) NSString *venueName;
@property (nonatomic,copy) NSString *venueCity;
@property (nonatomic,copy) NSString *venueState;
@property (nonatomic,copy) NSString *venueZip;
@property (nonatomic) BOOL searchType;

@end
