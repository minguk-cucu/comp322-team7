
function openTab(evt, tabName) {

	var i, tabcontent, tablinks;
	tabcontent = document.getElementsByClassName("tabcontent");
	for (i = 0; i < tabcontent.length; i++) {
		tabcontent[i].style.display = "none";
	}
	tablinks = document.getElementsByClassName("tablink");
	for (i = 0; i < tablinks.length; i++) {
		tablinks[i].className = tablinks[i].className
			.replace(" active", "");
	}
	document.getElementById("Tab"+tabName).style.display = "block";
	evt.currentTarget.className += " active";

	tabdate_contents = document.getElementsByClassName("tabdate-content")
	for (i = 0; i < tabdate_contents.length; i++) {
		if (tabdate_contents[i].id == "tab" + tabName + "-content") {
			tabdate_contents[i].style.display = "block";
		}

	}
}
