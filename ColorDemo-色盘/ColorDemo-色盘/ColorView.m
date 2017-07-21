//
//  ColorView.m
//  ColorDemo-色盘
//
//  Created by cxb on 2017/5/16.
//  Copyright © 2017年 pgq. All rights reserved.
//

#import "ColorView.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)




/**
 颜色block回调
 
 @param color 回调
 */
typedef void(^ColorViewBlock)(UIColor *color);
typedef void(^ColorViewYWBlock)(CGFloat nowValue);
typedef void(^ColorViewProgressBlock)(CGFloat value);

#pragma UIImage - 类别

@interface UIImage (rotate)
- (UIImage *)imageRotated;
@end

@implementation UIImage (rotate)

/** 将图片旋转弧度radians */
- (UIImage *)imageRotated
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    rotatedViewBox.transform = CGAffineTransformMakeRotation(RADIANS_TO_DEGREES(-90.005));
    CGSize rotatedSize = rotatedViewBox.bounds.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextConcatCTM(bitmap, rotatedViewBox.transform);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end


#pragma UIPickerView - 类别
@implementation UIPickerView (pgqViewExtension)


- (void)clearSpearatorLine
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView  *_Nonnull obj, NSUInteger idx, BOOL  * _Nonnull stop) {
        if (obj.frame.size.height < 2)
        {
            [obj removeFromSuperview];
        }
    }];
}

@end

#pragma UIView - 类别属性

@interface UIView (pgqViewExtension)
@property (nonatomic, assign) CGFloat pq_x;
@property (nonatomic, assign) CGFloat pq_y;
@property (nonatomic, assign) CGFloat pq_centerX;
@property (nonatomic, assign) CGFloat pq_centerY;
@property (nonatomic, assign) CGFloat pq_width;
@property (nonatomic, assign) CGFloat pq_height;
@property (nonatomic, assign) CGSize  pq_size;
@property (nonatomic, assign) CGPoint pq_origin;
@end

@implementation UIView (pgqViewExtension)
- (void)setPq_x:(CGFloat)pq_x
{
    CGRect frame = self.frame;
    frame.origin.x = pq_x;
    self.frame = frame;
}

- (void)setPq_y:(CGFloat)pq_y
{
    CGRect frame = self.frame;
    frame.origin.y = pq_y;
    self.frame = frame;
}
- (CGFloat)pq_x
{
    return self.frame.origin.x;
}

- (CGFloat)pq_y
{
    return self.frame.origin.y;
}

- (void)setPq_centerX:(CGFloat)pq_centerX
{
    CGPoint center = self.center;
    center.x = pq_centerX;
    self.center = center;
}

- (CGFloat)pq_centerX
{
    return self.center.x;
}

- (void)setPq_centerY:(CGFloat)pq_centerY
{
    CGPoint center = self.center;
    center.y = pq_centerY;
    self.center = center;
}

- (CGFloat)pq_centerY
{
    return self.center.y;
}

- (void)setPq_width:(CGFloat)pq_width
{
    CGRect frame = self.frame;
    frame.size.width = pq_width;
    self.frame = frame;
}

- (void)setPq_height:(CGFloat)pq_height
{
    CGRect frame = self.frame;
    frame.size.height = pq_height;
    self.frame = frame;
}

- (CGFloat)pq_height
{
    return self.frame.size.height;
}

- (CGFloat)pq_width
{
    return self.frame.size.width;
}

- (void)setPq_size:(CGSize)pq_size
{
    CGRect frame = self.frame;
    frame.size = pq_size;
    self.frame = frame;
}

- (CGSize)pq_size
{
    return self.frame.size;
}

- (void)setPq_origin:(CGPoint)pq_origin
{
    CGRect frame = self.frame;
    frame.origin = pq_origin;
    self.frame = frame;
}

- (CGPoint)pq_origin
{
    return self.frame.origin;
}
@end


#pragma mark - 类别，主要用于获取颜色的HSB

