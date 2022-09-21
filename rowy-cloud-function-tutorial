const extensionBody: TaskBody = async({row, db, change, ref}) => {
  const { FieldValue } = require ("@google-cloud/firestore");
  var fsCounterCollection = db.collection('fs_counters').doc('ecUzLabKtMqYb7U0MXEj')
  const res = await fsCounterCollection.update({
    value: FieldValue.increment(1),
  });
}
