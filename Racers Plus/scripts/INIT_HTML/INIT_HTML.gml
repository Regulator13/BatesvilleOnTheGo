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
html_style(
	".type-slider",
	"width", "400px",
	"height", "50px",
	"background", "#d3d3d3",
	"outline", "none"
)

/* The slider handle (use -webkit- (Chrome, Opera, Safari, Edge) and -moz- (Firefox) to override default look) */
/*
html_style(
	".slider::-webkit-slider-thumb",
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

html_style(
	"button",
	"display", "inline-block",
	"position", "absolute",
	"width", "128px",
	"height", "128px",
	"top", "64px",
	"cursor", "pointer",
	"text-align", "center",
	"text-decoration", "none",
	"outline", "none",
	"color", "#fff",
	"background-color", "none",
	"border", "none",
	"border-radius", "15px",
	"box-shadow", "0 9px #999",
	"margin", "10px",
)

#region Grid
html_style(
	".item-display",
	"grid-area", "display",
	// Subtract and div padding
	"width", "128px",
	"height", "108px",
)
html_style(".item-left", "grid-area", "left")
html_style(".item-right", "grid-area", "right")
html_style(".item-select", "grid-area", "select")
html_style(".item-slider", "grid-area", "slider")
html_style(
	".item-drop", 
	"grid-area", "drop",
	"display", "flex",
	"flex-direction", "column",
	"justify-content", "flex-end",
	"align-items", "center",
)
html_style(".item-maniuplate", "grid-area", "maniuplate")
	
html_style(
	".grid-container",
	"display", "grid",
	"grid-template-areas", 
		"'select select select select drop' 'left display right manipulate drop' 'slider slider slider slider drop';",
	"gap", "10px",
	//"background-color", "#2196F3",
	"padding", "10px",
)

html_style(
	".grid-container > div",
	//"background-color", "rgba(255, 255, 255, 0.8)",
	"text-align", "center",
	"padding", "10px 0",
	"font-size", "30px",
)
#endregion
#endregion