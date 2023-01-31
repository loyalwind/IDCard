
#import <UIKit/UIKit.h>

@interface UIImage (WJExtension)

/**
 *  根据图片返回一张缩放的图片的图片
 */
+ (UIImage *)imageNamed:(NSString *)name withScale:(CGFloat)scale;

/**
 *  根据图片返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(UIImage *)image;


/**
 *  根据图片返回对应字符串
 */
- (NSString *)transformToNSString;

/**
 *  根据图片返回对应压缩好的NSData
 */
+ (NSData *)imageData:(UIImage *)myimage;

/**
 *  根据指定宽度生成缩放图片
 */
- (UIImage *)scaleImageWithWidth:(CGFloat)width;
/**
 *  根据指定宽度生成缩放图片(200kb 以内)
 */
- (UIImage *)scaleImage_200Kb_WithWidth:(CGFloat)width;

/**
 生成一张100x100大小尺寸的图片
 */
- (UIImage *)generateThumbnail_100x100;

/**
 生成一张size大小尺寸的图片
 */
- (UIImage *)generateImageScaleToSize:(CGSize)size;


#pragma mark - 2016.11.11添加
/**
 给一个字符串生成一个二维码图片
 @param string 原始字符串
 @param size   生成的图片宽度
 @return 二维码图片
 */
+ (UIImage *)createQRcodeImageWithString:(NSString *)string size:(CGFloat)size;

/**
 *  根据CIImage生成指定大小的UIImage
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image size:(CGFloat)size;

@end

@interface UIImage (WJRotation)

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

/**
 修复图片被系统旋转的问题(因为大于2M ,从相册或拍照取出的图片，会被自动旋转90°）

 @param aImage 相册，拍照的图片
 @return 返回一个修复方向的图片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end

@interface UIImage (WJResizImage)

+ (UIImage *)resizeWithImageName:(NSString *)name;

@end
