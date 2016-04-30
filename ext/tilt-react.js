import React from 'react';
import ReactDOM from 'react-dom';

class TiltReactClass {
  constructor() {
    this.components = {};
  }

  bind() {
    this.reactContainers().forEach(container => {
      const componentName = container.dataset.reactClass;
      const propsContainer = container.nextElementSibling;
      const props = JSON.parse(propsContainer.innerText);
      this.render(container, componentName, props);
      container.parentElement.removeChild(propsContainer);
    });

    window.addEventListener('popstate', event => {
      const containers = this.reactContainers();
      try {
        event.state.forEach((data, i) => {
          this.render(
            containers[i],
            data[0],
            JSON.parse(data[1]) || {}
          );
        });
      } catch(e) {
        // State wasn't in the correct format
      }
    });
  }

  render(container, componentName, props, pathChange) {
    const element = this.elementForComponent(componentName, props);
    ReactDOM.render(element, container);
    container.dataset.reactClass = componentName;
    container.dataset.props = JSON.stringify(props);

    if (typeof pathChange === 'undefined') {
      window.history.replaceState(
        this.pageState(),
        document.title,
        window.location.href
      );
    } else {
      window.history.pushState(
        this.pageState(),
        document.title,
        pathChange
      );
    }
  }

  elementForComponent(componentName, props) {
    const component = this.components[componentName];
    const element = React.createElement(component, props);
    return element;
  }

  addComponent(component) {
    this.components[component.name] = component;
  }

  componentNames() {
    return Object.keys(this.components);
  }

  reactContainers() {
    return Array.prototype.slice.call(document.querySelectorAll('div[data-react-class]'));
  }

  reactContainerFor(element) {
    while(typeof element !== 'null') {
      if (element.hasAttribute('data-react-class')) {
        return element;
      }
      element = element.parentElement;
    }
  }

  pageState() {
    return this.reactContainers().map(container => {
      return [
        container.dataset.reactClass,
        container.dataset.props
      ];
    });
  }

  fetch(path, options, targetContainer) {
    targetContainer = targetContainer || this.reactContainers()[0];
    options = options || {};
    options.headers = options.headers || {};
    options.headers.Accept = 'application/json';

    fetch(path, options).then(response => {
      return response.json();
    }).then(json => {
      this.render(targetContainer, json[0], json[1], path);
    });
  }

  ajaxLoad(event) {
    event.preventDefault();
    switch(event.type) {
      case 'click':
        TiltReact.fetch(
          event.target.href,
          { method: 'GET' },
          TiltReact.reactContainerFor(event.target)
        );
        return;
    }
  }
}

window.TiltReact = new TiltReactClass();

module.exports = window.TiltReact;
