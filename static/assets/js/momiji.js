/*
* Misc Utility Functions
*/

function setCookie(key, value) {
  document.cookie = `${key.replaceAll(/[^a-z0-9_\-]+/ig, '')}=${encodeURIComponent(value)};`
}

function getCookie(re) {
  let matched = document.cookie.match(re);
  return matched && matched[1] ? decodeURIComponent(matched[1]) : undefined
}

function getCookieRegExp(key, flags) {
  return new RegExp(`${key.replaceAll(/[^a-z0-9_\-]+/ig, '')}=([^;]+)`, flags)
}

function randomString(len) {
  var arr = new Int16Array((len || 40) / 4);
  window.crypto.getRandomValues(arr);
  return Array.from(arr, dec => dec.toString(16).padStart(2, "0")).join('-')
}

let delkey = document.cookie.match(/delkey=([^;]+)/);
delkey = delkey ? delkey[1] : randomString(32);
document.querySelectorAll('input[name=delpass]').forEach(elem => elem.value = delkey);

/*
* Built-in Stylesheet Stuff
*/

const stylesheetCookieKey = 'momijistyle'
const stylesheetCookieRegExp = getCookieRegExp(stylesheetCookieKey, 'i');
const styleSelect = document.querySelector('select[name=styleselect]');

function getStylesheet() {
  return getCookie(stylesheetCookieRegExp) || defaultStyle
}

function setStylesheet(title, e) {
  // Not sure if this is any worse than setting the name attr and using
  // styleSelect.namedItem(title).setAttr... performance or best-practices wise...
  styleSelect.querySelector(`option[value="${title}"]`).setAttribute('selected', true);
  setCookie(stylesheetCookieKey, title);
  
  document.querySelectorAll('link[title]').forEach(v => { 
    v.setAttribute('rel', 'alternate stylesheet');
    v.setAttribute('disabled', true);
    v.removeAttribute('enabled')
  });

  let newStylesheetLink = document.querySelector(`link[title="${title}"]`);
  newStylesheetLink.setAttribute('rel', 'stylesheet');
  newStylesheetLink.setAttribute('enabled', true);
  newStylesheetLink.removeAttribute('disabled')
}

window.addEventListener('load', e => setStylesheet(getStylesheet(), styleSelect, e));
styleSelect.addEventListener('change', e => setStylesheet(e.currentTarget.selectedOptions[0].innerHTML, e.currentTarget, e));

/*
* Password Field
*/

let passwordControl = document.querySelectorAll("form.post-form span.password-control");

passwordControl.forEach(v => {
  let passMask = v.querySelector('input[name=delmask]');
  let passInput = v.querySelector('input[name=delpass]');

  passMask.addEventListener('change', e => {
    passMask.checked
      ? passInput.setAttribute('type', 'text')
      : passInput.setAttribute('type', 'password')
  })
});

/*
* Options Field
* TODO: <noscript> version. Also everything else
* What about an expiration option where a thread closes or deletes itself after some amount of time?
* And post premeires are a pretty new concept
* Why not threads with live streams as OP file/media
*/

let optionSelect = document.querySelectorAll('form.post-form input[name="options"]');

optionSelect.forEach(v => {

});

/*
* Trip Code Auto-Suggestions/Generator
* TODO: Handle esc and tab keypress events
*/

let nameFields = document.querySelectorAll('form input[name="name"]');
let tripSugValue = randomString(32);
let tripSugDisplay = tripSugValue.substring(0, 10) + ' ...';

nameFields.forEach(v => {
  let sizedName = v.parentElement.querySelector('div.scratch');
  let shadowName = v.parentElement.querySelector('input[name="namesugs"]');
  let shadowName2 = v.parentElement.querySelector('input[name="namesugs2"]');

  v.addEventListener('focus', e => {
    v.style.backgroundColor = "transparent";
    shadowName.style.visibility = "visible";
    shadowName2.style.visibility = "visible"
  });

  v.addEventListener('blur', e => {
    v.style.backgroundColor = "#fff";
    shadowName2.style.visibility = "hidden";
    shadowName.style.visibility = "hidden"
  });

  v.addEventListener('input', e => {    
    if(!v.value.length) {
      shadowName.placeholder = "";
      shadowName2.placeholder = ""
    }
    else {
      sizedName.innerHTML = v.value;
      shadowName.style.textIndent = sizedName.clientWidth + 1 + "px";
      shadowName2.placeholder = "⇧⏎";

      if(v.value.indexOf("##") === -1) {
        if(v.value.lastIndexOf("#") === v.value.length - 1) {
          shadowName.placeholder = "#" + tripSugDisplay
        }
        else {
          shadowName.placeholder = "##" + tripSugDisplay
        }
      }
      else if(v.value.indexOf("##") === v.value.length - 2) {
        shadowName.placeholder = tripSugDisplay
      }
      else {
        shadowName.placeholder = "";
        shadowName2.placeholder = ""
      }
    }
  })
});

