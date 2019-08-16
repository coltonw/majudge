import "@babel/polyfill";
import React from "react";
import ReactDOM from "react-dom";
import CandidatesMultiselect from "./CandidatesMultiselect";

const { candidates: startingSelectedCandidates, error } = window.phxData;

ReactDOM.render(
  <CandidatesMultiselect
    startingSelectedCandidates={startingSelectedCandidates}
  />,
  document.getElementById("reactCandidateSelector")
);
