// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video -
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

async function handleRequest(request) {
    const country = request.headers.get('CF-IPCountry');

    return new Response(JSON.stringify({ country: country }), {
        headers: { 'Content-Type': 'application/json' },
    });
}

export default {
    fetch: handleRequest
};
