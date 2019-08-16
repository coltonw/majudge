import React from "react";
import ReactDOM from "react-dom";
import VoteForm from "./VoteForm";

const {
  candidates,
  currentRatings: startingCurrentRatings,
  disabled
} = window.phxData;

ReactDOM.render(
  <VoteForm
    candidates={candidates}
    startingCurrentRatings={startingCurrentRatings}
    disabled={disabled}
  />,
  document.getElementById("reactVoteForm")
);
