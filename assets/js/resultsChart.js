// Depends on a global instance of d3 and lodash

const svg = d3.select("svg"),
    margin = {top: 20, right: 20, bottom: 30, left: 60},
    width = +svg.attr("width") - margin.left - margin.right,
    height = +svg.attr("height") - margin.top - margin.bottom,
    g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

const y = d3.scaleBand()			// x = d3.scaleBand()	
    .rangeRound([0, height])	// .rangeRound([0, width])
    .paddingInner(0.05)
    .align(0.1);

const x = d3.scaleLinear()
    .rangeRound([0, width]);

const z = d3.scaleOrdinal()
    .range(["#52ba8c", "#87bc7a", "#b0be6e", "#f5ce62", "#e9a268", "#dd776e"]);
const ranks = ['excellent', 'verygood', 'good', 'average', 'fair', 'poor'];

const rankMap = {};
_.forEach(ranks, function (value, key) {
  rankMap[value] = key;
});

const data = [
  {name: 'Will', value: [5,4,3,2,1,0]},
  {name: 'Jeff', value: [4,5,3,2,1,0]},
  {name: 'Don', value: [3,4,5,2,1,0]},
  {name: 'Joe', value: [2,3,4,5,1,0]},
  {name: 'Bill', value: [0,1,2,3,4,5]},
];

y.domain(data.map(function(d) { return d.name; }));
x.domain([0, d3.max(data, function(d) { return _.sum(d.value); })]).nice();
z.domain(ranks);

g.append("g")
  .selectAll("g")
  .data(d3.stack().keys(ranks).value(function(d, rank) {
    return d.value[rankMap[rank]];
  })(data))
  .enter().append("g")
    .attr("fill", function(d) { return z(d.key); })
  .selectAll("rect")
  .data(function(d) { return d; })
  .enter().append("rect")
    .attr("y", function(d) { return y(d.data.name); })
    .attr("x", function(d) { return x(d[0]); })
    .attr("width", function(d) { return x(d[1]) - x(d[0]); })
    .attr("height", y.bandwidth());

g.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0,0)")
    .call(d3.axisLeft(y));
