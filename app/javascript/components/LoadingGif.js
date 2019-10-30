import React from "react";
import CompileGif from '../images/Loading_Compile.gif';

const LoadingGif = ({ hide }) => {
    return hide ? null : <img src={CompileGif} className='loading-gif'/>;
}

export default LoadingGif;