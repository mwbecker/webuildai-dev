
import React from 'react';
import PropTypes from 'prop-types';

class CategoricalFeatureModal extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: "",
      opts: "",
      description: "",
    }
  }

  onFeatureNameChange = (e) => {
    this.setState({ name: e.target.value });
  }

  setOpts = (opts) => {
    return () => this.setState({ opts })
  }

  canSubmit = () => {
    return (this.state.name !== "" && this.state.opts !== "");
  }

  onSubmit = () => {
    this.props.onSubmit({ ...this.state, weight: 0 });
  }

  onCategoryChange = (e) => {
    this.setState({description: e.target.value});
  }

  render() {
    return (
      <div id="con_con" className="container" style={{ width: "100%" }} >
        <h4 className="modal-header"> Add Categorical Feature </h4>
        <a className="btn" onClick={this.props.onClose} style={{ float: "right", marginTop: "-50px" }}>
          &times;
        </a>
        <hr className="modal-hr" />
        <br />
        <form>
          <label htmlFor="feature-name" className="feature-label">
            Feature Name
          </label>
          <input id="feature-name" type="text" name="featurename" placeholder="Feature Name" onChange={this.onFeatureNameChange} />

          {
            this.props.displayDescription && (
              <React.Fragment>
                <br/>
                <br/>
                <label htmlFor="con_category" className="model-subheader"> Category/Type </label>
                <input id="con_category" type="text" placeholder="Category Name" onChange={this.onCategoryChange}></input>
              </React.Fragment>
            )
          }

          {/* <!-- Range (Numeric vs. Percentage) --> */}
          <p className="feature-label"> Range Options </p>
          <p>
            <label htmlFor="percentage">
              <input id="percentage" className="with-gap" type="radio" name="range-group5" onClick={this.setOpts("High*Medium*Low")} />
              <span style={{ color: "black", fontSize: "1.3em" }}>High / Mid / Low</span>
              <br />
              <span style={{ color: "#808080" }}>ex. A person's preference towards a destination.</span>
            </label>
          </p>

          <p>
            <label htmlFor="numerical">
              <input id="numerical" className="with-gap" type="radio" name="range-group5" onClick={this.setOpts("Yes*No")} />
              <span style={{ color: "black", fontSize: "1.3em" }}>Yes / No</span>
              <br />
              <span style={{ color: "#808080" }}>ex. Does the customer have a pet?</span>
            </label>
          </p>

          {/* <p>
            <label htmlFor="freeform">
              <input id="freeform" className="with-gap" type="radio" name="range-group5" onClick={this.setType("freeform")} />
              <span style={{ color: "black", fontSize: "1.3em" }}>Freeform</span>
              <br />
            </label>
          </p> */}

          {/* <!-- If numeric, need to specify lower/upper bound --> */}
          {this.state.type === "freeform" && (
            <div id="num_input_div" className="row">
              <div className="input-field col s6">
                {/* <!-- TODO: add validations for numbers only (upper > lower, is a number, etc.) --> */}
                <input id="lower-bound" type="text" placeholder="18" onChange={this.onMinValueChange} />
                <span className="helper-text">Minimum Value</span>
              </div>
              <div className="input-field col s6">
                <input id="upper-bound" type="text" placeholder="45" onChange={this.onMaxValueChange} />
                <span className="helper-text">Maximum Value</span>
              </div>
            </div>
          )
          }
          <br />
        </form>
        <br />
        <a disabled={!this.canSubmit()} onClick={this.onSubmit} className="waves-effect waves-dark btn" id="submit_con_btn" style={{ width: "20%", color: "#FFFFFF", display: "block", backgroundColor: "#3d6ab1" }}>
          Submit
        </a>
      </div>
    );
  }
}

CategoricalFeatureModal.propTypes = {
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  displayDescription: PropTypes.bool,
}

export default CategoricalFeatureModal;