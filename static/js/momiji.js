/*
* Misc Functions
*/

function dec2hex (dec) {
  return dec.toString(16).padStart(2, "0")
}

function randomString (len) {
  var arr = new Int16Array((len || 40) / 4)
  window.crypto.getRandomValues(arr)
  return Array.from(arr, dec2hex).join('')
}

let delkey = document.cookie.delkey || randomString(32);

/*
* Options Field
* TODO: <noscript> version. Also everything else
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
    shadowName2.style.visibility = "visible"
  });

  v.addEventListener('blur', e => {
    shadowName2.style.visibility = "hidden"
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