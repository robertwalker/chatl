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
  new Ajax.Updater('gravatar_image_' + idx, '/users/' + user_id, {
    method: "get",
    insertion: "before",
    onComplete: function() {
      gravatar_v_offset = $('gravatar_image_' + idx).positionedOffset().top;
      card_height = $('address_card_' + user_id).getHeight();
      $('address_card_' + user_id).setStyle("left: " + ((idx * 42) + 3) + "px");
      $('address_card_' + user_id).setStyle("top: " + (gravatar_v_offset - (card_height - 38)) + "px");
      $('address_card_close_button_' + user_id).observe('click', function() {
        $('address_card_close_button_' + user_id).stopObserving();
        $('address_card_' + user_id).remove();
      });
    }
  });
}
