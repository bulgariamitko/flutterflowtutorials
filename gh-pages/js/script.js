function setDarkMode(enabled) {
    if (enabled) {
      $('body').addClass('bg-dark text-white');
      $('.navbar').addClass('navbar-dark bg-dark');
      $('#modeToggle .fa-sun').addClass('d-none');
      $('#modeToggle .fa-moon').removeClass('d-none');
    } else {
      $('body').removeClass('bg-dark text-white');
      $('.navbar').removeClass('navbar-dark bg-dark');
      $('#modeToggle .fa-sun').removeClass('d-none');
      $('#modeToggle .fa-moon').addClass('d-none');
    }
  }

function displayResults(data) {
  searchResults.innerHTML = '';
  data.forEach((item) => {
    const video = document.createElement('div');
    video.innerHTML = `
      <h3>${item.title}</h3>
      <div class="embed-responsive embed-responsive-16by9">
        <iframe class="embed-responsive-item" src="${item.url}" title="${item.title}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
      </div>
    `;
    searchResults.appendChild(video);
  });
}

$(document).ready(function() {
  let darkModeEnabled = localStorage.getItem('darkMode') === 'true' ? true : false;

  setDarkMode(darkModeEnabled);

  $('#modeToggle').on('click', function() {
    darkModeEnabled = !darkModeEnabled;
    localStorage.setItem('darkMode', darkModeEnabled);
    setDarkMode(darkModeEnabled);
  });

  const searchInput = document.querySelector('.fake-input');
	const searchResults = document.getElementById('searchResults');

	searchInput.addEventListener('input', (e) => {
	  const query = e.target.value.toLowerCase();
	  fetch('gh-pages/data/data.json')
	    .then((response) => response.json())
	    .then((data) => {
	      const filteredData = data.filter((item) => item.title.toLowerCase().includes(query));
	      displayResults(filteredData);
	    });
	});

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
