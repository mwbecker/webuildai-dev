import React from "react";
import PropTypes from "prop-types";
import { connect } from "react-redux";
import { ACTION_TYPES } from "../store";
import LoadingSpinner from "./LoadingSpinner";

class RLNew extends React.Component {
    getPairwiseComparisons = () => {
        fetch('/api/v1/ranked_list/new')
            .then(response => response.json())
            .then((data) => {
                return this.props.setPairwiseComparisons({ ...data, pairwiseComparisons: JSON.parse(data.pairwiseComparisons) })
            }) // loading state
            .catch(error => console.log(error))
    }

    constructor(props) {
        super(props);
        this.state = {
            isLoading: false
        };
    }

    componentDidMount() {
        this.getPairwiseComparisons();
    }

    onClickGo = () => {
        console.log("hi")
        this.setState((prevState) => ({
            isLoading: !prevState.isLoading
        }))
    }

    render() {
        console.log("category", this.props.category);
        console.log("round", this.props.round);
        console.log("comps", this.props.pairwiseComparisons, typeof this.props.pairwiseComparisons);
        console.log(this.state);
        return (
            <div className="container">
                <h1 className="title">
                    Let’s check the results of your
                    {this.props.category == 'request' ? ' individual ' : ' social '}
                    preference model.
                    {this.props.round > 0 && `(Tuning Round ${this.props.round + 1})`}
                </h1>
                {
                    this.state.isLoading ? (
                        <LoadingSpinner />
                    ) : (
                            <div className="row">
                                <div className="col s5"></div>
                                <div className="col s1">
                                    <a
                                        className="waves-effect waves-dark btn"
                                        id="rank_yes_btn"
                                        onClick={this.onClickGo}
                                    >
                                        Go!
                                    </a>
                                </div>
                            </div>
                        )
                }
            </div>
        )
    }
}

const mapStoreStateToProps = (storeState, givenProps) => {
    return { ...givenProps, ...storeState.rankedListState }
}

const mapDispatchToProps = (dispatch) => {
    return {
        setPairwiseComparisons: (data) => dispatch({ type: ACTION_TYPES.SET_PAIRWISE_COMPARISONS, data })
    }
}
const RankedListNewPage = connect(mapStoreStateToProps, mapDispatchToProps)(RLNew);
export default RankedListNewPage;