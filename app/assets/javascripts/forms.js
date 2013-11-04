function add_fields(total, link, content) {
  $(link).parent().before(content);

  // this returns an array of inputs closest to the
  // button that adds new fields
  var inputs = $(link).closest('.inst-box').find('input');

  // get the current time
  var time = new Date().getTime();

  // Set the id of the last fields that were created to the current time
  // so that each field has a unique id.
  // The "total" variable is defined in the add_fields call in the
  // partials that use it. See _contacts.html.haml for example,
  // which creates 6 new inputs when adding a new contact.
  for (var i = 1; i <= total; i++) {
    inputs[inputs.length - i].setAttribute("id", time);
    time += 1;
  }
}