
/*   FILE:  PROOFER.FNC

/*   Functional Character Table for PROOFER -- January, 1997
/*
/*   Last edited:  J.Lentz; 11-3-97:  deleted assignment for illegible character.

/*   Purpose of table:  supplies characters which serve a specific function
/*                      for manuscript transcription
/*

/*   Note:  All characters are unicased during processing,
/*          therefore, enter only one case, either upper
/*          or lower for each character.

/*      If a character is extended ASCII, designate it by one of two ways:
/*      1. extended ASCI, or    
/*      2. # plus the ASCII numeric value 
/* 
/*               E.g., "‚" or "#130"
/*
/*
/*      3. Designate the cross hatch character by entering two cross hatches:
/*               
/*               E.g., "##" will be interpreted as "#" 
/*                     "####' will be interpreted as "##" 
/*

/*  Function codes:
/*      begin folio                      1
/*      end folio                        2
/*      old folio notation               3

/*      begin mnemonic                   4
/*      end mnemonic                     5
/*      begin mnemonic text              6
/*      begin mnemonic remark            7
/*      continuation of mnemonic         8
/*      mnemonic vector                  9

/*      begin inserted text             10    
/*      end inserted text               11

/*      begin deleted text              12 
/*      end deleted text                13 
  
/*      begin abbreviation              14
/*      end abbreviation                15

/*      begin suprascript               16
/*      end suprascript                 17

/*      begin parenthesis               18
/*      end parenthesis                 19

/*      scribal hand                    20
/*      non-original scribal hand       21

/*      illegible character             22  CURRENTLY NOT USED
/*      illegible word or part of word  23
/*      illegible phrase                24


/*      calderon                        25  (variants are handled by the software)
/*      hyphen                          26
/*      inverted text                   27
/*      non sequitor text               28          
/*      prefix                          29
/*      reconstituted text              30
/*      text separator                  31

/*************************************************************************************

/* Functional        End Character(s)     Begin             End
/* Character(s)                           Function Code     Function Code

/* Folio notation

     [fol.                ]                     1               2

     \                                          3
     
/* Mnemonic notation

     {                     }                    4               5
     
     .                                          6

     :                                          7
     
     +                                          8
     
     =                                          9

/* Inserted text  

     [                    ]                    10               11

/* Deleted text

     (                    )                    12               13

/* Abbreviated text

     <                    >                    14               15

/* Superscript

     <<                   >>                   16               17

/* Parentheses

     ((                   ))                   18               19

   
/* Scribal hand
                                                                
     ^                                         20
     
     ##                                        21
     
/* Illegible text


     ??                                        23

     ???                                       24

/* Miscellaneous

     %                                         25
         
     -                                         26
     
     $                                         27
     
    [...]                                      28

    [+]                                        29

     *                                         30

     |                                         31

 
/* End of PROOFER.FNC


