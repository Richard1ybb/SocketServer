//
//  FNNetServiceBrowser.m
//  BackgroundTracker
//
//  Created by jonathan on 13/04/2015.
//  Copyright (c) 2015 foundry. All rights reserved.
//

#import "FNNetServicePublisher.h"
@interface FNNetServicePublisher ()< NSNetServiceDelegate, NSStreamDelegate>
@property (nonatomic, strong) NSNetService* netService;
@property (nonatomic, strong) NSString* serviceName;
@property (nonatomic, strong) NSInputStream* inputStream;
@property (nonatomic, strong) NSOutputStream* outputStream;
@end

@implementation FNNetServicePublisher



- (void)initialisePublishing {
    NSLog(@"%s",__func__);
    uint16_t port = 9000;
    self.serviceName = @"FNSocketSensors";
    [self publishService:port];
    
}



- (void)publishService:(uint16_t)chosenPort {
    NSLog(@"chosenPort = %d", chosenPort);
    
    self.netService = [[NSNetService alloc] initWithDomain:@""
                                                      type:@"_fnwebsockets._tcp."
                                                      name:@""
                                                      port:chosenPort];
    [self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    if (self.netService != nil) {
        [self.netService setDelegate:self];
        [self.netService publishWithOptions:NSNetServiceListenForConnections];
    }
    
}

#pragma mark - netserivce

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"%s, %@",__func__,sender.name);
    [self.delegate didPublishNetService:sender];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    NSLog(@"%s, %@",__func__,sender);
}

- (void)netServiceDidStop:(NSNetService *)sender {
    NSLog(@"%s, %@",__func__,sender);
}

- (void)netServiceWillPublish:(NSNetService *)sender {
    NSLog(@"%s, %@",__func__,sender);
}

- (void)netServiceWillResolve:(NSNetService *)sender {
    NSLog(@"%s, %@",__func__,sender);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
    NSLog(@"%s, %@, %@",__func__,sender,errorDict);
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
    [self.delegate netService:sender didAcceptConnectionWithInputStream:inputStream outputStream:outputStream];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"%s, %@, %@",__func__,sender,errorDict);
}

- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data {
    NSLog(@"%s, %@",__func__,sender);
}




@end


