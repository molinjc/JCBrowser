//
//  JCDownloader.h
//  JCBrowser
//
//  Created by molin on 15/11/7.
//  Copyright © 2015年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCDownloaderDelegate <NSObject>

- (void)startDownloader;
- (void)endDownloader;
- (void)endDownloaderWithError:(NSError *)error;

@end

@interface JCDownloader : NSObject

@property (nonatomic, weak) id<JCDownloaderDelegate> delegate;

- (void)startDownloaderURL:(NSString *)url depositPath:(NSString *)path;

@end
