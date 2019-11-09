import React from "react";
import PropTypes from "prop-types";
import { connect } from "react-redux";
import { ACTION_TYPES } from "../store";
import LoadingGif from "./LoadingGif";


class RLNew extends React.Component {
    getPairwiseComparisons = () => {
        fetch(`/api/v1/ranked_list/new?category=${this.props.category}&round=${this.props.round}`)
            .then(response => response.json())
            .then((data) => {
                const comps = JSON.parse(data.pairwiseComparisons);
                this.props.setPairwiseComparisons(comps.comparisons);
                // this.props.setMLServerUrl(data.serverUrl);
            }) // loading state
            .catch(error => console.log(error))
    }

    getSamples = () => {
        fetch('/api/v1/ranked_list/generate_samples', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                category: this.props.category,
                round: this.props.round,
            })
        })
            .then(response => response.json())
            .then((data) => {
                console.log('generated samples', data);
                // this.props.setRankedList(JSON.parse(data));
                this.trainModel(data)
                this.props.setRanklistId(data.ranklistId);
            })
            .catch(error => console.log(error))
    }

    evaluateModel = (samples) => {
        // while (!this.state.isModelTrained) continue;
        fetch(this.props.mlServerUrl + "/evaluate", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Data-Type': 'json',
            },
            body: JSON.stringify({ data: samples })
        })
            .then(response => response.json())
            .then((data) => {
                console.log("rankedlist:", data);
                this.setState({ isLoading: false });
                this.updateModelRanks(data.order, samples, data.scores);
            })
            .then(() => {
              console.log(this.props);
              this.props.history.push("view");
            });
    }

    getPairwiseFeatures = (comp) => {
        const newComp = { ...comp };
        newComp.scenario_1 = comp.scenario_1.features;
        newComp.scenario_2 = comp.scenario_2.features;
        return newComp
    }

    trainModel = (samples) => {
        fetch(this.props.mlServerUrl + "/train", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Data-Type': 'json',
            },
            body: JSON.stringify({
                data: {
                    comparisons: this.props.pairwiseComparisons.map(this.getPairwiseFeatures),
                    feedback_round: this.props.round,
                    request_type: this.props.category,
                    participant_id: this.props.participantId,
                },
            })
        })
            .then(response => response.json())
            .then((data) => {
                console.log("weights", data);
                this.props.setModelWeights(data.weights);
                this.props.setAccuracy(this.average(data.accuracy));
                this.evaluateModel(samples);
            })
    }

    updateModelRanks = (order, samples, scores) => {
        let id;
        const scenarios = samples.scenarios;
        for (let i = 0; i < order.length; i++) {
            id = order[i];
            for (let j = 0; j < scenarios.length; j++) {
                if (scenarios[j].id === id) {
                    scenarios[j].model_rank = i + 1; // start at 1
                    scenarios[j].score = scores[j];
                    break;
                }
            }
        }
        this.props.setRankedList(scenarios);
    }

    constructor(props) {
        super(props);
        this.state = {
            isLoading: false,
            samples: [],
        };
    }

    average(accuracies) {
      return ((accuracies.reduce( (total, num) => total + parseFloat(num)) / accuracies.length) * 100).toFixed(2);
    }

    componentDidMount() {
        this.getPairwiseComparisons();
    }

    onClickGo = () => {
        this.setState((prevState) => ({ isLoading: !prevState.isLoading }))
        this.getSamples()
    }

    render() {
        return (
            <div className="container">
                <h1 className="title">
                    Let’s check the results of your Work
                    {this.props.category == 'request' ? ' Preference ' : ' Distribution '}
                    Model.
                    {this.props.round > 0 && ` (Tuning Round ${this.props.round + 1})`}
                </h1>
                <div className="row">
                    <div className="col s5"></div>
                    <div className="col s1">
                        {this.state.isLoading ? (
                            <LoadingGif />
                        ) : (
                                <a
                                    className="waves-effect waves-dark btn"
                                    id="rank_yes_btn"
                                    onClick={this.onClickGo}
                                >
                                    Go!
                            </a>
                            )
                        }
                    </div>
                </div>
            </div>
        )
    }
}

const mapStoreStateToProps = (storeState, givenProps) => {
    return {
        ...givenProps,
        round: storeState.round,
        category: storeState.category,
        pairwiseComparisons: storeState.pairwiseComparisons,
        mlServerUrl: storeState.model_url || 'https://webuildai-ml-server.herokuapp.com',
        participantId: storeState.participantId,
        model_weights: storeState.model_weights,
        accuracy: storeState.accuracy,
    };
}

const mapDispatchToProps = (dispatch) => {
    return {
        setPairwiseComparisons: (payload) => dispatch({ type: ACTION_TYPES.SET_PAIRWISE_COMPARISONS, payload }),
        setRankedList: (payload) => dispatch({ type: ACTION_TYPES.SET_RANKED_LIST, payload }),
        setModelWeights: (payload) => dispatch({ type: ACTION_TYPES.SET_MODEL_WEIGHTS, payload }),
        setRanklistId: (payload) => dispatch({ type: ACTION_TYPES.SET_RANKLIST_ID, payload }),
        setAccuracy: (payload) => dispatch({type: ACTION_TYPES.SET_ACCURACY, payload}),
    };
}

const RankedListNewPage = connect(mapStoreStateToProps, mapDispatchToProps)(RLNew);
export default RankedListNewPage;