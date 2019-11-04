import React from "react";
import Spinner from '../images/loading.gif';

const LoadingSpinner = ({ hide }) => {
    return hide ? null : <img src={Spinner} />;
}

export default LoadingSpinner;