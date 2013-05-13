//
//  FavouriteConcerts.h
//  ConcertFinder
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This model contains the list of favorite concerts which are added by the user
 */
@interface FavouriteConcerts : NSObject <NSCoding>

@property (nonatomic,copy) NSMutableArray *favouriteConcerts;
@end
