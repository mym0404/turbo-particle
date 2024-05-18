import NativeTurboParticle, {
  type EmitterDefaultCellContent,
  type NativeContent,
} from '../spec/TurboParticleNativeComponent';
import {
  type StyleProp,
  type ViewStyle,
  processColor,
  type ImageRequireSource,
  Image,
} from 'react-native';

type TurboParticleProp = { style?: StyleProp<ViewStyle> } & {};

function parseColor(v: any): number {
  return processColor(v) as number;
}

export type ParticleContent =
  | ImageRequireSource
  | {
      shape?: EmitterDefaultCellContent;
      httpUri?: string;
      nativeAssetName?: string;
    };

export const convertJsImagePropToNativeProp = (
  image: ParticleContent
): NativeContent => {
  if (typeof image === 'number') {
    const reactAssetUri = Image.resolveAssetSource(image)?.uri;
    if (reactAssetUri) {
      return { reactAssetUri };
    } else {
      return {};
    }
  }
  const { httpUri, nativeAssetName, shape } = image as Exclude<
    ParticleContent,
    number
  >;
  if (httpUri) {
    return { httpUri };
  }
  if (nativeAssetName) {
    return { nativeAssetName };
  }
  if (shape) {
    return { shape };
  }
  return {};
};

const TurboParticle = ({ style }: TurboParticleProp) => {
  return (
    <NativeTurboParticle
      cells={[
        {
          birthRate: 10,
          lifetime: 20,
          lifetimeRange: 0,
          velocity: 20,
          velocityRange: 0,
          xAcceleration: 0,
          yAcceleration: 24,
          scale: 0.5,
          scaleRange: 0,
          spin: 1,
          spinRange: 4,
          alphaRange: 0,
          alphaSpeed: 0,
          color: parseColor('white'),
          redRange: 0,
          redSpeed: 0,
          greenRange: 0,
          greenSpeed: 0,
          blueRange: 0,
          blueSpeed: 0,
          content: {
            // nativeAssetName: 'logo',
            shape: 'circle',
            // reactAssetUri: Image.resolveAssetSource(require('./logo.png')).uri,
          },
        },
      ]}
      emitterShape={'line'}
      emitterPositionAnchor={{ x: 0.5, y: 0.2 }}
      emitterSizeRatio={{ width: 1, height: 1 }}
      style={style}
    />
  );
};

export { TurboParticle };
export type { TurboParticleProp };
