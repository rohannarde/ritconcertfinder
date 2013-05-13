//
//  IpodLibraryViewController.h
//  ConcertFinder
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

/**
 This interface contains the list of artists synchronized from the iPod Library
 */
@interface IpodLibraryViewController : UITableViewController

@property (nonatomic) NSMutableArray *artistNames;
@property (nonatomic) NSMutableArray *sortedArtistListArray;

@end
