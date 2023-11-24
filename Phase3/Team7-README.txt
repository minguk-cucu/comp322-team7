T3P7.java에서 oracle 연결하고 해당 파일에서 클래스들을 호출합니다.
T3P7.java에서 //CUTOMIZE THIS //주석이 달린 부분을 수정하여 oracle 연결을 수정할 수 있습니다.
ojdbc10.jar 라이브러리를 이용하여 개발하였습니다.

-- QUERY 수정 --

TYPE 7 의 두번째 쿼리
SELECT team_name, AVG_H
FROM ( SELECT team_name, AVG_H, ROWNUM r
        FROM (SELECT team_name, AVG(height) AS AVG_H
                FROM PLAYER
                GROUP BY team_name 
                ORDER BY AVG_H DESC) )
WHERE r <=3;

을 

WITH AWAY_TEAM
AS( SELECT team_name, match_id FROM TEAM_PLAYED_MATCH WHERE match_id = 93418
    MINUS
    SELECT home_team_name AS team_name, match_id FROM MATCH WHERE match_id = 93418 )
SELECT m.season_name, m.match_date, m.home_team_name, a.team_name 
FROM MATCH m, AWAY_TEAM a
WHERE m.match_id = 93418
    AND m.match_id = a.match_id;

으로 수정하였습니다.