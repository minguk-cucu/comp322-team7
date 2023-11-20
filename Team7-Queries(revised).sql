--Type 1------------

--id가 19758인 player 찾기
SELECT name, nationality, birth, team_name
FROM PLAYER
WHERE player_id = 19758;


--'Arsenal' 이름을 가진 team 찾기
SELECT team_name, est_year, stadium, manager
FROM TEAM
WHERE team_name = 'Arsenal';


--Type 2----------------

--'Son Heung-Min'이라는 이름을 가진 선수(들)의 팀 이름, 그 팀의 manager, 선수의 이름, 선수의 국적, 출전 횟수, 골 수 출력
SELECT t.team_name, t.manager, p.name, p.nationality, ps.appearances, ps.goals
FROM PLAYER p, PLAYER_STAT ps, TEAM t
WHERE p.name = 'Son Heung-Min'
    AND p.player_id = ps.player_id
    AND p.team_name = t.team_name;

--'Arsenal'을 following 하고 있는 user가 남긴 review 보기
SELECT ui.user_id, e.match_id, e.rating, e.review
FROM USER_INFO ui, EVALUATION e, USER_FOLLOW_TEAM uf
WHERE ui.user_id = e.user_id
    AND ui.user_id = uf.user_id
    AND uf.TEAM_NAME = 'Arsenal';

--Type  3---------------------------------

--type3-1.) 한 경기에 세 골 이상 넣은 경기에서 낸 팀별 평균 골 횟수 출력
SELECT tm.TEAM_NAME team_name , AVG(tpm.score) AS average_goal
FROM MATCH m, TEAM_PLAYED_MATCH tpm, TEAM tm
WHERE m.Match_id = tpm.Match_id
AND tpm.Team_name = tm.Team_name
AND tpm.Score >=3
GROUP BY tm.TEAM_name
ORDER BY average_goal DESC;

--type3-2) 2023/24시즌 내 골 횟수가 5회 이상인 선수가 이번 시즌 경기에 참여한 횟수
SELECT pn.name,COUNT(*) AS numofmatch
FROM player pn, player_stat ps, player_played_match ppm, match mc
WHERE mc.match_id = ppm.match_id
AND ppm.player_id = pn.player_id
AND ps.player_id = pn.player_id
AND ps.goals >= 5
GROUP BY pn.name
ORDER BY numofmatch DESC;


--Type 4---------------

-- 한 경기에 5점 이상 득점(score)한 적 있는 team들의 2023/24시즌 stat 표시
SELECT t.team_name, ts.goals, ts.shots_on_target, ts.wins
FROM TEAM t, TEAM_STAT ts
WHERE t.team_name = ts.team_name
    AND ts.season_name = '2023/24'
    AND t.team_name IN ( SELECT team_name
                        FROM TEAM_PLAYED_MATCH
                        WHERE score >= 5 );

-- 2023/24 시즌, 가장 많이 출전한(appearances) player들의 포지션
SELECT p.position, COUNT(p.player_id)
FROM PLAYER p, PLAYER_STAT ps
WHERE p.player_id = ps.player_id
    AND ps.season_name = '2023/24'
    AND ps.appearances = ( SELECT MAX(appearances)
                            FROM PLAYER_STAT
                            WHERE season_name = '2023/24' )
GROUP BY p.position;


-- type 5
-- 한국인이 있는 팀의 팀 이름과 선수 이름
SELECT T.Team_name FROM TEAM T
WHERE EXISTS(
    SELECT * FROM PLAYER P
    WHERE P.Team_name = T.Team_name AND P.Nationality = 'South Korea'
);
-- 2023/24 시즌에 7번 승리한 팀에 속한 선수의 이름과 국적
SELECT P.Name, P.Nationality FROM PLAYER P
WHERE EXISTS(
    SELECT * FROM TEAM T, TEAM_STAT TS
    WHERE T.Team_name = P.Team_name AND T.Team_name = TS.Team_name AND TS.Season_name = '2023/24' AND TS.Wins >= 7
);

--Type 6---------------------------

--6-1) 승리한 수가 패배한 수 보다 많은 팀의 이름과 경기장을 출력하기
SELECT tm.TEAM_NAME, tm.Stadium
FROM TEAM tm
WHERE tm.TEAM_NAME IN(
    SELECT ts.TEAM_NAME
    FROM TEAM_STAT ts
    WHERE tm.Team_name = ts.Team_name
    AND ts.Wins>ts.Losses
);

