import React from 'react';
import { findNodeHandle, Platform, requireNativeComponent, UIManager, View, StyleSheet } from 'react-native';

const RCTCustomView = requireNativeComponent('DrawView');
const COMMAND_RESET = 1;
const COMMAND_SAVE = 2;

const styles = StyleSheet.create({
  container: {
    position: 'relative',
  },
  mask: {
    position: 'absolute',
    top: 0,
    left: 0,
    width: '100%',
    height: '100%',
    opacity: 0.6,
    backgroundColor: '#fff',
  },
  drawer: {
    position: 'absolute',
    top: 0,
    left: 0,
    width: '100%',
    height: '100%',
  },
});


class DrawView extends React.PureComponent {
  drawerRef;

  constructor(props) {
    super(props);
    this.drawerRef = React.createRef();
  }

  componentDidMount() {
    this.props.onRef(this);
  }

  componentWillUnmount() {
    this.props.onRef(undefined);
  }

  reset() {
    const command = Platform.OS === 'ios' ? UIManager.DrawerView.Commands.reset : COMMAND_RESET;
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.drawerRef.current),
      command,
      [],
    );
  }

  save() {
    const command = Platform.OS === 'ios' ? UIManager.DrawerView.Commands.save : COMMAND_SAVE;
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.drawerRef.current),
      command,
      [],
    );
  }

  render() {
    const { style, color, onSaved, onError, disabled } = this.props;
    return <View style={{ ...styles.container, ...style }}>
      <RCTCustomView
        ref={this.drawerRef}
        style={styles.drawer}
        color={color}
        onSaved={onSaved}
        onError={onError}
      />
      {disabled && <View style={styles.mask} />}

    </View>;
  }

}

export default DrawView;
