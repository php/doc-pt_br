<?php

wsfix ( $argv[1] );

function wsfix( $filename )
{
    $filename = trim( $filename );
    if ( strpos( $filename , 'en' ) === 0 )
        $filename = substr( $filename , 2 );
    if ( strpos( $filename , 'pt_BR' ) === 0 )
        $filename = substr( $filename , 5 );
    if ( strpos( $filename , '/' ) === 0 )
        $filename = substr( $filename , 1 );

    $srcName = 'en/' . $filename;
    $dstName = 'pt_BR/' . $filename;

    if ( ! file_exists( $srcName ) )
        die( "File not exists: $srcName\n" );
    if ( ! file_exists( $dstName ) )
        die( "File not exists: $dstName\n" );

    $srcText = file_get_contents( $srcName );
    $dstText = file_get_contents( $dstName );

    $srcLines = explode_lines( $srcText );
    $dstLines = explode_lines( $dstText );

    $srcCount = count( array_filter( $srcLines , "non_empty" ) );
    $dstLines = array_filter( $dstLines , "non_empty" );

    if ( $srcCount != count( $dstLines ) )
        die( "Text line count mismatch: $filename\n" );

    foreach ( $srcLines as $srcLine )
    {
        if ( strlen( trim( $srcLine ) ) == 0 )
        {
            $dstLines[] = "";
            continue;
        }

        $dstLine = array_shift( $dstLines );

        $ws = "";
        $chars = str_split( $srcLine );
        foreach( $chars as $char )
            if ( $char == ' ' )
                $ws .= ' ';
            else
                break;

        $dstLine = $ws . trim( $dstLine );
        $dstLines[] = $dstLine;
    }

    $dstTextNew = implode( "\n" , $dstLines );
    file_put_contents( $dstName , $dstTextNew );

    if ( $dstText != $dstTextNew )
        fwrite( STDERR , "Whitespace changed: $filename\n" );
}

function explode_lines( $text )
{
    $text = str_replace( "\r\n" , "\n" , $text );
    $text = str_replace( "\r"   , "\n" , $text );
    return explode( "\n" , $text );
}

function non_empty( $text )
{
    return strlen( trim( $text ) ) > 0;
}
