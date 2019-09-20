import React from "react"
import PropTypes from "prop-types"
import { BrowserRouter, Switch, Route } from 'react-router-dom';
import { store, persistor } from "../store";
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/lib/integration/react';
import RankedListFlow from './RankedListFlow';
import LoadingSpinner from "./LoadingSpinner";

// this exists so we can namespace everything by /react
const Routes = ({ match }) => {
  console.log("match", match);
  return (
    <Switch>
      <Route exact path={match.url + '/'} render={() => "homepage"} />
      <Route path={match.url + '/ranked_list'} component={RankedListFlow} />
    </Switch>
  );
}

class App extends React.Component {
  render() {
    return (
      <Provider store={store}>
        <PersistGate loading={<LoadingSpinner />} persistor={persistor}>
          < BrowserRouter >
            <Switch>
              <Route path="/react" component={Routes} />
            </Switch>
          </BrowserRouter >
        </PersistGate>
      </Provider>
    );
  }
}

export default App;
