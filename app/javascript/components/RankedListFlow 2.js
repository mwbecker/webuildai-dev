import React from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux";
import { Switch, Route } from 'react-router-dom';
import RankedListNewPage from './RankedListNewPage';
import RankedListView from "./RankedListView";
import ThankYou from "./ThankYou";

class RLFlow extends React.Component {

    render() {
        const baseUrl = this.props.match.url;
        return (
            <Switch>
                <Route exact path={baseUrl + '/new'} component={RankedListNewPage} />
                <Route exact path={baseUrl + '/view'} component={RankedListView} />
                <Route exact path={baseUrl + '/done'} component={ThankYou} />
            </Switch>
        );
    }
}

const mapStoreStateToProps = (storeState, givenProps) => {
    return { ...givenProps, ...storeState.rankedListState }
}

const mapDispatchToProps = (dispatch) => {
    return {}
}

const RankedListFlow = connect(mapStoreStateToProps)(RLFlow);

export default RankedListFlow;