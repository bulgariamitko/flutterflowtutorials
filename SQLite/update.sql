INSERT INTO Players (name, position, team_id)
VALUES ('${name}', '${position}', ${teamid})


UPDATE Players SET team_id = ${teamid} WHERE id = ${playerid} 

DELETE FROM Players WHERE id = ${id} 