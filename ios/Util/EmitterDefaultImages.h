//
//  EmitterDefaultImages.h
//  TurboParticle
//
//  Created by mj on 5/18/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef EmitterDefaultImages_h
#define EmitterDefaultImages_h

namespace tp {
UIImage* createEmitterCircle() {
  CGSize imageSize = CGSizeMake(32, 32);
  CGFloat scale = [UIScreen mainScreen].scale;

  UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
  CGContextFillEllipseInRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));

  CGContextRestoreGState(context);
  CGImageRef cgImage = CGBitmapContextCreateImage(context);

  UIGraphicsEndImageContext();

  return [UIImage imageWithCGImage:cgImage];
}

} // namespace tp

#endif /* EmitterDefaultImages_h */
