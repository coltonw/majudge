import React from "react";
import { ResponsiveBar } from "@nivo/bar";
import { useTheme } from "@nivo/core";

const wrapRegex = /(?![^\n]{1,20}$)([^\n]{1,20})\s/g;
const wrap = s => s.replace(wrapRegex, "$1\n");

const TallyChart = ({ tally }) => {
  const data = tally.reverse().map(cand => {
    return { ...cand, ...cand.value };
  });
  return (
    <ResponsiveBar
      data={data}
      keys={["excellent", "verygood", "good", "average", "fair", "poor"]}
      indexBy="name"
      margin={{ right: 120, left: 120 }}
      padding={0.3}
      layout="horizontal"
      colors={[
        "#52ba8c",
        "#87bc7a",
        "#b0be6e",
        "#f5ce62",
        "#e9a268",
        "#dd776e"
      ]}
      axisTop={null}
      axisRight={null}
      axisBottom={null}
      axisLeft={{
        legendPosition: "middle",
        renderTick: ({
          value: _value,
          x,
          y,
          opacity,
          rotate,
          format,
          lineX,
          lineY,
          onClick,
          textX,
          textY,
          textBaseline,
          textAnchor
        }) => {
          const theme = useTheme();

          let value = _value;
          if (format !== undefined) {
            value = format(value);
          }

          let gStyle = { opacity };
          if (onClick) {
            gStyle["cursor"] = "pointer";
          }

          const wrappedNameArr = wrap(value).split("\n");
          const wrappedName = wrappedNameArr.map((s, i) => {
            let y = undefined;
            if (wrappedNameArr.length > 1 && i === 0) {
              y = -6 * (wrappedNameArr.length - 1);
            }
            const tspan = (
              <tspan key={s} x={0} y={y} dy={i > 0 ? 12 : 0}>
                {s}
              </tspan>
            );
            return tspan;
          });

          return (
            <g
              transform={`translate(${x},${y})`}
              {...(onClick ? { onClick: e => onClick(e, value) } : {})}
              style={gStyle}
            >
              <line
                x1={0}
                x2={lineX}
                y1={0}
                y2={lineY}
                style={theme.axis.ticks.line}
              />
              <text
                dominantBaseline={textBaseline}
                textAnchor={textAnchor}
                transform={`translate(${textX},${textY}) rotate(${rotate})`}
                style={theme.axis.ticks.text}
              >
                {wrappedName}
              </text>
            </g>
          );
        }
      }}
      enableLabel={false}
    />
  );
};

export default TallyChart;
