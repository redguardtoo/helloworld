// Directory layout:
//   - frontend/index.js
//   - frontend/index.template.ejs (used by HtmlWebpackPlugin, @see html5-webpack.yasnippet)
//   - frontend/components/Home/Home.js
//   - frontend/components/Dashboard/Dashboard.js
//   - frontend/styles/ (storing global css files)
//   - frontend-dist/
//   - node_modules/
//   - package.json (@see package-reactjs.yasnippet)
//   - webpack.config.js (@see main-webpack.yasnippet)
//   - .babelrc (@see main-webpack.yasnippet)

require('es5-shim'); //ie 9

// Client entry point
import React from 'react';
import { Router, Route, browserHistory } from 'react-router';
import { render } from 'react-dom';
import { createStore, combineReducers, applyMiddleware } from 'redux';
import thunk from 'redux-thunk'; // reducer could resolve the promise
import { Provider } from 'react-redux';
import { syncHistoryWithStore, routerReducer } from 'react-router-redux'; // route saved into store
import update from 'immutability-helper';

// Base stylesheet (OPTIONAL)
//require('./styles/main.css');

// Initialize store
function rootReducer(storeState={}, action) {
  var finalStoreState;
  switch (action.type) {
  case 'EVT_DO_STH':
    finalStoreState = update(storeState, {foo: {$set: action.foo}});
    break;
  default:
    // return original state
    finalStoreState = storeState;
  }
  return finalStoreState;
};
const store = createStore(
  combineReducers({
    app:rootReducer,
    routing: routerReducer
  }),
  {}, /* initial state */
  applyMiddleware(thunk)
);

// master page stylesheet
class App extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    // "a full width container, spanning the entire width of your viewport', quoted from bootstrap docuemntation
    return(<div>{this.props.children}</div>);
  }
}

function getRoutePath(p) {
  return (process.env.NODE_ENV === 'production'? '/':'/') + (p? p:'');
}

// the path is relative to the root directory which defined in webpack.config.js
//
// resolve: {
//   extensions: ['', '.js', '.jsx'],
//   modules: [
//     'frontend',
//     'node_modules'
//   ],
//   // root for es2015 import
//   // @see http://moduscreate.com/es6-es2015-import-no-relative-path-webpack/
//   root: [
//     path.resolve('./frontend/components')
//   ]
// }
const rootRoute = {
  // We use dynamic routes which can be changed programmically
  // @see https://github.com/ReactTraining/react-router/blob/master/docs/API.md
  path: getRoutePath(), // the reason we use dynamic route
  component: App,
  indexRoute: {
    getComponent: (nextState, cb) => {
      require.ensure([], require => {
        // use Y if you prefer relative index.js
        cb(null, require('Home/Home.js').default);
      });
    }
  },
  childRoutes: [
    {
      path: 'dashboard',
      getComponent:(nextState, cb) => {
        require.ensure([], require => {
          cb(null, require('Dashboard/Dashboard.js').default);
        });
      }
    }
  ]
};
const history = syncHistoryWithStore(browserHistory, store);

render(
  <Provider store={store}>
    <Router history={history}>
      {rootRoute}
    </Router>
  </Provider>,
  document.getElementById('app')
);
