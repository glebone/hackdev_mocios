//
//  ShowCase.h
//  conficane_test
//
//  Created by gleb dobzhanskiy on 01.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SBJSON.h"
#import "ASIHTTPRequest.h"
#import "ExtAudioFileConvertUtil.h"


@interface ShowCase : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate, ASIProgressDelegate>
{
    NSArray *indexArray;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    NSString *fileStamp;

    
}
@property (nonatomic, retain) NSString * seminarId;
@property (nonatomic, retain) NSMutableString * showCaseString;
@property (nonatomic, retain) NSMutableString * showCaseRawString;
@property (nonatomic, retain) NSArray * indexArray;
@property (nonatomic, retain) NSString * presentcastReady;
@property (nonatomic, retain) NSString * fileStamp;


-(NSString *) getPathForRecording;
-(void) prepareRecording;
-(IBAction) recordAudio;



- (void) addSlideTickWithIndex:(int) curInd;

- (void) startTick;

- (void) endTick;

- (void) playAudio;

- (NSString *) getResultString;

- (NSArray *) getRawArrayIndex;

- (NSArray *) getCurrentCase:(int) curInd;

- (NSTimeInterval) getNextDelay:(int) curInd;

- (void) convertStringToRaw:(NSString *) showCaseStr;

- (int) getShowCaseindexForSlide:(int)currentSlide;

- (NSTimeInterval) getPlayerTimeForIndex:(int) curInd;

- (NSString *) convertIndexToRaw:(NSString *) index;
- (NSString *) convertTimestampToRaw:(NSString *) stamp;
- (void) audioCondertingDone:(NSNotification *)n;

// Audio related 

- (NSString *) getPathForRecording;
-(void) prepareRecording;
-(IBAction) recordAudio;
- (NSString *) getConvertedAudioFilePath;
- (NSString *) getReadyConvertedAudioFilePath;



@end
