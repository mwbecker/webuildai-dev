import React from "react";
import PropTypes from "prop-types";
import { BrowserRouter, Switch, Route } from 'react-router-dom';
import { store, persistor } from "../store";
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/lib/integration/react';
import RankedListFlow from './RankedListFlow';
import LoadingSpinner from "./LoadingSpinner";
import FeatureSelection from './FeatureSelection';
import PairwiseComparisonFlow from './PairwiseComparisonFlow'
import Overview from './Overview'
import Login from "./Login";
import Header from "./Header";

// this exists so we can namespace everything by /react
const Routes = ({ match, history }) => {
  return (
    <React.Fragment>
      <Header history={history}/>
      <Switch>
        <Route exact path={match.url + '/'} component={Login} />
        <Route path={match.url + '/feature_selection'} component={FeatureSelection} />

        <Route path={match.url + '/work_preference_overview'} render={(props) => <Overview {...props} model={"preference"} />} />
        <Route path={match.url + '/social_preference_overview'} render={(props) => <Overview {...props} model={"distribution"} />} />

        <Route path={match.url + '/pairwise_comparisons'} component={PairwiseComparisonFlow} />
        <Route path={match.url + '/ranked_list'} component={RankedListFlow} />
      </Switch>
    </React.Fragment>
  );
}

class App extends React.Component {
  render() {
    return (
      <Provider store={store}>
        <PersistGate loading={<LoadingSpinner />} persistor={persistor}>
          <BrowserRouter >
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
