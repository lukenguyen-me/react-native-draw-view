import React from 'react';
import { SafeAreaView, Button, View } from 'react-native';

import DrawView from 'react-native-draw-view';

class App extends React.Component {
  drawer;

  save = () => {
    this.drawer.save()
  }

  reset = () => {
    this.drawer.reset();
  }

  render() {
    return (
      <SafeAreaView style={{ flex: 1 }}>
        <DrawView
          style={{ flex: 1, backgroundColor: '#eee' }}
          onRef={el => this.drawer = el}
          color="#000"
          strokeWidth={2}
          onSaved={res => console.log('Save', res.nativeEvent)}
          onError={error => console.log('Error', error.nativeEvent)} />
        <View style={{ flexDirection: 'row', justifyContent: 'space-around' }}>
          <Button title="Reset" onPress={this.reset} />
          <Button title="Save" onPress={this.save} />
        </View>
      </SafeAreaView>
    );
  }
};

export default App;