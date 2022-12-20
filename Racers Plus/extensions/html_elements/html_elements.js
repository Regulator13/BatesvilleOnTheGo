const ATTRIBUTES = [
  'accept', 'accept-charset', 'accesskey', 'action', 'align', 'alt', 'async', 'autocomplete', 'autofocus', 'autoplay', 'bgcolor', 'border', 'charset', 
  'checked', 'cite', 'class', 'color', 'cols', 'colspan', 'content', 'contenteditable', 'controls', 'coords', 'data', 'datetime', 'default', 'defer', 
  'dir', 'dirname', 'disabled', 'download', 'draggable', 'dropzone', 'enctype', 'for', 'form', 'formaction', 'headers', 'height', 'hidden', 'high', 
  'href', 'hreflang', 'http-equi', 'ismap', 'kind', 'label', 'lang', 'list', 'loop', 'low', 'max', 'maxlength', 'media', 'method', 'min', 'multiple', 
  'muted', 'name', 'novalidate', 'onabort', 'onafterprint', 'onbeforeprint', 'onbeforeunload', 'onblur', 'oncanplay', 'oncanplaythrough', 'onchange', 
  'onclick', 'oncontextmenu', 'oncopy', 'oncuechange', 'oncut', 'ondblclick', 'ondrag', 'ondragend', 'ondragenter', 'ondragleave', 'ondragover', 'ondragstart',
  'ondrop', 'ondurationchange', 'onemptied', 'onended', 'onerror', 'onfocus', 'onhashchange', 'oninput', 'oninvalid', 'onkeydown', 'onkeypress', 'onkeyup', 
  'onload', 'onloadeddata', 'onloadedmetadata', 'onloadstart', 'onmousedown', 'onmousemove', 'onmouseout', 'onmouseover', 'onmouseup', 'onmousewheel', 'onoffline', 'ononline',
  'onpagehide', 'onpageshow', 'onpaste', 'onpause', 'onplay', 'onplaying', 'onpopstate', 'onprogress', 'onratechange', 'onreset', 'onresize', 'onscroll', 'onsearch', 'onseeked',
  'onseeking', 'onselect', 'onstalled', 'onstorage', 'onsubmit', 'onsuspend', 'ontimeupdate', 'ontoggle', 'onunload', 'onvolumechange', 'onwaiting', 'onwheel', 'open', 
  'optimum', 'pattern', 'placeholder', 'poster', 'preload', 'readonly', 'rel', 'required', 'reversed', 'rows', 'rowspan', 'sandbox', 'scope', 'selected', 'shape', 'size',
  'sizes', 'span', 'spellcheck', 'src', 'srcdoc', 'srclang', 'srcset', 'start', 'step', 'style', 'tabindex', 'target', 'title', 'translate', 'type', 'usemap', 'value', 'width', 'wrap'
];
var _html_elements_mouse_position = [0, 0];

function _html_elements_create(type, id, parent, insert_after) {
  var element = document.createElement(type);
  element.setAttribute("id", id);

  if (parent) {
    if (insert_after) {
      document.getElementById(insert_after).insertAdjacentElement("afterend", element);
    } else {
      document.getElementById(parent).insertAdjacentElement("afterbegin", element)
    }
  } else {
    document.body.appendChild(element);    
  }

  return true;
}

function _html_elements_remove(id) {
  return document.getElementById(id) && document.getElementById(id).remove();
}

function _html_elements_set_property(id, key, value) {
  var element = document.getElementById(id);
  if (!element) {
    return false;
  }

  if (key === "content") {
    element.innerHTML = typeof value === "undefined" ? null : value;
    return true;
  }
  if (ATTRIBUTES.indexOf(key) >= 0) {
    if (typeof value === "undefined") {
      element.removeAttribute(key);
    } else {
      element.setAttribute(key, value);
    }
    return true;
  }
  element[key] = value;
  return true;
}

function _html_style_add(rule) {
  var sheet = document.styleSheets[0];
  sheet.insertRule(rule, 1);
}

function _html_elements_get_x(id) {
  var element = document.getElementById(id);
  if (!element) {
    return null;
  }
  return element.getBoundingClientRect().x;
}

function _html_elements_get_y(id) {
  var element = document.getElementById(id);
  if (!element) {
    return null;
  }
  return element.getBoundingClientRect().y;
}

function _html_elements_get_mouse_x() {
  return _html_elements_mouse_position[0];
}

function _html_elements_get_mouse_y() {
  return _html_elements_mouse_position[1];
}

function _html_elements_store_mouse_position(e) {
  var pageX = e.pageX;
  var pageY = e.pageY;
  if (pageX === undefined) {
    pageX = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
    pageY = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
  }

  _html_elements_mouse_position = [pageX, pageY];
}

document.onmousemove = function(e){
    _html_elements_store_mouse_position(e);
}