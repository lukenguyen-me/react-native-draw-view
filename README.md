# react-native-draw-view

A React Native component for free-hand drawing on both iOS and Android.

## Features

- 👆 Draw with your finger and export an image from it.
- 💾 Save your sketch to image.
- 🖍 Change the stroke color and thickness of the pen easily.
- 👻 Full-customize UI.

## Setup

Install the module from npm:

```bash
npm i --save react-native-draw-view
```

Link the module to your project:

```bash
react-native link react-native-draw-view
```

Note: For iOS, if you're using CocoaPod, remember to `cd ios && pod install` after link. Or you can manual link [follow this instruction](https://facebook.github.io/react-native/docs/linking-libraries-ios).

**Important for iOS:**
Because the source code is written in Swift, so if your project doesn't include any .swift file, please open your project in XCode, create a file `anyname.swift`, accept to create the bridging header, then just leave it empty is ok.

## Usage

```javascript
import React from 'react';
import { View } from 'react-native';
import DrawView from 'react-native-draw-view';

export default class MyScreen extends React.Component {
  drawer;

  save = () => {
    this.drawer.save()
  }

  reset = () => {
    this.drawer.reset();
  }

  render() {
    return (
      <View style={{ flex: 1 }}>
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
      </View>
    );
  }
}
```

## API

Here are the `props` of the the component:

| Name | Type | Default value | Comment |
| ---- | ---- | ------------- | ---- |
| `color` | `String` | `'#000000'` | The stroke color you want to draw with. |
| `strokeWidth` | `Number` | `1` | The stroke thickness, in pixels. |
| `style` | Style object | `null` | Some `View` styles if you need. |
| `onRef` | Function | `null` | Bind draw view's ref to your variable. |
| `onSaved` | Function | `null` | Event called after the draw's saved successfully. The return value is an object `res` which `res.nativeEvent` include file's information: uri, type, size, name. |
| `onError` | Function | `null` | Event called if there is error. The return value is an object `err` which `err.nativeEvent` include `message` of that error. |

The component also has some instance methods:

| Name | Return type | Comment |
| ---- | ----------- | ------- |
| `reset()` | `Promise` | Reset the drawing. You could simply type: `this.sketch.clear();` |
| `save()` | `Promise` | Save the drawing to an image. The result's returned by `onSaved` event.` |

## Contributing

Feel free to contribute by sending a pull request or [creating an issue](https://github.com/phucloc8697/react-native-draw-view/issues/new).

## License

[MIT](https://github.com/phucloc8697/react-native-draw-view/tree/master/LICENSE)