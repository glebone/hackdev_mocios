//
//  ExtAudioFileConvertUtil.m
//
//  Created by Moses DeJong on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ExtAudioFileConvertUtil.h"

#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import <AudioToolbox/AudioConverter.h>

@implementation ExtAudioFileConvertUtil

+ (OSStatus) convertToCaff:(NSString*)inPath
				   outPath:(NSString*)outPath
{
	return [self convertToCaff:inPath outPath:outPath numChannels:-1];
}

+ (OSStatus) convertToCaff:(NSString*)inPath
					   outPath:(NSString*)outPath
				   numChannels:(NSInteger)numChannels
{
	return [self convertTo:inPath outPath:outPath
		   audioFileTypeID:kAudioFileCAFType
				 mFormatID:kAudioFormatLinearPCM
			   numChannels:numChannels];
}

+ (OSStatus) convertToIMA4Caff:(NSString*)inPath
					   outPath:(NSString*)outPath
{
	return [self convertToIMA4Caff:inPath outPath:outPath numChannels:-1];
}

+ (OSStatus) convertToIMA4Caff:(NSString*)inPath
				   outPath:(NSString*)outPath
			   numChannels:(NSInteger)numChannels
{
	return [self convertTo:inPath outPath:outPath
		   audioFileTypeID:kAudioFileCAFType
				 mFormatID:kAudioFormatAppleIMA4
			   numChannels:numChannels];
}

+ (OSStatus) convertToALACCaff:(NSString*)inPath
					   outPath:(NSString*)outPath
{
	return [self convertToALACCaff:inPath outPath:outPath numChannels:-1];
}

+ (OSStatus) convertToALACCaff:(NSString*)inPath
					   outPath:(NSString*)outPath
				   numChannels:(NSInteger)numChannels
{
	return [self convertTo:inPath outPath:outPath
		   audioFileTypeID:kAudioFileCAFType
				 mFormatID:kAudioFormatAppleLossless
			   numChannels:numChannels];
}

+ (OSStatus) convertToAACCaff:(NSString*)inPath
                       outPath:(NSString*)outPath
{
	return [self convertToAACCaff:inPath outPath:outPath numChannels:-1];
}

+ (OSStatus) convertToAACCaff:(NSString*)inPath
                       outPath:(NSString*)outPath
                   numChannels:(NSInteger)numChannels
{
	return [self convertTo:inPath outPath:outPath
         audioFileTypeID:kAudioFileCAFType
               mFormatID:kAudioFormatMPEG4AAC
             numChannels:numChannels];
}

+ (OSStatus) convertToAACM4A:(NSString*)inPath
                      outPath:(NSString*)outPath
                       target:(id)target
{
	return [self convertToAACM4A:inPath outPath:outPath numChannels:-1 target:target];
}

+ (OSStatus) convertToAACM4A:(NSString*)inPath
                      outPath:(NSString*)outPath
                  numChannels:(NSInteger)numChannels
target:(id)target
{
	return [self convertTo:inPath outPath:outPath
         audioFileTypeID:kAudioFileM4AType
               mFormatID:kAudioFormatMPEG4AAC
             numChannels:numChannels target:target];
}

// Set flags for default audio format on iPhone OS

+ (void) _setDefaultAudioFormatFlags:(AudioStreamBasicDescription*)audioFormatPtr
						 numChannels:(NSUInteger)numChannels
{
	bzero(audioFormatPtr, sizeof(AudioStreamBasicDescription));

	audioFormatPtr->mFormatID = kAudioFormatLinearPCM;
	audioFormatPtr->mSampleRate = 44100.0;
	audioFormatPtr->mChannelsPerFrame = numChannels;
	audioFormatPtr->mBytesPerPacket = 2 * numChannels;
	audioFormatPtr->mFramesPerPacket = 1;
	audioFormatPtr->mBytesPerFrame = 2 * numChannels;
	audioFormatPtr->mBitsPerChannel = 16;
	audioFormatPtr->mFormatFlags = kAudioFormatFlagsNativeEndian |
		kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;	
}

