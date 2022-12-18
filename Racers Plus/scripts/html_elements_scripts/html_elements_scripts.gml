// To use this extension, you need to call #html_init() and optionally #html_style() during initialisation, 
// and #html_sync() in an draw GUI end event

function html_init(texture_base) {
	global.texture_base = texture_base;
	global.html_element_focussed = undefined;
	global.html_elements_last_click_x = 0;
	global.html_elements_last_click_y = 0;
	global.html_elements = ds_list_create();
	global.html_element_next_id = 0;
}

function html_sync() {
	var new_list = ds_list_create();
	for (var i=0; i<ds_list_size(global.html_elements); i+=1) {
		var element = global.html_elements[| i];
		if element.destroy = true
		html_element_cleanup(element, true);
		else {
			html_element_sync(element);
			ds_list_add(new_list, element);
		}
	}
	ds_list_destroy(global.html_elements);
	global.html_elements = new_list;
}

/// @param selector
/// @param key
/// @param value
/// @param *
function html_style() {
	var rule = argument[0] + " { ";

	for (var i=1; i<argument_count; i+=2) {
		var key = argument[i];
		if string_count("@", rule) == 0
		key +=":"
		var value = argument[i + 1];
		rule += string(key)+" "+string(value)+"; ";
	}

	rule += "}";

	_html_style_add(rule);
}

/////////////////////////////////// Different implementations of #html_element \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/// @param parent
/// @param identifier
/// @param content
/// @param [classes]
function html_cell() {
	var parent = argument[0], identifier = argument[1], content = argument[2];
	var classes = argument_count > 3 ? argument[3] : "";

	return html_element(parent, identifier, "td", "className", classes, "content", content);
}

/// @param parent
/// @param identifier
/// @param [submit_label]
/// @param [enabled]
/// @param [classes]
function html_button() {
	var parent = argument[0], identifier = argument[1];
	var submit_label = argument_count > 2 ? argument[2] : "";
	var enabled = argument_count > 3 ? argument[3] : true;
	var classes = argument_count > 4 ? argument[4] : "";

	var button = html_element(
		parent, 
		identifier, 
		"button", 
		"type", "button", 
		"className", classes,
		"content", submit_label, 
		"title", submit_label, 
		"onclick", "event.preventDefault(); gml_Script_gmcallback_on_interaction(null, null, this.id)",
		"onmouseover", "event.preventDefault(); gml_Script_gmcallback_on_mouseover(null, null, this.id)",
		"onmouseout", "event.preventDefault(); gml_Script_gmcallback_on_mouseout(null, null, this.id)",
		"disabled", enabled ? undefined : "disabled"
	);

	return button;
}

/// @param parent
/// @param identifier
/// @param [content]
/// @param [classes]
/// @param [style]
function html_div() {
	var parent = argument[0], identifier = argument[1];
	var content = argument_count > 2 ? argument[2] : "";
	var classes = argument_count > 3 ? argument[3] : "";
	var style = argument_count > 4 ? argument[4] : "";

	return html_element(parent, identifier, "div", "className", classes, "content", content, "style", style);
}

/// @param parent
/// @param identifier
/// @param type
/// @param [placeholder]
/// @param [required]
/// @param [class]
/// @param [initial_value]
function html_field() {
	var parent = argument[0], identifier = argument[1], type = argument[2];
	var placeholder = argument_count > 3 ? argument[3] : "";
	var required = argument_count > 4 ? argument[4] : false;
	var classes = argument_count > 5 ? argument[5] : "";
	var initial_value = argument_count > 6 ? argument[6] : "";

	var input = html_element(
		parent, 
		identifier,
		"input",
		"onfocus", "gml_Script_gmcallback_lose_focus(null, null, this.id)",
		"onblur", "gml_Script_gmcallback_set_focus()",
		"oninput", "gml_Script_gmcallback_on_input(null, null, this.id, this.value)",
		"className", classes, 
		"name", identifier, 
		"type", type, 
		"placeholder", placeholder, 
		"required", required, 
		"value", initial_value
	);

	if input.new_element
	input.value = initial_value

	return input;
}

