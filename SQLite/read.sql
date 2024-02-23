-- // YouTube channel - https://www.youtube.com/@flutterflowexpert
-- // paid video - https://youtu.be/yl1rn79KpZo
-- // Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
-- // Support my work - https://github.com/sponsors/bulgariamitko
-- // Website - https://bulgariamitko.github.io/flutterflowtutorials/
-- // You can book me as FF mentor - https://calendly.com/bulgaria_mitko
-- // GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
-- // Discord channel - https://discord.gg/G69hSUqEeU

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