@implementation UIColor (ColorView)

/**
 获取颜色的HSB
 
 @return 字典
 */
- (NSDictionary *)getHSBAValue{
    
    CGFloat h=0,s=0,b=0,a=0;
    
    if ([self respondsToSelector:@selector(getHue:saturation:brightness:alpha:)]) {
        [self getHue:&h saturation:&s brightness:&b alpha:&a];
    }
    
    return @{@"H":@(h),@"S":@(s),@"B":@(b),@"A":@(a)};
}
@end

#pragma mark - 用于单调光的时候显示

@interface ColorProgressView : UIView

@property (nonatomic, strong) UILabel *nowProgressLabel;

- (void)updateProgress:(CGFloat)value;
@end

@implementation ColorProgressView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _nowProgressLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _nowProgressLabel.textAlignment = NSTextAlignmentCenter;
    _nowProgressLabel.textColor = [UIColor orangeColor];
    _nowProgressLabel.font = [UIFont systemFontOfSize:22];
    [self addSubview:_nowProgressLabel];
}

- (void)updateProgress:(CGFloat)value{
    _nowProgressLabel.text = [NSString stringWithFormat:@"%.2f%%",(1 - ABS(value)) * 100];
}

@end


#pragma mark - 用来显示颜色指示器，弧形三角形

@interface ColorPointerView : UIView
@property (nonatomic, strong) UIImageView *pointerImgView;
@property (nonatomic, assign) ColorViewType colorType;
@end

@implementation ColorPointerView{
    UIColor * _strokColor;
}

- (void)setColorType:(ColorViewType)colorType{
    _colorType = colorType;
    _strokColor = (colorType == RGB_Hue_Brightness) ? [UIColor whiteColor] : [UIColor greenColor];
    
    [self drawPointer];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawPointer{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(wSelf.bounds.size, NO, [UIScreen mainScreen].scale);
        [wSelf drawTriangle];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            wSelf.pointerImgView = [[UIImageView alloc] initWithImage:image];
            [wSelf addSubview:wSelf.pointerImgView];
        });
        
    });
}

- (void)drawTriangle{
    [_strokColor setStroke];
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.pq_width startAngle:DEGREES_TO_RADIANS(-110) endAngle:DEGREES_TO_RADIANS(-70) clockwise:YES];
    [path addLineToPoint:CGPointMake(self.pq_centerX, self.pq_width * 0.1)];
    [path closePath];
    path.lineWidth = 1.5;
    [path stroke];
    
}

@end


#pragma mark - PickerView 选择亮度
@interface PickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIColor *nowColor;
@property (nonatomic, copy)   ColorViewBlock nowColorBlock;
@property (nonatomic, copy)   ColorViewYWBlock wBlock;


- (void)getColor:(ColorViewBlock)block;
- (void)getWValueBlock:(ColorViewYWBlock)wBlock;
@end

@implementation PickerView


- (void)setNowColor:(UIColor *)nowColor{
    _nowColor = nowColor;
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect newFrame = frame;
    newFrame.size.width = frame.size.width * 0.45;
    newFrame.size.height = newFrame.size.width;
    newFrame.origin.x = (frame.size.width - newFrame.size.width) * 0.5;
    newFrame.origin.y = (frame.size.height - newFrame.size.width) * 0.5;
    self = [super initWithFrame:newFrame];
    if (self) {
        self.layer.cornerRadius = newFrame.size.width * 0.5;
        self.layer.masksToBounds = YES;
        
        [self addBackgroundColor:frame];
        self.pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
    }
    return self;
}

- (void)addBackgroundColor:(CGRect)frame{
    CAGradientLayer * layer = [CAGradientLayer layer];
    layer.bounds = frame;
    
    layer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor blackColor].CGColor];
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.locations = @[@(0.5),@(1)];
    
    [self.layer addSublayer:layer];
}

- (void)getColor:(ColorViewBlock)block{
    self.nowColorBlock = block;
}

