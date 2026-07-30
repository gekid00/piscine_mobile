import { StatusBar } from 'expo-status-bar';
import { Button, StyleSheet, Text, View } from 'react-native';
import { useState } from 'react';



export default function App()
{
  const [text, setText] = useState('A simple text');

  function handlePress()
  {
    if (text !== 'Hello World!')
      setText('Hello World!')
    else
    {
      setText('A simple text')
    }
    console.log('Button pressed');
  }

  return (
    <View style={styles.container}>
      <Text> {text} </Text>
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
