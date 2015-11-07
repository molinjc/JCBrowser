//
//  JCDownloader.m
//  JCBrowser
//
//  Created by molin on 15/11/7.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "JCDownloader.h"

@interface JCDownloader ()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *mdata;

/**
 *  连接对象
 */
@property (nonatomic, strong) NSURLConnection *conn;

/**
 *  写数据的文件句柄
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;

@property (nonatomic, copy) NSString *path;

@end

@implementation JCDownloader

//- (instancetype)init {
//    if (self = [super init]) {
//        //self.mdata = [NSMutableData new];
//    }
//    return self;
//}

- (void)startDownloaderURL:(NSString *)url depositPath:(NSString *)path {
    self.mdata = [NSMutableData new];
    self.path = path;
    NSURL *URL = [NSURL URLWithString:url];
    // 默认就是GET请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // 设置请求头信息
    //NSString *value = [NSString stringWithFormat:@"bytes=%lld-%lld",self.begin + self.currentLength,self.end];
    //[request setValue:value forHTTPHeaderField:@"Range"];
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate 代理方法

/**
 *  1. 当接受到服务器的响应(连通了服务器)就会调用
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.delegate startDownloader];
}

/**
 *  2. 当接受到服务器的数据就会调用(可能会被调用多次, 每次调用只会传递部分数据)
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.mdata appendData:data];
}

/**
 *  3. 当服务器的数据接受完毕后就会调用
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:self.path];
    [self.writeHandle writeData:self.mdata];
    [self.writeHandle closeFile];
    [self.delegate endDownloader];
}

/**
 *  请求错误(失败)的时候调用(请求超时\断网\没有网, 一般指客户端错误)
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate endDownloaderWithError:error];
}



@end
