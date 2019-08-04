import React from 'react';
import classNames from 'classnames';

const CandidateInterest = ({ candidateId, candidateName, thumbnail, currentRating, setCurrentRating }) => {
    const ratings = {
        excellent: 'Extremely Interested',
        verygood: 'Very Interested',
        good: 'Interested',
        average: 'Ambivalent',
        fair: 'Uninterested',
        poor: 'Extremely Uninterested',
    };

    return (
        <>
            <label data-candidate={candidateId}>{candidateName}</label>
            <div className="row rating">
                <div className="column"><img src={thumbnail} /></div>
                { Object.keys(ratings).map((rating) => {
                    const active = rating === currentRating;
                    return(
                        <div
                            key={rating}
                            className={classNames('column', rating, { active })}
                            onClick={() => setCurrentRating(rating)}
                        >
                            <span />
                            <label>{ratings[rating]}</label>
                            <input
                                type="radio"
                                name={`rating-${candidateId}`}
                                onChange={() => setCurrentRating(rating)}
                                checked={active}
                            />
                        </div>
                    );
                })}
            </div>
        </>
    );
};

export default CandidateInterest;
