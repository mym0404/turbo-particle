#import <react/renderer/components/RNWeatherEffectViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNWeatherEffectViewSpec/EventEmitters.h>
#import <react/renderer/components/RNWeatherEffectViewSpec/Props.h>
#import <react/renderer/components/RNWeatherEffectViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

using namespace facebook::react;

@interface SnowView : RCTViewComponentView
@end

@interface SnowView () <RCTSnowViewViewProtocol>
@end

@implementation SnowView {
  UIView* _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<SnowViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SnowViewProps>();
    _props = defaultProps;

    _view = [[UIView alloc] init];
    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& oldViewProps = *std::static_pointer_cast<SnowViewProps const>(_props);
  const auto& newViewProps = *std::static_pointer_cast<SnowViewProps const>(props);

  [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> SnowViewCls(void) {
  return SnowView.class;
}

@end
