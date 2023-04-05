$("#copy-text-btn").click(function() {
  var textToCopy = $("#text-to-copy");
  textToCopy.focus();
  textToCopy.select();
  document.execCommand("copy");
  alert("Text copied: " + textToCopy.val());
});