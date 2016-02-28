import React, { PropTypes } from 'react';

class HomePage extends React.Component {
  render() {
    return (
      <h1>Hello {this.props.name || 'you'}</h1>
    );
  }
}

HomePage.propTypes = { name: PropTypes.string };

export default HomePage;