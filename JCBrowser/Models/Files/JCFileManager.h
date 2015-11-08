//
//  JCFileManager.h
//  File
//
//  Created by ibokan on 15/8/14.
//  Copyright (c) 2015年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCFileManager : NSObject

/**
 *  单例
 *
 *  @return 对象
 */
+ (JCFileManager *)sharedFileManager;

/**
 *  获取沙盒
 *
 *  @return 沙盒
 */
- (NSString *)getDocumentsPath;

/**
 *  获取CachesDirectory文件夹内的所有文件
 */
- (NSMutableArray *)getCachesDirectory;


/**
 *  判断是否是文件
 *
 *  @param file 文件名
 *  @param path 文件路径
 *
 *  @return NO 文件  Yes 文件夹
 */
- (BOOL)isFile:(NSString *)file path:(NSString *)path;

/**
 *  创建文件夹
 *
 *  @param directory 文件夹名
 *
 *  @return 是否创建成功
 */
- (BOOL)createDirectory:(NSString *)directory;
/**
 *  在某文件夹下创建文件
 *
 *  @param file      文件
 *  @param directory 文件夹 （为nil时直接在沙盒下创建）
 *
 *  @return 是否成功
 */
- (BOOL)createFile:(NSString *)file andDirectory:(NSString *)directory;
/**
 *  写文件
 *
 *  @param file      文件
 *  @param string    内容
 *  @param directory 文件夹
 *
 *  @return 是否写入成功
 */
- (BOOL)writeFile:(NSString *)file andData:(NSString *)string;
/**
 *  读取文件
 *
 *  @param file      文件
 *  @param directory 文件夹
 *
 *  @return 内容
 */
 - (NSMutableArray *)readFile:(NSString *)file;
/**
 *  判断文件是否存在
 *
 *  @param file      文件
 *  @param directory 文件夹
 *
 *  @return 是否存在
 */
- (BOOL)isSxistAtPath:(NSString *)file;
/**
 *  计算文件大小
 *
 *  @param file      文件
 *  @param directory 文件夹
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeAtPath:(NSString *)file;
/**
 *  计算整个文件夹中所有文件大小
 *
 *  @param folderPath 文件夹
 *
 *  @return 大小
 */
- (unsigned long long)folderSizeAtPath:(NSString *)folderPath;
/**
 *  删除文件
 *
 *  @param file      文件
 *  @param directory 文件夹
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteFile:(NSString *)file;
/**
 *  移动文件
 *
 *  @param file          文件
 *  @param directory     移动前文件夹
 *  @param moveDirectory 移动后文件夹
 *
 *  @return 是否移动成功
 */
- (BOOL)moveFile:(NSString *)file andDirectory:(NSString *)directory andMoveDirectory:(NSString *)moveDirectory;
/**
 *  重命名文件
 *
 *  @param file      文件
 *  @param fileName  重命名
 *  @param directory 文件夹
 *
 *  @return 是否重命名成功
 */
- (BOOL)renameFile:(NSString *)file andFileName:(NSString *)fileName andDirectory:(NSString *)directory;
@end
