
import React from "react";
import PropTypes from "prop-types";

class Scenario extends React.Component {
  renderFeatures = () => {
    console.log(this.props.features);
    return this.props.features.map((feature, i) => {
      return (
        <div className="cardRow" key={i}>
          <div className="column left">
            <p className="feature-name">  {feature.feat_name} </p>
          </div>
          <div className="column right">
            <p className="feature-value" style={{display:"inline-block"}}> {feature.feat_value} </p>
            {feature.feat_unit && <p style={{display:"inline-block"}}> &nbsp;{feature.feat_unit} </p>}
          </div>
        </div>
      );
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
  id: PropTypes.number.isRequired,
  features: PropTypes.any.isRequired,
}

export default Scenario;