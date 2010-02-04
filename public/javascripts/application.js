// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function signupUsingGoogle() {
  $("user_identity_url").setValue("https://www.google.com/accounts/o8/id");
  $('user_email').focus();
}

function signupUsingYahoo() {
  $("user_identity_url").setValue("http://yahoo.com/");
  $('user_email').focus();
}

function signupUsingOpenID(placholder_url, i, j) {
  $("user_identity_url").setValue(placholder_url);
  $("user_identity_url").setSelectionRange(i, j + 1);
}

function loginUsingGoogle() {
  $("openid_identifier").setValue("https://www.google.com/accounts/o8/id");
  $('openid_identifier').focus();
}

function loginUsingYahoo() {
  $("openid_identifier").setValue("http://yahoo.com/");
  $('openid_identifier').focus();
}
