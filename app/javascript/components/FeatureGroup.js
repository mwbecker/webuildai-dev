import React from "react";
import PropTypes from "prop-types";

class FeatureGroup extends React.Component {

  constructor(props) {
    super(props);
  }

  onWeightChange = (i) => {
    return (e) => {
      const weight = e.target.value;
      this.props.changeWeight(i, weight);
  }
}

  renderFeatureSliders = () => {
    return this.props.features.map((feature, i) => (
      <div className="row" key={i}>
        <div className="card" style={{ width: "80%", marginLeft: "10%", }}>
          <div className="card-content" style={{ padding: "50px", marginRight: "-2%" }}>
            <p className="feature-card-text" style={{ maxWidth: "70%", float:"left", wordWrap:"break-word", marginTop:"-1%"}}>
              {feature.name}
            </p>
            <p className="range-field">
              Importance: {feature.weight / 100}
            {/* <input type="text" className="weight" style={{ borderBottom: "none", width: "11%", marginRight: "7%", marginTop: "0%", fontWeight:300, fontSize:"24px", fontFamily: "Helvetica Neue"}} id="textInput-<%=f.id%>" value={feature.weight} /> */}
            <input type="range" style={{ width: "40%", float: "right", color: "blue",}}
               id="test5-<%=f.id%>" min="0" max="100" value={feature.weight}
               className="range-importance" onChange={this.onWeightChange(i)} />
            </p>
          </div>
        </div>
      </div>
    ));
  }

  render() {
    return this.props.features.length === 0 ? null : (
      <React.Fragment>
        <h5 className="subheader">{this.props.description}</h5>
        {this.renderFeatureSliders()}
      </React.Fragment>
    );
  }
}

FeatureGroup.propTypes = {
  description: PropTypes.string.isRequired,
  features: PropTypes.any.isRequired,
  changeWeight: PropTypes.func.isRequired,
}

export default FeatureGroup;