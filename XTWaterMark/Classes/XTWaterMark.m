//
//  XTWaterMark.m
//  XTWaterMark
//
//  Created by ztong.cheng on 2020/11/17.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import "XTWaterMark.h"

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )



@implementation XTMarkOption

+ (XTMarkOption *)defaultOption {
    XTMarkOption * option = [[XTMarkOption alloc] init];
    option.horizontalSpace = 60;
    option.verticalSpace = 80;
    option.angle = M_PI_2 / 3;
    option.targetSize = CGSizeMake(100, 100);
    return option;
}

- (CGSize)targetSize {
    if (CGSizeEqualToSize(_targetSize, CGSizeZero)) {
        _targetSize = CGSizeMake(100, 100);
    }
    return _targetSize;
}
@end


@implementation XTMark

+ (XTMark *)mark {
    XTMark * mark = [[XTMark alloc] init];
    return mark;
}
- (NSAttributedString *)attributedContent {
    NSDictionary * attribute = @{NSFontAttributeName: self.font,
                                 NSForegroundColorAttributeName :self.textColor};
    NSMutableAttributedString * attributeContent = [[NSMutableAttributedString alloc] initWithString:self.markText attributes:attribute];
    return attributeContent;
}

- (CGSize)boundingSize {
    CGSize size = [self attributedContent].size;
    size.width += (self.margin.left+self.margin.right);
    size.height += (self.margin.top+self.margin.bottom);
    return size;
}

- (NSString *)markText {
    if (!_markText) {
        _markText = @"--";
    }
    return _markText;
}

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont systemFontOfSize:20];
    }
    return _font;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor lightGrayColor];
    }
    return _textColor;
}
@end


@interface XTWaterMark ()

@end



@implementation XTWaterMark


+ (void)visibleWatermark:(UIImage *)image
              completion:(void (^ __nullable)(UIImage * waterMarkImage))completion {
    // 1. Get the raw pixels of the image
    // 定义 32位整形指针 *inputPixels
    UInt32 * inputPixels;

    //转换图片为CGImageRef,获取参数：长宽高，每个像素的字节数（4），每个R的比特数
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger inputWidth = CGImageGetWidth(inputCGImage);
    NSUInteger inputHeight = CGImageGetHeight(inputCGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;

    // 每行字节数
    NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;

    // 开辟内存区域,指向首像素地址
    inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));

    // 根据指针，前面的参数，创建像素层
    CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    //根据目前像素在界面绘制图像
    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);

    // 像素处理
    for (int j = 0; j < inputHeight; j++) {
        for (int i = 0; i < inputWidth; i++) {
            @autoreleasepool {
                UInt32 *currentPixel = inputPixels + (j * inputWidth) + i;
                UInt32 color = *currentPixel;
                UInt32 thisR,thisG,thisB,thisA;
                // 这里直接移位获得RBGA的值,以及输出写的非常好！
                thisR = R(color);
                thisG = G(color);
                thisB = B(color);
                thisA = A(color);

                UInt32 newR,newG,newB;
                newR = [self mixedCalculation:thisR];
                newG = [self mixedCalculation:thisG];
                newB = [self mixedCalculation:thisB];

                *currentPixel = RGBAMake(newR,
                                         newG,
                                         newB,
                                         thisA);
            }
        }
    }
    //创建新图
    // 4. Create a new UIImage
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    //释放
    // 5. Cleanup!
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(inputPixels);
    if (completion) {
        completion(processedImage);
    }
}

+ (int)mixedCalculation:(int)originValue {
    // 结果色 = 基色 —（基色反相×混合色反相）/ 混合色
    int mixValue = 1;
    int resultValue = 0;
    if (mixValue == 0) {
        resultValue = 0;
    } else {
        resultValue = originValue - (255 - originValue) * (255 - mixValue) / mixValue;
    }
    if (resultValue < 0) {
        resultValue = 0;
    }
    return resultValue;
}

+ (void)generateInvisibleWaterMark:(XTMark *)mark
                            option:(XTMarkOption *)option
                        completion:(void (^ __nullable)(UIImage * waterMarkImage))completion {
    NSAssert(mark, @"mark must be not null");
    mark.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.01];
    [self generateWaterMark:mark option:option completion:completion];
}

