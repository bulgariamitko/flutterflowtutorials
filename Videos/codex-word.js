// code created by https://www.youtube.com/@flutterflowexpert
// video -
// support my work - https://github.com/sponsors/bulgariamitko

$("#run").click(() => tryCatch(run));
async function run() {
    await Word.run(async (context) => {
        var body = context.document.body;
        var options = Word.SearchOptions.newObject(context);
        options.matchCase = false;
        var symbols = [".", ",", "?", "!", "…", ";", ":"];
        var letters = ["А", "Б", "В", "Г", "Д", "Е", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ь", "Ю", "Я"];
        for (let i = 0; i < symbols.length; i++) {
            for (let y = 0; y < letters.length; y++) {
                var addSpace = context.document.body.search(symbols[i] + letters[y], options);
                context.load(addSpace, "text");
                await context.sync();
                if (addSpace.items.length > 0) {
                    console.log("addSpace: ", addSpace);
                    for (var x = 0; x < addSpace.items.length; x++) {
                        let text = addSpace.items[x].text;
                        let onlyLetter = text.replace(symbols[i], "");
                        onlyLetter = onlyLetter.replace(/\s+/, "");
                        addSpace.items[x].insertText(symbols[i] + " " + onlyLetter, "Replace");
                        console.log(x + " addSpace " + addSpace.items[x].text + " REPLACED " + symbols[i] + " " + onlyLetter);
                        await context.sync();
                    }
                }
                var removeSpace = context.document.body.search(letters[y] + " " + symbols[i]);
                context.load(removeSpace, "text");
                await context.sync();
                if (removeSpace.items.length > 0) {
                    console.log("removeSpace: ", removeSpace);
                    for (var z = 0; z < removeSpace.items.length; z++) {
                        let text = removeSpace.items[z].text;
                        let onlyLetter2 = text.replace(symbols[i], "");
                        onlyLetter2 = onlyLetter2.replace(/\s+/, "");
                        removeSpace.items[z].insertText(onlyLetter2 + symbols[i], "Replace");
                        console.log(z + " removeSpace " + removeSpace.items[z].text + " REPLACED " + onlyLetter2 + symbols[i]);
                    }
                }
            }
        }
        await context.sync();
    });
} /** Default helper for invoking an action and handling errors. */
async function tryCatch(callback) {
    try {
        await callback();
    } catch (error) {
        console.error(error);
    }
}
