/// Where a form submission stands. Success is consumed once by a listener that
/// navigates away; failure shows an inline message below the button.
enum AuthSubmitStatus { idle, submitting, success, failure }
