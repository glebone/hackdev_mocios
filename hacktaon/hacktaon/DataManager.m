//
//  DataManager.m
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

#import "GData.h"
#import "GDataFeedPhotoAlbum.h"
#import "GDataFeedPhoto.h"
//
#import "GDataServiceGooglePhotos.h"
#import "GDataEntryPhotoAlbum.h"
#import "GDataEntryPhoto.h"

#import "Constants.h"


static DataManager *_sharedManager = nil;

@interface DataManager()
{
    GDataServiceGooglePhotos *_service;
    GDataFeedPhotoUser                  *_albumsFeed;
    GDataFeedPhotoAlbum                 *_photosFeed;
    NSMutableDictionary                 *_thumbnailDictionary;
}

@end


@implementation DataManager
@synthesize service = _service;
@synthesize albumsFeed = _albumsFeed;
@synthesize photosFeed = _photosFeed;

+ (DataManager *)sharedManager
{
    if (_sharedManager == nil) {
        _sharedManager = [[DataManager alloc] init];
    }
    return _sharedManager;
}
-(id)init
{
    self = [super init];
    if (self) {
        self.service = [[GDataServiceGooglePhotos alloc] init];
        self.service.shouldCacheResponseData = YES;
        _thumbnailDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)dealloc
{
    [_service release];
    [_albumsFeed release];
    [_photosFeed release];
    [_thumbnailDictionary release];
    [super dealloc];
}

- (void)setUserName:(NSString *)uName andPassword:(NSString *)pass
{
    [_service setUserCredentialsWithUsername:uName password:pass];
}
- (void)getAlbumList
{
    [self setAlbumsFeed:nil];
    
    GDataServiceTicket *ticket;
    NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:_service.username
                                                             albumID:nil
                                                           albumName:nil
                                                             photoID:nil
                                                                kind:nil
                                                              access:nil];
    ticket = [_service fetchFeedWithURL:feedURL
                              delegate:self
                     didFinishSelector:@selector(albumListFetchTicket:finishedWithFeed:error:)];
}
- (void)albumListFetchTicket:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedPhotoUser *)feed
                       error:(NSError *)error {
    if (error == nil) {  
        NSArray *entries = [feed entries];
        [self setAlbumsFeed:feed];
        [self getThumbnails];
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NOTIFICATION_FETCH_ALBUM_LIST_SUCCESS object:[NSDictionary dictionaryWithObject:_albumsFeed forKey:ALBUMS_KEY]]];
        
        NSLog(@"entries %i", [entries count]);
        if ([entries count] > 0) {
            
            for (int i = 0; i < [entries count]; i++) {
                GDataEntryPhotoAlbum *firstCalendar = [entries objectAtIndex:i];
                GDataTextConstruct *titleTextConstruct = [firstCalendar title];
                NSString *title = [titleTextConstruct stringValue];
                
                NSLog(@"title: %@ photosUsed:%@", title , [[firstCalendar photosUsed] stringValue]);
            }
        } else {
            NSLog(@"No Albums");
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NOTIFICATION_REQUEST_ERROR object:[NSDictionary dictionaryWithObject:error forKey:ERROR_KEY]]];
    }
}

- (void)getPhotosFromAlbumAtIndex:(int)index {
    
    NSArray *albums = [_albumsFeed entries];
    if (!([albums count] > 0 && index > -1)) return;
    GDataEntryPhotoAlbum *album = [albums objectAtIndex:index];
    if (album) {
        NSURL *feedURL = [[album feedLink] URL];
        if (feedURL) {
            [self setPhotosFeed:nil];

            GDataServiceTicket *ticket;
            ticket = [_service fetchFeedWithURL:feedURL
                                      delegate:self
                             didFinishSelector:@selector(photosTicket:finishedWithFeed:error:)];
        }
    }
}

- (void)photosTicket:(GDataServiceTicket *)ticket
    finishedWithFeed:(GDataFeedPhotoAlbum *)feed
               error:(NSError *)error {
    if (error == nil) {  
        NSArray *entries = [feed entries];
        [self setPhotosFeed:feed];
        
        NSLog(@"LINKS: \n %@", [self photoLinks]);
         [[NSNotificationCenter defaultCenter] postNotificationName:@"GlinksExtracted" object:self];        
        if ([entries count] > 0) {

        } else {
            NSLog(@"No Photos");
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NOTIFICATION_REQUEST_ERROR object:[NSDictionary dictionaryWithObject:error forKey:ERROR_KEY]]];    
    }
}

- (NSMutableArray *)photoLinks
{
    NSMutableArray *links = [NSMutableArray array];
    NSArray *photos = [_photosFeed entries];
    int photosCount = [photos count];
    for (int i = 0; i < photosCount; i++) {
        GDataEntryPhoto *photo = [photos objectAtIndex:i];
        GDataEntryContent *c = [photo content];
        [links addObject:c.sourceURL];
    }
    return links;
}

#pragma mark thumbnails downloader
- (void)getThumbnails
{
    [_thumbnailDictionary removeAllObjects];
    NSArray *albums = [_albumsFeed entries];
    int albumsFeedCount = [albums count];
    for (int i = 0; i < albumsFeedCount; i++) {
        GDataEntryPhotoAlbum *album = [albums objectAtIndex:i];
        NSArray *thumbnails = [[album mediaGroup] mediaThumbnails];
        
        if ([thumbnails count] <= 0) continue;
        GDataMediaThumbnail *t = [thumbnails objectAtIndex:0];
        
        [NSThread detachNewThreadSelector:@selector(getThumbnailsOnSeparateThreadWithURLString:) 
                                 toTarget:self 
                               withObject:t.URLString];
    }   
    
    
}
- (void)getThumbnailsOnSeparateThreadWithURLString:(NSString *)URLString
{
    @autoreleasepool {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        UIImage *img = [UIImage imageWithData:responseData];
        if (img) {
            //ok
            [_thumbnailDictionary setObject:img forKey:URLString];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NOTIFICATION_THUMBNAIL_UPDATE_SUCCESS object:[NSDictionary dictionaryWithObject:_thumbnailDictionary forKey:THUMBNAILS_KEY]]]; 
        } else {
            //error
        }
    }
}

@end