/*
* Media Viewer
* 16:9 screens have enough room for a portrait-mode live feed on the left or right side of the page
* Think dev tools open
*/

function togglePlayback(media, e) {
  media.paused ? media.play() : media.pause()
}

function toggleResizeText(resizePane) {
  let toggleText = resizePane.dataset.toggleText;
  resizePane.dataset.toggleText = resizePane.innerHTML;
  resizePane.innerHTML = toggleText
}

let sitePane = document.querySelector('div.site-pane');
let mediaPane = document.querySelector('div.media-pane');
let media = mediaPane.querySelector('video');
let mediaMeta = mediaPane.querySelectorAll('div.media-header, div.media-foot');
let resizePane = mediaMeta[0].querySelector('a.pane-toggle');
let openMedia = document.querySelector('a.pane-toggle-fixed');

let mediaMetaTimeout = false;

mediaPane.addEventListener('mouseenter', e => {
  if(mediaMetaTimeout)
    clearTimeout(mediaMetaTimeout);

  mediaMeta.forEach(v => v.classList.remove('faded'))
});

mediaPane.addEventListener('mouseleave', e => {
  if(mediaMetaTimeout)
    clearTimeout(mediaMetaTimeout);

  mediaMetaTimeout = setTimeout(c => {
    c.forEach(v => v.classList.add('faded'))
  }, 2000, mediaMeta)
});

resizePane.addEventListener('click', e => {
  toggleResizeText(resizePane);
  mediaPane.classList.toggle('max');
  sitePane.classList.toggle('media-max')
});

openMedia.addEventListener('click', e => {
  sitePane.classList.toggle('media-active');
  mediaPane.classList.toggle('active')
});

if(media) {
  let playButton = mediaPane.querySelector('a.media-play');
  let exitButton = mediaPane.querySelector('a.media-exit');
  let pauseSvg = playButton.innerHTML;

  exitButton.addEventListener('click', e => {
    media.pause();
    
    if(mediaPane.classList.contains('max'))
      toggleResizeText(resizePane);

    sitePane.classList.remove('media-active', 'media-max');
    mediaPane.classList.remove('active', 'max')
  });

  playButton.addEventListener('click', e => togglePlayback(media, e));

  media.addEventListener('pause', e => playButton.innerHTML = "&#9658;");
  media.addEventListener('play', e => playButton.innerHTML = pauseSvg);
  media.addEventListener('click', e => togglePlayback(media, e))
}

/*
* Post Controls
*/

let posts = document.querySelectorAll('div.post');
let commentInputs = document.querySelectorAll('form textarea[name=comment]');

posts.forEach(post => {
  /*
  * Post quoting/linking stuff
  */

  let postLink = post.querySelector('span.post-no a:first-child');
  let postQuote = post.querySelector('span.post-no a:last-child');

  //postLink.addEventListener('click', e => navigator.clipboard.writeText(postLink.href));

  postQuote.addEventListener('click', e => {
    e.preventDefault();
    commentInputs.forEach(textarea => textarea.innerHTML += `&gt;&gt;${postQuote.innerHTML} `)
  });

  /*
  * Quoted post inline/hover
  */

  let quoted = post.querySelectorAll('a.quote-link');

  quoted.forEach(link => {
    link.addEventListener('click', e => {
      e.preventDefault()
    })

    link.addEventListener('mouseenter', e => {
      
    })

    link.addEventListener('mouseleave', e => {
      
    })
  })

  /*
  * Post menu stuff
  */

  let menuToggle = post.querySelector('span.menu-toggle');
  let menu = post.querySelector('div.post-menu');

  menuToggle.addEventListener('click', e => {
    e.preventDefault()
  });

  /*
  * Image/file controls
  */

  let fileThumb = post.querySelector('img.file-thumb');

  if(fileThumb) {
    fileThumb.addEventListener('click', e => {
      e.preventDefault()
    });

    fileThumb.addEventListener('mouseenter', e => {

    });

    fileThumb.addEventListener('mouseleave', e => {

    })
  }
})
