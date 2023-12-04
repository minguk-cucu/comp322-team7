function checkPasswordMatch() {
    var password = document.getElementById('password').value;
    var confirmPassword = document.getElementById('password-confirm').value;
    var unChecked = document.getElementById('disabled-check');
    var checked = document.getElementById('enabled-check');
    var checkText = document.getElementById('password-check-text');

    if (password === confirmPassword) {
        checkText.style.color = '#0A154B';
        unChecked.style.display = 'none';
        checked.style.display = 'inline';
    } else {
        checkText.style.color = '#9A9A9A';
        unChecked.style.display = 'inline';
        checked.style.display = 'none';
    }
  }
