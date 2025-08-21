-- // YouTube channel - https://www.youtube.com/@dimitarklaturov
-- // paid video - https://youtu.be/yl1rn79KpZo
-- // Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
-- // Support my work - https://github.com/sponsors/bulgariamitko
-- // Website - https://bulgariamitko.github.io/flutterflowtutorials/
-- // You can book me as FF mentor - https://calendly.com/bulgaria_mitko
-- // GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
-- // Discord channel - https://discord.gg/G69hSUqEeU

INSERT INTO Players (name, position, team_id)
VALUES ('${name}', '${position}', ${teamid})

UPDATE Players SET team_id = ${teamid} WHERE id = ${playerid}

DELETE FROM Players WHERE id = ${id}