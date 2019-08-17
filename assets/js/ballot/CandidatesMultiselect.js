import React, { useState, useEffect } from "react";

const CandidatesMultiselect = ({ startingSelectedCandidates }) => {
  // this is fragile because it is dependent on the ordering of keys in JSON data.
  // TODO: rework this such that values are selected by their bgg id
  const [currentCandidates, setCurrentCandidates] = useState(
    startingSelectedCandidates || []
  );
  let storedAllCands = [];
  try {
    storedAllCands = JSON.parse(localStorage.getItem("cands"));
    if (!Array.isArray(storedAllCands)) {
      storedAllCands = [];
    }
  } catch (e) {}
  const [allCandidates, setAllCandidates] = useState(storedAllCands);

  useEffect(() => {
    if (!storedAllCands.length) {
      (async function() {
        const bggResults = await fetch(
          "https://www.boardgamegeek.com/xmlapi2/collection?username=dagreenmachine&own=1&excludesubtype=boardgameexpansion"
        );
        const bggText = await bggResults.text();
        const bggXml = new window.DOMParser().parseFromString(
          bggText,
          "text/xml"
        );
        const candsSet = {};
        const cands = Array.from(bggXml.querySelectorAll("item")).flatMap(
          item => {
            const value = {
              id: item.getAttribute("objectid"),
              name: item.querySelector("name").textContent,
              thumbnail: item.querySelector("thumbnail").textContent
            };
            if (candsSet[value.id]) return [];
            candsSet[value.id] = true;
            return [{ name: value.name, value: JSON.stringify(value) }];
          }
        );
        localStorage.setItem("cands", JSON.stringify(cands));
        setAllCandidates(cands);
      })();
    }
  }, []);

  return (
    <select
      id="ballot_candidates"
      multiple
      name="ballot[candidates][]"
      value={currentCandidates}
      onChange={e => {
        const options = Array.from(e.target.options);
        const values = options.flatMap(option => {
          if (option.selected) {
            return [option.value];
          }
          return [];
        });
        setCurrentCandidates(values);
      }}
    >
      {allCandidates.map(({ name, value }) => {
        return (
          <option key={value} value={value}>
            {name}
          </option>
        );
      })}
    </select>
  );
};

export default CandidatesMultiselect;