- (void)getWValueBlock:(ColorViewYWBlock)wBlock{
    self.wBlock = wBlock;
}

#pragma mark - PickerView 代理
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 100;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel * label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%zd",100 - row ];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [pickerView clearSpearatorLine];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.nowColorBlock) {
        NSDictionary * dict = [[self nowColor] getHSBAValue];
        CGFloat brightness = 1 - (row )/125.0;
        UIColor * backColor = [UIColor colorWithHue:[dict[@"H"] floatValue] saturation:[dict[@"S"] floatValue] brightness:brightness < 0.15 ? 0.18 : brightness alpha:1];
        self.nowColorBlock(backColor);
        CGFloat value = 0.01 * (100 - row);
        self.wBlock(value);
    }
}

@end


#pragma mark - 扇形View

@interface SectorView : UIView
@property (nonatomic, strong) UIColor *nowColor;
@property (nonatomic, copy)   ColorViewBlock nowColorBlock;
@property (nonatomic, copy)   ColorViewYWBlock yBlock;
@property (nonatomic, strong) UIImageView *saturationView;
@property (nonatomic, strong) UIImageView *imgView;

- (void)getColor:(ColorViewBlock)block;
- (void)getYValueBlock:(ColorViewYWBlock)yBlock;

@end

@implementation SectorView{
    CGFloat _h,_s,_b;
    CGFloat _minX;
}


/**
 初始化 HSB
 
 @param frame frame
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _b = 0.9921568627450981;
        _h = 0.1650246305418719;
        _s = 0.8023715415019763;
        
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imgView];
        [self drawSectorImage];
        
        
        _saturationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch"]];
        CGFloat value = self.pq_width * 0.1;
        _saturationView.pq_size = CGSizeMake(value, value);
        [self resultOriginSlidImageView:88];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(saturationPanEvent:)];
        _saturationView.userInteractionEnabled = YES;
        [_saturationView addGestureRecognizer:pan];
        
        [self addSubview:_saturationView];
        
    }
    return self;
}

- (void)resultOriginSlidImageView:(CGFloat)angle{
    
    
    CGFloat nowAngle = angle < 43 ? 43: angle;
    nowAngle = nowAngle > 137 ? 137 : nowAngle;
    
    CGFloat valueX = (self.pq_width - self.pq_width * 0.1) * 0.5 ;
    CGFloat valueY = (self.pq_height - self.pq_width * 0.1) * 0.5;
    
    CGFloat x = valueX + valueX * cos(DEGREES_TO_RADIANS(nowAngle));
    CGFloat y = valueY + valueY * sin(DEGREES_TO_RADIANS(nowAngle));
    _saturationView.pq_origin = CGPointMake(x,y);
    
    if (self.nowColorBlock) {
        CGFloat a = (nowAngle - 43) / 10000 * nowAngle;
        UIColor * backColor = [UIColor colorWithHue: _h saturation:1.0 - a brightness:1 alpha:1];
        self.nowColorBlock(backColor);
        
    }
}

- (void)saturationPanEvent:(UIPanGestureRecognizer *)pan{
    CGPoint currentTouch = [pan locationInView:self];
    CGFloat angle =  RADIANS_TO_DEGREES(pToA(currentTouch, self));
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
        {
            //计算位置
            [self resultOriginSlidImageView:angle];
            CGFloat nowAngle = angle < 43 ? 43: angle;
            nowAngle = nowAngle > 144 ? 144 : nowAngle;
            CGFloat a = (nowAngle - 43) / 10000 * nowAngle;
            self.yBlock(a < 0.01 ? 0.01 : a);
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            break;
        }
            
        default:
            break;
    }
}

static CGFloat pToA (CGPoint loc, UIView* self) {
    CGPoint c = CGPointMake(CGRectGetMidX(self.bounds),
                            CGRectGetMidY(self.bounds));
    
    return atan2(loc.y - c.y, loc.x - c.x);
}

- (void)getColor:(ColorViewBlock)block{
    self.nowColorBlock = block;
}

- (void)getYValueBlock:(ColorViewYWBlock)yBlock{
    self.yBlock = yBlock;
}

/**
 判断触点
 
 @param point 点
 @param event 时间
 @return 是否可以响应
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event{
    BOOL isTouch = point.y > self.frame.size.height * 0.7;
    //    NSLog(@"是否 (%d)",isTouch);
    return isTouch;
}


/**
 画扇形区域
 */
