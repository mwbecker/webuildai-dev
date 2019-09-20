import React from "react"
import PropTypes from "prop-types"
import { connect } from "react-redux";

class HelloWorld extends React.Component {
  render() {
    return (
      <div>
        Greeting: {this.props.greeting}
        <br></br>
        Things: {this.props.things}
        <br></br>
        <button onClick={this.props.getData}>Touch Me</button>
        <button onClick={() => { this.props.history.push("foo") }}>me too!</button>
      </div>
    );
  }
}

const fooProps = (state) => ({ things: state.things });
class Foo extends React.Component {
  render() {
    return this.props.things;
  }
}
export const Foopa = connect(fooProps)(Foo);


const getDataFinish = (data) => {
  console.log("almost there", data);
  return { type: 'GET_THINGS_SUCCESS', data }
}

const getData = (dispatch) => {
  console.log("getting");
  dispatch({ type: 'GET_THINGS_REQUEST' });
  // return fetch('static/marco.json')
  return fetch('/static/marco')
    .then((response) => {
      console.log(response);
      return response.json();
    })
    .then(data => dispatch(getDataFinish(data)))
    .catch(error => console.log(error));
}

const mapDispatchToProps = (dispatch) => {
  return {
    getData: () => getData(dispatch)
  }
};

const mapStoreStateToProps = (storeState, givenProps) => {
  return { things: storeState.things };
}

HelloWorld.propTypes = {
  history: PropTypes.any,
  greeting: PropTypes.string,
  things: PropTypes.string
};
const Hello = connect(mapStoreStateToProps, mapDispatchToProps)(HelloWorld);
export default Hello;
