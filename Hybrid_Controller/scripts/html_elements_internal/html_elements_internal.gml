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

	// Identify if element was created last step
	if has_parent {
		if !is_undefined(parent.children[? identifier])
			show_message(parent.identifier + " already has a child with id " + identifier + ". Please make sure identifiers are unique "+string(parent.children[? identifier]));
		
		ds_map_delete(parent.properties, "content");
		
		// Check if this element was already added last step
		element = parent.pending_children[? identifier];
		if !is_undefined(element) {
			if element.type != type
			show_message(identifier + " was a " + element.type + " but is now a " + type)
			ds_map_delete(parent.pending_children, identifier)
		}
	}
	else {
		element = html_element_by_identifier(identifier)
	}
	
	// If element is new, create it
	if is_undefined(element) {
		element = new HtmlElement(parent, identifier, type);
		ds_list_add(global.html_elements, element);
		if has_parent {
			_html_elements_create(type, html_element_id(element), html_element_id(parent), html_element_id(parent.last_child));
		}
		else {
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

/// @description Update and clean up properties and element children
function html_element_sync(element) {
	element.destroy = true;
	
	// Clean up any children from last step that were not updated
	html_element_cleanup_children(element.pending_children);
	
	// Store children this step for checking next step
	ds_map_copy(element.pending_children, element.children);
	ds_map_clear(element.children);
	
	// Update element properties
	for (var i=0; i<ds_list_size(element.sync_properties); i+=1) {
		var key = element.sync_properties[| i];
		if ds_map_exists(element.properties, key) {
			var value = ds_map_find_value(element.properties, key);
			_html_elements_set_property(html_element_id(element), key, value);
		}
	}
	ds_list_clear(element.sync_properties);
	
	// Clean up removed properties
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