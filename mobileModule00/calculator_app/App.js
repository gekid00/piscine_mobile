import { StatusBar } from 'expo-status-bar';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useState } from 'react';
import { Parser } from 'expr-eval';

function CalcButton({ label, onPress })
{
  return (
    <Pressable
      style={styles.btn}
      onPress={() => onPress(label)}
    >
      <Text style={styles.btnText}>{label}</Text>
    </Pressable>
  );
}

export default function App()
{
  const [expression, setExpression] = useState('');
  const [result, setResult] = useState('0');

  function handlePress(label)
  {
    if (label === 'AC')
    {
      setExpression('');
      setResult('0');
    }
    else if (label === 'C')
    {
      setExpression(expression.slice(0, -1));
    }
    else if (label === '=')
    {
      try
      {
        const r = Parser.evaluate(expression);
        setResult(String(r));
      }
      catch (e)
      {
        setResult('Error');
      }
    }
    else
    {
      setExpression(expression + label);
    }
  }

  return (
    <View style={styles.container}>
      <View style={styles.band}>
        <Text style={styles.bandText}>Calculator</Text>
      </View>
      <View style={styles.texts}>
        <Text style={styles.expr}>{expression}</Text>
        <Text style={styles.result}>{result}</Text>
      </View>
      <View style={styles.buttons}>
        <View style={styles.ligne}>
          <CalcButton label="7" onPress={handlePress} />
          <CalcButton label="8" onPress={handlePress} />
          <CalcButton label="9" onPress={handlePress} />
          <CalcButton label="C" onPress={handlePress} />
          <CalcButton label="AC" onPress={handlePress} />
        </View>
        <View style={styles.ligne}>
          <CalcButton label="4" onPress={handlePress} />
          <CalcButton label="5" onPress={handlePress} />
          <CalcButton label="6" onPress={handlePress} />
          <CalcButton label="+" onPress={handlePress} />
          <CalcButton label="-" onPress={handlePress} />
        </View>
        <View style={styles.ligne}>
          <CalcButton label="1" onPress={handlePress} />
          <CalcButton label="2" onPress={handlePress} />
          <CalcButton label="3" onPress={handlePress} />
          <CalcButton label="*" onPress={handlePress} />
          <CalcButton label="/" onPress={handlePress} />
        </View>
        <View style={styles.ligne}>
          <CalcButton label="0" onPress={handlePress} />
          <CalcButton label="." onPress={handlePress} />
          <CalcButton label="=" onPress={handlePress} />
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
