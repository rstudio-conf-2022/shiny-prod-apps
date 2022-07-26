/*https://cloudinary.com/blog/cool_tricks_for_resizing_images_in_javascript */
shinyjs.zoomin = function() {
  var myImg = document.getElementById("imgid");
  var currWidth = myImg.clientWidth;
  console.log('image width before zoomin is ' + currWidth);
  if(currWidth >= 10000){
      alert("You’re fully zoomed in!");
  } else{
      myImg.style.width = (currWidth + 100) + "px";
      var nextWidth = myImg.clientWidth;
      console.log('image width after zoomin is ' + nextWidth);
  } 
}

shinyjs.zoomout = function() {
  var myImg = document.getElementById("imgid");
  var currWidth = myImg.clientWidth;
  console.log('image width before zoomin is ' + currWidth);
  if(currWidth <= 20){
      alert("That’s as small as it gets.");
  } else{
      myImg.style.width = (currWidth - 100) + "px";
      var nextWidth = myImg.clientWidth;
      console.log('image width after zoomin is ' + nextWidth);
  }
}
