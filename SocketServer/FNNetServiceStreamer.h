//
//  FNNetServiceStreamer.h
//  NSNetServiceBrowsserTest
//
//  Created by jonathan on 15/04/2015.
//  Copyright (c) 2015 net.ellipsis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FNNetServiceStreamer;

@protocol FNNetServiceStreamerDelegate <NSObject>

- (void)serverIsListening;
- (void)clientIsConnected;

@optional
- (void)streamer:(FNNetServiceStreamer*)streamer didReceiveData:(NSData*)data;
- (void)streamer:(FNNetServiceStreamer*)streamer didReceiveMessage:(NSString*)message;

@end

@interface FNNetServiceStreamer : NSObject

@property (nonatomic, strong) id<FNNetServiceStreamerDelegate>delegate;
- (BOOL)serviceIsReady;
- (void)streamData:(NSData*)data;
- (void)streamMessage:(NSString*)message;

@end
