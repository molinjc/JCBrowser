//
//  JCFilesTable.m
//  JCBrowser
//
//  Created by molin on 15/11/5.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "JCFilesTable.h"

@interface JCFilesTable ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *files;

@end

@implementation JCFilesTable

- (instancetype)initWithFrame:(CGRect)frame files:(NSMutableArray *)array {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.table];
        self.files = [NSMutableArray new];
        self.files = array;
    }
    return self;
}

- (void)reloadFiles:(NSMutableArray *)files {
    self.files = files;
    [self.table reloadData];
}

- (void)doubleClick:(UITapGestureRecognizer *)sender {
    [self.delegate selecedIndex:sender.view.tag];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"cell%ld",(long)indexPath.row] ];
        cell.textLabel.text = self.files[indexPath.row][JCFilesTable_TITLE];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"文件大小：%@",self.files[indexPath.row][JCFilesTable_SIZE]];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        doubleTap.view.tag = indexPath.row;
        [doubleTap setNumberOfTapsRequired:2];
        [cell addGestureRecognizer:doubleTap];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
