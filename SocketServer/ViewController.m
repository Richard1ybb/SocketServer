//
//  ViewController.m
//  WebsocketTest
//
//  Created by jonathan on 11/04/2015.
//  Copyright (c) 2015 net.ellipsis. All rights reserved.
//

#import "ViewController.h"
#import "FNNetServiceStreamer.h"

@interface ViewController()<FNNetServiceStreamerDelegate>
@property (nonatomic, strong) FNNetServiceStreamer* streamer;
@property (nonatomic, assign) int counter;
@end
@implementation ViewController

- (void)viewDidLoad {
    self.streamer = [[FNNetServiceStreamer alloc] init];
    self.streamer.delegate = self;
    [super viewDidLoad];

}

- (void)streamer:(FNNetServiceStreamer*)streamer didReceiveData:(NSData*)data {
    
}
- (void)streamer:(FNNetServiceStreamer*)streamer didReceiveMessage:(NSString*)message {
    NSLog(@"received: %@ %d",message, _counter++);
    [streamer streamMessage:@"received OK "];
    [self parseSteam:message];
    
}

- (void)parseSteam:(NSString*)string {
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSArray* triplets = [string componentsSeparatedByString:@"|"];
    for (id triple in triplets) {
        if ([triple isKindOfClass:NSString.class]) {
            NSArray* rpy = [triple componentsSeparatedByString:@","];
            if (rpy.count ==3 ) {
            [results addObject:rpy];
            }
        }
    }
    NSLog(@"parsed: %@",results);
    //if ([string in
}

- (void)serverIsListening {
    NSLog(@"Server is listening");
}

- (void)clientIsConnected {
    NSLog(@"Client is connected");
}

@end
