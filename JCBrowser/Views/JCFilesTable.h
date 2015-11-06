//
//  JCFilesTable.h
//  JCBrowser
//
//  Created by molin on 15/11/5.
//  Copyright © 2015年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JCFilesTable_TITLE @"title"
#define JCFilesTable_SIZE  @"size"
#define JCFilesTable_PATH  @"path"

@protocol JCFilesTableDelegate <NSObject>

- (void)selecedIndex:(NSInteger)index;

@end

@interface JCFilesTable : UIView

@property (nonatomic, weak) id<JCFilesTableDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame files:(NSMutableArray *)array;

/**
 *  刷新文件组
 */
- (void)reloadFiles:(NSMutableArray *)files;

@end
