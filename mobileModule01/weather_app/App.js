import { useState } from 'react';
import { TabView, TabBar } from 'react-native-tab-view';
import { Ionicons } from '@expo/vector-icons';
import { Pressable, StyleSheet, Text, TextInput, View } from 'react-native';


export default function App()
{
  const [index, setIndex] = useState(0);

  const [search, setSearch] = useState('');

  const routes =
  [
    { key:'currently', title:'Currently' },
    { key:'today', title:'Today' },
    { key:'weekly', title:'Weekly' }
  ];
  
  const renderScene = ({ route }) =>
  (
    <View style={styles.page}>
      <Text>{route.title}</Text>
      <Text>{search}</Text>
    </View>
  );

  const renderTabBar = (props) =>
  (
    <TabBar
      {...props}
      options={options}
      style={{ backgroundColor: '#6200ee' }}
      activeColor="white"
      inactiveColor="#ccc"
    />
  );

  const options =
  {
    currently: {
      labelText: 'Currently',
      icon: ({ color }) => <Ionicons name="partly-sunny-outline" size={22} color={color} />,
    },
    today: {
      labelText: 'Today',
      icon: ({ color }) => <Ionicons name="today-outline" size={22} color={color} />,
    },
    weekly: {
      labelText: 'Weekly',
      icon: ({ color }) => <Ionicons name="calendar-outline" size={22} color={color} />,
    },
  };


  return (
    <View style={{ flex: 1 }}>

      <View style={styles.topBar}>
        <TextInput
          style={styles.searchInput}
          placeholder="Search location..."
          placeholderTextColor="#ddd"
          value={search}
           onChangeText={setSearch}
        />
        <Pressable onPress={() =>  setSearch('Geolocation')}>
          <Ionicons name="navigate" size={24} color="white" />
        </Pressable>
      </View>

      <View style={{ flex: 1 }}>
        <TabView
          navigationState={{ index, routes }}
          renderScene={renderScene}
          onIndexChange={setIndex}
          renderTabBar={renderTabBar}
          tabBarPosition="bottom"
        />
      </View>
    
    </View>
  );
}

const styles = StyleSheet.create(
{
  topBar: {
  flexDirection: 'row',
  alignItems: 'center',
  backgroundColor: '#6200ee',
  paddingTop: 40,
  paddingHorizontal: 12,
  paddingBottom: 8,
  },
searchInput: {
  flex: 1,
  color: 'white',
  fontSize: 16,
  marginRight: 8,
  },

  page: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
