SELECT id, name, city, stadium_id AS stadiumid FROM Teams

SELECT Teams.name AS teamname, Stadiums.name AS stadiumname, Stadiums.capacity, Stadiums.location
FROM Teams
    JOIN Stadiums ON Teams.stadium_id = Stadiums.id

SELECT Players.id, Players.name AS playername, Players.position, Teams.name AS teamname
FROM Players
    JOIN Teams ON Players.team_id = Teams.id

SELECT * FROM Players WHERE name LIKE '%${playerName}%'

SELECT * FROM Teams WHERE city = '${city}'

SELECT id, name, position, team_id AS teamid FROM Players