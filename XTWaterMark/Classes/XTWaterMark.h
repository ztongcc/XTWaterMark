//
//  XTWaterMark.h
//  XTWaterMark
//
//  Created by ztong.cheng on 2020/11/17.
//  Copyright (c) 2020 zt.cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XTMarkOption : NSObject

@property (nonatomic, strong) UIImage * orginalImage;

@property (nonatomic, assign) CGSize targetSize;
/* Return a transform which rotates by `angle' radians:
     t' = [ cos(angle) sin(angle) -sin(angle) cos(angle) 0 0 ] */
// 默认  M_PI_2 / 3
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, assign) CGFloat horizontalSpace;
@property (nonatomic, assign) CGFloat verticalSpace;

+ (XTMarkOption *)defaultOption;

@end



@interface XTMark : NSObject

@property (nonatomic,   copy) NSString * markText;
@property (nonatomic, strong) UIFont   * font;
@property (nonatomic, strong) UIColor  * textColor;

// 外边距
@property (nonatomic, assign) UIEdgeInsets margin;

+ (XTMark *)mark;

- (NSAttributedString *)attributedContent;

- (CGSize)boundingSize;

@end




@interface XTWaterMark : NSObject

// 显示不可见的水印
+ (void)visibleWatermark:(UIImage *)image
              completion:(void (^ __nullable)(UIImage * image))completion;

// 生成不可见的水印
+ (void)generateInvisibleWaterMark:(XTMark *)mark
                            option:(XTMarkOption *)option
                        completion:(void (^ __nullable)(UIImage * waterMarkImage))completion;


+ (int)mixedCalculation:(int)originValue;


+ (void)generateWaterMark:(XTMark *)mark
               completion:(void (^ __nullable)(UIImage * waterMarkImage))completion;

+ (void)generateWaterMark:(XTMark *)mark
                   option:(XTMarkOption *)option
               completion:(void (^ __nullable)(UIImage * waterMarkImage))completion;

+ (void)generateWaterMarks:(NSArray *)marks
                    option:(XTMarkOption *)option
                completion:(void (^ __nullable)(UIImage * waterMarkImage))completion;

@end

NS_ASSUME_NONNULL_END
