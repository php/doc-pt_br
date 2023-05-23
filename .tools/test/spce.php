<?php

function wsfix( $filename )
{
    $strict = false;
    
    $filename = trim( $filename );
    if ( strpos( $filename , 'en' ) === 0 )
        $filename = substr( $filename , 2 );
    if ( strpos( $filename , 'pt_BR' ) === 0 )
        $filename = substr( $filename , 5 );
    if ( strpos( $filename , '/' ) === 0 )
        $filename = substr( $filename , 1 );
    
    $enname = 'en/' . $filename;
    $brname = 'pt_BR/' . $filename;
    
    $entext = file_get_contents( $enname );
    $brtext = file_get_contents( $brname );
    
    $enlines = explode( "\n" , $entext );
    $brlines = explode( "\n" , $brtext );
    
    if ( $strict )
    {
        if ( count( $enlines ) != count( $brlines ) )
            die( "Line strict count differs.\n" );
    }
    else
    {
        if ( count( explode( "\n" , rtrim( $entext ) ) ) != count( explode( "\n" , rtrim( $brtext ) ) ) )
            die( "Line loose count differs.\n" );
    }
    
    $i = 0;
    $l = count( $enlines );
    for ( $i = 0 ; $i < $l ; $i++ )
    {
        if ( array_key_exists( $i , $enlines ) == false )
            continue;
        if ( array_key_exists( $i , $brlines ) == false )
            continue;
        
        $en = $enlines[$i];
        $br = $brlines[$i];
        
        $ws = "";
        $chars = str_split( $en );
        foreach( $chars as $char )
            if ( $char == ' ' )
                $ws .= ' ';
            else
                break;
        
        $br = $ws . trim( $br );
        $br = rtrim( $br );
        
        $brlines[$i] = $br;
    }
    
    $brtext = implode( "\n" , $brlines );
    file_put_contents( $brname , $brtext );
}

wsfix ( $argv[1] );
