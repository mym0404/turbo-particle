import { StyleSheet, View } from 'react-native';
import { TurboParticle } from 'turbo-particle';

export default function App() {
  return (
    <View style={styles.container}>
      <TurboParticle style={styles.box} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  box: {
    flex: 1,
    backgroundColor: 'black',
  },
});
