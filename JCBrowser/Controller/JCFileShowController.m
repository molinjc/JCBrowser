//
//  JCFileShowController.m
//  JCBrowser
//
//  Created by molin on 15/11/5.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "JCFileShowController.h"

#import "JCImageSeeView.h"
#import "JCFilesTable.h"
#import "AlertHelper.h"

#import "JCFileManager.h"

@interface JCFileShowController ()<UIAlertViewDelegate,JCFilesTableDelegate>

@property (nonatomic, strong) JCImageSeeView  *imageSee;
@property (nonatomic, strong) JCFilesTable    *filesTable;
@property (nonatomic, strong) JCFileManager   *fileManager;
@property (nonatomic, strong) NSMutableArray  *filesArray;
@property (nonatomic, strong) NSMutableArray  *imageArray;
@property (nonatomic, assign) NSInteger        fileIndex;
@property (nonatomic, strong) UIBarButtonItem *item;
@property (nonatomic, strong) UIButton        *delete;

@end

@implementation JCFileShowController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.fileIndex = 0;
    self.filesArray = [NSMutableArray new];
    self.imageArray = [NSMutableArray new];
    [self obtainFilesArray];
    [self createNavigationWithBarButtonItem];
    [self.view addSubview:self.filesTable];
    [self.view addSubview:self.imageSee];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)obtainFilesArray {
    [self.filesArray removeAllObjects];
    [self.imageArray removeAllObjects];
    NSMutableArray *array = [self.fileManager getCachesDirectory];
    for (int i=0; i<array.count; i++) {
        NSString *path = array[i];
        NSArray *strArray = [path componentsSeparatedByString:@"/"];
        NSString *fileName = strArray[strArray.count-1];
        NSString *size = [NSString stringWithFormat:@"%llu",[self.fileManager fileSizeAtPath:path]];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:fileName,JCFilesTable_TITLE,size,JCFilesTable_SIZE,path,JCFilesTable_PATH, nil];
        [self.filesArray addObject:dic];
        
        NSArray *postfixArr = [fileName componentsSeparatedByString:@"."];
        if (postfixArr.count>1) {
            NSString *postfix = postfixArr[1];
            if ([postfix isEqualToString:@"png"] || [postfix isEqualToString:@"jpg"] || [postfix isEqualToString:@"gif"] || [postfix isEqualToString:@"bmp"]) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:path,@"image",postfixArr[0],@"info", nil];
                [self.imageArray addObject:dic];
            }
        }
    }
}

#pragma mark - JCFilesTableDelegate

- (void)selecedIndex:(NSInteger)index {
    self.fileIndex = index;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        BOOL isd = [self.fileManager deleteFile:self.filesArray[self.fileIndex][JCFilesTable_PATH]];
        if (isd) {
            [self obtainFilesArray];
            [self.filesTable reloadFiles:self.filesArray];
            [AlertHelper showOneSecond:@"删除成功！" andDelegate:self.view];
        }
        
    }
}

- (void)seeIndex:(NSInteger)index {
    NSString *fileName = self.filesArray[index][JCFilesTable_TITLE];
    NSArray *postfixArr = [fileName componentsSeparatedByString:@"."];
    if (postfixArr.count>1) {
        NSString *postfix = postfixArr[1];
        if ([postfix isEqualToString:@"png"] || [postfix isEqualToString:@"jpg"] || [postfix isEqualToString:@"gif"] || [postfix isEqualToString:@"bmp"]) {
            [self.imageSee showToImageWithPath:self.filesArray[index][JCFilesTable_PATH]];
            self.item.title = @"返回";
            self.imageSee.hidden = NO;
            self.filesTable.hidden = YES;
        }
    }
}

#pragma mark - 点击事件

- (void)item_sction:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"相册"]) {
        sender.title = @"返回";
        self.imageSee.hidden = NO;
        self.filesTable.hidden = YES;
    }else {
        sender.title = @"相册";
        self.imageSee.hidden = YES;
        self.filesTable.hidden = NO;
    }
}

- (void)delete_action:(UIButton *)sender {
    BOOL isd = [self.fileManager deleteFile:self.imageSee.dic[@"image"]];
    if (isd) {
        [self obtainFilesArray];
        self.imageSee.arrImage = self.imageArray;
        [self.filesTable reloadFiles:self.filesArray];
        [self.imageSee performSelectorOnMainThread:@selector(reloadImageView) withObject:nil waitUntilDone:NO];
        [AlertHelper showOneSecond:@"删除成功！" andDelegate:self.view];
    }
}

#pragma mark - 视图创建

- (void)createNavigationWithBarButtonItem {
    self.item = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(item_sction:)];
    self.navigationItem.rightBarButtonItem = self.item;
}

- (JCImageSeeView *)imageSee {
    if (!_imageSee) {
        _imageSee = [[JCImageSeeView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) andImageArray:self.imageArray];
        _imageSee.hidden = YES;
    }
    return _imageSee;
}

- (JCFilesTable *)filesTable {
    if (!_filesTable) {
        _filesTable = [[JCFilesTable alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) files:self.filesArray];
        _filesTable.delegate = self;
    }
    return _filesTable;
}

- (JCFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [JCFileManager sharedFileManager];
    }
    return _fileManager;
}

- (UIButton *)delete {
    if (!_delete) {
        _delete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _delete.backgroundColor = [UIColor colorWithWhite:0.802 alpha:0.500];
        [_delete setTitle:@"X" forState:UIControlStateNormal];
        _delete.frame = CGRectMake(self.view.frame.size.width-30, 0, 30, 30);
        [_delete addTarget:self action:@selector(delete_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delete;
}

@end
