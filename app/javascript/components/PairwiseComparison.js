import React from "react";
import PropTypes from "prop-types";
import Scenario from "./Scenario";

class PairwiseComparison extends React.Component {
  render() {
    return (
      <div style="width:70%;margin-left:15%;" >
        <div className="scenario_1" id="<%= pc.id %>-1" style="width:45%;float:left;margin-right:5%;">
          <div className="row">
            <Scenario id={left.id} features={left.features} />
          </div>
        </div>

        <div className="scenario_2" id="<%=pc.id%>-2" style="width:45%;float:right;">
          <div className="row">
            <Scenario id={right.id} features={right.features} />
          </div>
        </div>
      </div>
    );
  }
}

PairwiseComparison.propTypes = {
  left: PropTypes.object.isRequired,
  right: PropTypes.object.isRequired,
  category: PropTypes.string.isRequired,
}

export default PairwiseComparison;