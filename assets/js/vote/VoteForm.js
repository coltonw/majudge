import React, { useState } from "react";
import CandidateInterest from "./CandidateInterest";

const VoteForm = ({ candidates, startingCurrentRatings, disabled }) => {
  console.log(startingCurrentRatings);
  const [currentRatings, setCurrentRatings] = useState(
    startingCurrentRatings || {}
  );

  const setCurrentRating = candidateId => rating => {
    setCurrentRatings({
      ...currentRatings,
      [candidateId]: rating
    });
  };
  return (
    <>
      {!disabled ? (
        <input
          type="hidden"
          name="vote[vote]"
          value={JSON.stringify(currentRatings)}
        />
      ) : null}
      {candidates.map(({ id, name, thumbnail }) => {
        return (
          <CandidateInterest
            key={id}
            candidateId={id}
            candidateName={name}
            thumbnail={thumbnail}
            currentRating={currentRatings[id]}
            setCurrentRating={disabled ? () => {} : setCurrentRating(id)}
            disabled={disabled}
          />
        );
      })}
    </>
  );
};

export default VoteForm;
