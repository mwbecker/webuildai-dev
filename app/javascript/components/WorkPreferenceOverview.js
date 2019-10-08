import React from "react"
import WorkPrefImage from '../images/Work_Pref.png';
import FeatureSelectionImage from '../images/Feature_Selection.png';
import PCImage from '../images/Pairwise_Image.png';
import RLImage from '../images/Ranked_List_Image.png';

class WorkPreferenceOverview extends React.Component {
  render() {
    return (
      <div id="wp-page" className="wp-container">
        <img src={WorkPrefImage} className="wp-image"/>
        <div className="wp-text">
          <h2 className="wp-title">Work Preference</h2>
          <h4 className="wp-subtitle">What request would you like to get?</h4>
          <p className="wp-description">
            You will build an algorithmic model that chooses requests that you will like the most. 
            Requests are based on proximity, but when there are multiple requests around you, the 
            model will give you requests based on your preferences.
          </p>
          <h5 className="wp-subtitle2">To Build Your Model:</h5>
          <div className="wp-image-row">
            <div className="wp-image-col">
              <img src={FeatureSelectionImage} className="wp-sub-image"/>
              <h5 className="wp-subtitle">Feature Selection</h5>
            </div>
            <div className="wp-image-col">
              <img src={PCImage} className="wp-sub-image" style={{ marginBottom: "-18px" }}/>
              <h5 className="wp-subtitle">Pariwise Comparison</h5>
            </div>
            <div className="wp-image-col">
              <img src={RLImage} className="wp-sub-image" style={{ marginBottom: "-18px" }}/>
              <h5 className="wp-subtitle">Model Evaluation</h5>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default WorkPreferenceOverview;