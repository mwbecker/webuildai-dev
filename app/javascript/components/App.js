import React from "react"
import PropTypes from "prop-types"
import { BrowserRouter, Switch, Route } from 'react-router-dom';
import HelloWorld, {Foopa} from "./HelloWorld";
import { store, persistor } from "../store";
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/lib/integration/react';

// this exists so we can namespace everything by /react
const Routes = ({ match }) => {
  return (
    <Switch>
      <Route exact path={match.url + '/'} render={() => "homepage"} />
      <Route path={match.url + '/hello'} render={(props) => <HelloWorld greeting="Friend" {...props} />} />
      <Route path={match.url + '/foo'} render={() => <Foopa />} />
    </Switch>
  );
}

const LoadingView = () => {
  return <div>Loading...</div>
}

class App extends React.Component {
  render () {
    return (
      <Provider store={store}>
        <PersistGate loading={<LoadingView />} persistor={persistor}>
          <BrowserRouter>
            <Switch>
              {/* <Route component={NotFound} /> */}
              <Route path="/react" component={Routes} />
            </Switch>
          </BrowserRouter>
        </PersistGate>
      </Provider>
    );
  }
}

export default App
