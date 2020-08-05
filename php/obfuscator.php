<?php
require 'Obfuscator_class.php';

$to_obfuscate_file = $argv[1]; 
# A PHP file name (with absolute path) that you want to obfuscate
if (! file_exists($to_obfuscate_file) ) {
    echo "File not found! \n\r";
    exit(1);
}

$sData = str_replace(array('<?php', '<?', '?>'), '', file_get_contents( $to_obfuscate_file ) );
$sObfusationData = new Obfuscator($sData, 'Class/Code NAME');
file_put_contents( $to_obfuscate_file , '<?php ' . "\r\n" . $sObfusationData);
echo "File obfuscated successfully \n\r";