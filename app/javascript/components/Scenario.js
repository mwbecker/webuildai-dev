
import React from "react";
import PropTypes from "prop-types";

class Scenario extends React.Component {
  renderFeatures = () => {
    return this.props.features.map((feature) => {
        <div className="cardRow">
          <div className="column left">
            <p className="feature-name">  {feature.feat_name} </p>
          </div>
          <div className="column right">
            <p className="feature-value" style="display:inline-block"> {feature.feat_value} </p>
            {feature.unit && <p style="display:inline-block"> {feature.unit} </p>}
          </div>
        </div>
    });
  }

  render() {
    return (
      <div className="card default">
        <div className="card-content">
        <h5>Scenario #{this.props.id}</h5>
        {this.renderFeatures()}
        </div>
      </div>
    )
  }
}

Scenario.propTypes = {
  id: PropTypes.string.isRequired,
  features: PropTypes.object.isRequired,
}

export default Scenario;