- (void)drawSectorView{
    
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radiur = self.frame.size.width;
    CGFloat saturation = 1;
    for (int hue = 220; hue <= 320; hue++) {
        CGFloat secA = (hue) / 180.0 * M_PI + M_PI;
        CGFloat a = radiur * sin(secA);
        CGFloat b = radiur * cos(secA);
        CGPoint toPoint = CGPointMake(b * 0.5 + center.x, a * 0.5 + center.y);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = (hue == 220) ? 0 : 10;
        [path moveToPoint:CGPointMake(b * 0.25 + center.x, a * 0.25 + center.y)];
        [path addLineToPoint:toPoint];
        [path stroke];
        [[UIColor colorWithHue:0.1650246305418719 saturation:saturation brightness:0.9921568627450981 alpha:1.0] setStroke];
        saturation -= 0.01;
    }
}

- (void)drawSectorImage{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(wSelf.bounds.size, NO, [UIScreen mainScreen].scale);
        [wSelf drawSectorView];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            wSelf.imgView.image = image;
        });
        
    });
}

@end


#pragma mark - 圆形颜色View 圆环View

@interface CircleView : UIView
/// 颜色类型
@property (nonatomic, assign) ColorViewType colorType;
/// 用作与反馈颜色出去
@property (nonatomic, strong) ColorViewBlock block;
/// 用作与显示百分比
@property (nonatomic, strong) ColorViewProgressBlock progressBlock;
/// 圆环图片
@property (nonatomic, strong) UIImageView *imgView;
/// 偏移角度
@property (nonatomic, assign) CGFloat offseteDegree;
/// 上一次偏移角度
@property (nonatomic, assign) CGFloat lastDegree;

///反馈颜色方法
- (void)nowColor:(void(^)(UIColor * color))block;

@end

/// 定义渐变色
typedef NS_ENUM(NSUInteger, DrawType) {
    whiteToBlack = 0,
    blackToWhite,
    whiteToWhite,
};

@implementation CircleView{
    int _defaultDegress;
    CGFloat _b;
    CGFloat _h;
    CGFloat _s;
    BOOL _isHasProgressBlock;
}




- (void)setProgressBlock:(ColorViewProgressBlock)progressBlock{
    _progressBlock = progressBlock;
    if (progressBlock) {
        _isHasProgressBlock = YES;
    }
}

- (void)setColorType:(ColorViewType)colorType{
    _colorType = colorType;
    if (colorType == Hue_Brightness) {
        _b = 0.9921568627450981;
        _h = 0.1650246305418719;
        _s = 0.8023715415019763;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imgView];
        
        _defaultDegress = -270;
        [self drawImage];
        
        //        self.imgView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(_defaultDegress));
        
        [self drawBlurImageView];
    }
    return self;
}

- (void)drawBlurImageView{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage * img1 = [wSelf drawBlurImageView1:whiteToBlack];
        UIImage * img2 = [wSelf drawBlurImageView1:blackToWhite];
        UIImage * img3 = [wSelf drawBlurImageView1:whiteToWhite];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView * btwImgView = [[UIImageView alloc] initWithFrame:wSelf.bounds];;
            btwImgView.image = img1;
            
            UIImageView * btwImgView1 = [[UIImageView alloc] initWithFrame:wSelf.bounds];;
            btwImgView1.image = img2;
            
            UIImageView * btwImgView2 = [[UIImageView alloc] initWithFrame:wSelf.bounds];;
            btwImgView2.image = img3;
            
            
            if (wSelf.colorType == RGB_Hue_Brightness) {
                [wSelf addSubview:btwImgView];
            }
            //            [wSelf addSubview:btwImgView1];
            //            [wSelf addSubview:btwImgView2];
        });
    });
}

