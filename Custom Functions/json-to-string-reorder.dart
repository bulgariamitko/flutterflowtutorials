// code created by https://www.youtube.com/@flutterflowexpert
// future video - https://youtu.be/K-Xbub484lA
// widgets - Cg9Db2x1bW5fNmxmcjk3aHESvwEKEkNvbnRhaW5lcl85bmI5cndhZRgBIgP6AwBikAESPgoKZGltZW5zaW9ucxIwChQKCmRpbWVuc2lvbnMSBnQyZHI5ZTIYIhYKCREAAAAAAABZQBIJEQAAAAAAAFRAEkEKBGxpc3QSOQoOCgRsaXN0EgY1Yms1czgiJwgEEhFTY2FmZm9sZF9zaWtqY3IxdEICEgBKDIIBCQoHCgVvcmRlchoLUmVvcmRlckxpc3SCAQtSZW9yZGVyTGlzdJgBARKwAgoPQnV0dG9uX3hqZmV3bWZsGAkiZkphChYKClNhdmUgb3JkZXI6Bgj/////D0AFKQAAAAAAQGBAMQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQPoDAGIAigGvARKoAQoIOGpoZHlvcTMSmwEijQESigESZgpkCgVvcmRlchJbCgcKBW9yZGVyKlAIBRpMCgcKBW9yZGVyMkEIClI9EhgSFggMQhIiEAoMCgpjaXRpZXNKc29uEAEaIQoYY3JlYXRlU3RyaW5nTGlzdEZyb21Kc29uEgV6NmNnZRogCAQSEVNjYWZmb2xkX3Npa2pjcjF0QgISAEoFggECEAGqAggzNXl1NmplbBoCCAES/AEKD0J1dHRvbl9mMHZ5eXNyaRgJIm1KaAodChFTYXZlIHRvIEFwcCBTdGF0ZToGCP////8PQAUpAAAAAABAYEAxAAAAAAAAREBJAAAAAAAA8D9SAhABWgIIAHIkCQAAAAAAACBAEQAAAAAAACBAGQAAAAAAACBAIQAAAAAAACBA+gMAYgCKAXUSbwoIcnRqOGQxcnMSY+IBVUJPCggKBmNpdGllcxJDEkEIClI9EhgSFggMQhIiEAoMCgpjaXRpZXNKc29uEAEaIQoYY3JlYXRlU3RyaW5nTGlzdEZyb21Kc29uEgV6NmNnZVACWAGqAghzMHkzMHBtbhoCCAEYBCIFIgD6AwA=
// support my work - https://github.com/sponsors/bulgariamitko

List<String>? createStringListFromJson(List<dynamic> cityJsonList) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  List<String> resultList =
      List<String>.filled(cityJsonList.length, '', growable: false);

  for (Map<String, int> cityJson in cityJsonList) {
    cityJson.forEach((city, index) {
      if (index >= 0 && index < cityJsonList.length) {
        resultList[index] = city;
      }
    });
  }

  return resultList;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}