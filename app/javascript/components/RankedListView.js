import React from "react"
import { connect } from "react-redux";
import { ACTION_TYPES } from "../store";

const RANK_LB = 1;
const RANK_UB = 5;

class RLView extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      rankedList: []
    }
  }

  componentDidMount() {
    const rl = [...this.props.rankedList];
    rl.sort((a, b) => a.model_rank - b.model_rank);
    this.setState({ rankedList: rl });
  }

  renderFeatures = (rle) => {
    return rle.features.map((feature, i) => {
      return (
        <div className="cardRow" key={`${rle.id}_feature_${i}`}>
          <div className="column left">
            <p className="feature-name">  {feature.feat_name} </p>
          </div>
          <div className="column right">
            <p className="feature-value"> {feature.feat_value} </p>
          </div>
        </div>
      );
    });
  }

  handleChange = (i) => {
    return (event) => {
      const rle = this.state.rankedList[i];
      if (event.target.value === '') {
        rle.human_rank = undefined;
        this.state.rankedList[i] = rle;
        this.setState({ rankedList: this.state.rankedList });
      }
      const humanRank = parseInt(event.target.value);
      if (!isNaN(humanRank) && RANK_LB <= humanRank && humanRank <= RANK_UB) {
        rle.human_rank = humanRank;
        this.state.rankedList[i] = rle;
        this.setState({ rankedList: this.state.rankedList });
      }
    }
  }

  canSubmitRanks = () => {
    const found = [];
    for (let i = RANK_LB; i <= RANK_UB; i++) {
      found.push(false);
    }

    for (const rle of this.state.rankedList) {
      if (!rle.human_rank || rle.human_rank < RANK_LB || rle.human_rank > RANK_UB) return false;
      found[rle.human_rank - RANK_LB] = true;
    }

    for (let i = RANK_LB; i <= RANK_UB; i++) {
      if (!found[i - RANK_LB]) {
        return false;
      }
    }
    return true;
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
      .then(() => {
        if (callback) callback();
      })
      .catch(error => console.log(error))
  }

  onSubmit = () => {
    this.props.setRankedList(this.state.rankedList);
    let callback;
    if (this.props.round < 1) {
      // do another round of tuning
      callback = () => {
        this.props.setRound(this.props.round + 1);
        this.props.history.push('new');
      }
    } else {
      // end the interaction: either move to social or reset
      if (this.props.category === 'request') {
        callback = () => {
          this.props.setRound(0);
          this.props.setCategory('driver');
          this.props.history.push('new');
        }
      } else {
        callback = () => {
          this.endFlow(true)
        }
      }
    }
    this.saveRankedList(this.state.rankedList, callback);
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
      this.props.history.push('new');
    } else {
      this.props.endFlow();
      this.props.history.push('done')
    }
  }

  renderScenarios = () => {
    return this.state.rankedList.map((rle, i) => {
      return (
        <tr key={`rl_${i}`}>
          <td>
            <div className="container">
              <div className="card default">
                <div className="card-content">
                  <h5>Scenario #{rle.id}</h5>
                  {this.renderFeatures(rle)}
                </div>
              </div>
            </div>
          </td >
          <td>
            <div className="block">
              <h5 className="human-rank">Scenario #{rle.id} &nbsp;</h5>
              <input className="scenario-input" type="text" name="scenario-id-input" onChange={this.handleChange(i)} />
            </div>
          </td>
        </tr>
      );
    });
  }

  render() {
    return (
      <div id="rl-page">
        <h1>{this.props.category === 'request' ? 'Individual ' : 'Social '} Preference Models</h1>
        <hr className="feature-hr" />
        <p className="about-text">
          The model list is a list of scenarios that the AI has ranked from most preferable to least preferable.
          Please write the scenario ids in the fields below that represents your ranking of the presented scenarios.
        </p>

        <div className="row">
          <table>
            <tbody>
              <tr>
                <td><h4 className="subheader"> Model List </h4></td>
                <td><h4 className="subheader"> Your Ranks For: </h4></td>
              </tr>
              {this.renderScenarios()}
            </tbody>
          </table>
        </div>
        <div className="row">
          <a className="btn" id="submit_btn" disabled={!this.canSubmitRanks()} onClick={this.onSubmit}> Submit Changes </a>
          <a className="btn" id="lgtm_btn" onClick={() => this.endFlow(false)}> No Changes Needed </a>
        </div>
      </div >
    );
  }
}

const mapStoreStateToProps = (storeState, givenProps) => {
  return {
    ...givenProps,
    category: storeState.category,
    round: storeState.round,
    rankedList: storeState.rankedList,
    ranklistId: storeState.ranklistId,
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    setRankedList: (payload) => dispatch({ type: ACTION_TYPES.SET_RANKED_LIST, payload }),
    setRound: (payload) => dispatch({ type: ACTION_TYPES.SET_ROUND, payload }),
    setCategory: (payload) => dispatch({ type: ACTION_TYPES.SET_CATEGORY, payload }),
    endFlow: (payload) => dispatch({ type: ACTION_TYPES.END_RL_FLOW, payload }),
  }
}

const RankedListView = connect(mapStoreStateToProps, mapDispatchToProps)(RLView);
export default RankedListView;