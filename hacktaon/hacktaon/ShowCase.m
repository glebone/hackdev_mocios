    //
//  ShowCase.m
//  conficane_test
//
//  Created by gleb dobzhanskiy on 14.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowCase.h"
#import "Constants.h"

@implementation ShowCase

@synthesize indexArray;

@synthesize  seminarId;
@synthesize  showCaseString;
@synthesize  showCaseRawString;
@synthesize  presentcastReady;
@synthesize fileStamp;
@synthesize imgUrls;
@synthesize albumID;
@synthesize albumName;




- (void) startTick
{
    NSString *cutTS = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]*1000];
    NSArray *cutTSAr = [cutTS componentsSeparatedByString:@"."];
    NSLog(@" timestamp - %@", [cutTSAr objectAtIndex:0]);
    self.fileStamp = [cutTSAr objectAtIndex:0];
    self.showCaseString = [NSMutableString stringWithFormat:@"[[-1,%@],", [cutTSAr objectAtIndex:0]];
    
    self.showCaseRawString = [NSMutableString stringWithFormat:@"0,%f", [[NSDate date] timeIntervalSince1970]];
    [self prepareRecording];
    NSLog(@"+++ %@", self.showCaseRawString);
    [self recordAudio];
}

- (void) addSlideTickWithIndex:(int)curInd
{
    NSString *cutTS = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]*1000];
    NSArray *cutTSAr = [cutTS componentsSeparatedByString:@"."];
    [self.showCaseString appendFormat:@"[%d,%@],", curInd+1, [cutTSAr objectAtIndex:0]];
    
    [self.showCaseRawString appendFormat:@"|%d,%f", curInd, [[NSDate date] timeIntervalSince1970]];
    NSLog(@"----- %@", self.showCaseRawString);
    
}


-(void) endTick
{
    NSString *cutTS = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]*1000];
    NSArray *cutTSAr = [cutTS componentsSeparatedByString:@"."];
    [self.showCaseString appendFormat:@"[0,%@]]", [cutTSAr objectAtIndex:0]];
    [self.showCaseRawString appendFormat:@"|0,%f", [[NSDate date] timeIntervalSince1970]];
    self.presentcastReady = @"1";
    [audioRecorder stop];
    [audioRecorder release];
    
    [[AVAudioSession sharedInstance] setActive: NO error: nil];
    
    //[self playAudio];
    [self getConvertedAudioFilePath];
    
}

-(NSString *) getResultString
{
    return (NSString *) self.showCaseString;
}

- (NSArray *) getRawArrayIndex
{
    self.indexArray = [self.showCaseRawString componentsSeparatedByString:@"|"];
    return self.indexArray;
    
    
}

- (NSArray *) getCurrentCase:(int)curInd
{
    
    return [[self.indexArray objectAtIndex:curInd] componentsSeparatedByString:@","];
    
}

- (NSTimeInterval) getNextDelay:(int)curInd
{
    if ([self.indexArray count] >= curInd+2)
    {
        
        
        
        
        NSTimeInterval currentTime = [[[[self.indexArray objectAtIndex:curInd] componentsSeparatedByString:@","] objectAtIndex:1] doubleValue];
        NSTimeInterval nextTime =  [[[[self.indexArray objectAtIndex:curInd+1] componentsSeparatedByString:@","] objectAtIndex:1] doubleValue];
        
        return nextTime - currentTime;
        
    }
    else
    {
        return 0;
    }
}


- (NSString *) convertIndexToRaw:(NSString *)index
{
    if ([index length] > 2)
    {    
        NSRange firstCharRange = NSMakeRange(0,2);
        NSString* firstCharacter = [index substringWithRange:firstCharRange];
        if ([firstCharacter isEqualToString:@"[["])
        {
            return @"0"; 
        }
    }    
    NSLog(@"%@", index);
    if (![index isEqualToString:@"0"])
    {    
        int slide = [index intValue]-1;
        return [NSString stringWithFormat:@"%d", slide];
    }
    return @"0";
}

