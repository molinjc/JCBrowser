//
//  JCBarView.m
//  JCBrowser
//
//  Created by molin on 15/11/4.
//  Copyright © 2015年 molin. All rights reserved.
//

#import "JCBarView.h"

@interface JCBarView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField  *addressBar;  // 地址栏
@property (nonatomic, strong) UIButton     *advance;     // 前进
@property (nonatomic, strong) UIButton     *retreat;     // 后退
@property (nonatomic, strong) UIButton     *close;       // 关闭
@property (nonatomic, strong) UIButton     *refresh;     // 刷新
@property (nonatomic, strong) UIButton     *list;        // 列表
@end

@implementation JCBarView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)]) {
        self.backgroundColor = [UIColor colorWithWhite:0.220 alpha:0.700];
        [self addSubview:self.addressBar];
        [self addSubview:self.advance];
        [self addSubview:self.retreat];
        [self addSubview:self.close];
        [self addSubview:self.refresh];
        [self addSubview:self.list];
    }
    return self;
}

#pragma mark - 事件

- (void)advance_action:(UIButton *)sender {
    [self.delegate advanceEvent];
}

- (void)release_action:(UIButton *)sender {
    [self.delegate retreatEvent];
}

- (void)close_action:(UIButton *)sender {
    [self.delegate closeEvent];
}

- (void)refresh_action:(UIButton *)sender {
    [self.delegate refreshEvent];
}

- (void)list_action:(UIButton *)sender {
    [self.delegate listEvent];
}

#pragma mark - 控件代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate startEventWithAddress:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 属性

- (void)setTitle:(NSString *)title {
    self.addressBar.text = title;
    _title = title;
}

#pragma mark - 懒加载

- (UITextField *)addressBar {
    if (!_addressBar) {
        _addressBar = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 30)];
        _addressBar.backgroundColor = [UIColor colorWithWhite:0.810 alpha:1.000];
        _addressBar.center = CGPointMake(self.center.x, self.center.y+8);
        _addressBar.layer.cornerRadius = 5;
        _addressBar.delegate = self;
    }
    return _addressBar;
}

- (UIButton *)advance {
    if (!_advance) {
        _advance = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _advance.frame = CGRectMake(self.frame.size.width/8, 20, self.frame.size.width/8, self.frame.size.height-20);
        [_advance setImage:[[UIImage imageNamed:@"advance"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
        [_advance addTarget:self action:@selector(advance_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _advance;
}

- (UIButton *)retreat {
    if (!_retreat) {
        _retreat = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _retreat.frame = CGRectMake(0, 20, self.frame.size.width/8, self.frame.size.height-20);
        [_retreat setImage:[[UIImage imageNamed:@"retreat"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
        [_retreat addTarget:self action:@selector(release_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retreat;
}

- (UIButton *)close {
    if (!_close) {
        _close = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _close.frame = CGRectMake(self.refresh.frame.size.width+self.refresh.frame.origin.x, 20, self.frame.size.width/12, self.frame.size.height-20);
        [_close setImage:[[UIImage imageNamed:@"close"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(close_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _close;
}

- (UIButton *)refresh {
    if (!_refresh) {
        _refresh = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _refresh.frame = CGRectMake(self.addressBar.frame.origin.x+self.addressBar.frame.size.width, 20, self.frame.size.width/12, self.frame.size.height-20);
        [_refresh setImage:[[UIImage imageNamed:@"image_refresh"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
        [_refresh addTarget:self action:@selector(refresh_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refresh;
}

- (UIButton *)list {
    if (!_list) {
        _list = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _list.frame = CGRectMake(self.close.frame.origin.x+self.close.frame.size.width, 20, self.frame.size.width/12, self.frame.size.height-20);
        [_list setImage:[[UIImage imageNamed:@"imag_list"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_list addTarget:self action:@selector(list_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _list;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
