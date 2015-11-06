//
//  JCFileSingDownloader.h
//  JCBrowser
//
//  Created by molin on 15/11/4.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "JCFileDownloader.h"


@interface JCFileSingDownloader : JCFileDownloader

/**
 *  开始的位置
 */
@property (nonatomic, assign) long long begin;

/**
 *  结束的位置
 */
@property (nonatomic, assign) long long end;

@end
