import React from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux";
import { Switch, Route } from 'react-router-dom';
import RankedListNewPage from './RankedListNewPage';

class RLFlow extends React.Component {

    render() {
        const baseUrl = this.props.match.url;
        return (
            <Switch>
                <Route exact path={baseUrl + '/new'} component={RankedListNewPage} />
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