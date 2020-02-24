import React from 'react';
import { findNodeHandle, Platform, requireNativeComponent, UIManager, View, StyleSheet } from 'react-native';

const RCTCustomView = requireNativeComponent('DrawView');
const COMMAND_RESET = 1;
const COMMAND_SAVE = 2;

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
    const command = Platform.OS === 'ios' ? UIManager.DrawView.Commands.reset : COMMAND_RESET;
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.drawerRef.current),
      command,
      [],
    );
  }

  save() {
    const command = Platform.OS === 'ios' ? UIManager.DrawView.Commands.save : COMMAND_SAVE;
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.drawerRef.current),
      command,
      [],
    );
  }

  render() {
    const { style, ...rest } = this.props;
    return <RCTCustomView
      ref={this.drawerRef}
      style={style}
      {...rest}
    />
  }

}

export default DrawView;
