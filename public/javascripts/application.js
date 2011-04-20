function logout_click(){
  //alert("logout11");
  FB.getLoginStatus(function(response) {
    //alert("sssss   cccccccccc :  " + response.session );
    if (response.session) {
      // logged in and connected user, someone you know
      FB.logout(function(response) {
        // user is now logged out
      });
    } else {
      // no user session available, someone you dont know
    }

  });
  window.location = "/logout";
}
