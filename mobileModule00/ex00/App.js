import { StatusBar } from 'expo-status-bar';
import { Button, StyleSheet, Text, View } from 'react-native';

function handlePress()
{
  console.log('Button pressed');
}

export default function App()
{
  return (
    <View style={styles.container}>
      <Text>A simple button !</Text>
      <Button title="Hey ;)" onPress={handlePress}/>
    </View>
  );
}

const styles = StyleSheet.create(
{
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
