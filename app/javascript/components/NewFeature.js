
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from "react-redux";
import { ACTION_TYPES } from '../store';
import ContinuousFeatureModal from './ContinuousFeatureModal';
import CategoricalFeatureModal from './CategoricalFeatureModal';

class NewFeat extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      shouldShowForm: false,
      shouldShowContinuous: false,
    }
  }

  componentWillMount() {
    fetch('/api/v1/sessions/get_id', {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    })
    .then(response => response.json())
    .then(data => {
      console.log("received:", data);
      this.props.setParticipantId(data.participantId);
    })
  }

  createNewFeat = (isCategorical, feat) => {
    // this will also update the weight
    fetch('/api/v1/features/new_feature', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({...feat, cat: isCategorical ? 1 : 0, feature_only: true })
    })
    .then(response => response.json())
    .then((data) => {
      console.log('made feature', data);
      // TODO: can use feature data here
    })
    .catch(e => console.log(e))
  }

  onSubmit = (isCategorical) => {
    return (newFeature) => {
      this.createNewFeat(isCategorical, newFeature);
      this.onClose();
    }
  }

  onClose = () => {
    this.setState({shouldShowForm: false});
  }

  showCategorical = () => {
    this.setState({shouldShowForm: true, shouldShowContinuous: false});
  }

  showContinuous = () => {
    this.setState({shouldShowForm: true, shouldShowContinuous: true});
  }

  render() {
    return <div>
      <h2>New Feature</h2>
      <button className="btn" onClick={this.showCategorical}>Categorical</button>
      <button className="btn" onClick={this.showContinuous}>Continuous</button>
      {this.state.shouldShowForm && (
        this.state.shouldShowContinuous ? (
          <ContinuousFeatureModal
            onSubmit={this.onSubmit(false)}
            onClose={this.onClose}
            displayDescription={this.props.participantId === 2}
          />
        ) : (
          <CategoricalFeatureModal
            onSubmit={this.onSubmit(true)}
            onClose={this.onClose}
            displayDescription={this.props.participantId === 2}
          />
        )
      )}
    </div>
  }
}

NewFeat.propTypes = {
  setParticipantId: PropTypes.func.isRequired,
  participantId: PropTypes.number.isRequired,
}

const mapStoreStateToProps = (storeState, props) => {
  return {
    participantId: storeState.participantId,
    ...props
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    setParticipantId: (id) => dispatch({type: ACTION_TYPES.SET_PARTICIPANT_ID, payload: id})
  }
}

const NewFeature = connect(mapStoreStateToProps, mapDispatchToProps)(NewFeat);
export default NewFeature;