
import React from "react";
import PropTypes from "prop-types";

class Scenario extends React.Component {
  renderFeatures = () => {
    return this.props.features.map((feature, i) => {
      return (
        <div>
          <div>
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
          <h5 className="pc-header" style={{textAlign: "center", marginBottom:"7%"}}>Scenario #{this.props.id}</h5>
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