import React from "react";
import PropTypes from "prop-types";
import { connect } from "react-redux";
import { ACTION_TYPES } from "../store";
import { DragDropContext, Droppable, Draggable } from "react-beautiful-dnd";
import CircleOne from '../images/numbers-01.png';
import CircleTwo from '../images/numbers-02.png';
import CircleThree from '../images/numbers-03.png';
import CircleFour from '../images/numbers-04.png';
import CircleFive from '../images/numbers-05.png';
import DndIndicator from '../images/dndIndicator.png';
import Accuracy from '../images/Accuracy.png';
// import Scenario from "./Scenario";

class RLView extends React.Component {

  constructor(props) {
    super(props);
    console.log(props);
    this.state = {
      rankedList: [],
      changed: false,
      featureWeights: [],
      model_weights: [],
    }
  }

  componentDidMount() {
    const rl = [...this.props.rankedList];
    // console.log(this.props);
    const mw = [...this.props.model_weights]
    rl.sort((a, b) => a.model_rank - b.model_rank);
    this.setState({ rankedList: rl, model_weights: mw });
    this.getFeatureWeights();
  }

  getFeatureWeights = () => {
    fetch(`/api/v1/ranked_list/obtain_weights?category=${this.props.category}`)
      .then(response => response.json())
      .then((data) => {
        this.setState({ featureWeights: data.featureWeights});
      })
      .catch(error => console.log(error))
  }

