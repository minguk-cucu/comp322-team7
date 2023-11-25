<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <p>
    <%@ String userID = (String)session.getAttribute("userID");
        out.println(userID + ",  Hello !!");
    %></p>
</body>
</html>