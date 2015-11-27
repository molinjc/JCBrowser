//
//  JCFilesTable.m
//  JCBrowser
//
//  Created by molin on 15/11/5.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "JCFilesTable.h"
#import "JCFilesTableCell.h"

@interface JCFilesTable ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *files;

@property (nonatomic, assign) NSInteger index;

@end

@implementation JCFilesTable

- (instancetype)initWithFrame:(CGRect)frame files:(NSMutableArray *)array {
    if (self = [super initWithFrame:frame]) {
        self.multi_selective = NO;
        self.files = [NSMutableArray new];
        self.files = array;
        self.multi_selective_array = [NSMutableArray new];
        [self addSubview:self.table];
    }
    return self;
}

- (void)reloadFiles:(NSMutableArray *)files {
    self.files = files;
    [self.table removeFromSuperview];
    self.table = nil;
    [self addSubview:self.table];
    [self.table reloadData];
}

- (void)doubleClick:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.multi_selective = YES;
        [self.table removeFromSuperview];
        self.table = nil;
        [self addSubview:self.table];
        [self.multi_selective_array addObject:[NSString stringWithFormat:@"%ld",(long)sender.view.tag]];
        JCFilesTableCell *cell = (JCFilesTableCell *)sender.view;
        [self.table reloadData];
        cell.cell_selected = YES;
//        self.index = sender.view.tag;
        [self.delegate selecedIndex:1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.multi_selective) {
        JCFilesTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell.cell_selected) {
            [self.multi_selective_array addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }else {
            [self.multi_selective_array removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        }
        cell.cell_selected = !cell.cell_selected;
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.delegate seeIndex:indexPath.row];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"cell";//[NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    JCFilesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        
        cell = [[JCFilesTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier frame:CGRectMake(0, 0, self.frame.size.width, 50)];
     }
    cell.title.text = self.files[indexPath.row][JCFilesTable_TITLE];
    cell.filesize.text = [NSString stringWithFormat:@"文件大小：%@",self.files[indexPath.row][JCFilesTable_SIZE]];
    
//    NSArray *postfixArr = [self.files[indexPath.row][JCFilesTable_PATH] componentsSeparatedByString:@"."];
//    
//    if (postfixArr.count>1) {
    
//        NSString *postfix = postfixArr[1];
//        
//        if ([postfix isEqualToString:@"png"] || [postfix isEqualToString:@"jpg"] || [postfix isEqualToString:@"gif"] || [postfix isEqualToString:@"bmp"]) {
        
            NSFileManager *fileManage = [NSFileManager defaultManager];
            
            UIImage *image = [UIImage imageWithData:[fileManage contentsAtPath:self.files[indexPath.row][JCFilesTable_PATH]]];
    if (image) {
        
        if (image.size.width > self.frame.size.width) {
            cell.imageview.image = [self imageWithImage:image scaledToSize:CGSizeMake(cell.imageview.frame.size.width, cell.imageview.frame.size.height)];
        }else if (image.size.height > self.frame.size.height) {
            cell.imageview.image = [self imageWithImage:image scaledToSize:CGSizeMake(cell.imageview.frame.size.width, cell.imageview.frame.size.height)];
        }else {
            cell.imageview.image = image;
        }

    }else {
        cell.imageview.image = [UIImage imageNamed:@"image_folder"];
    }
        
        [cell isSelectedHidden:!self.multi_selective];
        cell.cell_selected = self.selectAll;
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
        cell.tag = indexPath.row;
//        [doubleTap setNumberOfTapsRequired:2];
        [cell addGestureRecognizer:longPressGestureRecognizer];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)setSelectAll:(BOOL)selectAll {
    _selectAll = selectAll;
    if (_selectAll) {
        [self.multi_selective_array removeAllObjects];
        for (int i=0; i<self.files.count; i++) {
            [self.multi_selective_array addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.table removeFromSuperview];
        self.table = nil;
        [self addSubview:self.table];
        [self.table reloadData];
    }
}


- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table reloadData];
    }
    return _table;
}


-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
