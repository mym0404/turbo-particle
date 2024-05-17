import NativeTurboParticle from '../spec/TurboParticleNativeComponent';
import type { StyleProp, ViewStyle } from 'react-native';

type SnowProps = { style?: StyleProp<ViewStyle> } & {};
const TurboParticle = ({ style }: SnowProps) => {
  return <NativeTurboParticle style={style} speed={1} />;
};

export { TurboParticle };
export type { SnowProps };
