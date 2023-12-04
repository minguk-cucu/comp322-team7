window.onload = function() {
	var svg = document.querySelector('svg');

	for (var i = 40; i >= 10; i -= 10) {
		var svgElement = createHexagon(i);

		svg.innerHTML += svgElement;
	}
}

var cnt = 0;
var first = 0;
var second = 0;
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
	var more_info = document.querySelector('.player-more-info');
	var table = document.getElementsByTagName('table')[0];

	var player1 = document.getElementById('player1');
	var player2 = document.getElementById('player2');
	var name1 = document.getElementById('player1-name');
	var name2 = document.getElementById('player2-name');
	var position1 = document.getElementById('player1-position');
	var position2 = document.getElementById('player2-position');
	var nat1 = document.getElementById('player1-nat');
	var nat2 = document.getElementById('player2-nat');
	var birth1 = document.getElementById('player1-birth');
	var birth2 = document.getElementById('player2-birth');
	var height1 = document.getElementById('player1-height');
	var height2 = document.getElementById('player2-height');
	var svg = document.querySelector('svg');

	var rows = document.querySelectorAll("table tbody tr");
	rows.forEach(function(row) {
		row.addEventListener('click', function() {
			var cells = this.cells;

			if (cnt == 0) {
				table.classList.add('left');
				more_info.classList.add('visible');
			}
			if (cnt < 2) {
				cnt++;

				if (first == 0) {
					player1.style.visibility = 'visible';
					var temp = cells[1].innerText.split('\n');

					name1.innerText = temp[0];
					position1.innerText = temp[1];
					nat1.innerText = cells[4].innerText;
					birth1.innerText = cells[5].innerText.split(' ')[0];
					height1.innerText = cells[6].innerText + 'cm';
					first = 1;

					svg.innerHTML += createStat("red", cells[7].innerText, cells[8].innerText, cells[9].innerText, cells[10].innerText, cells[11].innerText, cells[12].innerText);
				}
				else if (second == 0) {
					player2.style.visibility = 'visible';
					var temp = cells[1].innerText.split('\n');
					name2.innerText = temp[0];
					position2.innerText = temp[1];
					nat2.innerText = cells[4].innerText;
					birth2.innerText = cells[5].innerText.split(' ')[0];
					height2.innerText = cells[6].innerText + 'cm';
					second = 1;

					svg.innerHTML += createStat("green", cells[7].innerText, cells[8].innerText, cells[9].innerText, cells[10].innerText, cells[11].innerText, cells[12].innerText);
				}
			}
		});
	});

	var btns = document.querySelectorAll('.player-close-btn');
	btns.forEach(function(btn, index) {
		btn.addEventListener('click', function() {
			if (cnt > 0) {
				if (index == 0) {
					player1.style.visibility = 'hidden';
					svg.removeChild(document.querySelector('#stat-red'));
					first = 0;
				}
				else {
					player2.style.visibility = 'hidden';
					svg.removeChild(document.querySelector('#stat-green'));
					second = 0;
				}
				cnt--;
			}
			if (cnt == 0) {
				table.classList.remove('left');
				more_info.classList.remove('visible');
			}
		});
	});
});

function createHexagon(sideLength) {
	let coordinates = '';

	for (let i = 0; i < 6; i++) {
		let angle_deg = 60 * i - 30;
		let angle_rad = Math.PI / 180 * angle_deg;
		let x = 50 + sideLength * Math.cos(angle_rad);
		let y = 50 + sideLength * Math.sin(angle_rad);
		coordinates += (x + ',' + y + ' ');
	}

	return '<polygon points="' + coordinates + '"style="fill: white; stroke: gray; stroke-width: 0.1; fill-opacity: 0;"/>';
}

function createStat(color, assists, passes, cross_accuracy, aerial_battles_won, clearance, shots_on_target) {
	let coordinates = '';
	let array = [assists / 7, passes / 1003, cross_accuracy / 1, aerial_battles_won / 44, clearance / 67, shots_on_target / 24];

	for (let i = 0; i < 6; i++) {
		let sideLength = 50 * array[i];
		let angle_deg = 60 * i - 30;
		let angle_rad = Math.PI / 180 * angle_deg;
		let x = 50 + sideLength * Math.cos(angle_rad);
		let y = 50 + sideLength * Math.sin(angle_rad);
		coordinates += (x + ',' + y + ' ');
	}
	return '<polygon id="stat-' + color + '" points="' + coordinates + '"style="fill: ' + color + '; stroke: ' + color + '; stroke-width: 1; fill-opacity: 0.3;"/>';
}
