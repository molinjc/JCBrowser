//
//  JCImageSeeView.m
//  图片查看器
//
//

#import "JCImageSeeView.h"

@implementation JCImageSeeView
/**
 *  重写初始化方法
 *
 *  @param frame    位置及大小
 *  @param arrImage 图片数组（包含多个字典）
 *
 *  @return 返回视图对象
 */
-(instancetype)initWithFrame:(CGRect)frame andImageArray:(NSMutableArray *)arrImage{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        self.tally = 0;//设置下标从0开始
        
        self.arrImage = arrImage;//接收传过来的数组
        
        [self creatImageView];
        
        [self creatLabel];
        
        [self createClickView];
        
        [self addSubview:self.lbl_error];
    }
    return self;
}

/**
 *  根据图片地址展示图片
 *
 *  @param path 图片地址
 */
- (void)showToImageWithPath:(NSString *)path {
    for (int i=0; i<self.arrImage.count; i++) {
        NSString *imagePath = self.arrImage[i][@"image"];
        if ([imagePath isEqualToString:path]) {
            self.tally = i;
            self.dic = self.arrImage[self.tally];//获取字典
            [self setImageViewFrameWithPath:self.dic[@"image"]];//重新给图片视图指定图片
            self.lblTally.text = [NSString stringWithFormat:@"%ld/%lu",self.tally+1,(unsigned long)self.arrImage.count];
            self.lblInfo.text = self.dic[@"info"];
            break;
        }
    }
}

/**
 *  根据图片数组刷新图片视图
 */
- (void)reloadImageViewWithImageArray:(NSMutableArray *)array {
    self.arrImage = array;
    if (self.tally >= self.arrImage.count) {
        self.tally = self.arrImage.count-1;
    }
    [self reloadImageView];
}

/**
 *  刷新视图
 */
- (void)reloadImageView {
    if (self.tally < self.arrImage.count) {
        self.dic = self.arrImage[self.tally];//获取字典
        [self setImageViewFrameWithPath:self.dic[@"image"]];//重新给图片视图指定图片
        self.lblTally.text = [NSString stringWithFormat:@"%ld/%lu",self.tally+1,(unsigned long)self.arrImage.count];
        self.lblInfo.text = self.dic[@"info"];
    }else {
        self.tally = 0;
        if (self.arrImage.count > 0) {
            self.dic = self.arrImage[self.tally];//获取字典
            [self setImageViewFrameWithPath:self.dic[@"image"]];//重新给图片视图指定图片
            self.lblTally.text = [NSString stringWithFormat:@"%ld/%lu",self.tally+1,(unsigned long)self.arrImage.count];
            self.lblInfo.text = self.dic[@"info"];
        }else {
            self.imgV.image = [UIImage imageNamed:@""];
            self.lblTally.text = @"0/0";
            self.lblInfo.text = @"";
        }
    }
}

/**
 *  创建图片视图
 */
-(void)creatImageView{
    
    if (self.arrImage.count > 0) {
        self.dic = self.arrImage[self.tally];//读取数组第一个字典
        
        self.imgV = [[UIImageView alloc]init];
        
        [self addSubview:self.imgV];
        
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
        [self.imgV addGestureRecognizer:longPressGestureRecognizer];
        
        self.imgV.userInteractionEnabled = YES;//设置用户交互
        
        [self setImageViewFrameWithPath:self.dic[@"image"]];
    }
//    imgV.multipleTouchEnabled = YES;//设置多点触控开关
    
}

- (void)createClickView {
    self.leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, self.bounds.size.height)];
    self.leftview.backgroundColor = [UIColor clearColor];
    self.leftview.userInteractionEnabled = NO;
    [self addSubview:self.leftview];
    self.rightview = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width-50, 0, 50, self.bounds.size.height)];
    self.rightview.backgroundColor = [UIColor clearColor];
    self.rightview.userInteractionEnabled = NO;
    [self addSubview:self.rightview];
}

