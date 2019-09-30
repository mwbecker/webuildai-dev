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
            <h4 style={{color:"#3d6ab1", fontWeight:"bold", display: "inline-block"}}>
              Add Your Own Feature
            </h4>
            <a className="btn" style={{float: "right", paddingTop: "6px"}} onClick={this.props.onClose}>
              &times;
            </a>
          </div>
          <hr style={{marginLeft: "-24px", marginRight: "-24px"}} />
          <br/>
        </div>
        <p style={{fontWeight:"bold", fontSize:"1.25em"}}>
          Categorical features are qualitative.
        </p>
        <p style={{fontSize:"1.25em"}}>
          Examples include gender, race, and neighborhood.
        </p>

        <p style={{fontWeight:"bold", fontSize:"1.25em"}}>
          Continuous features are quantitative.
          </p>
        <p style={{fontSize:"1.25em"}}>
          Examples include income level, the length of a part of a day, and the time a payment is issued.
        </p>
        <br />
        <p style={{fontSize:"1.25em"}}>
          Is your feature categorical or continuous?
        </p>

        <form action="#" className = "add_form">
          <label style={{display:"inline", marginRight:"5%"}}>
            <input id="cat" className="with-gap" name="group3" type="radio" onClick={this.onRadioChange(true)}/>
            <span style={{color:"black", fontSize:"1.3em"}}>Categorical</span>
          </label>
          <br/> <br/>
          <label style={{display:"inline", marginRight:"5%"}}>
            <input id="con" className="with-gap" name="group3" type="radio" onClick={this.onRadioChange(false)} />
            <span style={{color:"black", fontSize:"1.3em"}}>Continuous</span>
          </label>
        </form>

        <a disabled={this.state.isCategorical === null}
           className="waves-effect waves-dark btn" id="next_btn" style={{marginTop:"5%", marginLeft:"63%", width:"20.5%", paddingTop:"0.7%", paddingBottom:"5%", color:"#FFFFFF", backgroundColor:"#3d6ab1", fontWeight:"bol", fontSize:"1.2em"}}
           onClick={this.goToNewFeaturePage}
        >
          NEXT
        </a>
      </React.Fragment>
    );
  }

  render() {
    return (
      <div id="myModal" style={{paddingTop:"50px"}}>
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