import '@babel/polyfill';

(async function() {
    const bggResults = await fetch('https://www.boardgamegeek.com/xmlapi2/collection?username=dagreenmachine&own=1&excludesubtype=boardgameexpansion');
    const bggText = await bggResults.text();
    const bggXml = (new window.DOMParser()).parseFromString(bggText, "text/xml");
    bggXml.querySelectorAll('item').forEach((item) => {
        const value = {
            name: item.querySelector('name').textContent,
            thumbnail: item.querySelector('thumbnail').textContent,
            id: item.getAttribute('objectid'),
        };
        const option = document.createElement('option');
        option.setAttribute('value', JSON.stringify(value));
        const optionText = document.createTextNode(value.name);
        option.append(optionText);
        document.querySelector('select#ballot_candidates').append(option);
        return value;
    });
})()