- (void)longPressClick:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.delegate selecedImageWithPath:self.dic[@"image"]];
    }
}

/**
 *  创建张数描述标签和图片描述标签
 */
-(void)creatLabel{
    
    self.lblTally = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, self.frame.size.width, 20)];
    self.lblTally.textAlignment = NSTextAlignmentCenter;
    
    self.lblTally.text = [NSString stringWithFormat:@"%ld/%lu",self.tally+1,(unsigned long)self.arrImage.count,nil];
    
    self.lblTally.textColor = [UIColor whiteColor];
    
    [self addSubview:self.lblTally];
    
    self.lblInfo = [[UILabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height-30 , self.frame.size.width, 20)];
    self.lblInfo.textAlignment = NSTextAlignmentCenter;
    
    self.lblInfo.text = self.dic[@"info"];
    
    self.lblInfo.textColor = [UIColor whiteColor];
    
    [self addSubview:self.lblInfo];
}

/**
 *  根据图片路径创建UIImage
 *
 *  @param path 图片路径
 */
- (UIImage *)imageWithPath:(NSString *)path {
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    NSData *data = [fileManage contentsAtPath:self.dic[@"image"]];
    
    UIImage *image = [UIImage imageWithData:data];//从字典读取图片
    
    return image;
}

/**
 *  开始触摸方法
 *
 *  @param touches 触摸点坐标集合
 *  @param event   事件
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if (!self.lbl_error.hidden) {
        self.lbl_error.hidden = !self.lbl_error.hidden;
    }
    
    CGPoint cu = [[touches anyObject]locationInView:self];//获取触摸点在图片视图的坐标
    //判断触摸点在哪边
    if (CGRectContainsPoint(self.rightview.frame, cu))  {
        //判断下标值
        if (self.tally == self.arrImage.count-1) {
            self.tally = 0;
        }else{
            self.tally += 1;
        }
        self.dic = self.arrImage[self.tally];//获取字典
        [self setImageViewFrameWithPath:self.dic[@"image"]];
        self.lblTally.text = [NSString stringWithFormat:@"%ld/%lu",self.tally+1,(unsigned long)self.arrImage.count];
        self.lblInfo.text = self.dic[@"info"];
    }else if (CGRectContainsPoint(self.leftview.frame, cu)) {
        if (self.tally == 0) {
            self.tally =self.arrImage.count-1;
        }else{
           self.tally -= 1;
        }
        self.dic = self.arrImage[self.tally];
        [self setImageViewFrameWithPath:self.dic[@"image"]];
        self.lblTally.text = [NSString stringWithFormat:@"%ld/%lu",self.tally+1,(unsigned long)self.arrImage.count];
        self.lblInfo.text = self.dic[@"info"];
    }
}

/**
 *  根据图片大小摆放位置
 *
 *  @param path 图片路径
 */
- (void)setImageViewFrameWithPath:(NSString *)path {
    UIImage *image = [self imageWithPath:path];//重新给图片视图指定图片
    
    if (!image) {
        self.lbl_error.hidden = NO;
        self.lbl_error.text = [NSString stringWithFormat:@"该文件无内容"];
    }
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat multiple = 0;
    if (image.size.width < width) {
        width = image.size.width;
        if (image.size.height < height) {
            height = image.size.height;
        }else {
            multiple = image.size.width / width + 0.35;
            width = image.size.width / multiple;
            height = image.size.height / multiple;
        }
    }else {
        multiple = image.size.width / width + 0.35;
        width = image.size.width / multiple;
        height = image.size.height / multiple;
    }
   
    
    self.imgV.frame = CGRectMake(0, 0, width, height);
    self.imgV.center = CGPointMake(self.center.x, self.center.y-60);
    self.imgV.image = image;
}

- (UILabel *)lbl_error {
    if (!_lbl_error) {
        _lbl_error = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
        _lbl_error.center = self.center;
        _lbl_error.textColor = [UIColor whiteColor];
        _lbl_error.hidden = YES;
    }
    return _lbl_error;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
