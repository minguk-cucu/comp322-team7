function confirmAndDelete() {
    // 확인 창 띄우기
    var confirmResult = confirm("정말 탈퇴하시겠습니까?");

    // 사용자가 확인을 선택한 경우
    if (confirmResult) {
        window.location.href = "delete-userinfo.jsp";
    } else {

    }
}
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
