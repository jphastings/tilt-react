React = require('react');
DOMServer = require('react-dom/server');

var tiltReact = {
  render: function(componentName, props) {
    var component = React.createFactory(tiltReact.components[componentName]);
    return DOMServer.renderToString(component(props));
  },
  components: {}
};

module.exports = tiltReact;