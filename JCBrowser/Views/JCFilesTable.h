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
- (void)seeIndex:(NSInteger)index;

@end

@interface JCFilesTable : UIView

@property (nonatomic, weak) id<JCFilesTableDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *multi_selective_array;

@property (nonatomic, assign) BOOL multi_selective;

@property (nonatomic, assign) BOOL selectAll;

- (instancetype)initWithFrame:(CGRect)frame files:(NSMutableArray *)array;

/**
 *  刷新文件组
 */
- (void)reloadFiles:(NSMutableArray *)files;

@end
