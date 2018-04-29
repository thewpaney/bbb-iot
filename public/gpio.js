function P8_7_setup() {
    jQuery.ajax({
	method: "POST",
	url: "/gpio",
	data: {
	    pin: "P8_7",
	    action: "init",
	    mode: "IN",
	    pullmode: "NONE"
	},
	success: function (resp) { alert(resp); }
    });
}
function P8_7_read() {
    $.ajax({
	url: "/gpio",
	data: {
	    pin: "P8_7",
	    action: "read"
	},
	success: function( result ) {
	    $( "#p8_7" ).html(result);
	}
    });
}
function P8_7_set(v) {
    $.ajax({
	url: "/gpio",
	data: {
	    pin: "P8_7",
	    action: "set",
	    value: v
	},
	success: function( result ) {
	    $( "#p8_7" ).html(result);
	}
    });
}
