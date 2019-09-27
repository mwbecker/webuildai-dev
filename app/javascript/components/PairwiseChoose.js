import React from "react";
import { connect } from "react-redux";
import PairwiseComparison from "./PairwiseComparison";

class PWChoose extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      comparisonNum: 0,
    }
  }

  renderPairwiseComparisons = () => {
    return this.props.pairwiseComparisons.map((pw) => (
      <PairwiseComparison left={pw.scenario_1} right={pw.scenario_2} category={this.props.category} />
    ));
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
          <p id="top-counter" className="feature-text" align="right" style="margin-top:-3%;font-weight:bold;">
            Scenario {this.state.comparisonNum}/{this.props.pairwiseComparisons.length}
          </p>
        </div>
        <br />
        <div id="all_encompassing" className="0">
          {this.renderPairwiseComparisons()}
          <div style="margin-left:35%;" className="f-<%= pc.id %>">
            <label style="display:inline;margin-right:5%;">
              <input id="<%=pc.id %>-A" className="with-gap" name="group3" type="radio" />
              <span>Choose A</span>
            </label>
            <label style="display:inline;margin-right:5%;">
              <input id="<%=pc.id %>-B" className="with-gap" name="group3" type="radio" />
              <span>Choose B</span>
            </label>
            <label style="display:inline">
              <input id="<%=pc.id %>-N" className="with-gap" name="group3" type="radio" />
              <span>Neither</span>
            </label>
            <br/>
            <br/>
            <input style="margin-left:-27%; overflow:visible" id="reason-<%= pc.id %>" type="text" name="lower" value="" placeholder="Tell us why you chose this option —" />
            <br/>
            <br/>
              <p id="error_r-<%= pc.id %>" style="margin-left:-27%;color:red;margin-top:-1%;">
                Reason cannot be blank
              </p>
          </div>
        </div>
        <br/><br/><br/>
        <a className="btn" id="next_btn" style="margin-left:40%;width:20%;color:#FFFFFF;background-color:#3d6ab1;font-weight:bold;" >
                  Next Scenario
        </a>
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