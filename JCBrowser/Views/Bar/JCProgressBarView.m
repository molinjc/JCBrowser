//
//  JCProgressBarView.m
//  JCBrowser
//
//  Created by molin on 15/11/28.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "JCProgressBarView.h"
#import "UIView+Coordinate.h"

#define JCProgressBarView_WIDTH  [UIScreen mainScreen].bounds.size.width
#define JCProgressBarView_HEIGHT 50

@interface JCProgressBarView ()
@property (nonatomic, strong) UILabel *label_image_quantity_get;
@property (nonatomic, strong) UILabel *label_image_quantity_get_text;
@property (nonatomic, strong) UILabel *label_image_quantity_downloader;
@property (nonatomic, strong) UILabel *label_image_quantity_downloader_text;
@property (nonatomic, strong) UILabel *label_image_url_downloader;
@end

@implementation JCProgressBarView

#pragma mark - 初始化
- (instancetype)initWithPlace:(CGPoint)place {
    if (self = [super initWithFrame:CGRectMake(place.x, place.y, JCProgressBarView_WIDTH, JCProgressBarView_HEIGHT)]) {
        self.backgroundColor = [UIColor colorWithWhite:0.220 alpha:0.700];
        self.downloader_finish = 0;
        [self addSubview:self.label_image_quantity_get];
        [self addSubview:self.label_image_quantity_get_text];
        [self addSubview:self.label_image_url_downloader];
        [self addSubview:self.label_image_quantity_downloader];
        [self addSubview:self.label_image_quantity_downloader_text];
    }
    return self;
}

#pragma mark - 属性的set方法

- (void)setImage_quantity_get:(int)image_quantity_get {
    _image_quantity_get = image_quantity_get;
    self.label_image_quantity_get.text = [NSString stringWithFormat:@"%d",image_quantity_get];
}

- (void)setImage_url_downloader:(NSString *)image_url_downloader {
    _image_url_downloader = image_url_downloader;
    self.label_image_url_downloader.text = image_url_downloader;
}

- (void)setDownloader_finish:(int)downloader_finish {
    _downloader_finish = downloader_finish;
    if (_downloader_finish != 0) {
        if (_downloader_finish == self.image_quantity_get) {
            self.label_image_quantity_downloader.text = @"完成";
        }else {
            self.label_image_quantity_downloader.text = [NSString stringWithFormat:@"%d",_downloader_finish];
        }
    }
}

#pragma mark - 懒加载

- (UILabel *)label_image_quantity_get {
    if (!_label_image_quantity_get) {
        _label_image_quantity_get = [[UILabel alloc]initWithFrame:CGRectMake(self.width/3*2, 20, self.width/3*2/2, 30)];
        _label_image_quantity_get.textAlignment = NSTextAlignmentCenter;
        _label_image_quantity_get.font = [UIFont systemFontOfSize:16];
    }
    return _label_image_quantity_get;
}

- (UILabel *)label_image_quantity_get_text {
    if (!_label_image_quantity_get_text) {
        _label_image_quantity_get_text = [[UILabel alloc]initWithFrame:CGRectMake(self.width/3*2, 0, self.width/3*2/2, 20)];
        _label_image_quantity_get_text.textAlignment = NSTextAlignmentCenter;
        _label_image_quantity_get_text.font = [UIFont systemFontOfSize:14];
        _label_image_quantity_get_text.text = @"获取到的图片数量";
    }
    return _label_image_quantity_get_text;
}

- (UILabel *)label_image_quantity_downloader {
    if (!_label_image_quantity_downloader) {
        _label_image_quantity_downloader = [[UILabel alloc]initWithFrame:CGRectMake(self.width/3*2+self.label_image_quantity_get.width, 20, self.label_image_quantity_get.width, self.label_image_quantity_get.height)];
        _label_image_quantity_downloader.textAlignment = NSTextAlignmentCenter;
        _label_image_quantity_downloader.font = [UIFont systemFontOfSize:16];
    }
    return _label_image_quantity_downloader;
}

- (UILabel *)label_image_quantity_downloader_text {
    if (!_label_image_quantity_downloader_text) {
        _label_image_quantity_downloader_text = [[UILabel alloc]initWithFrame:CGRectMake(self.width/3*2+self.label_image_quantity_get_text.width, 0, self.width/3*2/2, 20)];
        _label_image_quantity_downloader_text.textAlignment = NSTextAlignmentCenter;
        _label_image_quantity_downloader_text.font = [UIFont systemFontOfSize:14];
        _label_image_quantity_downloader_text.text = @"下载完成";
    }
    return _label_image_quantity_downloader_text;
}

- (UILabel *)label_image_url_downloader {
    if (!_label_image_url_downloader) {
        _label_image_url_downloader = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width/3*2, self.height)];
        _label_image_url_downloader.numberOfLines = 0;
        _label_image_url_downloader.font = [UIFont systemFontOfSize:15];
    }
    return _label_image_url_downloader;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