// Set flags for IMA4 compressed audio (optimal size for uncompressed audio)

+ (void) _setIMA4AudioFormatFlags:(AudioStreamBasicDescription*)audioFormatPtr
						  numChannels:(NSUInteger)numChannels
{
	bzero(audioFormatPtr, sizeof(AudioStreamBasicDescription));

	audioFormatPtr->mFormatID = kAudioFormatAppleIMA4;
	audioFormatPtr->mSampleRate = 44100.0;
	audioFormatPtr->mChannelsPerFrame = numChannels;
	audioFormatPtr->mBytesPerPacket = 34 * numChannels;
	audioFormatPtr->mFramesPerPacket = 64;
}

+ (void) _setALACAudioFormatFlags:(AudioStreamBasicDescription*)audioFormatPtr
					  numChannels:(NSUInteger)numChannels
{
	bzero(audioFormatPtr, sizeof(AudioStreamBasicDescription));

	audioFormatPtr->mFormatID = kAudioFormatAppleLossless;
	audioFormatPtr->mSampleRate = 44100.0;
	audioFormatPtr->mChannelsPerFrame = numChannels;
}

+ (void) _setAACAudioFormatFlags:(AudioStreamBasicDescription*)audioFormatPtr
                      numChannels:(NSUInteger)numChannels
{
	bzero(audioFormatPtr, sizeof(AudioStreamBasicDescription));
  
	audioFormatPtr->mFormatID = kAudioFormatMPEG4AAC;
	audioFormatPtr->mFormatFlags = kMPEG4Object_AAC_Main;
	audioFormatPtr->mSampleRate = 22050.0;
	audioFormatPtr->mChannelsPerFrame = numChannels;
}

// Get a string description of common ext audio result codes

+ (NSString*) commonExtAudioResultCode:(OSStatus)code
{
	char *str;

	if (code == kExtAudioFileError_InvalidProperty) {
		str = "kExtAudioFileError_InvalidProperty";
	} else if (code == kExtAudioFileError_InvalidPropertySize) {
		str = "kExtAudioFileError_InvalidPropertySize";
	} else if (code == kExtAudioFileError_NonPCMClientFormat) {
		str = "kExtAudioFileError_NonPCMClientFormat";
	} else if (code == kExtAudioFileError_InvalidChannelMap) {
		str = "kExtAudioFileError_InvalidChannelMap";
	} else if (code == kExtAudioFileError_InvalidOperationOrder) {
		str = "kExtAudioFileError_InvalidOperationOrder";
	} else if (code == kExtAudioFileError_InvalidDataFormat) {
		str = "kExtAudioFileError_InvalidDataFormat";
	} else if (code == kExtAudioFileError_MaxPacketSizeUnknown) {
		str = "kExtAudioFileError_MaxPacketSizeUnknown";
	} else if (code == kExtAudioFileError_InvalidSeek) {
		str = "kExtAudioFileError_InvalidSeek";
	} else if (code == kExtAudioFileError_AsyncWriteTooLarge) {
		str = "kExtAudioFileError_AsyncWriteTooLarge";
	} else if (code == kExtAudioFileError_AsyncWriteBufferOverflow) {
		str = "kExtAudioFileError_AsyncWriteBufferOverflow";
	} else if (code == kExtAudioFileError_AsyncWriteBufferOverflow) {
		str = "kExtAudioFileError_AsyncWriteBufferOverflow";
	} else {
		str = "";
	}

	return [NSString stringWithFormat:@"%s", str];
}

