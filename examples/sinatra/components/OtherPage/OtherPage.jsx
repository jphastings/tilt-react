import React, { PropTypes } from 'react';

class OtherPage extends React.Component {
  render() {
    return (
      <section>
        <h1>Another page</h1>
        <p>Go back <a href="/" onClick={window.TiltReact.ajaxLoad}>Home</a>.</p>
      </section>
    );
  }
}

export default OtherPage;