+ (void)generateWaterMark:(XTMark *)mark
               completion:(void (^ __nullable)(UIImage * waterMarkImage))completion {
    NSAssert(mark, @"mark must be not null");
    [self generateWaterMark:mark option:[XTMarkOption defaultOption] completion:completion];
}

+ (void)generateWaterMark:(XTMark *)mark
                   option:(XTMarkOption *)option
               completion:(void (^ __nullable)(UIImage * waterMarkImage))completion {
    NSAssert(mark, @"mark must be not null");
    [self generateWaterMarks:@[mark] option:option completion:completion];
}

+ (void)generateWaterMarks:(NSArray *)marks
                    option:(XTMarkOption *)option
                completion:(void (^ __nullable)(UIImage * waterMarkImage))completion {
    NSAssert((marks && marks.count != 0), @"mark must be not null");
    CGFloat viewWidth = option.targetSize.width;
    CGFloat viewHeight = option.targetSize.height;
    
    if (option.orginalImage) {
        viewWidth = option.orginalImage.size.width;
        viewHeight = option.orginalImage.size.height;
    }
    //为了防止图片失真，绘制区域宽高和原始图片宽高一样
    UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
    //先将原始image绘制上
    if (option.orginalImage) {
        [option.orginalImage drawInRect:CGRectMake(0, 0, viewWidth, viewHeight)];
    }
    //sqrtLength：原始image的对角线length。在水印旋转矩阵中只要矩阵的宽高是原始image的对角线长度，无论旋转多少度都不会有空白。
    CGFloat sqrtLength = sqrt(viewWidth*viewWidth + viewHeight*viewHeight);
    

    //开始旋转上下文矩阵，绘制水印文字
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (option.angle != 0) {
        //将绘制原点（0，0）调整到源image的中心
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(viewWidth/2, viewHeight/2));
        //以绘制原点为中心旋转
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(option.angle));
        //将绘制原点恢复初始值，保证当前context中心和源image的中心处在一个点(当前context已经旋转，所以绘制出的任何layer都是倾斜的)
        CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-viewWidth/2, -viewHeight/2));
    }
    
    //此处计算出需要绘制水印文字的起始点，由于水印区域要大于图片区域所以起点在原有基础上移
    CGFloat orignX = - (sqrtLength-viewWidth)/2;
    CGFloat orignY = - (sqrtLength-viewHeight)/2;
    
    //在每列绘制时X坐标叠加
    CGFloat tempOrignX = orignX;
    //在每行绘制时Y坐标叠加
    CGFloat tempOrignY = orignY;
    
    CGFloat lineHeight = 0;
    NSInteger tmpIdx = 0;
    while (tmpIdx < marks.count) {
        XTMark * mark = marks[tmpIdx];
        lineHeight = fmaxf(lineHeight, mark.boundingSize.height);
        tmpIdx ++;
    }
    
    tmpIdx = 0;
    while (tempOrignY < sqrtLength) {
        XTMark * mark = marks[tmpIdx];  CGSize size = mark.boundingSize;
        CGFloat diff = (lineHeight - size.height)/2;
        CGRect rect = CGRectMake(tempOrignX + mark.margin.left, tempOrignY + diff + mark.margin.top, size.width, size.height);
        [mark.attributedContent drawInRect:rect];
        if (tempOrignX > sqrtLength) {
            tempOrignX = orignX;
            tempOrignY += (lineHeight + option.verticalSpace);
        }else{
            tempOrignX += (size.width +  option.horizontalSpace);
        }
        tmpIdx++;
        if (tmpIdx >= marks.count) tmpIdx = 0;
    }
    
    //根据上下文制作成图片
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRestoreGState(context);
    if (completion) {
        completion(finalImg);
    }
}

//根据图片获取图片的主色调
+ (UIColor *)mostColor:(UIImage *)image {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(image.size.width/2, image.size.height/2);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
//第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData(context);
    if (data == NULL) return nil;
    NSCountedSet * cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];
    
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha > 0) { //去除透明
                if (red == 255 && green == 255 && blue == 255) { //去除白色
                } else {
                    NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ((curColor = [enumerator nextObject]) != nil) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if (tmpCount < MaxCount) continue;
        MaxCount = tmpCount;
        MaxColor = curColor;
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

@end
