//
//  DataManager.h
//  hacktaon
//
//  Created by Pavlo Nadolinskyi on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDataServiceGooglePhotos;

@interface DataManager : NSObject
+ (DataManager *)sharedManager;
- (void)setUserName:(NSString *)uName andPassword:(NSString *)pass;
- (void)getAlbumList;
- (void)fetchPhotosFromAlbumAtIndex:(int)index;
- (NSMutableArray *)photoLinks;

@property(nonatomic, retain) GDataServiceGooglePhotos *service;
@property(nonatomic, retain) NSArray *albums;
@property(nonatomic, retain) NSArray *photos;


@end
