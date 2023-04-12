function setDarkMode(enabled) {
  if (enabled) {
    $('body, footer').addClass('bg-dark text-white');
    $('.navbar').addClass('navbar-dark bg-dark');
    $('#modeToggle .fa-sun').addClass('d-none');
    $('#modeToggle .fa-moon').removeClass('d-none');
    $('.modal-content').addClass('bg-dark text-white');
  } else {
    $('body, footer').removeClass('bg-dark text-white');
    $('.navbar').removeClass('navbar-dark bg-dark');
    $('#modeToggle .fa-sun').removeClass('d-none');
    $('#modeToggle .fa-moon').addClass('d-none');
    $('.modal-content').removeClass('bg-dark text-white');
  }
}

// Function to filter videos by folder
function filterVideosByFolder(folder) {
  const allVideos = document.querySelectorAll('.video');
  allVideos.forEach((video) => {
    if (video.dataset.folder === folder) {
      video.style.display = 'block';
    } else {
      video.style.display = 'none';
    }
  });
}

async function getFileContent(url) {
  try {
    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const content = await response.text();
    return content;
  } catch (error) {
    console.error('Error fetching file content:', error);
    return null;
  }
}

$(document).ready(function() {
  let darkModeEnabled = localStorage.getItem('darkMode') === 'true' ? true : false;

  setDarkMode(darkModeEnabled);

  $('#modeToggle').on('click', function() {
    darkModeEnabled = !darkModeEnabled;
    localStorage.setItem('darkMode', darkModeEnabled);
    setDarkMode(darkModeEnabled);
  });

  fetch('gh-pages/data/data.json')
    .then((response) => response.json())
    .then((data) => {
      const folderData = data.reduce((acc, item) => {
        if (!acc[item.folder]) {
          acc[item.folder] = [];
        }
        acc[item.folder].push(item);
        return acc;
      }, {});

      const navItems = document.getElementById('navbar-items');

      const uniqueFolders = [...new Set(Object.keys(folderData))];

      const dropdownItems = uniqueFolders
        .map((folder) => `<li><a class="dropdown-item folder-item" href="#" target="_blank">${folder}</a></li>`)
        .join('');

      const dropdown = `<li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Folders
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            ${dropdownItems}
          </ul>
        </li>`;
      navItems.insertAdjacentHTML('beforeend', dropdown);

      // Add event listener to the folder items
      const folderItems = document.querySelectorAll('.folder-item');
      folderItems.forEach((item) => {
        item.addEventListener('click', (event) => {
          event.preventDefault(); // Prevent default behavior
          const selectedFolder = event.target.textContent;
          filterVideosByFolder(selectedFolder);
        });
      });
    });

  const searchInput = document.querySelector('.fake-input');
  const searchResults = document.getElementById('searchResults');

  searchInput.addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase();

    fetch('gh-pages/data/data.json')
      .then((response) => response.json())
      .then((data) => {
        const filteredData = data.filter((item) => item.title.toLowerCase().includes(query));
        const filteredIds = filteredData.map((item) => item.id);

        $("#tutorials .video").each(function () {
          const currentId = parseInt($(this).attr("data-id"));
          const shouldShow = filteredIds.includes(currentId);
          $(this).toggle(shouldShow);
        });

        if (query === '') {
          $("#tutorials .video").show();
        }
      });
  });

  $.getJSON('gh-pages/data/data.json', async function(data) {
    $.each(data, async function(index, video) {
      const baseUrl = 'https://github.com/bulgariamitko/flutterflowtutorials/blob/main/';
      const localFilePath = video.file_path.replace(baseUrl, '');
      const fileName = video.file_path.split('/').pop();
      let copyWidgetsButton = '';

      if (video.widgets && video.widgets.length > 0) {
        copyWidgetsButton = `<button class="btn btn-primary copy-widgets" data-widgets='${video.widgets}'>2. Copy All Widgets</button>`;
      }

      var videoElement = `
        <div class="video col-lg-6 col-md-8 col-sm-10 my-5" data-id="${video.id}" data-folder="${video.folder}">
          <h4 class="m-3 text-center">${video.title}</h4>
          <div class="embed-responsive embed-responsive-16by9">
            <iframe class="w-100 embed-responsive-item" src="${video.embed}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
          </div>
          <p class="mt-2 text-center">
            <span class="d-block">${fileName}</span>
            <button class="btn btn-primary show-dart-code" data-filename='${fileName}' data-localpath='${localFilePath}' data-replace='${JSON.stringify(video.replace)}'>1. Get Code</button>
            ${copyWidgetsButton}
          </p>
        </div>
      `;
      $("#tutorials").append(videoElement);
    });
  });

  // Add click event handler for copy widgets buttons
  $('.copy-widgets').on('click', function() {
    // const widgetsData = $(this).attr('data-widgets');
    let widgetsData = $(this).attr('data-widgets');

    // Fallback: Use textarea to copy widgets data to clipboard
    const textarea = $('<textarea></textarea>');
    textarea.val(widgetsData);
    $('body').append(textarea);
    textarea.select();

    try {
      const successful = document.execCommand('copy');
      if (successful) {
        console.log('Widgets data copied to clipboard');
        $(this).removeClass('btn-primary').addClass('btn-success').text('Copied!');
      } else {
        console.error('Failed to copy widgets data');
      }
    } catch (err) {
      console.error('Failed to copy widgets data: ', err);
    }

    textarea.remove();
  });

  // Add click event handler for show-dart-code buttons
  $('.show-dart-code').on('click', async function() {
    const fileName = $(this).data('filename');
    const localFilePath = $(this).data('localpath');
    const replace = $(this).data('replace');
    const dartCodeModal = new bootstrap.Modal(document.getElementById('dartCodeModal'), {});
    const code = await getFileContent(localFilePath);
    // let codeWithoutComments = code.split('\n').filter(line => !line.trim().startsWith('//')).join('\n');

    let initialCodeWithoutComments = code.split('\n').filter(line => !line.trim().startsWith('//')).join('\n');
		let codeWithoutComments = initialCodeWithoutComments;


    // Set the modal title to the fileName
    $('#dartCodeModalLabel').text(fileName);

    // Create input fields for each replace item
    const inputFieldsContainer = $('#input-fields-container');
    inputFieldsContainer.empty();

    // Create a Map to store the original and new values for each input field
    const valueMap = new Map();

    replace.forEach((item, index) => {
      const key = Object.keys(item)[0];
      const value = item[key];

      console.log([key, value]);

      const label = $('<label>').text(key);
      const input = $('<input>').attr('type', 'text').attr('data-index', index).addClass('form-control mb-2');
      input.val(value);

      inputFieldsContainer.append(label).append(input);


      input.on('input', function () {
        const newValue = $(this).val();
        let capitalizedValue = newValue;

        // Check if the original "value" has a capital letter as the first character
        if (value.charAt(0) === value.charAt(0).toUpperCase()) {
          capitalizedValue = newValue.charAt(0).toUpperCase() + newValue.slice(1);
        }

        const initialPlaceholder = `${value}`;
        const newPlaceholder = `${capitalizedValue}`;

        // Update the input value with the capitalized value
        $(this).val(capitalizedValue);

        // Update the valueMap with the new value
        valueMap.set(initialPlaceholder, newPlaceholder);

        // Replace the placeholders in the code based on the valueMap
        let updatedCode = initialCodeWithoutComments;
        for (const [originalValue, replacedValue] of valueMap.entries()) {
          updatedCode = updatedCode.split(originalValue).join(replacedValue);
        }

        $('#code').text(updatedCode);
      });
    });

    $('#code').text(codeWithoutComments);

    dartCodeModal.show();
  });

  $('#copy-code, #copy-code-header').on('click', function() {
	  const codeElement = document.getElementById('code');
	  const selection = window.getSelection();
	  const range = document.createRange();

	  range.selectNodeContents(codeElement);
	  selection.removeAllRanges();
	  selection.addRange(range);

	  try {
	  	$(this).removeClass('btn-primary').addClass('btn-success').text('Copied!');
	    const successful = document.execCommand('copy');
	    const message = successful ? 'successful' : 'unsuccessful';
	    console.log(`Copy command was ${message}`);
	  } catch (err) {
	    console.error('Error copying to clipboard:', err);
	  }

	  selection.removeAllRanges();
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
