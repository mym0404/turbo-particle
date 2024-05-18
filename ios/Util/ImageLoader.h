//
//  BundleImageLoader.m
//  turbo-particle
//
//  Created by mj on 5/18/24.
//

#import "EmitterDefaultImages.h"
#import "TypeUtil.h"
#import <Foundation/Foundation.h>
#import <React/RCTBridge+Private.h>
#import <React/RCTBridge.h>
#import <React/RCTImageLoader.h>
#import <UIKit/UIKit.h>
#import <string>

typedef void (^ImageLoadCancel)(void);
typedef void (^ImageLoadHandler)(UIImage* _Nullable);
typedef void (^ImagesLoadHandler)(NSArray<UIImage*>* _Nonnull);

namespace tp {

static inline UIImage* _Nullable loadMainBundleImage(std::string name) {
  NSBundle* bundle = [NSBundle mainBundle];
  return [UIImage imageNamed:[NSString stringWithUTF8String:name.c_str()]
                           inBundle:bundle
      compatibleWithTraitCollection:nil];
}

static inline UIImage* _Nullable loadTurboParticleBundleImage(std::string name) {
  NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
  NSString* bundlePath = [mainBundlePath stringByAppendingPathComponent:@"TurboParticle.bundle"];
  NSBundle* bundle = [NSBundle bundleWithPath:bundlePath];
  return [UIImage imageNamed:[NSString stringWithUTF8String:name.c_str()]
                           inBundle:bundle
      compatibleWithTraitCollection:nil];
}

static inline ImageLoadCancel _Nullable loadUriImage(std::string uri,
                                                     ImageLoadHandler _Nonnull callback) {
  auto bridge = [RCTBridge currentBridge];
  RCTImageLoader* _Nonnull imageLoader = [bridge moduleForClass:[RCTImageLoader class]];

  return
      [imageLoader loadImageWithURLRequest:[RCTConvert NSURLRequest:nsStr(uri)]
                                      size:CGSizeZero
                                     scale:RCTScreenScale()
                                   clipped:YES
                                resizeMode:RCTResizeModeCenter
                             progressBlock:nil
                          partialLoadBlock:nil
                           completionBlock:^(NSError* _Nullable error, UIImage* _Nullable image) {
                             callback(image);
                           }];
}

static inline ImageLoadCancel _Nonnull loadImages(
    const std::vector<facebook::react::TurboParticleViewCellsContentStruct>& contents,
    ImagesLoadHandler _Nonnull callback) {
  NSMutableArray* ret = [NSMutableArray new];
  NSMutableArray* cancels = [NSMutableArray new];
  __block int loadCount = 0;
  int size = contents.size();
  for (int i = 0; i < contents.size(); i++) {
    [ret addObject:[NSNull null]];
    [cancels addObject:[NSNull null]];
  }

  for (int i = 0; i < contents.size(); i++) {
    auto& c = contents[i];
    if (c.httpUri.size() || c.reactAssetUri.size()) {
      std::string uri = c.httpUri.size() ? c.httpUri : c.reactAssetUri;
      cancels[i] = loadUriImage(uri, ^(UIImage* image) {
        ret[i] = image;
        loadCount++;

        if (loadCount == size) {
          callback(ret);
        }
      });
    } else if (c.nativeAssetName.size()) {
      ret[i] = loadMainBundleImage(c.nativeAssetName);
      loadCount++;
    } else {
      if (c.shape == "circle") {
        ret[i] = createEmitterCircle();
      } else if (c.shape == "star") {
      } else {
      }
      loadCount++;
    }
    if (loadCount == size) {
      callback(ret);
    }
  }
  return ^{
    for (int i = 0; i < size; i++) {
      if (![cancels[i] isEqual:[NSNull null]])
        static_cast<ImageLoadCancel>(cancels[i])();
    }
  };
}

} // namespace tp