+ (OSStatus) convertTo:(NSString*)inPath
			   outPath:(NSString*)outPath
	   audioFileTypeID:(AudioFileTypeID)audioFileTypeID
			 mFormatID:(UInt32)mFormatID
		   numChannels:(NSInteger)numChannels
                target:(id)targ
{
    OSStatus							err = noErr;
    AudioStreamBasicDescription			inputFileFormat;
    AudioStreamBasicDescription			converterFormat;
    UInt32								thePropertySize = sizeof(inputFileFormat);
    ExtAudioFileRef						inputAudioFileRef = NULL;
    ExtAudioFileRef						outputAudioFileRef = NULL;
    AudioStreamBasicDescription			outputFileFormat;

#define BUFFER_SIZE 4096

    //NSLog(@"converting");

	UInt8 *buffer = NULL;

	NSURL *inURL = [NSURL fileURLWithPath:inPath];
	NSURL *outURL = [NSURL fileURLWithPath:outPath];

	// Open input audio file

    err = ExtAudioFileOpenURL((CFURLRef)inURL, &inputAudioFileRef);
    if (err)
	{
		goto reterr;
	}
	assert(inputAudioFileRef);

    // Get input audio format

	bzero(&inputFileFormat, sizeof(inputFileFormat));
    err = ExtAudioFileGetProperty(inputAudioFileRef, kExtAudioFileProperty_FileDataFormat,
								  &thePropertySize, &inputFileFormat);
    if (err)
	{
		goto reterr;
	}
	
	// only mono or stereo audio files are supported

    if (inputFileFormat.mChannelsPerFrame > 2) 
	{
		err = kExtAudioFileError_InvalidDataFormat;
		goto reterr;
	}

	// Enable an audio converter on the input audio data by setting
	// the kExtAudioFileProperty_ClientDataFormat property. Each
	// read from the input file returns data in linear pcm format.

	if (numChannels == -1)
		numChannels = inputFileFormat.mChannelsPerFrame;

	[self _setDefaultAudioFormatFlags:&converterFormat numChannels:numChannels];

    err = ExtAudioFileSetProperty(inputAudioFileRef, kExtAudioFileProperty_ClientDataFormat,
								  sizeof(converterFormat), &converterFormat);
    if (err)
	{
		goto reterr;
	}
	
	// Handle the case of reading from a mono input file and writing to a stereo
	// output file by setting up a channel map. The mono output is duplicated
	// in the left and right channel.

	if (inputFileFormat.mChannelsPerFrame == 1 && numChannels == 2) {
		SInt32 channelMap[2] = { 0, 0 };

		// Get the underlying AudioConverterRef

		AudioConverterRef convRef = NULL;
		UInt32 size = sizeof(AudioConverterRef);

		err = ExtAudioFileGetProperty(inputAudioFileRef, kExtAudioFileProperty_AudioConverter, &size, &convRef);

		if (err)
		{
			goto reterr;
		}    
    
		assert(convRef);

		err = AudioConverterSetProperty(convRef, kAudioConverterChannelMap, sizeof(channelMap), channelMap);

		if (err)
		{
			goto reterr;
		}
	}

    // Output file is typically a caff file, but the user could emit some other
	// common file types. If a file exists already, it is deleted before writing
	// the new audio file.

	if (mFormatID == kAudioFormatAppleIMA4) {
		[self _setIMA4AudioFormatFlags:&outputFileFormat numChannels:converterFormat.mChannelsPerFrame];
	} else if (mFormatID == kAudioFormatMPEG4AAC) {
		[self _setAACAudioFormatFlags:&outputFileFormat numChannels:converterFormat.mChannelsPerFrame];
	} else if (mFormatID == kAudioFormatAppleLossless) {
		[self _setALACAudioFormatFlags:&outputFileFormat numChannels:converterFormat.mChannelsPerFrame];		
	} else if (mFormatID == kAudioFormatLinearPCM) {
		[self _setDefaultAudioFormatFlags:&outputFileFormat numChannels:converterFormat.mChannelsPerFrame];		
	} else {
		err = kExtAudioFileError_InvalidDataFormat;
		goto reterr;
	}

	UInt32 flags = kAudioFileFlags_EraseFile;

	err = ExtAudioFileCreateWithURL((CFURLRef)outURL, audioFileTypeID, &outputFileFormat,
									NULL, flags, &outputAudioFileRef);
    if (err)
	{
		// -48 means the file exists already
		goto reterr;
	}
	assert(outputAudioFileRef);

	// Enable converter when writing to the output file by setting the client
	// data format to the pcm converter we created earlier.

    err = ExtAudioFileSetProperty(outputAudioFileRef, kExtAudioFileProperty_ClientDataFormat,
								  sizeof(converterFormat), &converterFormat);
    if (err)
	{
		goto reterr;
	}

	// Buffer to read from source file and write to dest file

	buffer = malloc(BUFFER_SIZE);
	assert(buffer);	

	AudioBufferList conversionBuffer;
	conversionBuffer.mNumberBuffers = 1;
	conversionBuffer.mBuffers[0].mNumberChannels = inputFileFormat.mChannelsPerFrame;
	conversionBuffer.mBuffers[0].mData = buffer;
	conversionBuffer.mBuffers[0].mDataByteSize = BUFFER_SIZE;

	while (TRUE) {
		conversionBuffer.mBuffers[0].mDataByteSize = BUFFER_SIZE;

		UInt32 frameCount = INT_MAX;

		if (inputFileFormat.mBytesPerFrame > 0) {
			frameCount = (conversionBuffer.mBuffers[0].mDataByteSize / inputFileFormat.mBytesPerFrame);
		}

		// Read a chunk of input

		err = ExtAudioFileRead(inputAudioFileRef, &frameCount, &conversionBuffer);

		if (err) {
			goto reterr;
		}

		// If no frames were returned, conversion is finished

		if (frameCount == 0)
			break;

		// Write pcm data to output file

		err = ExtAudioFileWrite(outputAudioFileRef, frameCount, &conversionBuffer);

		if (err) {
			goto reterr;
		}
	}

reterr:
	if (buffer != NULL)
		free(buffer);

	if (inputAudioFileRef)
		ExtAudioFileDispose(inputAudioFileRef);

	if (outputAudioFileRef)
		ExtAudioFileDispose(outputAudioFileRef);
    
    ShowCase *seminar = (ShowCase *)targ;

    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SeminarAudioDidFinishConvertion" object:seminar.fileStamp];
    
    
    //NSLog(@"converted");

	return err;
}

