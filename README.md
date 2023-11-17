# comp322-team7

민국 - 페이즈 2에서 가져온 쿼리 2개 했음 8-2 2-2

쿼리 개수 모자라면 Type7 둘 중 아무거나 빼고
WITH AWAY_TEAM
AS( SELECT team_name, match_id FROM TEAM_PLAYED_MATCH WHERE match_id = 93418
    MINUS
    SELECT home_team_name AS team_name, match_id FROM MATCH WHERE match_id = 93418 )
SELECT m.season_name, m.match_date, m.home_team_name, a.team_name 
FROM MATCH m, AWAY_TEAM a
WHERE m.match_id = 93418
    AND m.match_id = a.match_id;
넣으면 될듯

Evaluation.java 에 주석으로 TYPE 7?? 달려있음


----
