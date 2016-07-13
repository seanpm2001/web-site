<?php
require("config.php");

$uri = $_POST['uri'];
$body = $_POST['body'];

if (!isset($uri, $body)) {
  header("HTTP/1.1 400 Missing fields", true, 400);
  die("Missing fields in POST");
  exit(1);
}

require('Mail.php');

$recipient = "zero-install-bugs@lists.sourceforge.net";

$headers = array (
    'From' => 'bugs@0install.net',
    'To' => $recipient,
    'Subject' => "Bug in $uri",
);

$mail_object =& Mail::factory('smtp',
    array(
        'host' => 'prwebmail',
        'auth' => true,
        'username' => 'zero-install',
        'password' => $password,
        //'debug' => true, # uncomment to enable debugging
    ));

if (strpos($body, "gpg: no writable keyring found")) {
    $notes = "\n\n" .
	"Hint: Check the permissions and ownership of your ~/.gnupg directory. " .
	"It should be owned by your user (not root), and have permissions rwx------.";
} else if (strpos($body, "Fedora release 20")) {
    $notes = "\n\n" .
	"Note: The official Fedora 20 package of 0install has been compiled without " .
	"D-BUS support. Therefore, 0install will not be able to find missing packages " .
	"that are only provided by the distribution. You will need to install these " .
	"manually for now. See https://bugzilla.redhat.com/show_bug.cgi?id=1103476";

    if (strpos($body, "http://dispcalgui.hoech.net")) {
	$notes .= "\n\ndispcalGUI users should do 'yum install numpy wxPython'";
    }
} else if (strpos($body, "Ubuntu 14.04")) {
    $notes = "\n\n" .
	"The version of apt-cache in Ubuntu 14.04 no longer supports the " .
	"--no-all-versions option after the subcommand, which means that " .
	"0install cannot find the candidate (uninstalled) python-pygame " .
	"package. This was fixed in 0install 2.7.";
    if (strpos($body, "dispcalgui.hoech.net/0install/pygame.xml")) {
	$notes .= "\n\nA work-around is to 'apt-get install python-pygame' manually.";
    }
} else {
    $notes = "";
}

$result = $mail_object->send($recipient, $headers, $body . $notes);

if ($result === true) {
  echo("Bug report email sent." . $notes);
} else {
  header("HTTP/1.1 500 Failed to send email: $result", true, 500);
  die($result . $notes);
}
