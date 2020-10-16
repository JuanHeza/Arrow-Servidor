var pixelID = 0;
var newSerie = false;
var framePixel;
var count = 0;
var prevSerie;
var colors = [];

//function setColors(input){
window.setColors = function (input) {
  colors = input;
  console.log(colors);
};

//function Animate(){
window.Animate = function () {
  var pixels = document.getElementsByClassName("pixel");
  pixels[0].style.backgroundColor = colors[count][0];
  pixels[1].style.backgroundColor = colors[count][1];
  pixels[2].style.backgroundColor = colors[count][2];
  pixels[3].style.backgroundColor = colors[count][3];
  count = (count + 1) % colors.length;
};

// function CustomColors() {
window.CustomColors = function () {
  document.getElementById("toggle").style.display = "block";
  document.getElementById("NewSerie").style.display = "none";
  document.getElementById("NewEvent").style.display = "none";
    document.getElementById("newSerieButton").innerHTML = "Nueva Serie"
    document.getElementById("newEventButton").innerHTML = "Nuevo Evento"
    document.getElementById("Dashboard").style.display = "block";
  newSerie = false;
  var pixels = document.getElementsByClassName("pixel");
  for (var j = 0; j < pixels.length; j++) {
    pixels[j].disabled = !pixels[j].disabled;
  }
  var colorsDiv = document.getElementById("colors");
  var toggle = document.getElementById("toggle");
  if (colorsDiv.style.display === "none") {
    colorsDiv.style.display = "grid";
    toggle.innerHTML = "Aceptar";
    prevSerie = colors;
    colors = [["#000000", "#000000", "#000000", "#000000"]];
    count = 0;
  } else {
    colorsDiv.style.display = "none";
    toggle.innerHTML = "Custom Serie";
    pixelID = 0;
    prevSerie = colors;
    console.log(JSON.stringify({ serie: colors }));
    $.ajax({
      type: "POST",
      url: "/Serie/Custom",
      data: JSON.stringify(JSON.stringify({ secuencia: colors })),
      contentType: "application/json; charset=utf-8",
      dataType: "json",
    });
    setInterval("location.reload()", 50);
  }
};

// function Pixel(id) {
window.Pixel = function (id) {
  pixelID = id;
  newSerie = false;
};

// function PixelColor(color) {
window.PixelColor = function (color) {
  console.log(newSerie, "||", pixelID, "||", framePixel);
  if (newSerie == false) {
    if (pixelID == 0) {
      alert(
        "Por favor seleccione alguna de las 4 luces y posteriormente un color"
      );
    } else {
      console.log(colors);
      colors[0][pixelID - 1] = color;
      console.log(colors);
    }
  } else {
    document.getElementById("colors").style.display = "none";
    framePixel.style.backgroundColor = color;
    framePixel.children[0].value = color;
    framePixel = null;
  }
};

// function ShowMenu(block) {
window.ShowMenu = function (block) {
  newSerie = true;
  document.getElementById("colors").style.display = "grid";
  block.style.backgroundColor = block.children[0].value;
  framePixel = block;
  console.log(block, block.children);
};

// function addFrame() {
window.addFrame = function () {
  if (document.getElementById("frames").childElementCount < 13) {
    var frame = document.getElementById("frame");
    var newFrame = frame.cloneNode(true);
    var pixels = newFrame.children;
    for (var i = 0; i < pixels.length; i++) {
      var pixel_Div = pixels[i];
      var hidden_Input = pixels[i].children[0];
      pixel_Div.style.backgroundColor = "#000000";
      hidden_Input.value = "#000000";
    }
    $(document.getElementById("frames")).append(newFrame);
  } else {
    alert("Se alcanzo el limite de Frames");
  }
  console.log(newFrame);
  console.log(pixels);
};

window.NewSerie = function () {
  document.getElementById("colors").style.display = "none";
  document.getElementById("NewEvent").style.display = "none";
  document.getElementById("Dashboard").style.display = "none";
  document.getElementById("toggle").innerHTML = "Custom Serie";
  if (document.getElementById("NewSerie").style.display != "block") {
    document.getElementById("NewSerie").style.display = "block";
    document.getElementById("newSerieButton").innerHTML = "Cancelar"
  }else{
    document.getElementById("NewSerie").style.display = "none";
    document.getElementById("Dashboard").style.display = "block";
    document.getElementById("newSerieButton").innerHTML = "Nueva Serie"
    document.getElementById("SerieForm").reset();
    document.getElementById("EventForm").reset();
  }
  colors = prevSerie;
};

window.NewEvent = function () {
  document.getElementById("colors").style.display = "none";
  document.getElementById("NewSerie").style.display = "none";
  document.getElementById("Dashboard").style.display = "none";
  document.getElementById("toggle").innerHTML = "Custom Serie";
  if (document.getElementById("NewEvent").style.display != "block") {
    document.getElementById("NewEvent").style.display = "block";
    document.getElementById("newEventButton").innerHTML = "Cancelar"
  }else{
    document.getElementById("NewEvent").style.display = "none";
    document.getElementById("Dashboard").style.display = "block";
    document.getElementById("newEventButton").innerHTML = "Nuevo Evento"
    document.getElementById("SerieForm").reset();
    document.getElementById("EventForm").reset();
  }
  colors = prevSerie;
};

window.show_users = function () {
  console.log(document.getElementById("notificar_espec").checked);
  if (document.getElementById("notificar_espec").checked) {
    document.getElementById("usersRow").style.display = "block";
  } else {
    document.getElementById("usersRow").style.display = "none";
  }
};
