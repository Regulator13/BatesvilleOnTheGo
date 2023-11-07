#macro CXT_TEAM 3
#macro CXT_COLOR 4
#macro CXT_MODEL 5
#macro CXT_AVAILABLE_DELIVERY 6
#macro CXT_DELIVER 0
#macro CXT_PICKUP 2
#macro CXT_STATE 1

function scr_context_to_string(context) {
	switch (context) {
		case CXT_TEAM:
			return "CXT_TEAM"
		case CXT_COLOR:
			return "CXT_COLOR"
		case CXT_MODEL:
			return "CXT_MODEL"
		case CXT_AVAILABLE_DELIVERY:
			return "CXT_AVAILABLE_DELIVERY"
		case CXT_DELIVER:
			return "CXT_DELIVER"
		case CXT_PICKUP:
			return "CXT_PICKUP"
		case CXT_STATE:
			return "CXT_STATE"
	}
}