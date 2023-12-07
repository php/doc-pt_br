<?php
/**
 *  +----------------------------------------------------------------------+
 *  | Copyright (c) 1997-2023 The PHP Group                                |
 *  +----------------------------------------------------------------------+
 *  | This source file is subject to version 3.01 of the PHP license,      |
 *  | that is bundled with this package in the file LICENSE, and is        |
 *  | available through the world-wide-web at the following url:           |
 *  | https://www.php.net/license/3_01.txt.                                |
 *  | If you did not receive a copy of the PHP license and are unable to   |
 *  | obtain it through the world-wide-web, please send a note to          |
 *  | license@php.net, so we can mail you a copy immediately.              |
 *  +----------------------------------------------------------------------+
 *  | Authors:     Andŕe L F S Bacci <ae php.net>                          |
 *  +----------------------------------------------------------------------+
 *  | Description: Gera um arquivo anotado, indicando as inclusões e       |
 *  |              remoções de linhas conforme diff do hash informado.     |
 *  |              EXPERIMENTAL.                                           |
 *  +----------------------------------------------------------------------+
 */

if ( $argc == 2)
    mess_replace( $argv[1] );
else
    mess_replace( $argv[1] , $argv[2] );

function mess_replace( string $filename , string $hash = "" )
{
    if ( strpos( $filename , "\n" ) )
    {
        $parts = explode( "\n" , $filename );
        [ $filename , $hash ] = $parts;
    }

    // Dados iniciais
    $sourceFile = "en/{$filename}";
    $targetFile = "pt_BR/{$filename}";
    $sourceLines = explode( "\n" , file_get_contents( $sourceFile ) );
    $targetLines = explode( "\n" , file_get_contents( $targetFile ) );
    if ( count( $sourceLines ) == 0 )
    {
        fwrite( STDERR , "Failed to load: $sourceFile\n" );
        return;
    }
    if ( count( $targetLines ) == 0 )
    {
        fwrite( STDERR , "Failed to load: $targetFile\n" );
        return;
    }

    // Leitura do log
    $log = array();
    $cwd = getcwd();
    chdir( 'en' );

    $fp = popen( "git diff -U0 $hash -- $filename" , "r" );
    while ( ( $line = fgets( $fp ) ) !== false )
        $log[] = $line;
    pclose( $fp );
    chdir( $cwd );

    // Extração dos chunks
    $chunks = array();
    for ( $n = 0 ; $n < count( $log ) ; $n++ )
    {
        // procura caceçalho de chunk
        while ( $log[$n][0] != '@' )
            $n++;
        // extrai chunck
        $chunk = array( $log[$n] );
        $n++;
        for ( ; $n < count( $log ) ; $n++ )
        {
            $c = $log[$n][0];
            if ( $c == '+' || $c == '-' )
            {
                $chunk[] = $log[$n];
                continue;
            }
        }
        $chunks[] = $chunk;
    }
    $n = count( $chunks );

    // Aplicando os chunks
    $mergedLines = array();
    $sourceLine = 0;
    $targetLine = 0;
    foreach( $chunks as $chunk )
    {
        // Cabeçalho chunk
        $head = explode( ' ' , trim( str_replace( '@' , '' , $chunk[0] ) ) );
        $skip = explode( ',' , $head[0] )[0];
        if ( $skip < 0 )
            $skip = abs( $skip );
        else
            die( "Not a del line chunk header.\n" );

        // Linhas copiar
        while ( ( $sourceLine + 1 ) < $skip )
        {
            $mergedLines[] = $targetLines[$targetLine];
            $sourceLine++;
            $targetLine++;
        }

        // Linhas apagar
        $mergedLines[] = "<<<<<<<";
        for ( $c = 1 ; $c < count( $chunk ) ; $c++ )
        {
            if ( $chunk[$c][0] == '-' )
            {
                $mergedLines[] = $targetLines[$targetLine];
                $sourceLine++;
                $targetLine++;
            }
        }

        // Linhas incluir
        $mergedLines[] = "=======";
        for ( $c = 1 ; $c < count( $chunk ) ; $c++ )
        {
            if ( $chunk[$c][0] == '+' )
            {
                $add = rtrim( substr( $chunk[$c] , 1 ) );
                $mergedLines[] = $add;
            }
        }
        $mergedLines[] = ">>>>>>>";
    }

    // Linhas finais
    while( $targetLine < count( $targetLines ) )
    {
        $mergedLines[] = $targetLines[$targetLine];
        $targetLine++;
    }

    $mergedContents = implode( "\n" , $mergedLines );
    file_put_contents( $targetFile , $mergedContents );
}
