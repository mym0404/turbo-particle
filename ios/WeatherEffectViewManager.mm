#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"

@interface WeatherEffectViewManager : RCTViewManager
@end

@implementation WeatherEffectViewManager

RCT_EXPORT_MODULE(WeatherEffectView)

- (UIView *)view
{
  return [[UIView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(color, NSString)

@end
