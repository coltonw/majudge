import React from 'react';
import ReactDOM from 'react-dom';
import VoteForm from './VoteForm';

const { candidates, currentRatings: startingCurrentRatings } = window.phxData;

ReactDOM.render(<VoteForm candidates={candidates} startingCurrentRatings={startingCurrentRatings} />, document.getElementById('reactVoteForm'));