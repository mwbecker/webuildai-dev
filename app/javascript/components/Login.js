import React from 'react';
import { connect } from 'react-redux';
import { ACTION_TYPES } from '../store';

class LoginComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      id: "",
      password: ""
    };
  }

  setPassword = (e) => {
    const password = e.target.value;
    this.setState({password});
  }

  setId = (e) => {
    const id = e.target.value;
    this.setState({id});
  }

  login = () => {
    const request = { auth: { id: this.state.id, password: this.state.password } };
    console.log(request)
    fetch("/api/v1/sessions/login", {
      method: "POST",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(request),
    })
    .then(response => response.json())
    .then(result => {
      if (result.status === 'ok') {
        this.props.setLogin();
        this.props.setParticipantId(Number(this.state.id));
        this.props.history.push('/react/work_preference_overview')
      } else {
        alert("failed to log in");
      }
    })
    .catch(err => console.log('error logging in', err));
  }

  onKeyDown = (e) => {
    if (e.key === 'Enter') {
      this.login();
    }
  }

  render() {
    return (
      <div className="row" style={{marginBottom:"0px"}} >
        <div className="login-b2">
          <h3> Help us understand how algorithms affect you.
          </h3>
          <p>
            Thank you for voluntarily participating in our research. The goal of this
            online session is understand your work practice around your
            company’s in-app algorithm, which matches drivers with potential
            customers. We believe it is important to hear what drivers have to say
            about their companies’ current algorithmic systems and thus greatly
            appreciate your input.
          </p>
          <p>
            There are no risks or benefits to participating in this session. Any data
            collected from this session will be stored confidentially and
            anonymously and only shared within our research team at Carnegie
            Mellon. Following the session, we will provide a gift card of your
            choosing as a show of our appreciation for your time.
          </p>
        </div>
        <div className="login-b1">
          <div>
            <div>
              <span>Login</span>
              <hr id='hhr' />
              <div className="control-group-id">
                <label>ID</label>
                <div className="controls">
                  <input onChange={this.setId} type="text" placeholder="ID" />
                </div>
              </div>
              <br />
              <div className="control-group-password">
                <label>Password</label>
                <div className="controls">
                  <input onChange={this.setPassword} onKeyDown={this.onKeyDown} type="password" placeholder="password" />
                </div>
              </div>
              <div className="actions-login">
                <a onClick={this.login} className="btn" style={{color: "#ffffff", background: "#3d6ab1"}}>Login</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

const mapStoreStateToProps = (storeState, givenProps) => {
  return { ...givenProps };
}

const mapDispatchToProps = (dispatch) => {
  return {
    setLogin: () => dispatch({ type: ACTION_TYPES.SET_LOGIN, payload: true }),
    setParticipantId: (payload) => dispatch({type: ACTION_TYPES.SET_PARTICIPANT_ID, payload }),
  };
}

const Login = connect(mapStoreStateToProps, mapDispatchToProps)(LoginComponent);
export default Login;