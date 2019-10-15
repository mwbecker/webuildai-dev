import React from "react";
import PropTypes from "prop-types";

class Scenario extends React.Component {
    renderFeatures = () => {
    var sorted_features = [...this.props.features].sort(function(a, b) {
      return a.feat_id - b.feat_id;
    });
    return sorted_features.map((feature, i) => {
      return (
        <div key={i}>
          <div>
            <p className="pc-feature-icon"> {feature.feat_icon} </p>
            <p className="feature-value"> {feature.feat_value} </p>
            {feature.feat_unit && <p className="feature-value"> &nbsp;{feature.feat_unit} </p>}
          </div>
          <p className="feature-name" style={{marginBottom:"7%", marginTop:"2%"}}>  {feature.feat_name} </p>
        </div>
      );
    });
  }

  render() {
    return (
      <div className="card default">
        <div className="card-content">
          <h5 className="pc-header" style={{textAlign: "center", marginBottom:"7%"}}>{this.props.categoryName} {this.props.location}</h5>
          {this.renderFeatures()}
        </div>
      </div>
    )
  }
}

Scenario.propTypes = {
  id: PropTypes.number.isRequired,
  features: PropTypes.any.isRequired,
}

export default Scenario;