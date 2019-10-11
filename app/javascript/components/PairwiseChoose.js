import React from "react";
import { connect } from "react-redux";
import PairwiseComparison from "./PairwiseComparison";
import { ACTION_TYPES } from '../store';

class PWChoose extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      comparisonNum: 0,
      choice: null,
      reason: "",
    }
    this.reasonRef = React.createRef();
  }

  nextScenario = () => {
    const choice = this.state.choice;
    // TODO save it in the db
    const oldComparisonNum = this.state.comparisonNum;
    this.props.pairwiseComparisons[this.state.comparisonNum].choice = choice === -1 ? null : choice;
    const id = this.props.pairwiseComparisons[this.state.comparisonNum].id
    this.setState({choice: null, comparisonNum: oldComparisonNum+1 < this.props.pairwiseComparisons.length ? oldComparisonNum + 1 : oldComparisonNum}, () => {
      fetch('/api/v1/pairwise_comparisons/update_choice', {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({pairwise_id: id, choice, reason: this.state.reason }),
      })
      .then(() => {
        if (oldComparisonNum+1 >= this.props.pairwiseComparisons.length) {
          this.props.history.push('/react/ranked_list/new');
        }
        this.props.setPairwiseComparisons(this.props.pairwiseComparisons);
      })
      .catch(err => console.log(err));
    });
  }

  onChoose = (choice) => {
    return () => {
      this.setState({choice}, () => {
        this.reasonRef.current.focus();
      });
    }
  }

  skipChoosing = () => {
    for (let i = 0; i < this.props.pairwiseComparisons.length; i++) {
      this.props.pairwiseComparisons[i].choice = 1
      fetch('/api/v1/pairwise_comparisons/update_choice', {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ pairwise_id: this.props.pairwiseComparisons[i].id, choice: 1, reason: 'test' }),
        })
          .then()
          .catch(err => console.log(err));
    }
    this.props.setPairwiseComparisons(this.props.pairwiseComparisons);
    this.props.history.push('/react/ranked_list/new');
  }

  onReasonChange = (event) => {
    this.setState({reason: event.target.value});
  }

  renderPairwiseComparisons = () => {
    const pw = this.props.pairwiseComparisons[this.state.comparisonNum];
    return (
      <React.Fragment>
        <PairwiseComparison left={pw.scenario_1} right={pw.scenario_2} category={this.props.category} />
        <div style={{marginLeft:"35%"}} className="f-<%= pc.id %>">
          <label style={{display:"inline", marginRight:"5%" }}>
            <input id="<%=pc.id %>-A" className="with-gap" name="group3" type="radio" onChange={this.onChoose(1)} checked={this.state.choice === 1} />
            <span style={{ marginTop:"3%",fontWeight:"bold",fontFamily:"Helvetica Neue, sans-serif",}}>Choose #{pw.scenario_1.group_id}</span>
          </label>
          <label style={{display:"inline", marginRight:"5%"}}>
            <input id="<%=pc.id %>-B" className="with-gap" name="group3" type="radio" onChange={this.onChoose(2)} checked={this.state.choice === 2} />
            <span style={{ marginTop:"3%",fontWeight:"bold",fontFamily:"Helvetica Neue, sans-serif" }}>Choose #{pw.scenario_2.group_id}</span>
          </label>
          <label style={{display:"inline"}}>
            <input id="<%=pc.id %>-N" className="with-gap" name="group3" type="radio" onChange={this.onChoose(-1)} checked={this.state.choice === -1} />
            <span style={{ marginTop:"3%",fontWeight:"bold",fontFamily:"Helvetica Neue, sans-serif" }}>Neither</span>
          </label>
          <br/>
          <br/>
          {this.state.choice &&
            <input
              onChange={this.onReasonChange}
              style={{marginLeft:"-27%", overflow: "visible"}}
              id="reason-<%= pc.id %>" type="text" name="lower"
              ref={this.reasonRef}
              placeholder="Tell us why you chose this option —" />
          }
          <br/>
          <br/>
          {/* {this.state.choice && this.state.reason === "" &&
            <p id="error_r-<%= pc.id %>" style={{marginLeft:"-27%", color:"red", marginTop:"-1%"}}>
              Reason cannot be blank
            </p>
          } */}
        </div>
      </React.Fragment>
    );
  }

  render() {
    let title = "";
    let description = "";
    if (this.props.category == 'request') {
      title = <h3 id="titulo" className="title"> Which Request Would You Like to Receive? </h3>;
      description = <p id="prompt" className="feature-text">Please choose which request you prefer.</p>;
    } else {
      title = <h3 id = "titulo" className="title"> Who Should Get the Request?? </h3>;
      description = <p id="prompt" className="feature-text">Please choose which driver should get the ping.</p>;
    }

    return (
      <div id="aller_encompassing" >
        {title}
        <hr className="feature-hr" />
        <br />
        <div>
          {description}
          <p id="top-counter" className="feature-text" align="right" style={{marginTop:"-3%", fontWeight: "bold"}}>
            Scenario {this.state.comparisonNum+1}/{this.props.pairwiseComparisons.length}
          </p>
        </div>
        <br />
        <div id="all_encompassing" className="0">
          {this.renderPairwiseComparisons()}
        </div>
        <br/><br/><br/>
        {this.state.choice &&
          <a
            className="btn"
            onClick={this.nextScenario}
            disabled={this.state.reason === ""}
            id="next_btn"
            style={{marginLeft:"40%", width: "20%", color: "white", backgroundColor:"#3d6ab1", fontWeight:"bold"}}
          >
            Next Scenario
          </a>
        }
        { [1, 2, 3, 4,5,6,7,8,9,10, 11, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65].includes(this.props.participantId) &&
        <React.Fragment>
        <a className="btn" onClick={this.skipChoosing} >[Admin] Skip</a>
        <a className="btn" onClick={this.props.end} >[Admin] Reset Store (please logout after pushing this)</a>
        </React.Fragment>
        }
        <br/><br/><br/><br/><br/><br/><br/><br/>
      </div>
    );
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    setPairwiseComparisons: (payload) => dispatch({ type: ACTION_TYPES.SET_PAIRWISE_COMPARISONS, payload }),
    end: (payload) => dispatch({ type: ACTION_TYPES.END_RL_FLOW, payload}),
  }
}

const mapStoreStateToProps = (state, givenProps) => {
  return {
    history: givenProps.history,
    features: state.selectedFeatures,
    category: state.category,
    pairwiseComparisons: state.pairwiseComparisons,
    participantId: state.participantId,
  }
}

const PairwiseChoose = connect(mapStoreStateToProps, mapDispatchToProps)(PWChoose);

export default PairwiseChoose;