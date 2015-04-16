//
//  FNNetServiceBrowser.h
//  BackgroundTracker
//
//  Created by jonathan on 13/04/2015.
//  Copyright (c) 2015 foundry. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol FNNetServicePublisherDelegate <NSObject>

- (void)didPublishNetService:(NSNetService*)service;
- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;

@end
@interface FNNetServicePublisher : NSObject
@property (nonatomic, weak) id<FNNetServicePublisherDelegate>delegate;
- (void)initialisePublishing;

@end
