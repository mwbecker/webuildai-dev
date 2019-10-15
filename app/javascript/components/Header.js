import React from 'react';
import { connect } from 'react-redux';
import { ACTION_TYPES } from '../store';

class HeaderComponent extends React.Component {


  logout = () => {
    this.props.setLogout();
    this.props.history.push('/react/');
    fetch('/api/v1/sessions/logout', {
      method: "POST",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    }).then(response => response.json()).then(() => console.log("logged out!") // not sure if we need to do this
    );
    if ([1,2,3,4,5,6,7,8,9,10].includes(this.props.participantId)) {
      fetch('/api/v1/testing/reset', {
        method: "POST",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      }).then(response => response.json()).then(() => alert("and reset everything")); // not sure if we need to do this
    }
  }

  render () {
    return (
      <nav className="white">
        <div className="nav-wrapper">
          <div className="col s12" style={{paddingLeft: "70px", paddingRight: "70px"}}>
            <span style={{color: "#555", fontSize: "30px", fontWeight: "bold"}}>WeBuildAI</span>
            <ul id="nav-mobile" className="right">
              {this.props.isLoggedIn &&
                <li><a onClick={this.logout} className="wbai">Logout</a></li>
              }
            </ul>
          </div>
        </div>
      </nav>
    );
  }
}
const mapStoreStateToProps = (storeState, givenProps) => {
  return {
    ...givenProps,
    isLoggedIn: storeState.isLoggedIn,
    participantId: storeState.participantId,
  };
}

const mapDispatchToProps = (dispatch) => {
  return {
    setLogout: () => dispatch({ type: ACTION_TYPES.END_RL_FLOW }),
  };
}

const Header = connect(mapStoreStateToProps, mapDispatchToProps)(HeaderComponent);
export default Header;