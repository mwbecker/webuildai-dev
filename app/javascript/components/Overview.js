import React from "react"
import WorkPrefImage from '../images/Work_Pref.png';
import SocialPrefImage from '../images/Social_Pref.png';
// import FeatureSelectionImage from '../images/Feature_Selection.png';
// import PCImage from '../images/Pairwise_Image.png';
// import RLImage from '../images/Ranked_List_Image.png';
import FeatureSelectionImage from '../images/forNathan-14.png';
import PCImage from '../images/forNathan-15.png';
import RLImage from '../images/forNathan-06.png';

class Overview extends React.Component {
  render() {
    console.log(this.props.model);
    let image = <img src={WorkPrefImage} className="wp-image"/>;
    let title = <h2 className="wp-title">Work Preference</h2>;
    let subtitle = <h4 className="wp-subtitle">What request would you like to get?</h4>;
    let description = <p className="wp-description">
                        You will build an algorithmic model that chooses requests that you will like the most. 
                        Requests are based on proximity, but when there are multiple requests around you, the 
                        model will give you requests based on your preferences.
                      </p>;
    let button =  <a 
                    className="next-button" 
                    onClick={() => this.props.history.push('/react/feature_selection/')}
                    style={{ marginTop:"3%" }}
                  >
                    NEXT
                  </a>;
    if (this.props.model == "distribution") {
      image = <img src={SocialPrefImage} className="wp-image"/>;
      title = <h2 className="wp-title">Work Distribution</h2>;
      subtitle = <h4 className="wp-subtitle">Which driver should receive this request?</h4>;
      description = <p className="wp-description">
                      You will build an algorithmic model that distributes requests to drivers. 
                      Requests are based on proximity, but when there are multiple drivers around one request,
                      the model will distribute the request based on your criteria for drivers.
                    </p>;
      button =  <a 
                  className="next-button" 
                  onClick={() => this.props.history.push('/react/feature_selection/new')}
                  style={{ marginTop:"3%" }}
                >
                  NEXT
                </a>;
    }
    return (
      <div id="wp-page" className="wp-container">
        {image}
        <div className="wp-text">
          {title}
          {subtitle}
          {description}
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
        {button}
      </div>
    );
  }
}

export default Overview;