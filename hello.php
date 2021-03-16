#!/usr/bin/env php
<?php
 	function makePlural($retVal) {
        if('y' == substr($retVal, -1)) {
            $retVal = substr($retVal, 0, strlen($retVal)-1);
            $retVal .= 'ie';
        }
        return $retVal.'s';
    }
    $names = array('Orange', 'Banana', 'Raspberry', 'Apple', 'Pear');
    array_walk_recursive('makePlural', $names);
    print_r($names); 
?>
