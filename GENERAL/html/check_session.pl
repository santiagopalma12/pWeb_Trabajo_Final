#!/usr/bin/perl  -w
use strict;
use warnings;
use CGI;
use CGI::Session;

my $cgi = CGI->new;

# Load the session
my $session = CGI::Session->new(undef, $cgi, { Directory => '/tmp/sessions' });
my $username = $session->param("username");
my $user_id = $session->param("user_id");

# Send HTTP header
print $cgi->header(-type => "text/html", -charset => "UTF-8");

# Check session validity
if ($username && $user_id) {
    print "<h1>Perfil de Usuario</h1>";
    print "<p>Bienvenido de nuevo, $username</p>";
    print "<a href='/cgi-bin/logout.pl'>Cerrar Sesión</a><br><br>";

    # Form to add an item (or related content)
    print "<a href='/cgi-bin/echo.pl' method='post'>Crear uml</a>";
} else {
    print "<h1>No hay sesión activa</h1>";
    print "<a href='/index.html'>Iniciar Sesión</a>";
}

exit;
