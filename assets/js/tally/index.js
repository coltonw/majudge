import "@babel/polyfill";
import React from "react";
import ReactDOM from "react-dom";

import TallyChart from "./TallyChart";

const { tally } = window.phxData;

ReactDOM.render(
  <TallyChart tally={tally} />,
  document.getElementById("reactTallyChart")
);