+ (OSStatus) getCaffAudioFormatID:(NSString*)filePath fileFormatIDPtr:(UInt32*)fileFormatIDPtr
{
	OSStatus status;

	NSURL *url = [NSURL fileURLWithPath:filePath];
	
	AudioFileID inAudioFile = NULL;

/*
#ifndef kAudioFileReadPermission
# define kAudioFileReadPermission fsRdPerm
#endif
*/

	status = AudioFileOpenURL((CFURLRef)url, kAudioFileReadPermission, 0, &inAudioFile);
    if (status)
	{
		goto reterr;
	}

	// Lookup audio file type

    AudioStreamBasicDescription inputDataFormat;
	UInt32 propSize = sizeof(inputDataFormat);

	bzero(&inputDataFormat, sizeof(inputDataFormat));

    status = AudioFileGetProperty(inAudioFile, kAudioFilePropertyDataFormat,
								  &propSize, &inputDataFormat);

	if (status)
	{
		goto reterr;
	}

	*fileFormatIDPtr = inputDataFormat.mFormatID;

reterr:
	if (inAudioFile != NULL) {
		OSStatus close_status = AudioFileClose(inAudioFile);
		assert(close_status == 0);
	}

	return status;
}

+ (BOOL) isALACAudioFormat:(NSString*)filePath
{
	UInt32 fileFormatID;

	OSStatus status = [self getCaffAudioFormatID:filePath fileFormatIDPtr:&fileFormatID];

	NSAssert(status == 0, @"getCaffAudioFormatID failed");

	return (fileFormatID == kAudioFormatAppleLossless);
}

@end
