#import <react/renderer/components/TurboParticleViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/TurboParticleViewSpec/EventEmitters.h>
#import <react/renderer/components/TurboParticleViewSpec/Props.h>
#import <react/renderer/components/TurboParticleViewSpec/RCTComponentViewHelpers.h>

#import "BundleImageLoader.h"
#import "RCTFabricComponentsPlugins.h"
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

using namespace facebook::react;

@interface TurboParticleView : RCTViewComponentView
@end

@interface TurboParticleView () <RCTTurboParticleViewViewProtocol>
@end

@implementation TurboParticleView {
  UIView* _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<TurboParticleViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const TurboParticleViewProps>();
    _props = defaultProps;

    _view = [[UIView alloc] init];
    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& p = *std::static_pointer_cast<TurboParticleViewProps const>(_props);
  const auto& n = *std::static_pointer_cast<TurboParticleViewProps const>(props);

  [super updateProps:props oldProps:oldProps];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self fallingSnow];
}

- (void)fallingSnow {
  CAEmitterCell* c = [CAEmitterCell emitterCell];
  c.contents = (__bridge id _Nullable)(loadBundleImage("snow").CGImage);
  c.alphaRange = 0.5;
  c.alphaSpeed = -0.1;
  c.scale = 0.3;
  c.scaleRange = 0.6;
  c.emissionRange = M_PI * 2;
  c.lifetime = 30.0;
  c.birthRate = 1000;
  c.velocity = 100;
  c.velocityRange = 20;
  c.yAcceleration = 20;
  c.xAcceleration = 15;
  c.spin = -0.5;
  c.spinRange = 1.0;

  CAEmitterLayer* snowEmitterLayer = [CAEmitterLayer layer];
  snowEmitterLayer.emitterPosition = CGPointMake(_view.bounds.size.width / 2, 0);
  snowEmitterLayer.emitterSize = CGSizeMake(_view.bounds.size.width, 0);
  snowEmitterLayer.emitterShape = kCAEmitterLayerLine;
  snowEmitterLayer.beginTime = CACurrentMediaTime();
  snowEmitterLayer.timeOffset = 30;
  snowEmitterLayer.emitterCells = @[ c ];
  snowEmitterLayer.zPosition = 1;

  [_view.layer addSublayer:snowEmitterLayer];
}

@end

@implementation TurboParticleView (RN)
Class<RCTComponentViewProtocol> TurboParticleViewCls(void) {
  return TurboParticleView.class;
}
@end
/*
 func fallingRain() {
 let flakeEmitterCell = CAEmitterCell()
 flakeEmitterCell.contents = UIImage(named: "rain")?.cgImage
 flakeEmitterCell.alphaRange = 0.5
 flakeEmitterCell.alphaSpeed = -0.1
 flakeEmitterCell.scale = 0.3
 flakeEmitterCell.scaleRange = 0.3
 flakeEmitterCell.lifetime = 20.0
 flakeEmitterCell.birthRate = 20
 flakeEmitterCell.velocity = 200
 flakeEmitterCell.velocityRange = 20
 flakeEmitterCell.yAcceleration = 300
 flakeEmitterCell.xAcceleration = 5

 let rainEmitterLayer = CAEmitterLayer()
 rainEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width/2, y: -300)
 rainEmitterLayer.emitterSize = CGSize(width: view.bounds.width * 2, height: 0)
 rainEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
 rainEmitterLayer.beginTime = CACurrentMediaTime()
 rainEmitterLayer.timeOffset = 30
 rainEmitterLayer.emitterCells = [flakeEmitterCell]

 rainEmitterLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi/24))
 rainEmitterLayer.opacity = 0.9

 mainBackgroundImage.layer.addSublayer(rainEmitterLayer)
 }


 */
