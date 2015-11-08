//
//  JCFilesTableCell.h
//  JCBrowser
//
//  Created by molin on 15/11/8.
//  Copyright © 2015年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCFilesTableCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel     *title;
@property (nonatomic, strong) UILabel     *filesize;
@property (nonatomic, assign) BOOL         cell_selected;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

- (void)isSelectedHidden:(BOOL)hidden;

@end