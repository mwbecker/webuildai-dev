import React from "react";
import PropTypes from "prop-types";
import PersonalPref from "../images/Personal_Pref.png";
import { connect } from "react-redux";
import { ACTION_TYPES } from '../store';

class PWIntro extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      loading: false,
    }
  }

  createAndFetchPairwiseComparisons = () => {
    fetch('/api/v1/pairwise_comparisons/generate_pairwise_comparisons', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        category: this.props.category,
        // selected_features: this.props.features.map(f => f.id),
      })
    })
      .then(response => response.json())
      .then((data) => {
        this.setState({loading: false});
        console.log('generated pairwise', data);
        // data.isAdmin, data.pairwiseComparisons
        this.props.setPairwiseComparisons(data.pairwiseComparisons);
        this.props.setParticipantId(data.participantId);
        this.props.setMLServerUrl(data.mlServerUrl);
      })
      .then(() => {
        this.props.history.push('choose');
      })
      .catch(error => console.log(error))
  }

  onClick = () => {
    this.setState({loading: true});
    this.createAndFetchPairwiseComparisons();
  }

  renderSelectedFeatures = () => {
    const features = this.props.features.map((feature, i) => (
      <p className="scenario-names" key={i}>{feature.name}</p>
    ));
    return (<div>{features}</div>);
  }

  render() {
    let title = "";
    let part = "";
    let partDescription = "";
    if (this.props.category == 'request') {
      title = <h3 className="title">Training Your Individual Preference Profile</h3>;
      part = <p className="pg-1-subheader"> Part 1. Personal Preference </p>;
      partDescription = <p className="feature-text">
                          Please assume that the algorithm notifies you of two potential requests.
                          <b> Please choose which request you would prefer the algorithm to match you with. </b>
                          The information below are features you believe that algorithm should consider.
                        </p>
    } else {
      title = <h3 className="title">Training Your Social Preference Profile</h3>;
      part = <p className="pg-1-subheader"> Part 2. Social Ranking </p>;
      partDescription = <p className="feature-text">
                          Please assume that you are the algorithm and you have to assign a request to a driver.
                          <b> Please choose which driver you would prefer the algorithm to give the request. </b>
                          The information below are features you believe that algorithm should consider.
                        </p>
    }

    return (
      <div id="pg_1" >
        {title}
        <hr className="feature-hr" />
        <br />
        <p className="feature-text">
          We are now going to give you some sets of hypothetical scenarios based on your chosen features.
          Each set will have two options, and it is up to your discretion to choose which is the better option.
          Your decisions will be used to help train our own matching algorithm.
        </p>
        <br /> <br /> <br />
        <br /> <br /> <br />
        <div className="pg-1-image-block">
          <div className="text-image-container">
            {part}
            {partDescription}
          </div>
          <img src={PersonalPref} className="personal-pref-image" />
        </div>
        <p className="pg-1-subheader">Scenarios will include: </p>
        {this.renderSelectedFeatures()}
        {
          !this.state.loading && <a className="waves-effect waves-dark start_btn btn" id="start_btn_1" onClick={this.onClick} style={{ marginBottom:"5%", }}> Start </a>
        }
      </div>
    );
  }
}

PWIntro.propTypes = {
  history: PropTypes.any.isRequired,
  features: PropTypes.any.isRequired,
  category: PropTypes.string.isRequired,
};

const mapStoreStateToProps = (state, givenProps) => {
  return {
    history: givenProps.history,
    features: state.selectedFeatures,
    category: state.category,
  };
}

const mapDispatchToProps = (dispatch) => {
  return {
    setPairwiseComparisons: (payload) => dispatch({ type: ACTION_TYPES.SET_PAIRWISE_COMPARISONS, payload }),
    setParticipantId: (payload) => dispatch({ type: ACTION_TYPES.SET_PARTICIPANT_ID, payload }),
    setMLServerUrl: (payload) => dispatch({ type: ACTION_TYPES.SET_ML_SERVER_URL, payload }),
  };
}

const PairwiseIntro = connect(mapStoreStateToProps, mapDispatchToProps)(PWIntro);

export default PairwiseIntro;