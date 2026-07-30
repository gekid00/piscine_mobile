import { StatusBar } from 'expo-status-bar';
import { Button, StyleSheet, Text, View } from 'react-native';
import { useState } from 'react';



export default function App()
{
  return (   
    <View style={styles.container}>
      <View style={styles.band}>
        <Text> Calculator </Text>
      </View>
      <View style={styles.texts}>
        <Text> 0 </Text>
        <Text> 0 </Text>
      </View>
      <View style={styles.buttons}>
        <View style={styles.ligne}>
          <Button title="7" />
          <Button title="8" />
          <Button title="9" />
          <Button title="C" />
          <Button title="AC" />
        </View>
        <View style={styles.ligne}>
          <Button title="4" />
          <Button title="5" />
          <Button title="6" />
          <Button title="+" />
          <Button title="-" />
        </View>
        <View style={styles.ligne}>
          <Button title="1" />
          <Button title="2" />
          <Button title="3" />
          <Button title="*" />
          <Button title="/" />
        </View>
        <View style={styles.ligne}>
          <Button title="0" />
          <Button title="." />
          <Button title="=" />
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create(
{
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  band: {
    height: 56,
    backgroundColor: '#fff',
  },
  texts: {
    flex: 2,
    alignItems: 'flex-end',
    backgroundColor: '#fff',
  },
  buttons: {
    alignItems: 'flex-end',
    backgroundColor: '#fff',
  },
  ligne: {
    flexDirection: "row",
    alignItems: 'flex-end',
    backgroundColor: '#fff',
  },
});
