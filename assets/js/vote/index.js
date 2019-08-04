import React from 'react';
import ReactDOM from 'react-dom';
import VoteForm from './VoteForm';

ReactDOM.render(<VoteForm candidates={window.phxData} />, document.getElementById('reactVoteForm'));