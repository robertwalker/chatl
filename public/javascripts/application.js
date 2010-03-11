// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function openIDUsing(url, mode, shared, i, j) {
  if (mode == "signup") {
    $("openid_identifier").setValue(url);
    if (shared == true) {
      $("openid_identifier").readOnly = true;
      $('user_email').focus();
    } else {
      $("openid_identifier").readOnly = false;
      $("openid_identifier").setValue(url);
      $("openid_identifier").setSelectionRange(i, j + 1);
    }
  } else if (mode == "login") {
    $("openid_identifier").setValue(url);
    if (shared == true) {
      $("openid_identifier").readOnly = true;
    } else {
      $("openid_identifier").readOnly = false;
      $("openid_identifier").setValue(url);
      $("openid_identifier").setSelectionRange(i, j + 1);
    }
  }
}

function showAddressCard(user_id, idx) {
  var gravatar_offset;
  var card_left;
  var card_top;
  var card_height;

  new Ajax.Updater('attendee_image_' + idx, '/users/' + user_id, {
    method: "get",
    insertion: "before",
    onComplete: function() {
      gravatar_offset = $('attendee_image_' + idx).positionedOffset();
      card_height = $('address_card_' + user_id).getHeight();
      card_left = (gravatar_offset.left + 3) + "px";
      card_top = (gravatar_offset.top - (card_height - 38)) + "px";
      $('address_card_' + user_id).setStyle("left: " + card_left);
      $('address_card_' + user_id).setStyle("top: " + card_top);
      $('address_card_close_button_' + user_id).observe('click', function() {
        $('address_card_close_button_' + user_id).stopObserving();
        $('address_card_' + user_id).remove();
      });
    }
  });
}
