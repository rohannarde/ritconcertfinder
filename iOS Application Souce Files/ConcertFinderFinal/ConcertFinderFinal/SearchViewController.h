//
//  SearchViewController.h
//  Milestone 5
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XMLParser.h"
#import "ConcertDetailViewController.h"

/**
 This interface contains the result parsed by the XMLParser class.
 It implements the following delegates
 UISearchBarDelegate - for the search bar
 UITableViewDelegate - for the table view
 UITableViewDataSource - for the table view
 XMLParserDelegate - for passing the concert results array
 */
@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,UIApplicationDelegate,XMLParserDelegate>
{
    ConcertDetailViewController *_concertDetail;
    XMLParser *_parser;
}

@property (nonatomic) int concertIndexNumber;
@property (nonatomic, retain) NSMutableArray *concertResults;
@property(retain) NSMutableArray *tableData;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, copy) NSString *artistToBeSearched;

@end
