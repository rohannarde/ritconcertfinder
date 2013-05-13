//
//  XMLParser.h
//  Milestone 5
//
//  Created by
//  Rohan Narde - rsn5770@rit.edu
//  Amit Shroff - aas6521@rit.edu
//
//  Copyright (c) 2012 Rohan Narde. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMLParser;

/**
 This is the delegate method which is used to initialize the concert results
 array
 */
@protocol XMLParserDelegate <NSObject>
/**
 Delegate Method
 @param concertResultArray the array which contains all results
 @return none
 */
-(void)didLoadFeed:(NSMutableArray *) concertResultsArray;

@end

@interface XMLParser : NSObject<NSXMLParserDelegate> {
    
    NSString *_urlAPI;
    NSMutableData *_responseData;
    NSURLConnection *_urlAPIConnection;
    
    //For the XML Parser
    NSXMLParser *_xmlParser;
    NSMutableArray *_itemArray;
    
    IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic, weak) id <XMLParserDelegate> delegate;

@property (nonatomic) NSString *currentElementValue;
@property (nonatomic) NSMutableDictionary *currentItemDict;
@property (nonatomic) NSMutableString *artistName;
@property (nonatomic) NSMutableString *venueName;
@property (nonatomic) NSMutableString *venueCity;
@property (nonatomic) NSMutableString *venueState;
@property (nonatomic) NSMutableString *venueZip;
@property (nonatomic) NSMutableString *eventUrl;
@property (nonatomic) NSMutableString *eventDate;
@property (nonatomic) NSMutableString *ticketUrl;

/**
 This is used to initialize the parser with the webservice url
 @param urlAPIConnection the url which contains the request by the user
 @return XMParser *
 */
- (XMLParser *) initXMLParserWithUrlConnection:(NSString *)urlAPIConnection;

/**
 This parses the xml file and loads it into the itemArray.
 @param none
 @return none
 */
- (void)loadDataFromAPI;

@end
