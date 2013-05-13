//
//  ConcertDetail.m
//  ConcertFinder
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import "ConcertDetailViewController.h"

@implementation ConcertDetailViewController

@synthesize venueCity;
@synthesize venueName;
@synthesize venueState;
@synthesize venueZip;
@synthesize concertAddress;
@synthesize selectedConcert;
@synthesize searchType;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if(self){
    
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if(searchType){
        
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"MapView" style:UIBarButtonSystemItemAction target:self action:@selector(goToMap:)];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:(@"AddFavorite") style:UIBarButtonItemStyleBordered target:self action:@selector(addToFavorites:)];
    
    self.navigationItem.rightBarButtonItems = @[addBarButtonItem,sendButton];
    
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    }
    //Creates the address so that the mapView can display it.
    concertAddress = [[NSMutableString alloc]init];
    venueName = [selectedConcert objectForKey:@"venue_name"];
    venueCity = [selectedConcert objectForKey:@"venue_city"];
    venueState = [selectedConcert objectForKey:@"venue_state"];
    venueZip = [selectedConcert objectForKey:@"venue_zip"];
    
    [concertAddress appendString:venueName];
    [concertAddress appendString:@" "];
    [concertAddress appendString:venueCity];
    [concertAddress appendString:@" "];
    [concertAddress appendString:venueState];
    [concertAddress appendString:@" "];
    [concertAddress appendString:venueZip];
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
 
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Personalize the cell
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text= [selectedConcert objectForKey:@"artist_name"];
            break;
        }
        case 1:{
            cell.textLabel.text = [selectedConcert objectForKey:@"event_date"];
            
            break;
        }
        case 2:{
        
            cell.textLabel.text = venueName;
        
            break;
        }
        case 3:{
      
            cell.textLabel.text = venueCity;
            
            break;
        }
        case 4:{
            
            cell.textLabel.text = venueState;
            
            break;
        }
        case 5:{
            cell.textLabel.text = [selectedConcert objectForKey:@"event_url"];
        }
            break;
            
        case 6:{
            if ([selectedConcert objectForKey:@"ticket_url"]) {
                cell.textLabel.text = @"NA";
            }
            else{
                cell.textLabel.text = [selectedConcert objectForKey:@"ticket_url"];
                NSString *ticket_url = [selectedConcert objectForKey:@"ticket_url"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ticket_url]];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


//Title of each section
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    switch (section) {
        case 0:
            title = @"Artist name";
            break;
            
        case 1:
            title = @"Event date";
            break;
            
        case 2:
            title = @"Event venue";
            break;
            
        case 3:
            title = @"Event city";
            break;
            
        case 4:
            title = @"Event state";
            break;
            
        case 5:
            title = @"Event url";
            break;
            
        case 6:
            title = @"Ticket url";
            break;
            
        default:
            break;
    }
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
        NSString *url = [selectedConcert objectForKey:@"event_url"];
        
        NSString *parsedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:parsedUrl]];
    }
    
    if (indexPath.section == 6) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[selectedConcert objectForKey:@"ticket_url"]]];
    }
}

-(IBAction)goToMap:(id)sender
{
    _mapView = [[ConcertMapView alloc]initWithNibName:@"ConcertMapView" bundle:nil];
    _mapView.concertName = venueName;
    _mapView.artistName = [selectedConcert objectForKey:@"artist_name"];
    
    _mapView.concertAddress = concertAddress;
    [self.navigationController pushViewController:_mapView animated:YES];
    
}

-(IBAction)addToFavorites:(id)sender
{
    NSArray *getTabViewController = self.tabBarController.viewControllers;
    
    UINavigationController *t = [getTabViewController objectAtIndex:2];
    
    getTabViewController = t.viewControllers;
    _tabBarMapView = [getTabViewController objectAtIndex:0];
    
    [_tabBarMapView.favoriteConcerts addObject:selectedConcert];
    self.tabBarController.selectedIndex = 2;

}

@end
