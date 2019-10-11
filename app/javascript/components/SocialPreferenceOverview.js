import React from "react"
import SocialPrefImage from '../images/Social_Pref.png';
import FeatureSelectionImage from '../images/Feature_Selection.png';
import PCImage from '../images/Pairwise_Image.png';
import RLImage from '../images/Ranked_List_Image.png';

class SocialPreferenceOverview extends React.Component {

  render() {
    return (
      <div id="wp-page" className="wp-container">
        <img src={SocialPrefImage} className="wp-image"/>
        <div className="wp-text">
          <h2 className="wp-title">Work Distribution</h2>
          <h4 className="wp-subtitle">Which driver should receive this request?</h4>
          <p className="wp-description">
            You will build an algorithmic model that distributes requests to drivers. 
            Requests are based on proximity, but when there are multiple drivers around one request,
            the model will distribute the request based on your criteria for drivers.
          </p>
          <h5 className="wp-subtitle2">To Build Your Model:</h5>
          <div className="wp-image-row">
            <div className="wp-image-col">
              <img src={FeatureSelectionImage} className="wp-sub-image"/>
              <h5 className="wp-subtitle">Feature Selection</h5>
            </div>
            <div className="wp-image-col">
              <img src={PCImage} className="wp-sub-image"/>
              <h5 className="wp-subtitle">Pariwise Comparison</h5>
            </div>
            <div className="wp-image-col">
              <img src={RLImage} className="wp-sub-image"/>
              <h5 className="wp-subtitle">Model Evaluation</h5>
            </div>
          </div>
        </div>
        <a 
          className="next-button" 
          onClick={() => this.props.history.push('/react/feature_selection/new')}
          style={{ marginTop:"3%" }}
        >
          NEXT
        </a>
      </div>
    );
  }
}

export default SocialPreferenceOverview;