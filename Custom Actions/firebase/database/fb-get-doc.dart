// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=HtvtwLmaI0w
// widgets - Cg9Db2x1bW5faTEyYXd6dWESWgoNVGV4dF9iZ2U5cGowOBgCIkUSJwoLSGVsbG8gV29ybGQRAAAAAAAANkBABnoKEgh3NjQxOGtzMagBAJoBFgoCAgEqEAgMQgwiCgoGCgRuYW1lEAH6AwBiABKnAQoNVGV4dF92cDBzZGYxMxgCIlMSHgoLSGVsbG8gV29ybGRABnoKEghxcHhpd3VybqgBAJoBKAoCAgEqIggEEg1UZXh0X3ZwMHNkZjEzQgISAEoLggEICgYKBG5hbWX6AwDyBAIKAFI9CgwQBxoGCgRjYXJzIAAaLQoGCgRjYXJzGiMIAxIRU2NhZmZvbGRfaDA2OGY3YjhCDDIKCggKBmRvY1JlZmIAGAQiBSIA+gMA
// replace - [{"Collection name": "Cars"}]
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

// IMPORTANT you no longer need to use this custom code, more info - https://www.youtube.com/watch?v=yGggMqY0peY

Future<CarsRecord> getDoc(DocumentReference docRef) async {
  return CarsRecord.getDocumentOnce(docRef);
}
