// YouTube channel - https://www.youtube.com/@dimitarklaturov
// video - no
// Join the Klaturov army - https://www.youtube.com/@dimitarklaturov/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/G69hSUqEeU

Future<void> supabaseRealtime(
  String table,
  Future Function() callbackAction,
) async {
  await SupaFlow.client.channel('public:$table').unsubscribe();

  SupaFlow.client
      .channel('public:$table')
      .on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: "INSERT", schema: 'public', table: table),
        (payload, [ref]) => callbackAction(),
      )
      .on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: "DELETE", schema: 'public', table: table),
        (payload, [ref]) => callbackAction(),
      )
      .on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: "UPDATE", schema: 'public', table: table),
        (payload, [ref]) => callbackAction(),
      )
      .on(
        RealtimeListenTypes.postgresChanges,
        ChannelFilter(event: "TRUNCATE", schema: 'public', table: table),
        (payload, [ref]) => callbackAction(),
      )
      .subscribe();
}
