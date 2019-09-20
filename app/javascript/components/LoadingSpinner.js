import React from "react";
import Spinner from '../images/loading.gif';
// import Spinner from '../app/assets/images/loading.gif'

const LoadingSpinner = ({ hide }) => {
    return hide ? null : <img src={Spinner} />;
}

export default LoadingSpinner;