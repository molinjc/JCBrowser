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
-(instancetype)initWithFrame:(CGRect)frame andImageArray:(NSArray *)arrImage{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        self.tally = 0;//设置下标从0开始
        
        self.arrImage = arrImage;//接收传过来的数组
        
        [self creatImageView];
        
        [self creatLabel];
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
        
        self.imgV.userInteractionEnabled = YES;//设置用户交互
        
        [self setImageViewFrameWithPath:self.dic[@"image"]];
    }
    
    
//    imgV.multipleTouchEnabled = YES;//设置多点触控开关
    
}
/**
 *  创建张数描述标签和图片描述标签
 */
-(void)creatLabel{
    
    self.lblTally = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-25, 8, 50, 20)];
    
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

    CGPoint cu = [[touches anyObject]locationInView:self.imgV];//获取触摸点在图片视图的坐标
    //判断触摸点在哪边
    if (cu.x > self.frame.size.width/2) {
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
    }else if(cu.x < self.frame.size.width/2){
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
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    if (image.size.width < width) {
        width = image.size.width;
    }
    if (image.size.height < height) {
        height = image.size.height;
    }
    
    self.imgV.frame = CGRectMake(0, 0, width, height);
    self.imgV.center = self.center;
    self.imgV.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
