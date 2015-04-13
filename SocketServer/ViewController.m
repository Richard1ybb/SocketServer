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

@interface ViewController()<MBWebSocketServerDelegate, NSNetServiceDelegate>
@property (nonatomic, strong) MBWebSocketServer* ws;
@property (nonatomic, strong) NSNetService* netService;
@property (nonatomic, strong) NSString* serviceName;
@end
@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"%s",__func__);
    uint16_t port = 9000;
    self.ws = [[MBWebSocketServer alloc] initWithPort:9000 delegate:self];
    self.serviceName = @"socketsensors";
    [self publishService:port];
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

- (void)publishService:(uint16_t)chosenPort {
    NSLog(@"chosenPort = %d", chosenPort);
    
    self.netService = [[NSNetService alloc] initWithDomain:@""
                                                      type:@"_fnwebsockets._tcp."
                                                      name:self.serviceName
                                                      port:chosenPort];
    if (self.netService != nil) {
        [self.netService setDelegate:self];
        [self.netService publishWithOptions:0];
    }

}


#pragma mark - netserivce

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"%s, %@",__func__,sender);
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
    NSLog(@"%s, %@, %@",__func__,sender,outputStream);
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"%s, %@, %@",__func__,sender,errorDict);
}

- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data {
    NSLog(@"%s, %@",__func__,sender);
}
@end