  saveRankedList = (rankedList, callback) => {
    const data = {
      rankedList,
      round: this.props.round + 1,
      ranklistId: this.props.ranklistId,
      category: this.props.category,
    };
    fetch('/api/v1/ranked_list/save_human_weights', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    })
    .then(response => response.json())
      .then(() => {
        if (callback) callback();
      })
      .catch(error => console.log(error))
  }

  onSubmit = () => {
    const newRl = this.state.rankedList.map((rl, i) => ({ ...rl, human_rank: i+1 }));
    this.props.setRankedList(newRl);
    let callback;
    if (this.props.round < 2) {
      // do another round of tuning
      callback = () => {
        // this.props.setPairwiseComparisons([...this.props.pairwiseComparisons] + JSON.parse(data.pairwiseComparisons));
        this.props.setRound(this.props.round + 1);
        this.props.history.push('new');
      }
    } else {
      // end the interaction: either move to social or reset
      if (this.props.category === 'request') {
        callback = () => {
          this.props.setRound(0);
          this.props.setCategory('driver');
          this.props.history.push('/react/social_preference_overview');
        }
      } else {
        callback = () => {
          this.endFlow(true)
        }
      }
    }
    this.saveRankedList(newRl, callback);
  }

  endFlow = (skipAutofill) => {
    console.log("skip", skipAutofill);
    if (!skipAutofill) {
      console.log('saving.....')
      const newRl = this.state.rankedList.map((rl) => ({ ...rl, human_rank: rl.model_rank }));
      this.props.setRankedList(newRl);
      this.saveRankedList(newRl);
    }
    if (this.props.category === 'request') {
      this.props.setRound(0);
      this.props.setCategory('driver');
      this.props.history.push('/react/social_preference_overview');
    } else {
      this.props.endFlow();
      this.props.history.push('done')
    }
  }

  renderFeatureWeightsFromModel = (index) => {
    return this.state.model_weights.map((weight, i) => {
      if (index === i) {
      return (
              <div key={`model-weight-${index}`}>
                <p className="learned-accuracy">{weight.toFixed(2)}</p>
              </div>
              );
      }
    });
  }

  renderFeatureWeights = () => {
    return this.state.featureWeights.map((feature, i) => {
      return (
        <tbody>
          <tr>
            <td style={{width:"160px",color: "#636363"}}>{this.renderFeatureWeightsFromModel(i)}</td>
            <td style={{color: "#636363"}}>{feature[0]}</td>
          </tr>
          <tr>
            <td></td>
            <td style={{color: "#5A80BD", paddingTop: "0px", paddingBottom: "40px"}}>Your chosen importance: {feature[1]}%</td>
          </tr>
        </tbody>
      )
   });
  }


  renderFeatures = (rle) => {
    return rle.features.map((feature, i) => {
      return (
        <div key={`${rle.id}_feature_${i}`}>
            <p className="feature-value"> {feature.feat_value} </p>
            {feature.feat_unit && <p className="feature-value"> &nbsp;{feature.feat_unit} </p>}
        </div>
      );
    });
  }

  renderScenarioScore = (rle) => {
    return (
            <div key={`${rle.id}_rle_score`}>
              <p className="scenario-score">{rle.score}</p>
            </div>
    )
  }

  renderFeatureNames = () => {
    if (this.state.rankedList.length === 0) {
      return <div></div>;
    }
    const elem = this.state.rankedList[0];
    return elem.features.map((feature, i) => {
      return (
        <div key={`${elem.id}_feature_${i}`}>
          <p className="rl-feature-name">  {feature.feat_name} </p>
        </div>
      );
    });
  }

  renderScenarios = () => {
    return this.state.rankedList.map((rle, i) => {
      return (
        <Draggable draggableId={rle.id} index={i} key={rle.id}>
          {provided => (
            <div ref={provided.innerRef} {...provided.draggableProps} {...provided.dragHandleProps} className="rl-col">
              <img className="dnd-indicator"src={DndIndicator} />
              <div className="card default">
                <div className="card-content" style={{padding: "14px"}}>
                  <h5 className="scenario-header">{this.renderScenarioScore(rle)}</h5>
                  {this.renderFeatures(rle)}
                </div>
              </div>
            </div>
          )}
        </Draggable>
      );
    });
  }

  renderRLHeader = () => {
    return (
      <div className="rl-row">
        <div className="rl-feature-col">
          <h3></h3>
        </div>
        <div className="rl-col">
          <h3 className="rl-header">Most Preferable</h3>
          <img className="rl-header-cirlce" src={CircleOne} />
        </div>
        <div className="rl-col">
          <img className="rl-header-cirlce" src={CircleTwo} />
        </div>
        <div className="rl-col">
          <img className="rl-header-cirlce" src={CircleThree} />
        </div>
        <div className="rl-col">
          <img className="rl-header-cirlce" src={CircleFour} />
        </div>
        <div className="rl-col">
          <h3 className="rl-header">Least Preferable</h3>
          <img className="rl-header-cirlce" src={CircleFive} />
        </div>
      </div>
    );
  }

  onDragEnd = (e) => {
    const source = e.source;
    const dest = e.destination;
    if (!source || !dest) {
      return;
    }
    const rl = [...this.state.rankedList];
    rl.splice(dest.index, 0, rl.splice(source.index, 1)[0]);
    this.setState({rankedList: rl, changed: true });
  }

  render() {
    if (this.props.round != 2) {
      var submitButton = <a className="btn" id="submit_btn" onClick={this.onSubmit} disabled={!this.state.changed} > Submit Changes </a>;
      var noChangesNeededButton = <a className="btn" id="lgtm_btn" onClick={() => this.endFlow(false)}> No Changes Needed </a>;
      if (this.props.round == 0) {
        var title = <h3 className="title">{this.props.category === 'request' ? "Work Preference" : "Work Distribution"} Model</h3>;
      } else {
        var title = <h3 className="title">{this.props.category === 'request' ? "Work Preference" : "Work Distribution"} Model Round 2</h3>
      }
    } else {
      var title = <h3 className="title">{this.props.category === 'request' ? "Work Preference" : "Work Distribution"} Final Model</h3>;
      var noChangesNeededButton = <a></a>;
      var submitButton = <a className="btn" id="submit_btn" onClick={this.onSubmit}> Next </a>;
    } 
    return (
      <div id="rl-page">
        {title}
        <hr className="feature-hr" />
        <p className="about-text">
          This is going to be an overview page of the algorithm you've just created. Here, you can see the overally accuracy of your algorithm as well
          as look at the difference in weight your algorithm put on each feature compared to your initial importance rating. You will also be able to 
          see an example of 5 scenarios that your algoritm has ranked. If the ranking is incorrect, you will be able to adjust it to tune your algorithm.
        </p>
        <h4 className="rl-subtitle">Algorithm Profile</h4>
        <div>
        <img className="accuracy-image" src={Accuracy} />
          <h6 className="rl-subtitle2">Algorithm Accuracy: ###</h6>
          <p className="about-text">
            By looking at the accuracy score, you can see the overall percentage of the time that the model chose correctly. 
            For instance, if the accuracy score is 90%, the model you trained made the same choices as you 90% of the time 
            when it was presented the same set of comparisons.
          </p>
        </div>
        <table className="accuracy-table">
          <tr>
            <th>Learned Weight</th>
          </tr>
          {this.renderFeatureWeights()}
        </table>

        <h5 className="rl-subtitle">Example Decision From Model</h5>
        <p className="about-text">
          This is a list of scenarios that the algorithm has ranked from most to least preferable. Please go through the lsit and see if the 
          algorithm ranked these scenarios correctly. If not, <b>please drag and drop the scenarios into the correct rank</b>.
        </p>
        <DragDropContext onDragEnd={this.onDragEnd} isDragDisabled={this.props.round > 1}>
          <div>
            {this.renderRLHeader()}
              <Droppable droppableId="row" direction="horizontal" isDropDisabled={this.props.round > 1} >
                {provided => (
                  <div
                    ref={provided.innerRef}
                    {...provided.droppableProps}
                  >
                    <div className="rl-row">
                      <div className="rl-feature-col">
                        <h5 className="rl-subtitle3">Scenario Score</h5>
                        {this.renderFeatureNames()}
                      </div>
                      {this.renderScenarios()}
                      {provided.placeholder}
                    </div>
                  </div>
                )}
              </Droppable>
          </div>
          <div className="row">
            {submitButton}
            {noChangesNeededButton}
          </div>
        </DragDropContext>
      </div >
    );
  }
}

