function pin_setup(p, m) {
    jQuery.ajax({
	method: "POST",
	url: "/gpio",
	data :{
	    pin: p,
	    action: "init",
	    mode: m,
	    pullmode: "NONE"
	},
	success: function (resp) {
	    if (resp == "IN") {
		// Set direction appropriately
		$("div#pin-control-" + p).find("div span#dir-in").css("color", "rgb(0,0,0)");
		$("div#pin-control-" + p).find("div span#dir-out").css("color", "rgb(200,200,200)");
		$("div#pin-control-" + p).find("div span#dir-dis").css("color", "rgb(200,200,200)");
		// Disble set and clear, enable read
		$("div#pin-control-" + p).find("div button#read").removeAttr("disabled");
		$("div#pin-control-" + p).find("div button#set").attr("disabled", "true");
		$("div#pin-control-" + p).find("div button#clear").attr("disabled", "true");
		// Read data immediately
		pin_read(p);
	    } else if (resp == "OUT") {
		// Set direction appropriately
		$("div#pin-control-" + p).find("div span#dir-out").css("color", "rgb(0,0,0)");
		$("div#pin-control-" + p).find("div span#dir-in").css("color", "rgb(200,200,200)");
		$("div#pin-control-" + p).find("div span#dir-dis").css("color", "rgb(200,200,200)");
		// Enable set and clear, disable read
		$("div#pin-control-" + p).find("div button#read").attr("disabled", "true");
		$("div#pin-control-" + p).find("div button#set").removeAttr("disabled");
		$("div#pin-control-" + p).find("div button#clear").removeAttr("disabled");
	    }
	}
    });
}

function pin_read(p) {
    jQuery.ajax({
	method: "POST",
	url: "/gpio",
	data: {
	    pin: p,
	    action: "read",
	},
	success: function (resp) {
	    $("div#pin-control-" + p).find("div span#val-low").css("color", "rgb(200,200,200)");
	    $("div#pin-control-" + p).find("div span#val-high").css("color", "rgb(200,200,200)");
	    if (resp == "LOW") {
		$("div#pin-control-" + p).find("div span#val-low").css("color", "rgb(0,0,0)");
	    } else if (resp == "HIGH") {
		$("div#pin-control-" + p).find("div span#val-high").css("color", "rgb(0,0,0)");
	    }
	}
    });
}

function pin_write(p, v) {
    jQuery.ajax({
	method: "POST",
	url: "/gpio",
	data: {
	    pin: p,
	    action: "set",
	    value: v
	},
	success: function (resp) {
	    $("div#pin-control-" + p).find("div span#val-low").css("color", "rgb(200,200,200)");
	    $("div#pin-control-" + p).find("div span#val-high").css("color", "rgb(200,200,200)");
	    if (resp == "LOW") {
		$("div#pin-control-" + p).find("div span#val-low").css("color", "rgb(0,0,0)");
	    } else if (resp == "HIGH") {
		$("div#pin-control-" + p).find("div span#val-high").css("color", "rgb(0,0,0)");
	    }
	}
    });
}

function pin_disable(p) {
    jQuery.ajax({
	method: "POST",
	url: "/gpio",
	data :{
	    pin: p,
	    action: "disable"
	},
	success: function (resp) {
	    if (resp == "Disabled") {
		// Disble read, set, and clear
		$("div#pin-control-" + p).find("div button#read").attr("disabled", "true");
		$("div#pin-control-" + p).find("div button#set").attr("disabled", "true");
		$("div#pin-control-" + p).find("div button#clear").attr("disabled", "true");
		// Gray out values
		$("div#pin-control-" + p).find("div span#val-low").css("color", "rgb(200,200,200)");
		$("div#pin-control-" + p).find("div span#val-high").css("color", "rgb(200,200,200)");
		// Gray out in/out indicators
		$("div#pin-control-" + p).find("div span#dir-in").css("color", "rgb(200,200,200)");
		$("div#pin-control-" + p).find("div span#dir-out").css("color", "rgb(200,200,200)");
		// Highlight disabled indicator
		$("div#pin-control-" + p).find("div span#dir-dis").css("color", "rgb(0,0,0)");
	    }
	}
    });
}

