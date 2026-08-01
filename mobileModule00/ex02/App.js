import { StatusBar } from 'expo-status-bar';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useState } from 'react';

function CalcButton({ label }){
  return(
    <Pressable
      style={styles.btn}
      onPress={() => console.log('button pressed :', label)}
    >
      <Text style={styles.btnText}>{label}</Text>
    </Pressable>
  );
}

export default function App(){
  return (
    <View style={styles.container}>
      <View style={styles.band}>
        <Text style={styles.bandText}>Calculator</Text>
      </View>
      <View style={styles.texts}>
        <Text style={styles.expr}>0</Text>
        <Text style={styles.result}>0</Text>
      </View>
      <View style={styles.buttons}>
        <View style={styles.ligne}>
          <CalcButton label="7" />
          <CalcButton label="8" />
          <CalcButton label="9" />
          <CalcButton label="C" />
          <CalcButton label="AC" />
        </View>
        <View style={styles.ligne}>
          <CalcButton label="4" />
          <CalcButton label="5" />
          <CalcButton label="6" />
          <CalcButton label="+" />
          <CalcButton label="-" />
        </View>
        <View style={styles.ligne}>
          <CalcButton label="1" />
          <CalcButton label="2" />
          <CalcButton label="3" />
          <CalcButton label="*" />
          <CalcButton label="/" />
        </View>
        <View style={styles.ligne}>
          <CalcButton label="0" />
          <CalcButton label="." />
          <CalcButton label="=" />
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
    backgroundColor: '#6200ee',
    justifyContent: 'center',
    alignItems: 'center',
  },
  bandText: {
    color: 'white',
    fontSize: 22,
    fontWeight: 'bold',
  },
  texts: {
    flex: 2,
    alignItems: 'flex-end',
    justifyContent: 'flex-end',
    padding: 16,
    backgroundColor: '#fff',
  },
  expr: {
    fontSize: 32,
    color: 'black',
  },
  result: {
    fontSize: 24,
    color: 'gray',
  },
  buttons: {
    flex: 5,
    backgroundColor: '#fff',
  },
  ligne: {
    flex: 1,
    flexDirection: 'row',
  },
  btn: {
    flex: 1,
    margin: 2,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#eee',
    borderRadius: 4,
  },
  btnText: {
    fontSize: 18,
  },
});