/// @param parent
/// @param identifier
/// @param min
/// @param max
/// @param [class]
/// @param [initial_value]
function html_range() {
	var parent = argument[0], identifier = argument[1];
	var min_value = string(argument[2]), max_value = string(argument[3]);
	var classes = argument_count > 4 ? argument[4] : "";
	var initial_value = argument_count > 5 ? string(argument[5]) : "";

	var input = html_element(
		parent, 
		identifier,
		"input",
		"onfocus", "gml_Script_gmcallback_lose_focus(null, null, this.id)",
		"onblur", "gml_Script_gmcallback_set_focus()",
		"oninput", "gml_Script_gmcallback_on_input(null, null, this.id, this.value)",
		"className", classes, 
		"name", identifier, 
		"type", "range", 
		"placeholder", "", 
		"required", "", 
		"min", min_value,
		"max", max_value,
		"value", initial_value
	);

	if input.new_element
	input.value = initial_value

	return input;
}

/// @param parent
/// @param identifier
/// @param [classes]
function html_form() {
	var parent = argument[0], identifier = argument[1];
	var classes = argument_count > 2 ? argument[2] : "";

	var form = html_element(
		parent, 
		identifier, 
		"form", 
		"className", classes, 
		"onsubmit", "event.preventDefault(); gml_Script_gmcallback_on_interaction(null, null, this.id)"
	);

	return form;
}

/// @param parent
/// @param identifier
/// @param content
/// @param [classes]
function html_h1() {
	var parent = argument[0], identifier = argument[1], content = argument[2];
	var classes = argument_count > 3 ? argument[3] : "";

	return html_element(parent, identifier, "h1", "className", classes, "content", content);
}


/// @param parent
/// @param identifier
/// @param content
/// @param [classes]
function html_h2() {
	var parent = argument[0], identifier = argument[1], content = argument[2];
	var classes = argument_count > 3 ? argument[3] : "";

	return html_element(parent, identifier, "h2", "className", classes, "content", content);
}

/// @param parent
/// @param identifier
/// @param content
/// @param [classes]
function html_h3() {
	var parent = argument[0], identifier = argument[1], content = argument[2];
	var classes = argument_count > 3 ? argument[3] : "";

	return html_element(parent, identifier, "h3", "className", classes, "content", content);
}

/// @param parent
/// @param identifier
/// @param favicon-icon
/// @param [classes]
function html_icon() {
	var parent = argument[0], identifier = argument[1], icon = argument[2];
	var class = "fa fa-"+string(icon);
	var classes = argument_count > 3 ? argument[3] + " " + class : class;

	return html_element(parent, identifier, "span", "className", classes);	
}

/// @param parent
/// @param identifier
/// @param src
/// @param [classes]
/// @param [alt]
function html_image() {
	var parent = argument[0], identifier = argument[1], src = argument[2];
	var classes = argument_count > 3 ? argument[3] : "";
	var alt= argument_count > 4 ? argument[4] : "";

	return html_element(parent, identifier, "img", "src", src, "className", classes, "alt", alt);	
}

/// @param parent
/// @param identifier
/// @param content
/// @param [classes]
/// @param [style]
function html_link() {
	var parent = argument[0], identifier = argument[1], content = argument[2];
	var classes = argument_count > 3 ? argument[3] : "";
	var style = argument_count > 4 ? argument[4] : "";

	var link = html_element(
		parent, 
		identifier, 
		"a",
		"content", content, 
		"className", "link " + classes, 
		"style", style,
		"href", "",
		"onclick", "event.preventDefault(); gml_Script_gmcallback_on_interaction(null, null, this.id)",
		"onmouseover", "event.preventDefault(); _html_elements_store_mouse_position(event); gml_Script_gmcallback_on_mouseover(null, null, this.id)",
		"onmouseout", "event.preventDefault(); _html_elements_store_mouse_position(event); gml_Script_gmcallback_on_mouseout(null, null, this.id)",
	);

	return link;
}

