/*
document.getElementById("pre-btn").addEventListener("click", function() {
	var curYear = parseInt(document.getElementById("cur-year").textContent);
	var nextYear = parseInt(document.getElementById("next-year").textContent);

	document.getElementById("cur-year").textContent = curYear - 1;
	document.getElementById("next-year").textContent = nextYear - 1;
});

document.getElementById("next-btn").addEventListener("click", function() {
	var curYear = parseInt(document.getElementById("cur-year").textContent);
	var nextYear = parseInt(document.getElementById("next-year").textContent);

	document.getElementById("cur-year").textContent = curYear + 1;
	document.getElementById("next-year").textContent = nextYear + 1;
});
*/
document.addEventListener('DOMContentLoaded', function() {
	var more_info = document.querySelector('.team-more-info');
	var table = document.getElementsByTagName('table')[0];

	var name = document.getElementById('team-more-info-name');
	var stadium = document.getElementById('team-more-info-stadium');
	var est = document.getElementById('team-more-info-est');
	var mng = document.getElementById('team-more-info-mng');

	var rows = document.querySelectorAll("table tbody tr");
	rows.forEach(function(row) {
		row.addEventListener('click', function() {
			var cells = this.cells;

			if (!table.classList.contains('left')) {
				table.classList.add('left');
				more_info.classList.add('visible');
			}

			document.getElementById('team-more-info-img').src = ("pics/" + cells[1].innerText + ".png");
			name.innerText = cells[1].innerText;
			stadium.innerText = cells[4].innerText;
			est.innerText = cells[5].innerText;
			mng.innerText = cells[6].innerText;

			setGage(cells[7].innerText, cells[8].innerText, cells[9].innerText, cells[10].innerText)
		});
	});

	var btns = document.querySelectorAll('.team-close-btn');
	btns.forEach(function(btn) {
		btn.addEventListener('click', function() {
			table.classList.remove('left');
			more_info.classList.remove('visible');
		});
	});
});

function setGage(goals, shots_on_target, passes, tackles_success) {
	document.getElementById('goal-gage').style.width = 18*goals/26 + 'rem'
	document.getElementById('target-gage').style.width = 18*shots_on_target/70 + 'rem'
	document.getElementById('pass-gage').style.width = 18*passes/6463 + 'rem'
	document.getElementById('tackle-gage').style.width = 18*tackles_success/1 + 'rem'
}