- (NSString *) convertTimestampToRaw:(NSString *)stamp
{
    if ([stamp length] > 2)
    {    
        NSRange lastCharRange = NSMakeRange([stamp length]-2,2);
        NSString* lastCharacter = [stamp substringWithRange:lastCharRange];
        if ([lastCharacter isEqualToString:@"]]"])
        {
            stamp = [stamp stringByReplacingCharactersInRange:lastCharRange withString:@""];
        }
    }
    // NSLog(@"%@", stamp);
    double timestamp = [stamp doubleValue]/1000;
    
    return [NSString stringWithFormat:@"%f", timestamp];
}

- (void) convertStringToRaw:(NSString *)showCaseStr
{
    self.showCaseString = (NSMutableString *) showCaseStr;
    NSMutableString *tmpRawString = [[[NSMutableString alloc] initWithFormat:@""] autorelease];
    NSArray *splittedCase = [self.showCaseString componentsSeparatedByString:@"],["];
    
    int i = 0;
    for (NSString *curCase in splittedCase)
    {  
        NSArray *curStampArray = [curCase componentsSeparatedByString:@","]; 
        if (i == 0)
        {
            [tmpRawString appendFormat:@"%@,%@", [self convertIndexToRaw:[curStampArray objectAtIndex:0]], [self convertTimestampToRaw:[curStampArray objectAtIndex:1]]]; 
        }
        else
        {
            [tmpRawString appendFormat:@"|%@,%@", [self convertIndexToRaw:[curStampArray objectAtIndex:0]], [self convertTimestampToRaw:[curStampArray objectAtIndex:1]]]; 
        }
        i++;
    }
    // NSLog(tmpRawString);
    self.showCaseRawString = tmpRawString;
}

- (int) getShowCaseindexForSlide:(int)currentSlide
{
    int i = 0;
    for (NSString *curCase in self.indexArray)
    {
        if ([[[curCase componentsSeparatedByString:@","] objectAtIndex:0] intValue] == currentSlide)
        {
            return i;
        }
        i++; 
    }
    return -1;
}



- (NSTimeInterval) getPlayerTimeForIndex:(int)curInd
{
    if (curInd < 1)
    {
        return -1;
    }
    
    
    if ([self.indexArray count] > 1)
    {
        
        NSTimeInterval startTime = [[[[self.indexArray objectAtIndex:0] componentsSeparatedByString:@","] objectAtIndex:1] doubleValue];
        
        NSTimeInterval nextTime =  [[[[self.indexArray objectAtIndex:curInd] componentsSeparatedByString:@","] objectAtIndex:1] doubleValue];
        return (nextTime - startTime); 
    }
    else
    {
        return -1;
    }
}

- (NSString *) getPathForRecording
{
    NSString *filename = [NSString stringWithFormat:@"%@.caf",self.fileStamp];
    
	// Get full resource name
	NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:filename];
    NSLog(@" path - %@", path);
    return path;
}

- (void) prepareRecording
{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive: YES error: nil];   
    
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryRecord
     error: nil];
    
    
    NSLog(@"###################################### %@", [self getPathForRecording]);
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:[self getPathForRecording]];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getPathForRecording]])
    {
        [fileMgr removeItemAtPath:[self getPathForRecording] error:&error];
        
    }
    
    NSDictionary *recordSettings = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityLow],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], 
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 1], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:22050.0], 
                                    AVSampleRateKey,
                                    nil];
    
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
    }
    

}

- (IBAction)recordAudio
{
    [audioRecorder record];
}

- (void) playAudio
{
        NSError *error;
        
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self getPathForRecording]] error:&error];
        NSLog(@"playing");
        [audioPlayer prepareToPlay];
        [audioPlayer play];

}



