html_init("HTML5Elements")

#region Lobby
html_style(
	"@keyframes spinner",
	"to", "{transform: rotate(360deg);}"
);

html_style(
	".loading:before",
	"content", "''",
	"box-sizing", "border-box",
	"position", "absolute",
	"width", "20px",
	"height", "20px",
	"margin-top", "-20px",
	"border-radius", "50%",
	"border", "2px solid #ccc",
	"border-top-color", "#333",
	"animation", "spinner .6s linear infinite",
	"right", "-20px"
);

html_style(
	".tooltip",
	"background", "gray",
	"padding", ".3em"
)

html_style(
	".scrollable",
	"width", "200px",
	"height", "200px",
	"background", "white",
	"color", "black",
	"overflow", "hidden scroll",
	"top", "100px",
	"left", "20px",
	"padding", "0px 1em"
);

html_style(
	".styled",
	"color", "red",
	"background", "yellow",
	"padding", "1em",
	"border-radius", "0.4em",
	"top", "150px",
	"text-align", "center",
	"left", "350px",
	"transform", "rotate(-45deg);"
);

html_style(
	".html-element-parent", 
	"position", "absolute",
	"top", "0"
);
#endregion

#region Game
#region Slider
html_style(
	".type-slider",
	"min-width", "200px",
	"height", "50px",
	"background", "#d3d3d3",
	"outline", "none",
)

/* The slider handle (use -webkit- (Chrome, Opera, Safari, Edge) and -moz- (Firefox) to override default look) */
/*
html_style(
	".type-slider::-webkit-slider-thumb",
	"-webkit-appearance", "none",
	"appearance", "none",
	"width", "50px",
	"height", "50px",
	"background", "#04AA6D",
	"cursor", "pointer",
)

// Mobile app will load, but not show first menu
// if this code is ran
if os_browser == browser_firefox{
	html_style(
		".type-slider::-moz-range-thumb",
		"width", "50px",
		"height", "50px",
		"background", "#04AA6D",
		"cursor", "pointer"
	)
}
*/
#endregion

html_style(".color-display", 
	"height", "32px",
	"border-style", "solid",
	"border-color", "white",
)

html_style("p",
	"border", "solid",
	"margin", "0px",
)

#region Button
html_style(
	"button",
	"display", "inline-block",
	"padding", "15px 25px",
	"font-size", "24px",
	"cursor", "pointer",
	"text-align", "center",
	"text-decoration", "none",
	"outline", "none",
	"color", "#fff",
	"background-color", "#4CAF50",
	"border", "none",
	"border-radius", "15px",
	"box-shadow", "0 9px #999",
	"margin", "10px",
)

html_style(
	"button:hover",
	"background-color", "#3e8e41",
)

html_style(
	"button:active",
	"background-color", "#3e8e41",
	"box-shadow", "0 5px #666",
	"transform", "translateY(4px)",
)
#endregion

#region Grid
html_style(".action-left", 
	"grid-area", "action-left",
	"height", "95vh",
	"display", "flex",
	"flex-direction", "column-reverse",
)
html_style(".hud-top",
	"grid-area", "hud-top",
)
html_style(".hud-middle", 
	"grid-area", "hud-middle",
)
html_style(".hud-bottom", 
	"grid-area", "hud-bottom",
	"display", "flex",
	"flex-direction", "column-reverse",
)
html_style(".action-right", 
	"grid-area", "action-right",
)
html_style(".action-right-bottom", 
	"grid-area", "action-right-bottom",
	"display", "flex",
	"flex-direction", "column-reverse",
)

html_style(".grid-container", 
	"display", "grid",
	"grid-template-areas",
		"'action-left hud-top action-right' " +
		"'action-left hud-middle action-right' " +
		"'action-left hud-bottom action-right' " +
		"'action-left hud-bottom action-right-bottom'",
	"gap", "10px",
)

html_style(".grid-container > div", 
	"text-align", "center",
	"font-size", "30px",
	"border-style", "solid",
	"border-color", "white",
)

html_style(".button", 
	"display", "block",
	"width", "100%",
	"border", "none",
	"color", "white",
	"padding", "15px 32px",
	"text-align", "center",
	"background-color", "#4CAF50",
	"font-size", "24px",
)

html_style(".button-disabled", 
	"opacity", "0.6",
	"cursor", "not-allowed",
)

html_style(".team-options", 
	"display", "block",
	"width", "100%",
)

html_style(".delivery-container", 
	"display", "flex",
	"flex-wrap", "wrap",
)

html_style(".delivery", 
	"height", "128px",
	"width", "128px",
	"font-size", "24px",
	"line-height", "64px",
	"background-color", "#ff9933",
	"color", "white",
	"border-radius", "50%",
)

html_style(".delivery-button", 
	"height", "64px",
	"width", "64px",
	"font-size", "24px",
	"line-height", "64px",
	"background-color", "#ff9933",
	"color", "white",
	"border-radius", "50%",
)
#endregion
#endregion