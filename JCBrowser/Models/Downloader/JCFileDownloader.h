//
//  JCFileDownloader.h
//  JCBrowser
//
//  Created by molin on 15/11/4.
//  Copyright © 2015年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCFileDownloader : NSObject
{
    BOOL _downloading;
}
/**
 *  所需要下载文件的远程URL(连接服务器的路径)
 */
@property (nonatomic, copy) NSString *url;

/**
 *  文件的存储路径(文件下载到什么地方)
 */
@property (nonatomic, copy) NSString *destPath;

/**
 * 是否正在下载(有没有在下载, 只有下载器内部才知道)
 */
@property (nonatomic, readonly, getter = isDownloading) BOOL downloading;

/**
 *  用来监听下载进度
 */
@property (nonatomic, copy) void (^progressHandler)(double progress);

/**
 *  开始(恢复)下载
 */
- (void)start;

/**
 * 暂停下载
 */
- (void)pause;

@end
