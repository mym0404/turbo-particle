import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';
import type { Double, Int32 } from 'react-native/Libraries/Types/CodegenTypes';

export type EmitterShape = 'line' | 'rectangle';
export type EmitterDefaultCellContent = 'none' | 'circle' | 'star';
export type NativeContent = Readonly<{
  shape?: string;
  reactAssetUri?: string;
  httpUri?: string;
  nativeAssetName?: string;
}>;
export type ParticleCell = {
  content: NativeContent;
  birthRate: Double;
  lifetime: Double;
  lifetimeRange: Double;
  velocity: Double;
  velocityRange: Double;
  xAcceleration: Double;
  yAcceleration: Double;
  scale: Double;
  scaleRange: Double;
  spin: Double;
  spinRange: Double;
  alphaRange: Double;
  alphaSpeed: Double;
  color: Int32;
  redRange: Double;
  redSpeed: Double;
  blueRange: Double;
  blueSpeed: Double;
  greenRange: Double;
  greenSpeed: Double;
};

interface NativeProps extends ViewProps {
  cells: ParticleCell[];
  emitterSizeRatio: { width: Double; height: Double };
  emitterPositionAnchor: { x: Double; y: Double };
  emitterShape: string;
}

export default codegenNativeComponent<NativeProps>('TurboParticleView');
