//
//  ViewController.m
//  WebsocketTest
//
//  Created by jonathan on 11/04/2015.
//  Copyright (c) 2015 net.ellipsis. All rights reserved.
//

#import "ViewController.h"
#import "MBWebSocketServer.h"
#import "GCDAsyncSocket.h"

@interface ViewController()<MBWebSocketServerDelegate>
@property (nonatomic, strong) MBWebSocketServer* ws;
@end
@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"%s",__func__);

    self.ws = [[MBWebSocketServer alloc] initWithPort:9000 delegate:self];
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)webSocketServer:(MBWebSocketServer *)webSocketServer didAcceptConnection:(GCDAsyncSocket *)connection {
    NSLog(@"Connected to a client, we accept multiple connections");
}

- (void)webSocketServer:(MBWebSocketServer *)webSocket
         didReceiveData:(NSData *)data
         fromConnection:(GCDAsyncSocket *)connection {
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    [connection writeWebSocketFrame:@"Thanks for the data!"]; // you can write NSStrings or NSDatas
}

- (void)webSocketServer:(MBWebSocketServer *)webSocketServer
     clientDisconnected:(GCDAsyncSocket *)connection {
    NSLog(@"Disconnected from client: %@", connection);
}

- (void)webSocketServer:(MBWebSocketServer *)webSocketServer couldNotParseRawData:(NSData *)rawData
         fromConnection:(GCDAsyncSocket *)connection
                  error:(NSError *)error {
    NSLog(@"MBWebSocketServer error: %@", error);
}

@end
