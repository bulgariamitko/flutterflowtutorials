$(document).ready(function() {
	$.getJSON('gh-pages/data/data.json', function(data) {
        $.each(data, function(index, video) {
          var videoElement = `
            <div class="col-lg-4 col-md-6 col-sm-12 mb-4">
              <h4 class="m-3 text-center">${video.title}</h4>
              <div class="embed-responsive embed-responsive-16by9">
                <iframe class="embed-responsive-item" src="${video.url}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
              </div>
              <p class="mt-2 text-center">
                <button class="btn btn-primary">Copy all widgets from the video</button>
              </p>
            </div>
          `;
          $("#tutorials").append(videoElement);
        });
      });

	$("#copy-text-btn").click(function() {
	  var textToCopy = $("#text-to-copy");
	  textToCopy.focus();
	  textToCopy.select();
	  document.execCommand("copy");

	  // Change the text and background color
	  let copyBtn = $('#copy-text-btn');
	  copyBtn.addClass("copied");
	  var originalText = copyBtn.text();
	  copyBtn.text("Copied!");

	  // Reset the text and background color after 5 seconds
	  setTimeout(function() {
	    copyBtn.removeClass("copied");
	    copyBtn.text(originalText);
	  }, 5000);
	});
});
