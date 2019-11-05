
import React from 'react';
import PropTypes from 'prop-types';

class CategoricalFeatureModal extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: "",
      type: "",
    }
  }

  onFeatureNameChange = (e) => {
    this.setState({ name: e.target.value });
  }

  setType = (type) => {
    return () => this.setState({ type })
  }

  canSubmit = () => {
    return (this.state.name !== "" && this.state.type !== "");
  }

  onSubmit = () => {
    this.props.onSubmit({ ...this.state, weight: 0 });
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
              <input id="percentage" className="with-gap" type="radio" name="range-group5" onClick={this.setType("High*Medium*Low")} />
              <span style={{ color: "black", fontSize: "1.3em" }}>High / Mid / Low</span>
              <br />
              <span style={{ color: "#808080" }}>ex. A person's preference towards a destination.</span>
            </label>
          </p>

          <p>
            <label htmlFor="numerical">
              <input id="numerical" className="with-gap" type="radio" name="range-group5" onClick={this.setType("Yes*No")} />
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
}

export default CategoricalFeatureModal;