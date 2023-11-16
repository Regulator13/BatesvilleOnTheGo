/// @description User interface

// Automatic clean up occurs if UI is not reinstated each step
var form = html_form(undefined, "registration-form")
html_h1(form, "header", "Direct Connect")
html_element(form, "1", "br")
html_field(form, "name", "text", "Player Name", true, "", default_name)
html_element(form, "2", "br")
html_field(form, "ip", "text", "172.0.0.1", true, "", default_ip)
html_submit(form, "submit", "Join")

// Process UI
if html_element_interaction(form){
	var values = html_form_values(form)

	default_name = values[? "name"]
	default_ip = values[? "ip"]
	event_user(0)

	ds_map_destroy(values)
}