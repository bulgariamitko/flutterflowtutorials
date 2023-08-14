// code created by https://www.youtube.com/@flutterflowexpert
// paid video - no
// support my work - https://github.com/sponsors/bulgariamitko

const fs = require('fs');
const readline = require('readline');

const tiers = new Map();

async function processCSV(filePath) {
  const fileStream = fs.createReadStream(filePath);

  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity,
  });

  for await (const line of rl) {
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

  if (name !== 'Член') {
    tiers.get(tier).push(name);
  }
}

function displayTiers() {
  tiers.forEach((names, tier) => {
    console.log(tier);
    names.forEach((name) => {
      console.log(`| ${name}`);
    });
    console.log();
  });
}

const filePath = 'members.csv'; // Replace with the actual file path
processCSV(filePath);