- (UIImage*)drawBlurImageView1:(DrawType)type{
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGAffineTransform transform = CGAffineTransformMakeTranslation(self.pq_centerX, self.pq_centerY);
    /*
     CGMutablePathRef cg_nullable path, 路径
     const CGAffineTransform * __nullable m, CGAffineTransform
     CGFloat x, x坐标
     CGFloat y, 有坐标
     CGFloat radius, 半径
     CGFloat startAngle,  开始角度
     CGFloat endAngle, 结束角度
     bool clockwise 是否反向
     */
    CGPathAddArc(path, &transform, 0, 0, self.pq_width * 0.5, 0, 2 * M_PI, NO);
    //绘制渐变
    switch (type) {
        case whiteToBlack:
            [self drawRadialGradient:gc path:path startColor:[UIColor colorWithWhite:1 alpha:0.4].CGColor endColor:[UIColor colorWithWhite:1 alpha:0.1].CGColor];
            break;
        case blackToWhite:
            [self drawRadialGradient:gc path:path startColor:[UIColor colorWithWhite:0 alpha:0.1].CGColor endColor:[UIColor colorWithWhite:1 alpha:0.5].CGColor];
            break;
            
        default:
            [self drawRadialGradient:gc path:path startColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor endColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor];
            break;
    }
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
}

- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextSetLineWidth(context, 10);
    
    ///参数解释：
    /*
     1 上下文
     2 颜色CGGradientRef对象
     3 起点的中点
     4 起点的半径
     5 终点的中点
     6 终点的半径
     7 模式
     */
    CGContextDrawRadialGradient(context,
                                gradient,
                                center,
                                center.x * 0.52,
                                center,
                                center.x * 1.1,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


- (void)drawImage{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(wSelf.bounds.size, NO, [UIScreen mainScreen].scale);
        [wSelf drawCircleView];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (wSelf.colorType == Hue_Brightness || wSelf.colorType == Brightness) {
                wSelf.imgView.image = [image imageRotated];
            }else
                wSelf.imgView.image = image;
        });
        
    });
}

/**
 获取当前选中的颜色
 
 @param block 回调
 */
- (void)nowColor:(void(^)(UIColor * color))block{
    self.block = block;
}

/**
 绘制圆环
 */