/// @param parent
/// @param identifier
/// @param content
/// @param [classes]
function html_p() {
	var parent = argument[0], identifier = argument[1], content = argument[2];
	var classes = argument_count > 3 ? argument[3] : "";

	return html_element(parent, identifier, "p", "className", classes, "content", content);
}


/// @param parent
/// @param identifier
/// @param name
/// @param checked
/// @param label
function html_radio() {
	var parent = argument[0], identifier = argument[1], name = argument[2], checked = argument[3], label = argument[4];

	var radio = html_element(
		parent, 
		identifier, 
		"input", 
		"type", "radio", 
		"name", name, 
		"checked", checked ? "checked" : undefined,
		"onchange", "event.preventDefault(); gml_Script_gmcallback_on_interaction(null, null, this.id)"
	);

	html_element(
		parent, 
		identifier+"-label", 
		"label",
		"content", label, 
		"for", html_element_id(radio)
	);

	return radio;
}

/// @param parent
/// @param identifier
/// @param [classes]
function html_row() {
	var parent = argument[0], identifier = argument[1];
	var classes = argument_count > 2 ? argument[2] : "";

	return html_element(parent, identifier, "tr", "className", classes);
}

/// @param parent
/// @param identifier
/// @param content
/// @param [classes]
function html_span() {
	var parent = argument[0], identifier = argument[1], content = argument[2];
	var classes = argument_count > 3 ? argument[3] : "";

	return html_element(parent, identifier, "span", "className", classes, "content", content);
}

/// @param parent
/// @param identifier
/// @param sprite
/// @param index
/// @param [classes]
/// @param [xscale]
/// @param [yscale]
function html_sprite() {
	var parent = argument[0], identifier = argument[1], sprite = argument[2], index = argument[3];
	var classes = argument_count > 4 ? argument[4] : "";
	var xscale = argument_count > 5 ? argument[5] : 1;
	var yscale = argument_count > 6 ? argument[6] : 1;

	if is_undefined(sprite)
	exit;

	var texture = sprite_get_texture(sprite, index);
	var uvs = texture_get_uvs(texture);
	var texture_width = 1/texture_get_texel_width(texture);
	var texture_height = 1/texture_get_texel_height(texture);

	// @todo Find a way to correctly determine the texture_page
	var texture_id = 0;
	var url = "/html5game/"+global.texture_base+"_texture_"+string(texture_id)+".png";

	var img_width = ((uvs[2] - uvs[0])) * texture_width;
	var img_height = ((uvs[3] - uvs[1])) * texture_height;
	var img_left = uvs[0] * texture_width;
	var img_top = uvs[1] * texture_height;

	var style = "width: "+string(xscale * img_width)+"px; height: "+string(yscale * img_height)+"px;"
	style += " background-position: -"+string(xscale * img_left)+"px -"+string(yscale * img_top)+"px;";
	style += " background-size: "+string(xscale * texture_width)+"px "+string(yscale * texture_height)+"px;";
	style += " background-image: url('"+url+"');";

	return html_element(parent, identifier, "div", "style", style, "className", classes);
}

/// @param parent
/// @param identifier
/// @param [submit_label]
/// @param [enabled]
/// @param [classes]
function html_submit() {
	var parent = argument[0], identifier = argument[1], submit_label = argument[2];
	var enabled = argument_count > 3 ? argument[3] : true;
	var classes = argument_count > 4 ? argument[4] : "";

	var button = html_element(
		parent, 
		identifier, 
		"button", 
		"type", "submit", 
		"content", submit_label, 
		"className", classes, 
		"disabled", enabled ? undefined : "disabled"
	);

	return button;
}

