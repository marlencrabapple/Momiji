/*
* Misc Utility Functions
*/

function randomString (len) {
  var arr = new Int16Array((len || 40) / 4);
  window.crypto.getRandomValues(arr);
  return Array.from(arr, dec => dec.toString(16).padStart(2, "0")).join('-')
}

let delkey = document.cookie.delkey || randomString(32);

/*
* Media Viewer
* 16:9 screens have enough room for a portrait-mode live feed on the left or right side of the page
* Think dev tools open
*/

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
      shadowName2.placeholder = "⇧+⇥";

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
* Media Pane
*/

function togglePlayback(media) {
  if(media.paused) {
    media.play()
  }
  else {
    media.pause()
  }
}

let sitePane = document.querySelector('div.site-pane');
let mediaPane = document.querySelector('div.media-pane');
let media = mediaPane.querySelector('video');
let playButton = mediaPane.querySelector('a.media-play');
let exitButton = mediaPane.querySelector('a.media-exit');
let pauseSvg = playButton.innerHTML;

exitButton.addEventListener('click', e => {
  media.pause();
  mediaPane.style.width = "0%"
  mediaPane.style.display = "none";
  sitePane.style.marginLeft = "0px";
  sitePane.style.paddingLeft = "0px";
});

playButton.addEventListener('click', e => togglePlayback(media));

media.addEventListener('pause', e => playButton.innerHTML = "&#9658;");
media.addEventListener('play', e => playButton.innerHTML = pauseSvg);
media.addEventListener('click', e => togglePlayback(media))
