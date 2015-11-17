//
//  JCFilesTableCell.m
//  JCBrowser
//
//  Created by molin on 15/11/8.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "JCFilesTableCell.h"

@interface JCFilesTableCell ()

@property (nonatomic, strong) UIImageView *image_selected;

@end

@implementation JCFilesTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = frame;
        [self addSubview:self.image_selected];
        [self addSubview:self.imageview];
        [self addSubview:self.title];
        [self addSubview:self.filesize];
        self.cell_selected = NO;
    }
    return self;
}

- (void)setCell_selected:(BOOL)cell_selected {
    if (cell_selected) {
        self.image_selected.image = [UIImage imageNamed:@"image_selected"];
    }else {
        self.image_selected.image = [UIImage imageNamed:@"imang_no_selected"];
    }
    _cell_selected = cell_selected;
}

- (void)isSelectedHidden:(BOOL)hidden {
    self.image_selected.hidden = hidden;
}

- (UIImageView *)imageview {
    if (!_imageview) {
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, self.frame.size.height, self.frame.size.height)];
    }
    return _imageview;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height+28, 0, self.frame.size.width-(self.frame.size.height+28), self.frame.size.height/3*2)];
        _title.font = [UIFont systemFontOfSize:15];
    }
    return _title;
}

- (UILabel *)filesize {
    if (!_filesize) {
        _filesize = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height+28, self.frame.size.height/3*2, self.frame.size.width-(self.frame.size.height+28), self.frame.size.height/3)];
        _filesize.font = [UIFont systemFontOfSize:12];
    }
    return _filesize;
}

- (UIImageView *)image_selected {
    if (!_image_selected) {
        _image_selected = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-30, self.frame.size.height/2-10, 20, 20)];
        _image_selected.image = [UIImage imageNamed:@"imang_no_selected"];
        _image_selected.hidden = YES;
    }
    return _image_selected;
}


@end