--6.2) 슛을 20번 이상했던 선수들 중 골 성공률(goal/shot)이 20퍼센트 이상인 선수가 경기했던 match_id를 중복되지 않게 출력
SELECT DISTINCT mc.match_id
FROM MATCH mc
WHERE mc.Match_id IN(
    SELECT ppm.Match_id
    FROM PLAYER_PLAYED_MATCH ppm
    WHERE ppm.Player_id IN(
        SELECT pl.Player_id
        FROM PLAYER pl
        WHERE pl.Player_id IN(
            SELECT ps.Player_id
            FROM PLAYER_STAT ps
            WHERE ps.shots > 0
            AND ps.goals/ps.shots >= 0.2
            AND ps.shots >=20
        )
    )
)
;



--Type 7 --------------------

-- user들의 evaluation들 중 평균 rating 3점 이상을 받은 match들 출력
WITH MATCH_RATING AS (
SELECT m.match_id, AVG(e.rating) AS avg_rating
FROM MATCH m, EVALUATION e
WHERE m.match_id = e.match_id
GROUP BY m.match_id)
SELECT r.match_id, mm.match_date, mm.home_team_name
FROM MATCH_RATING r, MATCH mm
WHERE r.match_id = mm.match_id
    AND r.avg_rating > 3;

-- 특정 match_id 를 가지는 match 를 수행한 홈팀과 어웨이팀 ( 수정됨 )
WITH AWAY_TEAM
AS( SELECT team_name, match_id FROM TEAM_PLAYED_MATCH WHERE match_id = 93418
    MINUS
    SELECT home_team_name AS team_name, match_id FROM MATCH WHERE match_id = 93418 )
SELECT m.season_name, m.match_date, m.home_team_name, a.team_name 
FROM MATCH m, AWAY_TEAM a
WHERE m.match_id = 93418
    AND m.match_id = a.match_id;
    



--Type 8----------------------------------------


--8.1) Tottenham Hotspur에 소속된 선수중 Liverpool과의 경기에 참여한 선수들의 
-- 이름과 position을 패스 수가 높은 순으로 출력한다. (pass가 null인 선수는 제외한다)
SELECT pl.Name, pl.Position, ps.passes as pass
FROM PLAYER pl,PLAYER_STAT ps,PLAYER_PLAYED_MATCH ppm,MATCH mc,TEAM_PLAYED_MATCH tpm
WHERE pl.Team_name = 'Tottenham Hotspur'
AND pl.Player_id = ps.Player_id
AND pl.Player_id = ppm.Player_id
AND ppm.Match_id = mc.Match_id
AND mc.Match_id = tpm.Match_id
AND ps.passes is not null
ORDER BY pass DESC ;

--8.2) Tottenham Hotspur 치룬 경기들의 evaluation의 match_id , rating, review 순서로  레이팅이 높은 순으로 출력하기
SELECT ev.match_id,ev.rating, ev.review
FROM evaluation ev, match ch, team_played_match tpm
WHERE tpm.match_id = ch.match_id
AND ch.match_id = ev.match_id
AND tpm.team_name ='Tottenham Hotspur'
ORDER BY ev.rating DESC;




-- type 9
-- 사용자 평가가 높은 매치 순으로 정렬
SELECT M.Season_name, M.Match_date, M.HOME_TEAM_NAME FROM MATCH M, (
    SELECT M.Match_id, SUM(E.Rating) AS NUM FROM MATCH M, EVALUATION E 
    WHERE M.Match_id = E.Match_id
    GROUP BY M.Match_id
    ORDER BY NUM DESC
) TEMP
WHERE M.Match_id = TEMP.Match_id;
-- 2023.10.30 기준 경기에 많이 참여한 선수 순으로 정렬 
SELECT P.Name, COUNT(*) AS APPEARANCES FROM Player P, Player_played_match PPM, Match M
WHERE P.player_id = PPM.Player_id AND PPM.Match_id = M.Match_id
GROUP BY P.Name
ORDER BY APPEARANCES DESC;


-- type 10
-- 토트넘에서 지금까지 한 경기도 빠짐없이 참여한 선수 이름
SELECT P.Name FROM Player P
WHERE NOT EXISTS(
    SELECT TPM.Match_id FROM TEAM_PLAYED_MATCH TPM
    WHERE TPM.Team_name = 'Tottenham Hotspur'
    MINUS
    SELECT PPM.Match_id FROM PLAYER_PLAYED_MATCH PPM
    WHERE PPM.Player_id = P.Player_id
);
-- 울버햄튼에서 7번 이상 슛을 하고 5번 이상 골을 넣은 선수 이름
SELECT P.Name FROM Player P, Player_stat PS WHERE P.Player_id = PS.Player_id AND P.Team_name = 'Wolverhampton Wanderers' AND PS.Shots >= 7
INTERSECT
SELECT P.Name FROM Player P, Player_stat PS WHERE P.Player_id = PS.Player_id AND P.Team_name = 'Wolverhampton Wanderers' AND PS.Goals >= 5;