import React from 'react';
import PropTypes from 'prop-types';
import ContinuousFeatureModal from './ContinuousFeatureModal';
import CategoricalFeatureModal from './CategoricalFeatureModal';

class NewFeatureModal extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isCategorical: null,
      currPage: 0,
    }
  }

  onRadioChange = (isCategorical) => {
    return () => {
      this.setState({isCategorical});
    }
  }

  onSubmit = (isCategorical) => {
    return (newFeature) => {
      this.props.addFeature(isCategorical, newFeature);
      this.props.onClose();
    }
  }

  goToNewFeaturePage = () => {
    if (this.state.isCategorical) {
      this.setState({currPage: 1});
    } else {
      this.setState({currPage: 2});
    }
  }

  renderStartPage = () => {
    return (
      <React.Fragment>
        <div id="modal_cont">
          <div>
            <h4 className="modal-title">Add Your Own Feature</h4>
            <a className="modal-exit-button disabled" onClick={this.props.onClose}>
              &times;
            </a>
          </div>
          <hr className="modal-hr"/>
          <br/>
        </div>
        <p className="modal-subheader">
          Categorical features are qualitative.
        </p>
        <p className="modal-text">
          Examples include gender, race, and neighborhood.
        </p>

        <p className="modal-subheader">
          Continuous features are quantitative.
          </p>
        <p className="modal-text">
          Examples include income level, the length of a part of a day, and the time a payment is issued.
        </p>
        <br />
        <p className="modal-subheader">
          Is your feature categorical or continuous?
        </p>

        <form action="#" className = "add_form">
          <label style={{display:"inline", marginRight:"5%", fontSize:"20px"}}>
            <input id="cat" className="with-gap" name="group3" type="radio" onClick={this.onRadioChange(true)}/>
            <span className="modal-text">Categorical</span>
          </label>
          <br/> <br/>
          <label style={{display:"inline", marginRight:"5%", fontSize:"20px",}}>
            <input id="con" className="with-gap" name="group3" type="radio" onClick={this.onRadioChange(false)} />
            <span className="modal-text">Continuous</span>
          </label>
        </form>

        <a disabled={this.state.isCategorical === null}
           className="modal-next-button" id="next_btn"
           onClick={this.goToNewFeaturePage}
        >
          NEXT
        </a>
      </React.Fragment>
    );
  }

  render() {
    return (
      <div id="myModal">
        <div className="modal-content" >
          {this.state.currPage === 0 && this.renderStartPage()}
          {
            this.state.currPage === 1 && (
            <CategoricalFeatureModal
                onClose={this.props.onClose}
                onSubmit={this.onSubmit(true)}
              />
          )
          }
          {
            this.state.currPage === 2 && (
              <ContinuousFeatureModal
                onClose={this.props.onClose}
                onSubmit={this.onSubmit(false)}
              />
            )
          }

            {/* <%= render partial: 'categorical_add.html.erb' %> */}
            {/* <%= render partial: 'continuous_add.html.erb' %> */}

        </div>
      </div>
    );
  }
}

NewFeatureModal.propTypes = {
  category: PropTypes.string.isRequired,
  onClose: PropTypes.func.isRequired,
  addFeature: PropTypes.func.isRequired,
}

export default NewFeatureModal;