- (NSString *) getConvertedAudioFilePath
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //notConverted = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioCondertingDone:) name:@"SeminarAudioDidFinishConvertion" object:nil];
    
    NSString *processedFilename = [NSString stringWithFormat:@"%@.m4a",self.fileStamp];
	NSString *filename = [NSString stringWithFormat:@"%@.caf",self.fileStamp];
    
	// Get full resource name
	NSString *processedPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:processedFilename];
	NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:filename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:processedPath])
    {
        NSError *error;
        
        [ExtAudioFileConvertUtil convertToAACM4A:path outPath:processedPath target:self];
        //[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    // NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<%d", (int)self.notConverted);
    NSLog(@"processed -  %@", processedPath);
    [pool release];
    return processedPath;
}


- (NSString *) getReadyConvertedAudioFilePath
{
    NSString *processedFilename = [NSString stringWithFormat:@"%@.m4a",fileStamp];
	NSString *processedPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:processedFilename];
    NSLog(@"processed -  %@", processedPath);
    return processedPath;   
}

- (void) audioCondertingDone:(NSNotification *)n
{
    NSString *sid = (NSString *)n.object;
    NSLog(@"Coverting  Ready!!!! ");
    //notification about upload possibility and conversion
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NOTIFICATION_CONVERTION_ENDED object:nil]];
    //[self generateResultJSON];   
    [self uploadMedia];
 
}


- (NSString *) generateResultJSON
{
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] autorelease];
    
    NSLog(@"");
    
    NSMutableArray *urls = [NSMutableArray arrayWithArray:self.imgUrls];
    for (int i = 0; i < urls.count; i++) {
        NSString *urlString = [urls objectAtIndex:i];
        NSMutableArray *urlParticles = [NSMutableArray arrayWithArray:[urlString componentsSeparatedByString:@"/"]];
        if(urlParticles.count > 0)
        {
            NSString *fileName = [urlParticles lastObject];
            fileName = [@"s1280/" stringByAppendingString:fileName];
            [urlParticles removeObject:[urlParticles lastObject]];
            [urlParticles addObject:fileName];
            
            NSString *newUrlString = [NSString string];
            
            for (NSString *particle in urlParticles) {
                if (newUrlString.length > 0) {
                    newUrlString = [newUrlString stringByAppendingFormat:@"/%@", particle];
                } else {
                    newUrlString = [newUrlString stringByAppendingFormat:@"%@", particle];
                }
                
            }
            [urls replaceObjectAtIndex:i withObject:newUrlString];
            
            NSLog(@"%@", newUrlString);
        }
    }
    
    NSDictionary *tmpVals = [[[NSDictionary alloc] initWithObjectsAndKeys:self.albumID, @"album_id", 
                              self.albumName, @"album_name",
                              [writer stringWithObject:urls], @"photos_data",
                              [self getResultString], @"switches_data",
                              nil] autorelease];
    
    
    
    
    NSLog(@"%@", [writer stringWithObject:tmpVals]);
    return [writer stringWithObject:tmpVals];
}


- (void) uploadMedia
{
    ASIFormDataRequest *prequest = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/stories.json",SERVER_URL]]] autorelease];
    
    // NSLog(@"%@", prequest.url);
    
    [prequest setPostValue:@"post" forKey:@"_method"];
    [prequest setPostValue:[self generateResultJSON] forKey:@"data"];
    [prequest setFile:[self getPathForRecording] forKey:@"file"];
    
    //[prequest setShouldUseRFC2616RedirectBehaviour:YES];
    
    
    [prequest setRequestMethod:@"POST"];
    
    [prequest setCompletionBlock:^{[[NSNotificationCenter defaultCenter] postNotificationName:@"dataUploaded" object:self];}];
    [prequest setTimeOutSeconds:30];
    [prequest setShouldContinueWhenAppEntersBackground:YES];
    [prequest setDidFailSelector:@selector(uploadFailed)];
    [prequest setDelegate:self];
    [prequest startAsynchronous];

}

- (void) uploadFailed
{
    NSLog(@"upload Failed");
}




@end
