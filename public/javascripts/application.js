// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function openIDUsing(url, mode, shared, i, j) {
  if (mode == "signup") {
    $("user_identity_url").setValue(url);
    if (shared == true) {
      $('user_email').focus();
    } else {
      $("user_identity_url").setValue(url);
      $("user_identity_url").setSelectionRange(i, j + 1);
    }
  } else if (mode == "login") {
    $("openid_identifier").setValue(url);
    if (shared == true) {
      $('openid_identifier').focus();
    } else {
      $("openid_identifier").setValue(url);
      $("openid_identifier").setSelectionRange(i, j + 1);
    }
  }
}
