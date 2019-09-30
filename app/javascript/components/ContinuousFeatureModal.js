
import React from 'react';
import PropTypes from 'prop-types';

class ContinuousFeatureModal extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: "",
      units: "",
      isPercentage: null,
      minValue: 0,
      maxValue: 0,
    }
  }

  onFeatureNameChange = (e) => {
    this.setState({name: e.target.value});
  }

  onUnitChange = (e) => {
    this.setState({units: e.target.value});
  }

  setIsPercentage = (isPercentage) => {
    return () => this.setState({isPercentage})
  }

  canSubmit = () => {
    return (this.state.name !== "" &&
            this.state.units !== "" &&
            this.state.isPercentage !== null &&
            !(!this.state.isPercentage && this.state.maxValue <= this.state.minValue));
  }

  onMinValueChange = (e) => {
    const minValue = parseInt(e.target.value);
    if (minValue !== NaN) {
      this.setState({minValue});
    }
  }

  onMaxValueChange = (e) => {
    const maxValue = parseInt(e.target.value);
    if (maxValue !== NaN) {
      this.setState({maxValue});
    }
  }

  onSubmit = () => {
    const res = {...this.state, weight: 0};
    if (this.state.isPercentage) {
      res.minValue = 0;
      res.maxValue = 100;
    }
    this.props.onSubmit(res);
  }

  render() {
    return (
      <div id = "con_con" className="container" style={{width: "100%"}} >
        <h4 className="modal-header"> Add Continuous Feature </h4>
        <a className="btn" onClick={this.props.onClose} style={{float: "right", marginTop:"-50px"}}>
          &times;
        </a>
        <hr className="modal-hr"/>
        <br/>
        <form>
          <label htmlFor="feature-name" className="feature-label">
            Feature Name
          </label>
          <input id="feature-name" type="text" name="featurename" placeholder="Feature Name" onChange={this.onFeatureNameChange} />

          <label htmlFor="feature-units" className="feature-label">
            Units
          </label>
          <input id="feature-units" type="text" name="featureunits" placeholder="ex: miles" onChange={this.onUnitChange}/>
                  {/* <% if current_user.role == 'admin' %>
          <br/ > <br/>
                    <label for="con_category" style="color:black;font-weight:bold;font-size:1.38em;margin-bottom:0.5vh;"> Category/Type </label>
                    <input id="con_category" type="text" name="featurename" value="" placeholder="Category Name">
                      <% else %>
       <label for="con_category" style="color:black;font-weight:bold;font-size:1.38em;margin-bottom:0.5vh;display:none"> Category/Type </label>
                      <input id="con_category" type="text" name="featurename" value="" placeholder="Category Name" style="display:none">
                        <% end %> */}

          {/* <!-- Range (Numeric vs. Percentage) --> */}
          <p className="feature-label"> Range Options </p>
          <p>
            <label htmlFor="percentage">
              <input id="percentage" className="with-gap" type="radio" name="range-group5" onClick={this.setIsPercentage(true)} />
              <span style={{color:"black", fontSize:"1.3em"}}>Percentage ( 0%~100% ) </span>
              <br/>
              <span style={{color: "#808080"}}>ex. The customer pays tips to couriers 57% of the time.</span>
            </label>
          </p>

          <p>
            <label htmlFor="numerical">
              <input id="numerical" className="with-gap" type="radio" name="range-group5" onClick={this.setIsPercentage(false)} />
              <span style={{color:"black", fontSize:"1.3em"}}>Numerical</span>
              <br />
              <span style={{color: "#808080"}}>ex. Most customers are between 18 and 45 years old.</span>
            </label>
          </p>

          {/* <!-- If numeric, need to specify lower/upper bound --> */}
          { this.state.isPercentage === false  && (
            <div id="num_input_div" className="row">
              <div className="input-field col s6">
                {/* <!-- TODO: add validations for numbers only (upper > lower, is a number, etc.) --> */}
                <input id="lower-bound" type="text" placeholder="18" onChange={this.onMinValueChange} />
                <span className="helper-text">Minimum Value</span>
              </div>
              <div className="input-field col s6">
                <input id="upper-bound" type="text" placeholder="45" onChange={this.onMaxValueChange}/>
                <span className="helper-text">Maximum Value</span>
              </div>
            </div>
            )
          }
          <br/>
        </form>
        <br/>
        <a disabled={!this.canSubmit()} onClick={this.onSubmit} className="waves-effect waves-dark btn" id="submit_con_btn" style={{width:"20%", color: "#FFFFFF", display:"block", backgroundColor:"#3d6ab1"}}>
          Submit
        </a>
      </div>
    );
  }
}

ContinuousFeatureModal.propTypes = {
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
}

export default ContinuousFeatureModal;