/// @param parent
/// @param identifier
/// @param [classes]
function html_table() {
	var parent = argument[0], identifier = argument[1];
	var classes = argument_count > 2 ? argument[2] : "";

	return html_element(parent, identifier, "table", "className", classes);
}

///////////////////////////////////////// Helper functions to be used in application code \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/// @description Returns a map containing the values of all form inputs
function html_form_values(element) {
	var values_map = ds_map_create();

	html_form_add_values_from_children(values_map, element.pending_children);
	html_form_add_values_from_children(values_map, element.children);

	return values_map;
}

/// @description Returns whether a the mouse hover the element
function html_element_hover(element) {
	return element.hover;
}

/// @description Returns whether an element was clicked on
function html_element_interaction(element) {
	return element.interaction;
}

/// @description Returns the current x position of the element
function html_element_x(element) {
	return _html_elements_get_x(html_element_id(element));
}

/// @description Returns the current y position of the element
function html_element_y(element) {
	return _html_elements_get_y(html_element_id(element));
}

/// @description Returns the current x position of the mouse
function html_mouse_x() {
	return _html_elements_get_mouse_x();
}

/// @description Returns the current y position of the mouse
function html_mouse_y() {
	return _html_elements_get_mouse_y();
}

///////////////////////////////////////// Internal functions not to be used in application code \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function HtmlElement(_parent, _identifier, _type) constructor {
	element_id = 10000 + global.html_element_next_id;
	global.html_element_next_id += 1;
	// Children added this step
	children = ds_map_create();
	// Children added last step
	pending_children = ds_map_create();
	pending_properties = ds_map_create();
	properties = ds_map_create();
	sync_properties = ds_list_create();

	destroy = false;
	hover = false;
	incoming_interaction = false;
	interaction = false;
	last_child = undefined;
	new_element = true;
	value = undefined;
	
	parent = _parent;
	identifier = _identifier;
	type = _type;
}

/// @param parent
/// @param identifier
/// @param type
/// @param key
/// @param value
/// @param *
function html_element(parent, own_identifier, type) {
	var element = undefined;
	var has_parent = !is_undefined(parent);
	var identifier = has_parent ? parent.identifier + "-" + own_identifier : own_identifier;

	if has_parent {
		if !is_undefined(parent.children[? identifier])
		show_message(parent.identifier + " already has a child with id " + identifier + ". Please make sure identifiers are unique "+string(parent.children[? identifier]));
		ds_map_delete(parent.properties, "content");
		element = parent.pending_children[? identifier];
		if !is_undefined(element) {
			if element.type != type
			show_message(identifier + " was a " + element.type + " but is now a " + type)
			ds_map_delete(parent.pending_children, identifier)
		}
	} else {
		element = html_element_by_identifier(identifier)
	}
	
	if is_undefined(element) {
		element = new HtmlElement(parent, identifier, type);
		ds_list_add(global.html_elements, element);
		if has_parent {
			_html_elements_create(type, html_element_id(element), html_element_id(parent), html_element_id(parent.last_child));
		} else {
			_html_elements_create(type, html_element_id(element));
		}
	}
	element.own_identifier = own_identifier;

	if has_parent {
		parent.children[? identifier] = element;
		parent.last_child = element
	}

	for (var i=3; i<argument_count; i+=2) {
		var key = argument[i];
		var value = argument[i + 1];
		html_element_set_property(element, key, value);
	}
	if !ds_map_exists(element.properties, "className")
	html_element_set_property(element, "className", "");

	element.destroy = false;

	return element

}

/// @param id
function html_element_by_id(identifier) {
	for (var i=0; i<ds_list_size(global.html_elements); i+=1) {
		var element = global.html_elements[| i];
		if identifier == html_element_id(element)
		return element;
	}
	return undefined;
}

/// @param identifier
function html_element_by_identifier(identifier) {
	for (var i=0; i<ds_list_size(global.html_elements); i+=1) {
		var element = global.html_elements[| i];
		if identifier == element.identifier && is_undefined(element.parent)
		return element;
	}
	return undefined;
}

