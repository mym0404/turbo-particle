import SnowNativeComponent from '../spec/SnowNativeComponent';
import type { StyleProp, ViewStyle } from 'react-native';

type SnowProps = { style?: StyleProp<ViewStyle> } & {};
const Snow = ({ style }: SnowProps) => {
  return <SnowNativeComponent style={style} speed={1} />;
};

export { Snow };
export type { SnowProps };