RLView.propTypes = {
  category: PropTypes.string.isRequired,
  round: PropTypes.number.isRequired,
  rankedList: PropTypes.array.isRequired,
  ranklistId: PropTypes.number.isRequired,
  setRankedList: PropTypes.func.isRequired,
  setRound: PropTypes.func.isRequired,
  setCategory: PropTypes.func.isRequired,
  endFlow: PropTypes.func.isRequired,
  featureWeights: PropTypes.object.isRequired,
  setFeatureWeights: PropTypes.func.isRequired,
};

const mapStoreStateToProps = (storeState, givenProps) => {
  return {
    ...givenProps,
    category: storeState.category,
    round: storeState.round,
    rankedList: storeState.rankedList,
    ranklistId: storeState.ranklistId,
    pairwiseComparisons: storeState.pairwiseComparisons,
    featureWeights: storeState.featureWeights,
    model_weights: storeState.model_weights,
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    setRankedList: (payload) => dispatch({ type: ACTION_TYPES.SET_RANKED_LIST, payload }),
    setRound: (payload) => dispatch({ type: ACTION_TYPES.SET_ROUND, payload }),
    setCategory: (payload) => dispatch({ type: ACTION_TYPES.SET_CATEGORY, payload }),
    setPairwiseComparisons: (payload) => dispatch({ type: ACTION_TYPES.SET_PAIRWISE_COMPARISONS, payload }),
    endFlow: (payload) => dispatch({ type: ACTION_TYPES.END_RL_FLOW, payload }),
    setFeatureWeights: (payload) => dispatch({type: ACTION_TYPES.SET_FEATURE_WEIGHTS, payload}),
  }
}

const RankedListView = connect(mapStoreStateToProps, mapDispatchToProps)(RLView);
export default RankedListView;