$(document).ready(function(){
		// click "Create an account" on the sign in modal
		$("#modal_sign_form .button_desc").find("span").click(function(){
			$("#modal_create_button").trigger("click");
			$("#modal_sign_form .close").trigger("click");
		});
		
		// click "Sign in with Facebook" on the sign in modal
		$("#modal_sign_form .singup_fb").click(function(){	
			window.location = "/auth/facebook";
		});
                
                $('#facebook-connect').click(function(e){
                  e.preventDefault();
                  window.location = "/auth/facebook";
                })
		
		// click "Send a reset email." on the sign in modal
		$("#modal_sign_form .forgot").find("span").click(function(){
			console.log("reset clicked");
			$("#modal_sendemail_button").trigger("click");
			$("#modal_sign_form .close").trigger("click");
		});
		
		// click "Sign in" on the sign up modal
		$("#modal_create_form .button_desc").find("span").click(function(){
			
			$("#modal_sign_button").trigger("click");
			$("#modal_create_form .close").trigger("click");
		});
		
		// click "Sign up with Facebook" on the sign up modal
		$("#modal_create_form .singup_fb").click(function(){
			
			$("#signin_fb_button").trigger("click");
			$("#modal_create_form .close").trigger("click");
		});
		
		// click "Sign in" on the reset password modal
		$("#modal_sendeamil_form .button_desc").find("span").click(function(){
			
			$("#modal_sign_button").trigger("click");
			$("#modal_sendeamil_form .close").trigger("click");
		});
		
		// click "Sign in" on the reset password confirmed modal
		$("#resetpassword_form .button_desc").find("span").click(function(){
			
			$("#modal_sign_button").trigger("click");
			$("#resetpassword_form .close").trigger("click");
		});
		
		// submit the form with ajax when click the "Sign In" button on the sign in modal
		$('#signin').submit(function() { 
			
			// Validation Email
			$email = $(this).find(".email_input");
      if( !validateEmail($email.val())) {
    		// Appear error message
    		showEmailError($(this));
        return false;
      }else{
      	// Hide error message
        hideEmailError($(this));
        
        // ajax
        var valuesToSubmit = $(this).serialize();        
		    $.ajax({
		        url: $(this).attr('action'), //sumbits it to the given url of the form
		        data: valuesToSubmit,
		        dataType: "JSON",
		        success: function(data, status, xhttp)
	          {   
	          	  if (data.status == "success")
	          	  {
	          	  	window.location = data.redirect_to;
	          	  }else if (data.status == "failed")
	          	  {
	          	  	console.log("login failed");
	          	  	showPasswordError($('#signin'));
	          	  }               
	          }
		    });
		    return false; // prevents normal behaviour
      }
		});
		
		// submit the form with ajax when click the "Create Account" button on the sign up modal
		$('#create_account').submit(function() { 
			
	    // Validation Email
			$email = $(this).find(".email_input");		
			$password = $(this).find(".pw_input");
			$confirm_password = $(this).find(".confirm_pw_input");					
      if( !validateEmail($email.val())) {
    		// Appear error message
    		showEmailError($(this));
        return false;
      }else if (!$password.val() || ($password.val() != $confirm_password.val())) {
      	
      	hideEmailError($(this));
      	showPasswordError($(this));
        return false;
      }
      else{
      	// Hide error message
      	hideEmailError($(this));
        hidePasswordError($(this));
	    
		    var valuesToSubmit = $(this).serialize();
		    $.ajax({
		        url: $(this).attr('action'), //sumbits it to the given url of the form
		        type: "POST",
		        data: valuesToSubmit,
		        dataType: "JSON",
		        success: function(data, status, xhttp)
	          {   
	          	  if (data.status == "success")
	          	  {
	          	  	window.location = data.redirect_to;
	          	  }else if (data.status == "email exists")
	          	  {
	          	  	console.log("sign up failed");
	          	  	showEmailError($('#create_account'));
	          	  }               
	          }
		    });
		    return false; // prevents normal behaviour
		  }
		});

		// submit the form with ajax when click the "Send Email" button on the reset password modal
		$('#send_email').submit(function() { 
	    // Validation Email
			$email = $(this).find(".email_input");			
      if( !validateEmail($email.val())) {
    		// Appear error message
    		showEmailError($(this));
        return false;
      }
      else{
      	// Hide error message
      	hideEmailError($(this));
      	
		    var valuesToSubmit = $(this).serialize();
		    $.ajax({
		        url: $(this).attr('action'), //sumbits it to the given url of the form
		        type: "POST",
		        data: valuesToSubmit,
		        dataType: "JSON",
		        success: function(data, status, xhttp)
	          {   
	          	  if (data.status == "success")
	          	  {
	          	  	console.log("reset password successed");
	          	  	$("#resetpassword_button").trigger("click");
									$("#modal_sendeamil_form .close").trigger("click");
	          	  }else if (data.status == "failed")
	          	  {
	          	  	console.log("reset password successed failed");
	          	  	showEmailError($('#send_email'));
	          	  }               
	          }
		    });
		    return false; // prevents normal behaviour
		  }
		});
		
		// submit the form with ajax when click the "Send In" button on the password confirm modal
		$('#confirm_password').submit(function() { 
	    // Validation Password confirm
			$password = $(this).find(".pw_input");
			$confirm_password = $(this).find(".confirm_pw_input");
			
      if (!$password.val() || ($password.val() != $confirm_password.val())) {
      	showPasswordError($(this));
        return false;
      }
      else{
      	// Hide error message
      	hidePasswordError($(this));
      	
		    var valuesToSubmit = $(this).serialize();
		    $.ajax({
		        url: $(this).attr('action'), //sumbits it to the given url of the form
		        type: $(this).attr('method'),
		        data: valuesToSubmit,
		        dataType: "JSON",
		        success: function(data, status, xhttp)
	          {   
	          	  if (data.status == "success")
	          	  {
	          	  	console.log("confirm password success");
	          	  	$("#modal_sign_button").trigger("click");
									$("#confirm_password .close").trigger("click");
	          	  }else if (data.status == "failed")
	          	  {
	          	  	console.log("confirm password failed");
	          	  }else if (data.status == "expired")
	          	  {
	          	  	console.log("confirm password expired");
	          	  	$("#modal_sendemail_button").trigger("click");
									$("#confirm_password .close").trigger("click");
	          	  }                 
	          }
		    });
		    return false; // prevents normal behaviour
		  }
		});
		
    $(".modal input").keyup(function(){                 
        if($(this).val() == ''){
            $(".modal .create").css("background", "#da9996");
        }else{
            $(".modal .create").css("background", "#be3f3f");
        }
    });

    // $(".modal .create").click(function(){
        // $form = $(this).closest("form");
// 
        // $email = $form.find(".email_input");
        // if( !validateEmail($email.val())) { 
//             
            // $email.css("border", "1px solid #c55655");
            // $form.find(".email .caution").css("display", "block");
            // $form.find(".email .error_tooltip").css("display", "block");
        // }else{
            // $email.css("border", "1px solid #a6a5a2");
            // $form.find(".email .caution").css("display", "none");
            // $form.find(".email .error_tooltip").css("display", "none");
        // }
// 
        // $password = $form.find("input[name = 'password']") ;    
        // if(  $password.val() !='' && $password.val() != 'password' ) { 
            // $password.css("border", "1px solid #c55655");
            // $form.find(".password .caution").css("display", "block");
            // $form.find(".password .error_tooltip").css("display", "block");
        // }else{
            // $password.css("border", "1px solid #a6a5a2");
            // $form.find(".password .caution").css("display", "none");
            // $form.find(".password .error_tooltip").css("display", "none");
        // }

    // });        
});

function validateEmail($email) {	
  var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
  if( !emailReg.test( $email ) ) {
    return false;
  } else {
    return true;
  }
}

function showEmailError($form) {
	$email = $form.find(".email_input");
	$email.css("border", "1px solid #c55655");
  $form.find(".email .caution").css("display", "block");
  $form.find(".email .error_tooltip").css("display", "block");
}

function hideEmailError($form) {
	$email = $form.find(".email_input");
  $email.css("border", "1px solid #a6a5a2");
  $form.find(".email .caution").css("display", "none");
  $form.find(".email .error_tooltip").css("display", "none");
}

function showPasswordError($form) {
  $password = $form.find(".pw_input") ;
	$password.css("border", "1px solid #c55655");
  $form.find(".password .caution").css("display", "block");
  $form.find(".password .error_tooltip").css("display", "block");
}

function hidePasswordError($form) {
	$password = $form.find(".pw_input") ;
  $password.css("border", "1px solid #a6a5a2");
  $form.find(".password .caution").css("display", "none");
  $form.find(".password .error_tooltip").css("display", "none");
}
