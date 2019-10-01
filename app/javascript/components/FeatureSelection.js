import React from "react";
import PropTypes from "prop-types";
import { connect } from "react-redux";
import FeatureSelectionImg from "../images/Feature_Selection.png";
import FeatureGroup from "./FeatureGroup";
import NewFeatureModal from "./NewFeatureModal";
import ReactModal from 'react-modal';
import { ACTION_TYPES } from "../store";


  // function post_weights(user, feature, weight)
  // {
  //   console.log(feature)

  //   $.ajax({
  //     url: "/weighting?feature_id="+feature+"
  // &weight="+weight+"&method="+'how_you',
  //     type: "post",
  //     success: function(){
  //       console.log('Saved Successfully');
  //       //window.location.href = "/pairwise_comparisons"
  //     },
  //     error:function($xhr){
  //       console.log($xhr);
  //     }
  //   });
  // }


class FeatSelection extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      allFeatures: {},
      modalIsOpen: false,
    }
  }

  fetchFeatures = () => {
    fetch(`/api/v1/features/get_all_features_shuffled?category=${this.props.category}`, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    })
      .then(response => response.json())
      .then((data) => {
        console.log("gottem", data);
        this.setState({allFeatures: data.features_by_description});
      })
      .catch(error => console.log(error))
  }

  componentDidMount() {
    this.fetchFeatures();
  }

  changeWeight = (description) => {
    return (i, weight) => {
      const feats = {...this.state.allFeatures};
      feats[description][i].weight = weight;
      this.setState({allFeatures: feats});
      console.log('changed weight', feats, feats[description][i]);
    }
  }

  openModal = () => {
    this.setState({modalIsOpen: true});
  }

  closeModal = () => {
    this.setState({modalIsOpen: false});
  }

  saveWeights = (feat) => {
    fetch('/api/v1/features/new_weight', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({feature_id: feat.id, weight: feat.weight, category: this.props.category})
    })
    .then(response => response.json())
    .then((data) => {
      console.log('made feature', data);
      // TODO: can use feature data here
    })
    .catch(e => console.log(e))
  }

  saveAllWeights = () => {
    const customs = ['Your Own Feature(s) - Categorical' , 'Your Own Feature(s) - Continuous'];
    for (let description of Object.keys(this.state.allFeatures)) {
      if (!customs.includes(description)) {
        const feats = this.state.allFeatures[description];
        for (let feat of feats) {
          if (feat.weight > 0)
            this.saveWeights(feat);
        }
      }
    }
    const allFeatsList = [];
    for (let description of Object.keys(this.state.allFeatures)) {
      const feats = this.state.allFeatures[description];
      for (let feat of feats) {
        if (feat.weight > 0)
          allFeatsList.push(feat);
      }
    }
    this.props.setSelectedFeatures(allFeatsList);
  }

  addFeature = (isCategorical, features) => {
    const featType = isCategorical ? 'Your Own Feature(s) - Categorical' : 'Your Own Feature(s) - Continuous';
    const allFeatures = {...this.state.allFeatures};
    if (!Object.keys(allFeatures).includes(featType)) {
      allFeatures[featType] = [];
    }
    allFeatures[featType].push(features);
    this.setState({allFeatures});
    console.log("new features", allFeatures[featType]);
  }

  createNewFeat = (feat, i) => {
    // this will also update the weight
    fetch('/api/v1/features/new_feature', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(feat)
    })
    .then(response => response.json())
    .then((data) => {
      console.log('made feature', data);
      // TODO: can use feature data here
    })
    .catch(e => console.log(e))
  }

  createNewFeatures = () => {
    const keys = ['Your Own Feature(s) - Categorical', 'Your Own Feature(s) - Continuous']
    const cat_key = keys[0];
    const cat_vals = this.state.allFeatures[cat_key];
    const cont_key = keys[1];
    const cont_vals = this.state.allFeatures[cont_key];

    if (cat_vals) {
      let i = 0
      for (let newCatFeature of cat_vals){
        if (newCatFeature.weight === 0) continue;
        this.createNewFeat({
          cat: 1,
          name: newCatFeature.name,
          opts: newCatFeature.type,
          category: this.props.category,
          weight: newCatFeature.weight,
        }, i);
        i++;
      }
    }
    if (cont_vals) {
      let j = 0;
      for (let newContFeature of cont_vals) {
        if (newContFeature.weight === 0) continue;
        this.createNewFeat({
          cat: 0,
          name: newContFeature.name,
          lower: newContFeature.minValue,
          upper: newContFeature.maxValue,
          unit: newContFeature.units,
          category: this.props.category,
          weight: newContFeature.weight,
        }, j)
        j++;
      }
    }
  }

  finishFeatureSelection = () => {
    this.createNewFeatures();
    this.saveAllWeights();
    this.props.history.push('/react/pairwise_comparisons/intro');
  }

  renderDescription = () => {
    let description = "";
    if (this.props.category == 'request') {
      description = <p className = "feature-text" >
                      Your company uses an algorithm to match you with potential customers.
                      The boxes below contain features we believe your company’s algorithm uses. Based on your experiences,
                      <b> please select any features that you would consider important if you were to make an algorithm for youself.</b>
                    </p>;
    } else {
      description = <p className = "feature-text" >
                      Social preference means which driver should receive the request when there are multiple drivers waiting for a ping. 
                      In other words, <b>you act as the algorithm in this section.</b>
                    </p>;
    }
    return (
      <div>
        <h3 className="title">Feature Selection for Your {this.props.category === 'request' ? "Individual" : "Social"} Preference Profile</h3>
        <hr className = "feature-hr"/>
        {description}
        <div className="feature-image-block">
          <p className = "feature-text">
            Please use the sliders to mark how important each factor should be (0: Not Important - 1: Essential).
            If there other features you believe the algorithm should use, please add your own at the bottom of the page.
          </p>
          <img src={FeatureSelectionImg} className="feature-selection-image" />
        </div>
      </div>
    );
  }

  renderFeatures = () => {
    return Object.keys(this.state.allFeatures).map((description, i) => {
      return (
        <FeatureGroup
          description={description}
          features={this.state.allFeatures[description]}
          changeWeight={this.changeWeight(description)}
          key={i}
        />
      );
    });
  }

  render() {
    return (
      <React.Fragment>
        {this.renderDescription()}
        {this.renderFeatures()}

        <br/><br/>
        <a id="add" className="btn-floating btn-large waves-effect waves-light" onClick={this.openModal} style={{zIndex:0, backgroundColor:"#3d6ab1", marginLeft:"10%"}}>
          <i className="material-icons">add</i>
        </a>
        <p style={{fontWeight:"bold", fontSize:"1.25em", display:"inline", marginLeft:"1%"}}>
          Add Feature
        </p>
        <ReactModal
          isOpen={this.state.modalIsOpen}
          ariaHideApp={false}
        >
          <NewFeatureModal onClose={this.closeModal} category={this.props.category} addFeature={this.addFeature}/>
        </ReactModal>
          {/* <table className="feature-table striped highlight" id="feat">
              <% if f.description == "Your Own Feature(s) - Continuous" or f.description == "Your Own Feature(s) - Categorical" %>
          <td id="yof-<%=f.id%>" style={{cursor:"pointer", fontWeight:"bold", fontSize:"2em"}}>
            &times;
          </td>


            */}
            <a onClick={this.finishFeatureSelection} className="waves-effect waves-dark btn" style={{zIndex:0, marginTop:"5%", marginRight:"10vw", float:"right", width:"12.5%", paddingTop:"0.7%", paddingBottom:"3%", color:"#FFFFFF", backgroundColor:"#3d6ab1", fontWeight:"bold", fontSize:"1.2em",zIndex:"5",marginBottom:"3%",}}>
              NEXT
            </a>
            {/* <a onClick={this.props.end} className="btn">hi</a> */}
      </React.Fragment>
    );
  }
}

const mapStoreStateToProps = (state, givenProps) => {
  return {
    ...givenProps,
    category: state.category,
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    setSelectedFeatures: (payload) => dispatch({ type: ACTION_TYPES.SET_SELECTED_FEATURES, payload }),
    end: (payload) => dispatch({ type: ACTION_TYPES.END_RL_FLOW, payload}),
  }
}

const FeatureSelection = connect(mapStoreStateToProps, mapDispatchToProps)(FeatSelection);
export default FeatureSelection;