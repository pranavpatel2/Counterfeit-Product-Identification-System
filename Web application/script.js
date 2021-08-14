
const encrypt = (text) => {
  return CryptoJS.enc.Base64.stringify(CryptoJS.enc.Utf8.parse(text));
};

const decrypt = (data) => {
  return CryptoJS.enc.Base64.parse(data).toString(CryptoJS.enc.Utf8);
};

var QR_CODE = new QRCode("qrcode", {
  width: 220,
  height: 220,
  colorDark: "#000000",
  colorLight: "#ffffff",
  correctLevel: QRCode.CorrectLevel.H,
});


async function loadWeb3() {
  if (window.ethereum) {

    window.web3 = new Web3(window.ethereum)
    await window.ethereum.enable();
  }
  else if (window.web3) {
    window.web3 = new Web3(window.web3.currentProvider);

  } else {
    window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!');
  }
}
async function loadContract() {
  var address="0xaC911d37C3773FE21757677B7B687044a3feF1bc";
  var abi=[
    {
      "constant": true,
      "inputs": [
        {
          "name": "code",
          "type": "string"
        }
      ],
      "name": "getProductDetails",
      "outputs": [
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "code",
          "type": "string"
        },
        {
          "name": "brand",
          "type": "string"
        },
        {
          "name": "model",
          "type": "string"
        },
        {
          "name": "description",
          "type": "string"
        },
        {
          "name": "manufactuerName",
          "type": "string"
        },
        {
          "name": "manufactuerLocation",
          "type": "string"
        },
        {
          "name": "manufactuerTimestamp",
          "type": "string"
        },
        {
          "name": "productOwner",
          "type": "string"
        }
      ],
      "name": "addProduct",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "name",
          "type": "string"
        },
        {
          "name": "email",
          "type": "string"
        }
      ],
      "name": "addCustomer",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "code",
          "type": "string"
        }
      ],
      "name": "getOwner",
      "outputs": [
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "email",
          "type": "string"
        }
      ],
      "name": "getCustomer",
      "outputs": [
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "name",
          "type": "string"
        },
        {
          "name": "company_address",
          "type": "string"
        },
        {
          "name": "email",
          "type": "string"
        }
      ],
      "name": "addCompany",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "email",
          "type": "string"
        }
      ],
      "name": "getCompany",
      "outputs": [
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "code",
          "type": "string"
        },
        {
          "name": "email",
          "type": "string"
        }
      ],
      "name": "changeOwner",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "name",
          "type": "string"
        },
        {
          "name": "retailer_address",
          "type": "string"
        },
        {
          "name": "email",
          "type": "string"
        }
      ],
      "name": "addRetailer",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "email",
          "type": "string"
        }
      ],
      "name": "getRetailer",
      "outputs": [
        {
          "name": "",
          "type": "string"
        },
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    }
  ];
  return await new window.web3.eth.Contract(abi,address);
}

async function getCurrentAccount() {
  const accounts = await window.web3.eth.getAccounts();
  return accounts[0];
}

var firebaseConfig = {
  apiKey: "AIzaSyBxbtzxzf3BxO6vPijJT5Xa5PsbpDy06CA",
  authDomain: "fakeproduct-fbccb.firebaseapp.com",
  projectId: "fakeproduct-fbccb",
  storageBucket: "fakeproduct-fbccb.appspot.com",
  messagingSenderId: "841251853609",
  appId: "1:841251853609:web:87a28a9f507f343628d338"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
var auth =firebase.auth();
 var database = firebase.database();

  function signup()
  {
    var email = document.getElementById('email').value
    var password = document.getElementById('password').value

    const promise = auth.createUserWithEmailAndPassword(email, password)
    .then((userCredential) => {
     
      var user = userCredential.user;
      console.log("signup");
    
    })
    .catch((error) => {
      var errorCode = error.code;
      var errorMessage = error.message;
  
    });
  }
  const user=auth.currentUser;
  if (user !== null) {
    // The user object has basic properties such as display name, email, etc.
    const displayName = user.displayName;
    const email = user.email;
    const photoURL = user.photoURL;
    const emailVerified = user.emailVerified;
  
    // The user's ID, unique to the Firebase project. Do NOT use
    // this value to authenticate with your backend server, if
    // you have one. Use User.getToken() instead.
    const uid = user.uid;
  }
  else

  function login()
  {
    var email = document.getElementById('email').value
    var password = document.getElementById('password').value

    const promise = auth.signInWithEmailAndPassword(email, password)
    .then((userCredential) => {
      console.log("login");
      document.cookie="yes";
      localStorage.setItem("email", email);
      var user = userCredential.user;
      // ...
    })
    .catch((error) => {
      var errorCode = error.code;
      var errorMessage = error.message;
    });
  }
  function save() {

    var email = document.getElementById('email').value
    var password = document.getElementById('password').value
  
    database.ref('users/' + email).set({
      email : email,
      password : password,
    })
  
    alert('Saved')
  }
function openpage()
{
  var session = document.cookie;
    console.log(session);
    if(session!=="yes")
      {
        window.alert("Login first");
        return;
      }
  window.location="generateqrcode.html";
}

  async function qrcode()
  { 
    load(); 
    var email=localStorage.getItem("email");
    var  brand = document.getElementById('brand').value;
    var model= document.getElementById('model').value;
    var description= document.getElementById('dis').value;
    var manufactuerName = document.getElementById('mname').value;
    var manufactuerLocation= document.getElementById('address').value;
    let manufacturerTimestamp = new Date().toISOString().slice(0, 10);
   
    let e =encrypt(brand + model + description + manufactuerName + manufactuerLocation)
    QR_CODE.makeCode(e);

    const account = await getCurrentAccount();
    await window.contract.methods.addProduct(e,brand,model,description,manufactuerName,manufactuerLocation,manufacturerTimestamp,email).send({ from: account }); 

  }
  function loginclick()
{
    
    document.getElementById("login").style.display = "block";
    document.getElementById('mainPage').style.opacity = 0.2;
}
function cancelclick()
{
    document.getElementById("login").style.display = "none";
    document.getElementById('mainPage').style.opacity = 1;

}
function userlogin()
{
  document.getElementById("h1").style.display = "none";
  document.getElementById("h2").style.display = "block";
    var email = document.getElementById("email").value;
    var Password = document.getElementById("password").value;
    console.log(email,Password);

    const promise = auth.signInWithEmailAndPassword(email,Password)
    .then((userCredential) => {
      console.log("login");
      document.cookie="yes";
      localStorage.setItem("email", email);
      var user = userCredential.user;
      // ...
    })
    .catch((error) => {
      var errorCode = error.code;
      var errorMessage = error.message;
    });

    document.getElementById("login").style.display = "none";
    document.getElementById('mainPage').style.opacity = 1;
}
function logoutclick()
{
  document.cookie="no";
  localStorage.setItem("email", email);
  document.getElementById("h2").style.display = "none";
  document.getElementById("h1").style.display = "block";
}
  document.getElementById("h2").style.display = "none";

  async function load() {
		await loadWeb3();
		window.contract = await loadContract();     
	}
  function openForm() {
    document.getElementById("myForm").style.display = "block";
  }
  
  function closeForm() {
    document.getElementById("myForm").style.display = "none";
  }