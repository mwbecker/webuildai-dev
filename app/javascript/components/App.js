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
import WorkPreferenceOverview from './WorkPreferenceOverview'
import SocialPreferenceOverview from './SocialPreferenceOverview'

// this exists so we can namespace everything by /react
const Routes = ({ match }) => {
  console.log("match", match);
  return (
    <Switch>
      <Route exact path={match.url + '/'} render={() => "homepage"} />
      <Route path={match.url + '/feature_selection'} component={FeatureSelection} />

      <Route path={match.url + '/work_preference_overview'} component={WorkPreferenceOverview} />
      <Route path={match.url + '/social_preference_overview'} component={SocialPreferenceOverview} />

      <Route path={match.url + '/pairwise_comparisons'} component={PairwiseComparisonFlow} />
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
