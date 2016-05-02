import ReactDOMServer from 'react-dom/server';

window.TiltReact.renderToString = function(componentName, props) {
  const element = window.TiltReact.elementForComponent(componentName, props);
  return ReactDOMServer.renderToString(element);
};