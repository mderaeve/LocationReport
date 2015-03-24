//
//  Uploader.m
//  AssistUCameraApp
//
//  Created by Mark Deraeve on 28/01/15.
//  Copyright (c) 2015 AssistU. All rights reserved.
//

#import "Uploader.h"
#import "NetworkManager.h"
#import "VariableStore.h"
#include <CFNetwork/CFNetwork.h>

enum {
    kSendBufferSize = 32768
};

@interface Uploader () <NSStreamDelegate>

@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong, readwrite) NSOutputStream *  networkStream;
@property (nonatomic, strong, readwrite) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;


@end

@implementation Uploader
{
    uint8_t                     _buffer[kSendBufferSize];
    NSString * returnStatus;
}

#pragma mark * Status management

// These methods are used by the core transfer code to update the UI.

- (void)sendDidStart:(NSString *) url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendDidStart:)])
    {
        [self.delegate sendDidStart:url];
    }
   [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void)updateStatus:(NSString *)statusString
{
    assert(statusString != nil);
    returnStatus = statusString;
}

- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"Put succeeded";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendDidStopWithStatus:)])
    {
        [self.delegate sendDidStopWithStatus:statusString];
    }
    
   returnStatus = statusString;
    /*self.cancelButton.enabled = NO;
    [self.activityIndicator stopAnimating];*/
    [[NetworkManager sharedInstance] didStopNetworkOperation];
    
}

#pragma mark * Core transfer code

// This is the code that actually does the networking.

// Because buffer is declared as an array, you have to use a custom getter.
// A synthesised getter doesn't compile.

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (BOOL)isSending
{
    return (self.networkStream != nil);
}

- (void)startSend:(UIImage *)image andSubPath:(NSString *) subPath
{
    BOOL                    success;
    NSURL *                 url;
    
    assert(image != nil);
    
    assert(self.networkStream == nil);      // don't tap send twice in a row!
    assert(self.fileStream == nil);         // ditto
    
    // First get and check the URL.
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    
    [f setDateFormat:@"yyyyMMDDHHmmss"];
    
    NSString * urlString = [NSString stringWithFormat:@"%@/%@.jpg", [VariableStore sharedInstance].ftpPath, subPath];
    url = [[NetworkManager sharedInstance] smartURLForString: urlString];
    success = (url != nil);
    
    
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        //self.statusLabel.text = @"Invalid URL";
    } else {
        
        // Open a stream for the file we're going to send.  We do not open this stream;
        // NSURLConnection will do it for us.
        //NSData *imageData = UIImagePNGRepresentation(image);
        NSData *imageData = UIImageJPEGRepresentation(image,1.0);
        //self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        self.fileStream  = [NSInputStream inputStreamWithData:imageData];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open a CFFTPStream for the URL.
        
        self.networkStream = CFBridgingRelease(
                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                               );
        assert(self.networkStream != nil);
        
        NSString * userName = [VariableStore sharedInstance].ftpUser;
        NSString * pwd = [VariableStore sharedInstance].ftpPwd;
        
        
        [_networkStream setProperty:userName forKey:(id)kCFStreamPropertyFTPUserName];
        
        [_networkStream setProperty:pwd forKey:(id)kCFStreamPropertyFTPPassword];
        
        self.networkStream.delegate = self;
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];
        
        // Tell the UI we're sending.
        
        [self sendDidStart:urlString];
    }
}

- (void)stopSendWithStatus:(NSString *)statusString
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self sendDidStopWithStatus:statusString];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.networkStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            [self updateStatus:@"Opened connection"];
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            [self updateStatus:@"Sending"];
            
            // If we don't have any data buffered, go read the next chunk of data.
            
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    [self stopSendWithStatus:@"File read error"];
                } else if (bytesRead == 0) {
                    [self stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            // If we're not out of data completely, send the next chunk.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self stopSendWithStatus:@"Network write error"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopSendWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

#pragma mark * Actions

- (void )sendAction:(UIImage *)image andSubPath:(NSString *) subPath
{
    if ( ! self.isSending )
    {
        //int i = 0;
        //assert( [im isKindOfClass:[UIImage class]] );
        //assert(im != nil);
        
        [self startSend:image andSubPath:subPath];
        
    }
}







@end
