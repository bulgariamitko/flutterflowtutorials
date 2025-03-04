// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - no
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

const fs = require('fs');
const readline = require('readline');

const tiers = new Map();

async function processCSV(filePath) {
  const fileStream = fs.createReadStream(filePath);

  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity,
  });

  let isFirstLine = true;

  for await (const line of rl) {
    if (isFirstLine) {
      isFirstLine = false;
      continue;
    }
    processLine(line);
  }

  displayTiers();
}

function processLine(line) {
  const modifiedLine = line.replace(/"([^"]*), ([^"]*)"/g, '$1 $2').replace(/"/g, '');
  const columns = modifiedLine.split(',');
  const name = columns[0].trim();
  const tier = columns[2].trim();

  if (!tiers.has(tier)) {
    tiers.set(tier, []);
  }

  tiers.get(tier).push(name);
}

function displayTiers() {
  // Define the order of tiers
  const tierOrder = [
    'Klaturov Cadet',
    'Klaturov Fanatic',
    'Klaturov Devotees',
    'Klaturov Elite'
  ];

  // Display tiers in the specified order
  tierOrder.forEach(tier => {
    if (tiers.has(tier)) {
      console.log(tier);
      // Sort names alphabetically within each tier
      const sortedNames = tiers.get(tier).sort();
      sortedNames.forEach(name => {
        console.log(`| ${name}`);
      });
      console.log();
    }
  });

  // Display any tiers not in the specified order (if they exist)
  tiers.forEach((names, tier) => {
    if (!tierOrder.includes(tier)) {
      console.log(`Unspecified Tier: ${tier}`);
      const sortedNames = names.sort();
      sortedNames.forEach(name => {
        console.log(`| ${name}`);
      });
      console.log();
    }
  });
}

const filePath = 'members.csv'; // Replace with the actual file path
processCSV(filePath);
