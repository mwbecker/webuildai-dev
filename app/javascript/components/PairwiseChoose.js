import React from "react";
import { connect } from "react-redux";
import PairwiseComparison from "./PairwiseComparison";

class PWChoose extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      comparisonNum: 0,
      choice: null,
      reason: "",
    }
  }

  nextScenario = () => {
    const choice = this.state.choice;
    // TODO save it in the db
    const oldComparisonNum = this.state.comparisonNum;
    this.setState({choice: null, comparisonNum: oldComparisonNum+1});
  }

  onChoose = (choice) => {
    return () => {
      this.setState({choice});
    }
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
            <input id="<%=pc.id %>-A" className="with-gap" name="group3" type="radio" onClick={this.onChoose(1)} />
            <span>Choose #{pw.scenario_1.group_id}</span>
          </label>
          <label style={{display:"inline", marginRight:"5%"}}>
            <input id="<%=pc.id %>-B" className="with-gap" name="group3" type="radio" onClick={this.onChoose(2)} />
            <span>Choose #{pw.scenario_2.group_id}</span>
          </label>
          <label style={{display:"inline"}}>
            <input id="<%=pc.id %>-N" className="with-gap" name="group3" type="radio" onClick={this.onChoose(-1)} />
            <span>Neither</span>
          </label>
          <br/>
          <br/>
          {this.state.choice &&
            <input onChange={this.onReasonChange} style={{marginLeft:"-27%", overflow: "visible"}} id="reason-<%= pc.id %>" type="text" name="lower" placeholder="Tell us why you chose this option —" />
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
    return (
      <div id="aller_encompassing" >
        <h3 id="titulo" className="title"> Which Request Would You Like to Receive? </h3>
        <hr className="feature-hr" />
        <br />
        <div>
          <p id="prompt" className="feature-text">
            Please choose which request you prefer.
          </p>
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
        <br/><br/><br/><br/><br/><br/><br/><br/>
      </div>
    );
  }
}

const mapStoreStateToProps = (state, givenProps) => {
  return {
    history: givenProps.history,
    features: state.selectedFeatures,
    category: state.category,
    pairwiseComparisons: state.pairwiseComparisons,
  }
}

const PairwiseChoose = connect(mapStoreStateToProps)(PWChoose);

export default PairwiseChoose;