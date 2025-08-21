// YouTube channel - https://www.youtube.com/@dimitarklaturov
// paid video - https://youtu.be/Y82DsIHiPNI
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
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

// addEventListener('fetch', (event) => {
//     event.respondWith(handleRequest(event.request));
// });

// const corsHeaders = {
//     'Access-Control-Allow-Headers': 'Content-Type',
//     'Access-Control-Allow-Methods': 'GET, OPTIONS', // Only allow GET and OPTIONS for CORS preflight
//     'Access-Control-Allow-Origin': 'https://flutterflow.io', // Specify the allowed origin
// }

// async function handleRequest(request) {
//     if (request.method === "OPTIONS") {
//         // Respond to the CORS preflight request
//         return new Response("OK", {
//             headers: corsHeaders
//         });
//     } else if (request.method === 'GET') {
//         // Handle GET request, return the country
//         const country = request.headers.get('CF-IPCountry');
//         return new Response(JSON.stringify({ country: country, }), {
//             headers: {
//                 'Content-Type': 'application/json',
//                 ...corsHeaders
//             }
//         });
//     } else {
//         // Return method not allowed for other types of requests
//         return new Response("Method not allowed", {
//             status: 405,
//             headers: corsHeaders
//         });
//     }
// }
