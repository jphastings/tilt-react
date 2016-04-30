import React, { PropTypes } from 'react';

class HomePage extends React.Component {
  render() {
    return (
      <section>
        <h1>Hello {this.props.name || 'you'}</h1>
        <p>This is being rendered with React. Head to <a href="/other" onClick={window.TiltReact.ajaxLoad}>another page</a>.</p>
      </section>
    );
  }
}

HomePage.propTypes = { name: PropTypes.string };

export default HomePage;