- (void)drawCircleView{
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radiur = self.frame.size.width;
    
    for (int hue = 0; hue <= 360; hue++) {
        CGFloat secA = (hue) / 180.0 * M_PI + M_PI;
        CGFloat a = radiur * sin(secA);
        CGFloat b = radiur * cos(secA);
        CGPoint toPoint = CGPointMake(b * 0.5 + center.x, a * 0.5 + center.y);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 10;
        [path moveToPoint:CGPointMake(b * 0.25 + center.x, a * 0.25 + center.y)];
        [path addLineToPoint:toPoint];
        [path stroke];
        switch (_colorType) {
            case RGB_Hue_Brightness:
            {
                [[UIColor colorWithHue:(1.0 * hue / 360) saturation:1.0 brightness:1.0 alpha:1.0] set];
            }
                break;
            case Hue_Brightness:
            {
                CGFloat value = (hue<=180)?(_s * hue / 180):(_s * (360 - hue) / 180);
                [[UIColor colorWithHue:_h saturation:value brightness:_b alpha:1.0] set];
            }
                break;
            case Brightness:
            {
                CGFloat value = (hue<=180)?(1.0 * hue / 180):(1.0 * (360 - hue) / 180);
                [[UIColor colorWithHue:1 saturation:0 brightness:1.0 - value alpha:1.0] set];
            }
                break;
                
            default:
                break;
        }
        
    }
    
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:touch.view];//当前手指的坐标
    CGPoint previousPoint = [touch previousLocationInView:touch.view];//上一个坐标
    
    
    _offseteDegree += ([self mDegree:currentPoint] - [self mDegree:previousPoint]);
    int temp = (int)(_lastDegree + _offseteDegree + 0) % 360;
    
    
    self.imgView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(temp));
    UIColor * color = nil;
    switch (_colorType) {
        case RGB_Hue_Brightness:
        {
            CGFloat h = (360-temp)/360.0 + 0.25;
            //            CGFloat hue = (360-temp)/360.0;//使用这个方法就需要把图片进行旋转
            color = [UIColor colorWithHue:h>1 ? h - 1.0 : h saturation:1 brightness:1 alpha:1];
        }
            break;
        case Hue_Brightness:
        {
            CGFloat s = (temp <= 180)?(_s * temp / 180):(_s * (360 - temp) / 180);
            color = [UIColor colorWithHue:_h saturation:s > _s ? _s : s  brightness:_b alpha:1];
        }
            break;
            
        default:{
            CGFloat b = (temp<=180)?(1.0 * temp / 180):(1.0 * (360 - temp) / 180);
            if (_isHasProgressBlock) {
                self.progressBlock(b);
            }
            b = 1 - b;
            color = [UIColor colorWithHue:1 saturation:0 brightness:b > 1 ? 1 : b alpha:1];
        }
            break;
    }
    if (self.block) {
        self.block(color);
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _lastDegree += _offseteDegree;
    _offseteDegree = 0;
    _lastDegree = (int)_lastDegree % 360;
}

- (float)mDegree:(CGPoint)e{
    float x = e.x - self.pq_width * 0.5;
    float y = e.y - self.pq_width * 0.5;
    
    return RADIANS_TO_DEGREES(atan2f(y, x) + 180);
}


@end

#pragma mark - ColorView  baseView

typedef void(^ColorYWBlock)(CGFloat y,CGFloat w);

@interface ColorView ()
///颜色block
@property (nonatomic, copy) ColorViewBlock block;
///色温block
@property (nonatomic, copy) ColorViewBlock showColorblock;
///返回当前的色温／饱和度值
@property (nonatomic, copy) ColorYWBlock ybBlock;
@property (nonatomic, copy) ColorViewProgressBlock onlyBrightnessBlock;
///扇形view
@property (nonatomic, strong) SectorView *sectorView;
///圆环View
@property (nonatomic, strong) CircleView *circleView;
///亮度选择
@property (nonatomic, strong) PickerView * pickerView;
///颜色选择指示器
@property (nonatomic, strong) ColorPointerView *pointerView;
///单调光标题
@property (nonatomic, strong) ColorProgressView *progressView;
///当前颜色
@property (nonatomic, strong) UIColor *nowColor;
///色温参数 - 亮度
@property (nonatomic, assign) CGFloat brightness;
///色温参数 - 色温
@property (nonatomic, assign) CGFloat hue;
///用来判断是否是选择色温中
@property (nonatomic, assign) BOOL isSetYW;
@end

@implementation ColorView

+ (instancetype)createWithFrmae:(CGRect)frame colorType:(ColorViewType)type{
    ColorView * colorView = [[ColorView alloc] initWithFrame:frame];
    colorView.colorType = type;
    [colorView setup];
    return colorView;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}


