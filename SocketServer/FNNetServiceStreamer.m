//
//  FNNetServiceStreamer.m
//  NSNetServiceBrowsserTest
//
//  Created by jonathan on 15/04/2015.
//  Copyright (c) 2015 net.ellipsis. All rights reserved.
//
/*
 http://benincosa.com/?p=449
 http://stackoverflow.com/questions/11940911/ios-socket-networking-fundamentals-using-cfstreamcreatepairwithsockettohost
 https://robots.thoughtbot.com/streaming-audio-to-multiple-listeners-via-ios-multipeer-connectivity
 */

#import "FNNetServiceStreamer.h"
#import "FNNetServicePublisher.h"

@interface FNNetServiceStreamer()<FNNetServicePublisherDelegate, NSStreamDelegate>
@property (nonatomic, assign) BOOL ready;
@property (nonatomic, strong) FNNetServicePublisher* publisher;
@property (nonatomic, strong) NSNetService* service;
@property (nonatomic, strong) NSInputStream* inputStream;
@property (nonatomic, strong) NSOutputStream* outputStream;
//@property (nonatomic, strong) NSMutableString* stringOutputBuffer;
//@property (nonatomic, strong) NSMutableData* dataOutputBuffer;
@property (nonatomic, assign) int dataOutputBufferIndex;

@end

@implementation FNNetServiceStreamer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ready = NO;
        self.publisher = [[FNNetServicePublisher alloc] init];
        self.publisher.delegate = self;
        [self.publisher initialisePublishing];
    }
    return self;
}
/*
- (NSMutableString*)stringOutputBuffer {
    if (!_stringOutputBuffer) {
        _stringOutputBuffer = [[NSMutableString alloc] init];
    }
    return _stringOutputBuffer;
}

- (NSMutableData*)dataOutputBuffer {
    if (!_dataOutputBuffer) {
        _dataOutputBuffer = [[NSMutableData alloc] init];
    }
    return _dataOutputBuffer;
}
*/
- (void)streamData:(NSData*)data {
   // [self.dataOutputBuffer appendData:data];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)streamMessage:(NSString *)message {
   // [self.stringOutputBuffer appendString:message];
    [self streamData:[message dataUsingEncoding:NSUTF8StringEncoding]];
}

- (BOOL)serviceIsReady {
    return self.ready;
}

#pragma mark - FNNetServicePublisherDelegate

- (void)didPublishNetService:(NSNetService *)service {
    [self.delegate serverIsListening];
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inStream outputStream:(NSOutputStream *)outStream {
    self.service = sender;
    inStream.delegate = self;
    outStream.delegate = self;
    self.inputStream = inStream;
    self.outputStream = outStream;
    if (inStream && outStream) {
        [self setupStream:self.inputStream];
        [self setupStream:self.outputStream];
    }  else
    {
        NSLog(@"Failed to acquire valid streams");
    }
    self.ready = YES;
    [self.delegate clientIsConnected];
}

- (void)setupStream:(NSStream*)stream {
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream open];
}




#pragma mark - NSStream delegate

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {
    NSString* streamType = @"outputstream";
    if (stream ==  self.inputStream) {
        streamType = @"inputstream";
    }
    switch (streamEvent) {
        case NSStreamEventOpenCompleted:
            NSLog(@"%@:NSStreamEventOpenCompleted",streamType);
            break;
        case NSStreamEventHasBytesAvailable:
            NSLog(@"%@:NSStreamEventHasBytesAvailable",streamType);
            if (stream ==  self.inputStream) {
                [self readFromInputStream];
            }
                        break;
        case NSStreamEventErrorOccurred:
            NSLog(@"%@:NSStreamEventErrorOccurred",streamType);
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"%@:NSStreamEventEndEncountered",streamType);
            
            break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"%@:NSStreamEventHasSpaceAvailable",stream);
            break;
        case NSStreamEventNone:
            NSLog(@"%@:NSStreamEventNone",stream);
            break;
            
            
    }
}

- (void)readFromInputStream {
    int maxBufferLength = 1024;
    uint8_t buffer[maxBufferLength];
    NSInteger actualBufferLength;
    while ([self.inputStream hasBytesAvailable]) {
        actualBufferLength = [self.inputStream read:buffer maxLength:sizeof(buffer)];
        if (actualBufferLength > 0) {
            NSString *output =
            [[NSString alloc] initWithBytes:buffer
                                     length:actualBufferLength
                                   encoding:NSASCIIStringEncoding];
            if (nil != output) {
                [self.delegate streamer:self didReceiveMessage:output]; ;
            }
        }
    }
}

/*
-(void)writeToOutputStream {
    //this is the way Apple recommends writing
    //but - is there a memory leak? output bytes are not removed from self.dataOutputBuffer
    int byteIndex = self.dataOutputBufferIndex;
    uint8_t* readBytes = (uint8_t *)[self.dataOutputBuffer mutableBytes];
    readBytes += byteIndex;
    int dataLength = [self.dataOutputBuffer length];
    unsigned int bufferLength = ((dataLength - byteIndex >= 1024) ?
                        1024 : (dataLength-byteIndex));
    uint8_t buffer[bufferLength];
    (void)memcpy(buffer, readBytes, bufferLength);
    bufferLength = [self.outputStream write:(const uint8_t *)buffer maxLength:bufferLength];
    self.dataOutputBufferIndex += bufferLength;
}
*/


- (void)shutdownStream:(NSStream*)stream {
    [stream close];
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSDefaultRunLoopMode];
    stream = nil;

}

@end
