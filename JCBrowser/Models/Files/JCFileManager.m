//
//  JCFileManager.m
//  File
//
//  Created by ibokan on 15/8/14.
//  Copyright (c) 2015年 molin. All rights reserved.
//

#import "JCFileManager.h"

static JCFileManager *fileManager = nil;

@implementation JCFileManager

/**
 *  单例
 *
 *  @return 对象
 */
+ (JCFileManager *)sharedFileManager {
    if (!fileManager) {
        fileManager = [[JCFileManager alloc]init];
    }
    return fileManager;
}

/**
 *  获取沙盒
 *
 *  @return 沙盒
 */
- (NSString *)getDocumentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

/**
 *  获取CachesDirectory文件夹内的所有文件
 */
- (NSMutableArray *)getCachesDirectory {
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arr_home = [fileManager subpathsAtPath:caches];
    NSMutableArray *fileArray = [NSMutableArray new];
    for (int i=0; i<arr_home.count; i++) {
        BOOL isFile = NO;
        NSString *path = arr_home[i];
        [fileManager fileExistsAtPath:path isDirectory:(&isFile)];
        if (!isFile) {
            [fileArray addObject:[NSString stringWithFormat:@"%@/%@",caches,path]];
        }
    }
    return fileArray;
}

/**
 *  判断是否是文件
 *
 *  @param file 文件名
 *  @param path 文件路径
 *
 *  @return NO 文件  Yes 文件夹
 */
- (BOOL)isFile:(NSString *)file path:(NSString *)path {
    BOOL isFile = NO;
    NSString *paths = [path stringByAppendingPathComponent:file];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager fileExistsAtPath:paths isDirectory:(&isFile)];
    return isFile;
}

/**
 *  创建文件夹
 *
 *  @param directory 文件夹名
 *
 *  @return 是否创建成功
 */
- (BOOL)createDirectory:(NSString *)directory{
    NSString *documentsPath = [self getDocumentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:directory];
    BOOL isSuccess = [fileManager createDirectoryAtPath:iOSDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return isSuccess;
}
/**
 *  在某文件夹下创建文件
 *
 *  @param file      文件
 *  @param directory 文件夹 （为nil时直接在沙盒下创建）
 *
 *  @return 是否成功
 */
- (BOOL)createFile:(NSString *)file andDirectory:(NSString *)directory{
    NSString *documentsPath = [self getDocumentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath;
    if (directory != nil) {
       filePath = [NSString stringWithFormat:@"/%@/%@",directory,file];
    }else{
        filePath = file;
    }
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:filePath];
    BOOL isSuccess = [fileManager createFileAtPath:iOSPath contents:nil attributes:nil];
    return isSuccess;
}

/**
 *  写文件
 *
 *  @param file      文件
 *  @param string    内容
 *  @param directory 文件夹
 *
 *  @return 是否写入成功
 */
- (BOOL)writeFile:(NSString *)file andData:(NSString *)string {
    NSString *documentsPath = [self getDocumentsPath];
    NSFileManager *flieManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:file];
    if ( ![flieManager fileExistsAtPath:filePath]) {
        [flieManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSString *myString = [NSString stringWithContentsOfFile:filePath usedEncoding:NULL error:NULL];
    NSString *str = [NSString stringWithFormat:@"%@,\n%@",myString,string];
    BOOL isSuccess = [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isSuccess;
}
/**
 *  读取文件
 *
 *  @param file      文件
 *  @param directory 文件夹
 *
 *  @return 内容
 */
- (NSString *)readFile:(NSString *)file andDirectory:(NSString *)directory{
    NSString *documentsPath = [self getDocumentsPath];
    NSString *filePath;
    if (directory != nil) {
        filePath = [NSString stringWithFormat:@"%@/%@",directory,file];
    }else{
        filePath = file;
    }
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:filePath];
    NSString *contents = [NSString stringWithContentsOfFile:iOSPath encoding:NSUTF8StringEncoding error:nil];
    return contents;
}
/**
 *  判断文件是否存在
 *
 *  @param file      文件
 *  @param directory 文件夹
 *
 *  @return 是否存在
 */
- (BOOL)isSxistAtPath:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:file];
}
/**
 *  计算文件大小
 *
 *  @param file      文件
 *  @param directory 文件夹
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeAtPath:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [self isSxistAtPath:file];
    if (isExist) {
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:file error:nil] fileSize];
        return fileSize;
    }else{
        return 0;
    }
}
/**
 *  计算整个文件夹中所有文件大小
 *
 *  @param folderPath 文件夹
 *
 *  @return 大小
 */
- (unsigned long long)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString  *newFilePath=[NSString  stringWithFormat:@"%@/%@",[self  getDocumentsPath],folderPath];
    NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:newFilePath] objectEnumerator];
    unsigned long long folderSize = 0;
    NSString *fileName = @"";
    while ((fileName = [childFileEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [newFilePath stringByAppendingPathComponent:fileName];
        folderSize += [[fileManager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
    }
    return folderSize;
}
/**
 *  删除文件
 *
 *  @param file      文件
 *  @param directory 文件夹
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteFile:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager removeItemAtPath:file error:nil];
    return isSuccess;
}
/**
 *  移动文件
 *
 *  @param file          文件
 *  @param directory     移动前文件夹
 *  @param moveDirectory 移动后文件夹
 *
 *  @return 是否移动成功
 */
- (BOOL)moveFile:(NSString *)file andDirectory:(NSString *)directory andMoveDirectory:(NSString *)moveDirectory{
    NSString *documentsPath = [self getDocumentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",directory,file];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:filePath];
    NSString *moveFilePath = [NSString stringWithFormat:@"%@/%@",moveDirectory,file];
    NSString *iOSMovePath = [documentsPath stringByAppendingPathComponent:moveFilePath];
    BOOL isSuccess = [fileManager moveItemAtPath:iOSPath toPath:iOSMovePath error:nil];
    return isSuccess;
}
/**
 *  重命名文件
 *
 *  @param file      文件
 *  @param fileName  重命名
 *  @param directory 文件夹
 *
 *  @return 是否重命名成功
 */
- (BOOL)renameFile:(NSString *)file andFileName:(NSString *)fileName andDirectory:(NSString *)directory{
    NSString *documentsPath = [self getDocumentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",directory,file];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:filePath];
    NSString *moveFilePath = [NSString stringWithFormat:@"%@/%@",directory,fileName];
    NSString *iOSMovePath = [documentsPath stringByAppendingPathComponent:moveFilePath];
    BOOL isSuccess = [fileManager moveItemAtPath:iOSPath toPath:iOSMovePath error:nil];
    return isSuccess;
}
@end
