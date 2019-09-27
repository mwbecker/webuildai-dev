import React from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux";

class IndividualFeatureSelection extends React.Component {
  render() {
    return (
      <div>
        <h3 class="title">Feature Selection for Your Individual Preference Profile</h3>
        <hr class = "feature-hr"/>
        <p class = "feature-text" >
          Your company uses an algorithm to match you with potential customers. 
          The boxes below contain features we believe your company’s algorithm uses. Based on your experiences,
          <b> please select any features that you would consider important if you were to make an algorithm for youself.</b>
        </p>
        <div class="feature-image-block">
          <p class = "feature-text">
            Please use the sliders to mark how important each factor should be (0: Not Important - 1: Essential). 
            If there other features you believe the algorithm should use, please add your own at the bottom of the page.
          </p>
          <img src='Feature_Selection.png' class="feature-selection-image" />
        </div>










      </div>
    );
  }
}

export default IndividualFeatureSelection;