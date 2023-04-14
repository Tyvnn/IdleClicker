//alert("This alert box was called with the onload event");

//////////////////Name Popup
var user_name = document.getElementById("name");
document.getElementById("btn-namealert").addEventListener("click", function(){
    var value=user_name.value.trim();
    if(!value)
        alert("Name Cannot be empty!");
    else
        alert("Hello, " + value + "!\n");
});
/////////////////////Math - button
document.getElementById("addbutton").addEventListener("click", add)
document.getElementById("subtractbutton").addEventListener("click", subtract)
document.getElementById("multiplybutton").addEventListener("click", multiply)
document.getElementById("dividebutton").addEventListener("click", divide)
/////////////////////Math - functions
//Add
function add(){
    let num1 = document.getElementById("intNum1").valueAsNumber;
    let num2 = document.getElementById("intNum2").valueAsNumber;
    let res = num1 + num2
    document.getElementById('calculationTotal').innerHTML = res;
};
//Subtract
function subtract() {
    let num1 = document.getElementById("intNum1").valueAsNumber;
    let num2 = document.getElementById("intNum2").valueAsNumber;
    let res = num1 - num2;  
    document.getElementById('calculationTotal').innerHTML = res;
};
//Multiply
function multiply() {
    let num1 = document.getElementById("intNum1").valueAsNumber;
    let num2 = document.getElementById("intNum2").valueAsNumber;
    let res = num1 * num2;
    document.getElementById('calculationTotal').innerHTML = res;              
};
//Divide
function divide() {
    let num1 = document.getElementById("intNum1").valueAsNumber;
    let num2 = document.getElementById("intNum2").valueAsNumber;
    let res = num1 / num2;
    document.getElementById('calculationTotal').innerHTML = res;  
};
///Add hobby

// document.getElementById("hobbybutton").addEventListener("click", function(){
//     var newhobbytxt = document.getElementById("hobbyinputbox").value;
//     var hobbynode = document.createElement("li");
//     var textnode = document.createTextNode(newhobbytxt);
//     var listNode = document.getElementById('myList');
//     hobbynode.appendChild(textnode);
//     listNode.appendChild(hobbynode);
// });

document.getElementById("hobbybutton").addEventListener("click", function(){
    var hobby = document.getElementById("hobbyinputbox").value;
    const node = document.createElement("li");
    const textnode = document.createTextNode(hobby);
    //const textnode = "text"
    node.appendChild(textnode);
    document.getElementById("myList").appendChild(node);
});