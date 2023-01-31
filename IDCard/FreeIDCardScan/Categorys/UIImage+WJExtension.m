

#import "UIImage+WJExtension.h"

@implementation UIImage (WJExtension)
/**
 *  根据图片返回对应字符串
 */
- (NSString *)transformToNSString
{
    NSData * _data = UIImageJPEGRepresentation(self, 1.0f);
    NSString * encodedImageStr = [_data base64Encoding];
    return encodedImageStr;
}

+ (NSData *)imageData:(UIImage *)myimage;
{
    NSData *data = UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>4*1024*1024) {//4M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}

+ (UIImage *)imageNamed:(NSString *)name withScale:(CGFloat)scale
{
    UIImage *image = [UIImage imageNamed:name];
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
}

+ (UIImage *)resizedImage:(UIImage *)image
{
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
- (UIImage *)scaleImageWithWidth:(CGFloat)width
{
    if (width <= 0) {
        return nil;
    }
    
    CGFloat height = self.size.height / self.size.width * width;
    
    CGSize size = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:(CGRect){CGPointZero, size}];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)generateThumbnail_100x100
{
    return [self generateImageScaleToSize:CGSizeMake(100, 100)];
}

- (UIImage *)generateImageScaleToSize:(CGSize)size
{
    CGSize scaledSize = size;
    
    CGFloat widthFactor = size.width / self.size.width;
    CGFloat heightFactor = size.height / self.size.height;
    CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
    scaledSize.width = self.size.width * scaleFactor;
    scaledSize.height = self.size.height * scaleFactor;
    
    UIGraphicsBeginImageContext(scaledSize);
    
    [self drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (UIImage *)scaleImage_200Kb_WithWidth:(CGFloat)width
{
    UIImage *image = [self scaleImageWithWidth:width];
    NSData *data = UIImageJPEGRepresentation(image,1.0);
    if (data.length > 200 * 1024) {
        data = [UIImage imageData:image];
        return [[UIImage alloc] initWithData:data];
    }else{
        return image;
    }
}

+ (UIImage *)createQRcodeImageWithString:(NSString *)string size:(CGFloat)size
{
    if (string.length == 0) return nil;
    // 1.创建过滤器
    CIFilter *filter =  [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) return nil;
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5.显示二维码
    return [self createNonInterpolatedUIImageFormCIImage:outputImage size:size];
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image size:(CGFloat)size
{
    if (!image || size <= 0)return nil;
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef csRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapCxtRef = CGBitmapContextCreate(nil, width, height, 8, 0, csRef, (CGBitmapInfo)kCGImageAlphaNone);
    CGImageRef imageRef = [CIContext.context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapCxtRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapCxtRef, scale, scale);
    CGContextDrawImage(bitmapCxtRef, extent, imageRef);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(bitmapCxtRef);
    UIImage *returnImage = [UIImage imageWithCGImage:scaledImageRef];
    
    // 3.释放内存
    CGContextRelease(bitmapCxtRef);
    CGImageRelease(imageRef);
    CGImageRelease(scaledImageRef);
    CGColorSpaceRelease(csRef);
    
    return returnImage;
}

@end

@implementation UIImage (WJRotation)

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    
    long double rotate = 0.0;
    
    CGRect rect;
    
    float translateX = 0;
    
    float translateY = 0;
    
    float scaleX = 1.0;
    
    float scaleY = 1.0;
    
    
    
    switch (orientation) {
            
        case UIImageOrientationLeft:
            
            rotate = M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = 0;
            
            translateY = -rect.size.width;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationRight:
            
            rotate = 3 * M_PI_2;
            
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            
            translateX = -rect.size.height;
            
            translateY = 0;
            
            scaleY = rect.size.width/rect.size.height;
            
            scaleX = rect.size.height/rect.size.width;
            
            break;
            
        case UIImageOrientationDown:
            
            rotate = M_PI;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = -rect.size.width;
            
            translateY = -rect.size.height;
            
            break;
            
        default:
            
            rotate = 0.0;
            
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            translateX = 0;
            
            translateY = 0;
            
            break;
            
    }
    
    
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextRotateCTM(context, rotate);
    
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newPic;
    
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end


@implementation UIImage (WJResizImage)

+ (UIImage *)resizeWithImageName:(NSString *)name
{
    UIImage *normal = [UIImage imageNamed:name];
    
    //    CGFloat w = normal.size.width * 0.5f ;
    //    CGFloat h = normal.size.height *0.5f ;
    
    CGFloat w = normal.size.width*0.5;
    CGFloat h = normal.size.height*0.5;
    //传入上下左右不需要拉升的边距，只拉伸/填铺中间部分
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
    
    //    [normal resizableImageWithCapInsets:UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)]
    
    // 1 = width - leftCapWidth  - right
    // 1 = height - topCapHeight  - bottom
    
    //传入上下左右不需要拉升的编剧，只拉伸中间部分，并且传入模式（平铺/拉伸）
    //    [normal :<#(UIEdgeInsets)#> resizingMode:<#(UIImageResizingMode)#>]
    
    //只用传入左边和顶部不需要拉伸的位置，系统会算出右边和底部不需要拉升的位置。并且中间有1X1的点用于拉伸或者平铺
    // 1 = width - leftCapWidth  - right
    // 1 = height - topCapHeight  - bottom
    //    return [normal stretchableImageWithLeftCapWidth:w topCapHeight:h];
}

@end
