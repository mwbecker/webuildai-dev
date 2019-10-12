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
// import Scenario from "./Scenario";

class RLView extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      rankedList: [],
      changed: false,
    }
  }

  componentDidMount() {
    const rl = [...this.props.rankedList];
    rl.sort((a, b) => a.model_rank - b.model_rank);
    this.setState({ rankedList: rl });
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
    if (this.props.round < 1) {
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

  renderFeatureNames = () => {
    if (this.state.rankedList.length === 0) {
      return <div></div>;
    }
    const elem = this.state.rankedList[0];
    return elem.features.map((feature, i) => {
      return (
        <div key={`${elem.id}_feature_${i}`}>
          <p className="feature-name">  {feature.feat_name} </p>
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
                <div className="card default">
                  <div className="card-content">
                    <h5 className="pc-header" style={{marginTop:"1%"}}>Scenario #{rle.id}</h5>
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
        <div className="rl-col">
          <h3></h3>
        </div>
        <div className="rl-col">
          <h3 className="rl-header">Most Preferable</h3>
          <img className="rl-header-cirlce" src={CircleOne} />
        </div>
        <div className="rl-col">
          <h3 className="rl-header">Preferable</h3>
          <img className="rl-header-cirlce" src={CircleTwo} />
        </div>
        <div className="rl-col">
          <h3 className="rl-header">Neutral</h3>
          <img className="rl-header-cirlce" src={CircleThree} />
        </div>
        <div className="rl-col">
          <h3 className="rl-header">Not Preferable</h3>
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
    return (
      <div id="rl-page">
        <h3 className="title">{this.props.category === 'request' ? 'Individual ' : 'Social '} Preference Models</h3>
        <hr className="feature-hr" />
        <p className="about-text">
          The model list is a list of scenarios that the AI has ranked from most preferable to least preferable.
          Please go through the list and see if the algorithm ranked these scenarios correctly. If not,
          <b> please drag and drop the scenarios into the correct rank. </b>
        </p>

        <DragDropContext onDragEnd={this.onDragEnd}>
          <div>
            {this.renderRLHeader()}
              <Droppable droppableId="row" direction="horizontal" >
                {provided => (
                  <div
                    ref={provided.innerRef}
                    {...provided.droppableProps}
                  >
                    <div className="rl-row">
                      <div className="rl-col">
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
            <a className="btn" id="submit_btn" onClick={this.onSubmit} disabled={!this.state.changed} > Submit Changes </a>
            <a className="btn" id="lgtm_btn" onClick={() => this.endFlow(false)}> No Changes Needed </a>
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
};

const mapStoreStateToProps = (storeState, givenProps) => {
  return {
    ...givenProps,
    category: storeState.category,
    round: storeState.round,
    rankedList: storeState.rankedList,
    ranklistId: storeState.ranklistId,
    pairwiseComparisons: storeState.pairwiseComparisons,
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    setRankedList: (payload) => dispatch({ type: ACTION_TYPES.SET_RANKED_LIST, payload }),
    setRound: (payload) => dispatch({ type: ACTION_TYPES.SET_ROUND, payload }),
    setCategory: (payload) => dispatch({ type: ACTION_TYPES.SET_CATEGORY, payload }),
    setPairwiseComparisons: (payload) => dispatch({ type: ACTION_TYPES.SET_PAIRWISE_COMPARISONS, payload }),
    endFlow: (payload) => dispatch({ type: ACTION_TYPES.END_RL_FLOW, payload }),
  }
}

const RankedListView = connect(mapStoreStateToProps, mapDispatchToProps)(RLView);
export default RankedListView;