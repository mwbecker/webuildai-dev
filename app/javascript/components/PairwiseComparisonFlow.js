import React from "react";
import PropTypes from "prop-types";
import { Switch, Route } from 'react-router-dom';
import PairwiseChoose from "./PairwiseChoose";
import PairwiseIntro from "./PairwiseIntro";

class PairwiseComparisonFlow extends React.Component {

  render() {
    const baseUrl = this.props.match.url;
    return (
      <Switch>
        <Route exact path={baseUrl + '/intro'} component={PairwiseIntro} />
        <Route exact path={baseUrl + '/choose'} component={PairwiseChoose} />
        {/* <Route exact path={baseUrl + '/choose'} component={RankedListView} /> */}
        {/* <Route exact path={baseUrl + '/done'} component={ThankYou} /> */}
      </Switch>
    );
  }
}

export default PairwiseComparisonFlow;