function html_element_cleanup(element, remove_element) {
	html_element_cleanup_children(element.pending_children)
	ds_map_destroy(element.pending_children);
	ds_map_destroy(element.children);
	ds_map_destroy(element.pending_properties);
	ds_map_destroy(element.properties);
	ds_list_destroy(element.sync_properties);
	
	if remove_element
	_html_elements_remove(html_element_id(element));

	if global.html_element_focussed == element.identifier
	gmcallback_set_focus()
}

function html_element_cleanup_children(map) {
	if ds_exists(map, ds_type_grid)
	for (var key=ds_map_find_first(map); !is_undefined(key); key=ds_map_find_first(map)) {
		html_element_cleanup(map[? key], false);
		ds_map_delete(map, key);
	}
}

function html_element_id(element) {
	if is_undefined(element)
	return undefined

	return "gmID"+string(element.element_id)
}

function html_element_set_property(element, key, value) {
	if key == "className" {
		value += " "+element.own_identifier;
		value += " html-element";
		if is_undefined(element.parent)
		value += " html-element-parent";
	}
	var current = undefined;
	if !element.new_element {
		current = element.pending_properties[? key];
		ds_map_delete(element.pending_properties, key);
	}
	if current != value
	ds_list_add(element.sync_properties, key);
	element.properties[? key] = value;
}

function html_element_sync(element) {
	element.destroy = true;
	html_element_cleanup_children(element.pending_children);

	ds_map_copy(element.pending_children, element.children);
	ds_map_clear(element.children);

	for (var i=0; i<ds_list_size(element.sync_properties); i+=1) {
		var key = element.sync_properties[| i];
		if ds_map_exists(element.properties, key) {
			var value = ds_map_find_value(element.properties, key);
			_html_elements_set_property(html_element_id(element), key, value);
		}
	}
	ds_list_clear(element.sync_properties);

	for (var key=ds_map_find_first(element.pending_properties); !is_undefined(key); key=ds_map_find_first(element.pending_properties)) {
		_html_elements_set_property(html_element_id(element), key, undefined);
		ds_map_delete(element.pending_properties, key);
	}
	ds_map_copy(element.pending_properties, element.properties);
	ds_map_clear(element.properties);

	element.interaction = element.incoming_interaction;
	element.incoming_interaction = false;
	element.last_child = undefined;
	element.new_element = false
}

function html_form_add_values_from_children(values_map, children_map) {
	for (var identifier = ds_map_find_first(children_map); !is_undefined(identifier); identifier = ds_map_find_next(children_map, identifier)) {
		var child = ds_map_find_value(children_map, identifier);

		if child.type == "input"
		values_map[? child.own_identifier] = child.value;

		html_form_add_values_from_children(values_map, child.pending_children);
		html_form_add_values_from_children(values_map, child.children);
	}
}

///////////////////////////////////////// External functions to be used by javascript \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
function gmcallback_lose_focus(focussed) {
	global.html_element_focussed = focussed;
	browser_input_capture(false)
}

function gmcallback_on_input(identifier, value) {
	var element = html_element_by_id(identifier);
	if !is_undefined(element)
	element.value = value;
}

function gmcallback_on_interaction(identifier) {
	var element = html_element_by_id(identifier);
	if !is_undefined(element)
	element.incoming_interaction = true;
	
	if argument_count > 1 {
		global.html_elements_last_click_x = argument[1];
		global.html_elements_last_click_y = argument[2];
	}
	
	mouse_clear(mb_left)
}

function gmcallback_on_mouseover(identifier) {
	var element = html_element_by_id(identifier);
	if !is_undefined(element)
	element.hover = true;
}

function gmcallback_on_mouseout(identifier) {
	var element = html_element_by_id(identifier);
	if !is_undefined(element)
	element.hover = false;
}

function gmcallback_set_focus() {
	global.html_element_focussed = undefined;
	browser_input_capture(true)
}