//
//  TypeUtil.h
//  TurboParticle
//
//  Created by mj on 5/18/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <string>
#import <utility>

#define EQ(name) lhs.name == rhs.name

namespace tp {

static inline UIColor* uiColor(NSInteger v) {
  float alpha = ((v & 0xFF000000) >> 24) / 255.0;
  float red = ((v & 0xFF0000) >> 16) / 255.0;
  float green = ((v & 0x00FF00) >> 8) / 255.0;
  float blue = (v & 0x0000FF) / 255.0;
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

static inline CGColor* cgColor(NSInteger v) {
  return [uiColor(v) CGColor];
}

static inline NSString* nsStr(std::string s) {
  return [NSString stringWithUTF8String:s.c_str()];
}

template <typename T> concept IsAnchor = requires(T t) {
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.x)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.y)>>;
};
template <typename T> concept IsSize = requires(T t) {
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.width)>>;
  requires std::is_arithmetic_v<std::remove_cvref_t<decltype(t.height)>>;
};

template <IsAnchor T> bool isAnchorEqual(const T& lhs, const T& rhs) {
  return EQ(x) && EQ(y);
}
template <IsSize T> bool isSizeEqual(const T& lhs, const T& rhs) {
  return EQ(width) && EQ(height);
}

} // namespace tp
