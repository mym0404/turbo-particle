#import <react/renderer/components/TurboParticleViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/TurboParticleViewSpec/EventEmitters.h>
#import <react/renderer/components/TurboParticleViewSpec/Props.h>
#import <react/renderer/components/TurboParticleViewSpec/RCTComponentViewHelpers.h>

#import "EmitterDefaultImages.h"
#import "ImageLoader.h"
#import "RCTFabricComponentsPlugins.h"
#import "TypeUtil.h"
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define debugO(value) NSLog(@"🔥 %@", value);
#define debugE(value) debugO([NSString stringWithUTF8String:value]);
#define debugF(value) NSLog(@"🔥 %lf", value);
#define debugI(value) NSLog(@"🔥 %d", value);
#else
#define debugE(...)                                                                                \
  {}
#endif

using namespace facebook::react;
using Cell = TurboParticleViewCellsStruct;

@interface TurboParticleView : RCTViewComponentView
@end

@interface TurboParticleView () <RCTTurboParticleViewViewProtocol>
@end

@implementation TurboParticleView {
  UIView* _view;
  CAEmitterLayer* _layer;
  double _emitterSizeRatioWidth;
  double _emitterSizeRatioHeight;
  double _emitterPositionAnchorX;
  double _emitterPositionAnchorY;
  std::string _emitterShape;
  ImageLoadCancel _imageLoadCancel;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const TurboParticleViewProps>();
    _props = defaultProps;
    _view = [[UIView alloc] init];
    [self addEmitterLayer];
    self.contentView = _view;
  }
  return self;
}

- (void)layoutSublayersOfLayer:(CALayer*)layer {
  [super layoutSublayersOfLayer:layer];
  [self updateLayerLayout];
}

- (void)prepareForRecycle {
  [super prepareForRecycle];
  if (_imageLoadCancel)
    _imageLoadCancel();
  _imageLoadCancel = nil;
}

/**
 CA_EXTERN CAEmitterLayerEmitterShape const kCAEmitterLayerPoint
 CA_EXTERN CAEmitterLayerEmitterShape const kCAEmitterLayerLine
 CA_EXTERN CAEmitterLayerEmitterShape const kCAEmitterLayerRectangle
 CA_EXTERN CAEmitterLayerEmitterShape const kCAEmitterLayerCuboid
 CA_EXTERN CAEmitterLayerEmitterShape const kCAEmitterLayerCircle
 CA_EXTERN CAEmitterLayerEmitterShape const kCAEmitterLayerSphere

 */

- (void)addEmitterLayer {
  _layer = [CAEmitterLayer layer];
  _layer.emitterShape = kCAEmitterLayerLine;
  _layer.beginTime = CACurrentMediaTime();
  [_view.layer addSublayer:_layer];
}

- (void)updateLayerLayout {
  double w = _view.bounds.size.width;
  double h = _view.bounds.size.height;
  _layer.emitterPosition = CGPointMake(w * _emitterPositionAnchorX, h * _emitterPositionAnchorY);
  _layer.emitterSize = CGSizeMake(w * _emitterSizeRatioWidth, h * _emitterSizeRatioHeight);
}

- (void)updateCells:(const std::vector<Cell>&)cells {
  if (_imageLoadCancel)
    _imageLoadCancel();
  _imageLoadCancel = nil;

  std::vector<TurboParticleViewCellsContentStruct> contents;
  for (const Cell& cell : cells)
    contents.push_back(cell.content);

  __weak __typeof__(self) wSelf = self;
  _layer.emitterCells = @[];

  _imageLoadCancel = tp::loadImages(contents, ^(NSArray<UIImage*>* images) {
    __strong __typeof__(self) sSelf = wSelf;
    if (!sSelf)
      return;
    NSMutableArray* cellArr = [[NSMutableArray alloc] initWithCapacity:cells.size()];
    for (int i = 0; i < images.count; i++) {
      UIImage* value = images[i];
      if (value && ![value isKindOfClass:[NSNull class]]) {
        [cellArr addObject:[sSelf createCell:cells[i] content:value.CGImage]];
      }
    }
    [sSelf onMain:^{
      sSelf->_layer.emitterCells = cellArr;
      sSelf->_imageLoadCancel = nil;
    }];
  });
}

#define DIFF(name) if (p.name != n.name)
#define CELL_UPD(name) ret.name = c.name;

- (CAEmitterCell*)createCell:(const Cell&)c content:(CGImageRef)content {
  CAEmitterCell* ret = [CAEmitterCell emitterCell];

  CELL_UPD(birthRate)
  CELL_UPD(lifetime)
  CELL_UPD(lifetimeRange)
  CELL_UPD(velocity)
  CELL_UPD(velocityRange)
  CELL_UPD(xAcceleration)
  CELL_UPD(yAcceleration)
  CELL_UPD(scale)
  CELL_UPD(scaleRange)
  CELL_UPD(spin)
  CELL_UPD(spinRange)
  CELL_UPD(alphaRange)
  CELL_UPD(alphaSpeed)
  CELL_UPD(redRange)
  CELL_UPD(redSpeed)
  CELL_UPD(greenRange)
  CELL_UPD(greenSpeed)
  CELL_UPD(blueRange)
  ret.contents = (__bridge id _Nullable)content;
  ret.color = tp::cgColor(c.color);
  return ret;
}

- (void)updateProps:(Props::Shared const&)props oldProps:(Props::Shared const&)oldProps {
  const auto& p = *std::static_pointer_cast<TurboParticleViewProps const>(_props);
  const auto& n = *std::static_pointer_cast<TurboParticleViewProps const>(props);

  _emitterSizeRatioWidth = n.emitterSizeRatio.width;
  _emitterSizeRatioHeight = n.emitterSizeRatio.height;
  _emitterPositionAnchorX = n.emitterPositionAnchor.x;
  _emitterPositionAnchorY = n.emitterPositionAnchor.y;

  if (!tp::isSizeEqual(p.emitterSizeRatio, n.emitterSizeRatio) ||
      !tp::isAnchorEqual(p.emitterPositionAnchor, n.emitterPositionAnchor))
    [self updateLayerLayout];

  DIFF(emitterShape) {
    _layer.emitterShape = n.emitterShape == "line"        ? kCAEmitterLayerLine
                          : n.emitterShape == "rectangle" ? kCAEmitterLayerRectangle
                                                          : kCAEmitterLayerLine;
  }
  _emitterShape = n.emitterShape;

  [self updateCells:n.cells];

  [super updateProps:props oldProps:oldProps];
}

typedef void (^MainRunner)(void);
- (void)onMain:(MainRunner)block {
  if ([NSThread isMainThread]) {
    block();
  } else {
    dispatch_async(dispatch_get_main_queue(), ^{
      block();
    });
  }
}

@end

@implementation TurboParticleView (RN)
Class<RCTComponentViewProtocol> TurboParticleViewCls(void) {
  return TurboParticleView.class;
}
+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<TurboParticleViewComponentDescriptor>();
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