- (void)setup{
    __weak typeof(self) weakSelf = self;
    //颜色 圆环
    self.circleView = [[CircleView alloc] initWithFrame:self.bounds];
    self.circleView.colorType = self.colorType;
    self.circleView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.circleView];
    
    //三角形
    self.pointerView = [[ColorPointerView alloc] initWithFrame:self.bounds];
    self.pointerView.colorType = self.colorType;
    [self addSubview:self.pointerView];
    
    switch (_colorType) {
        case RGB_Hue_Brightness:
        {
            //饱和度 扇形
            self.sectorView = [[SectorView alloc] initWithFrame:self.bounds];
            self.sectorView.backgroundColor = [UIColor clearColor];
            [self addSubview:self.sectorView];
            
            //亮度 pickerview
            self.pickerView = [[PickerView alloc] initWithFrame:self.bounds];
            [self addSubview:self.pickerView];
            
            self.brightness = 1;
            self.hue = 0.5;
        }
            break;
        case Hue_Brightness:
        {
            //亮度 pickerview
            self.pickerView = [[PickerView alloc] initWithFrame:self.bounds];
            [self addSubview:self.pickerView];
        }
            break;
            
        default:{
            CGFloat width = self.pq_width * 0.4;
            CGFloat height = self.pq_height * 0.4;
            self.progressView = [[ColorProgressView alloc] initWithFrame:CGRectMake((self.pq_width - width) * 0.5, (self.pq_height - height) * 0.5, width, height)];
            [self addSubview:self.progressView];
            [self.progressView updateProgress:0];
            
            self.circleView.progressBlock = ^(CGFloat value) {
                [weakSelf.progressView updateProgress:value];
                if (weakSelf.onlyBrightnessBlock) {
                    weakSelf.onlyBrightnessBlock(value);
                }
            };
        }
            break;
    }
    
    
    
    
    //返回颜色 当前颜色
    [self.circleView nowColor:^(UIColor *color) {
        weakSelf.isSetYW = NO;
        
        //设置饱和度View
        weakSelf.sectorView.nowColor = color;
        
        //把颜色存到pickerView中，当pickerView拖动就返回颜色出去
        weakSelf.pickerView.nowColor = color;
        
        //        weakSelf.circleView.backgroundColor = color;
        
        //返回颜色
        if (weakSelf.block) {
            weakSelf.block(color);
        }
    }];
    
    
    //返回颜色 饱和度
    [self.sectorView getColor:^(UIColor *color) {
        weakSelf.isSetYW = YES;
        //把颜色存到pickerView中，当pickerView拖动就返回颜色出去
        weakSelf.pickerView.nowColor = color;
        
        //        weakSelf.circleView.backgroundColor = color;
        
        if (weakSelf.showColorblock) {
            weakSelf.showColorblock(color);
        }
    }];
    
    //返回YW 主要是 hue
    [self.sectorView getYValueBlock:^(CGFloat nowValue) {
        weakSelf.hue = nowValue > 1 ? 1 : nowValue;
        weakSelf.hue = weakSelf.hue < 0.01 ? 0.01 : weakSelf.hue;
        weakSelf.brightness = 1;
        if (weakSelf.ybBlock) {
            weakSelf.ybBlock(weakSelf.brightness, weakSelf.hue);
        }
    }];
    
    //返回颜色 亮度
    [self.pickerView getColor:^(UIColor *color) {
        //        self.circleView.backgroundColor = color;
        if (weakSelf.block) {
            weakSelf.block(color);
        }
    }];
    
    //返回YW 主要是brightness
    [self.pickerView getWValueBlock:^(CGFloat nowValue) {
        if (weakSelf.isSetYW == NO) {
            return ;
        }
        weakSelf.brightness = nowValue > 1 ? 1 : nowValue;
        weakSelf.brightness = weakSelf.brightness < 0.01 ? 0.01 : weakSelf.brightness;
        if (weakSelf.ybBlock) {
            weakSelf.ybBlock(weakSelf.brightness, weakSelf.hue);
        }
    }];
    
    
}

- (void)nowColor:(void(^)(UIColor * color))block{
    self.block = block;
}

- (void)showNowColor:(void(^)(UIColor * color))block{
    self.showColorblock = block;
}

- (void)nowYW:(void(^)(CGFloat brightness , CGFloat hue))block{
    self.ybBlock = block;
}

- (void)onlyBrightness:(void(^)(CGFloat brightness))block{
    self.onlyBrightnessBlock = block;
}


@end



