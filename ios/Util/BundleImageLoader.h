//
//  BundleImageLoader.m
//  turbo-particle
//
//  Created by mj on 5/18/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <string>

static inline UIImage* loadBundleImage(std::string name) {
  NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
  NSString* bundlePath = [mainBundlePath stringByAppendingPathComponent:@"TurboParticle.bundle"];
  NSBundle* bundle = [NSBundle bundleWithPath:bundlePath];
  return [UIImage imageNamed:[NSString stringWithUTF8String:name.c_str()]
                           inBundle:bundle
      compatibleWithTraitCollection:nil];
}
