# utl-transpose-multiple-rows-into-one-row-do_over-dosubl-and-varlist-macros
    Transpose multiple rows into one row do_over dosubl and varlist macros                                                            
                                                                                                                                      
    Three Solutions                                                                                                                   
        a. array doover with #record input option                                                                                     
        b. do_over merge                                                                                                              
        c. more general solution (no utility macros vanilla sAS) by                                                                   
           "Keintz, Mark" <mkeintz@WHARTON.UPENN.EDU>                                                                                 
                                                                                                                                      
    github                                                                                                                            
    https://tinyurl.com/yblaekkw                                                                                                      
    https://github.com/rogerjdeangelis/utl-transpose-multiple-rows-into-one-row-do_over-dosubl-and-varlist-macros                     
                                                                                                                                      
    macros                                                                                                                            
    https://tinyurl.com/y9nfugth                                                                                                      
    https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                                        
                                                                                                                                      
    SAS Forum                                                                                                                         
    https://tinyurl.com/ybj3yrkf                                                                                                      
    https://communities.sas.com/t5/SAS-Programming/change-structure-of-table-from-long-to-wide-with-one-row/m-p/646231                
                                                                                                                                      
                                                                                                                                                                                                                                                                        
     Some of these solution use macros                                                                                                
         1. utlnopts (turn log off except errors warnings and notes)                                                                  
         2. utlopts (turn debug options on)                                                                                           
         3. varlist (Soron's macro)                                                                                                   
         4. array and do_over (Ted Clay)                                                                                              
         5. dosubl                                                                                                                    
                                                                                                                                      
    *_                   _                                                                                                            
    (_)_ __  _ __  _   _| |_                                                                                                          
    | | '_ \| '_ \| | | | __|                                                                                                         
    | | | | | |_) | |_| | |_                                                                                                          
    |_|_| |_| .__/ \__,_|\__|                                                                                                         
            |_|                                                                                                                       
    ;                                                                                                                                 
                                                                                                                                      
    Data have(index=(group/unique));                                                                                                  
    input group$ x y z xx yy zz w t q r;                                                                                              
    cards4;                                                                                                                           
    a 1 2 3 4 5 6 7 8 9 10                                                                                                            
    b 11 12 13 14 15 16 17 18 19 20                                                                                                   
    all  3 5 7 9 11 13 17 21 30 40                                                                                                    
    ;;;;                                                                                                                              
    run;                                                                                                                              
                                                                                                                                      
     WORK.HAVE total obs=3                                                                                                            
                                                                                                                                      
      GROUP     X     Y     Z    XX    YY    ZZ     W     T     Q     R                                                               
                                                                                                                                      
       a        1     2     3     4     5     6     7     8     9    10                                                               
       b       11    12    13    14    15    16    17    18    19    20                                                               
       all      3     5     7     9    11    13    17    21    30    40                                                               
                                                                                                                                      
    *            _               _                                                                                                    
      ___  _   _| |_ _ __  _   _| |_                                                                                                  
     / _ \| | | | __| '_ \| | | | __|                                                                                                 
    | (_) | |_| | |_| |_) | |_| | |_                                                                                                  
     \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                 
                    |_|                                                                                                               
    ;                                                                                                                                 
                                                                                                                                      
    Middle Observation(1 ) of want - Total Obs 1                                                                                      
                                                                                                                                      
     -- NUMERIC --   TYPE    VALUE                                                                                                    
                                                                                                                                      
    ALLX              N8       3                                                                                                      
    ALLY              N8       5                                                                                                      
    ALLZ              N8       7                                                                                                      
    ALLXX             N8       9                                                                                                      
    ALLYY             N8       11                                                                                                     
    ALLZZ             N8       13                                                                                                     
    ALLW              N8       17                                                                                                     
    ALLT              N8       21                                                                                                     
    ALLQ              N8       30                                                                                                     
    ALLR              N8       40                                                                                                     
                                                                                                                                      
    BX                N8       11                                                                                                     
    BY                N8       12                                                                                                     
    BZ                N8       13                                                                                                     
    BXX               N8       14                                                                                                     
    BYY               N8       15                                                                                                     
    BZZ               N8       16                                                                                                     
    BW                N8       17                                                                                                     
    BT                N8       18                                                                                                     
    BQ                N8       19                                                                                                     
    BR                N8       20                                                                                                     
                                                                                                                                      
    AX                N8       1                                                                                                      
    AY                N8       2                                                                                                      
    AZ                N8       3                                                                                                      
    AXX               N8       4                                                                                                      
    AYY               N8       5                                                                                                      
    AZZ               N8       6                                                                                                      
    AW                N8       7                                                                                                      
    AT                N8       8                                                                                                      
    AQ                N8       9                                                                                                      
    AR                N8       10                                                                                                     
                                                                                                                                      
    *          _       _   _                                                                                                          
     ___  ___ | |_   _| |_(_) ___  _ __                                                                                               
    / __|/ _ \| | | | | __| |/ _ \| '_ \                                                                                              
    \__ \ (_) | | |_| | |_| | (_) | | | |                                                                                             
    |___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                                             
    *              _                                 _  _                                                                             
      __ _      __| | ___     _____   _____ _ __   _| || |_                                                                           
     / _` |    / _` |/ _ \   / _ \ \ / / _ \ '__| |_  ..  _|                                                                          
    | (_| |_  | (_| | (_) | | (_) \ V /  __/ |    |_      _|                                                                          
     \__,_(_)  \__,_|\___/___\___/ \_/ \___|_|      |_||_|                                                                            
                        |_____|                                                                                                       
    ;                                                                                                                                 
                                                                                                                                      
    * just in case;                                                                                                                   
    %arraydelete(grps);                                                                                                               
    proc datasets lib=work;                                                                                                           
    delete want;                                                                                                                      
    run;quit;                                                                                                                         
                                                                                                                                      
    Data have;                                                                                                                        
      input group$ x y z xx yy zz w t q r;                                                                                            
    cards4;                                                                                                                           
    a 1 2 3 4 5 6 7 8 9 10                                                                                                            
    b 11 12 13 14 15 16 17 18 19 20                                                                                                   
    all  3 5 7 9 11 13 17 21 30 40                                                                                                    
    ;;;;                                                                                                                              
    run;quit;                                                                                                                         
                                                                                                                                      
    %array(grps,data=have,var=group);                                                                                                 
                                                                                                                                      
    data want;                                                                                                                        
      if _n_=0 then do; %dosubl('                                                                                                     
         data _null_;                                                                                                                 
            set have;                                                                                                                 
            file "d:/txt/mulRow.txt";                                                                                                 
            put x--r;                                                                                                                 
         run;quit;                                                                                                                    
         ');                                                                                                                          
      end;                                                                                                                            
                                                                                                                                      
      infile "d:/txt/mulRow.txt";                                                                                                     
        input                                                                                                                         
            %do_over(grps,phrase=#?_i_ ?x ?y ?z ?xx ?yy ?zz ?w ?t ?q ?r);                                                             
    run;quit;                                                                                                                         
                                                                                                                                      
                                                                                                                                      
    * if you want the generated code;                                                                                                 
                                                                                                                                      
    %put %do_over(grps,phrase=#?_i_ ?x ?y ?z ?xx ?yy ?zz ?w ?t ?q ?r);                                                                
                                                                                                                                      
    #1 ax ay az axx ayy azz aw at aq ar                                                                                               
    #2 bx by bz bxx byy bzz bw bt bq br                                                                                               
    #3 allx ally allz allxx allyy allzz allw allt allq allr                                                                           
                                                                                                                                      
    *_            _                                                                                                                   
    | |__      __| | ___     _____   _____ _ __   _ __ ___   ___ _ __ __ _  ___                                                       
    | '_ \    / _` |/ _ \   / _ \ \ / / _ \ '__| | '_ ` _ \ / _ \ '__/ _` |/ _ \                                                      
    | |_) |  | (_| | (_) | | (_) \ V /  __/ |    | | | | | |  __/ | | (_| |  __/                                                      
    |_.__(_)  \__,_|\___/___\___/ \_/ \___|_|    |_| |_| |_|\___|_|  \__, |\___|                                                      
                       |_____|                                       |___/                                                            
    ;                                                                                                                                 
                                                                                                                                      
    %utlnopts;                                                                                                                        
                                                                                                                                      
    proc datasets lib=work nolist;                                                                                                    
      delete want rowfix;                                                                                                             
    run;quit;                                                                                                                         
                                                                                                                                      
    %symdel grp / nowarn;                                                                                                             
                                                                                                                                      
    %array(vars,values=%utl_varlist(have,keep=_numeric_));                                                                            
                                                                                                                                      
    Data _null_;                                                                                                                      
                                                                                                                                      
      if _n_=0 then do; %dosubl('data want;run;quit;'); end;                                                                          
                                                                                                                                      
      set have;                                                                                                                       
      call symputx('grp',group);                                                                                                      
                                                                                                                                      
      rc=dosubl('                                                                                                                     
          data rowfix;                                                                                                                
              set have(where=(group="&grp") rename=(                                                                                  
                  %do_over(vars,phrase=%str(? = &grp? ))));                                                                           
          run;quit;                                                                                                                   
          data want;                                                                                                                  
              merge rowfix(drop=group) want ;                                                                                         
          run;quit;                                                                                                                   
      ');                                                                                                                             
                                                                                                                                      
    run;quit;                                                                                                                         
                                                                                                                                      
    %utlopts;                                                                                                                         
                                                                                                                                      
    *                                         _                                                                                       
      ___      __ _  ___ _ __   ___ _ __ __ _| |                                                                                      
     / __|    / _` |/ _ \ '_ \ / _ \ '__/ _` | |                                                                                      
    | (__ _  | (_| |  __/ | | |  __/ | | (_| | |                                                                                      
     \___(_)  \__, |\___|_| |_|\___|_|  \__,_|_|                                                                                      
              |___/                                                                                                                   
    ;                                                                                                                                 
                                                                                                                                      
    One time reading the entire data set.                                                                                             
                                                                                                                                      
    For each of the NOBS unique group values, filters the entire dataset.                                                             
                                                                                                                                      
                                                                                                                                      
                                                                                                                                      
    I don't suppose this flattening would often be applied to datasets with                                                           
    lots of observations, so scalability probably isn't really an issue.                                                              
                                                                                                                                      
                                                                                                                                      
                                                                                                                                      
    But, says I to myself, why let practicality get in the way of another solution?                                                   
    This one reads the dataset once, uses metadata about HAVE to facilitate that reading,                                             
    and then renames variables as needed after WANT is written:                                                                       
                                                                                                                                      
                                                                                                                                      
    data have;                                                                                                                        
    input group$ x y z xx yy zz w t q r nn$;                                                                                          
    cards4;                                                                                                                           
    a 1 2 3 4 5 6 7 8 9 10 ABCDE                                                                                                      
    b 11 12 13 14 15 16 17 18 19 20 FGHIJ                                                                                             
    all 3 5 7 9 11 13 17 21 30 40 KLMNO                                                                                               
    ;;;;                                                                                                                              
    run;quit;                                                                                                                         
                                                                                                                                      
                                                                                                                                      
    %macro flatten;                                                                                                                   
    %local                                                                                                                            
         N_HAVE   /*number of obs in have*/                                                                                           
         LENGTHS  /* N_HAVE sets of lengths for each of the original variables, in original order                                     
                     Each set of vars will have prefix _1_, _2_, ... based on _N_                 */                                  
         ASSIGNS  /* N_HAVE sets of assignments of original values to appropriate new variable    */                                  
         RENAME_TEMPLATE  /* to be modified into needed RENAME statements, based on group value   */                                  
      ;                                                                                                                               
                                                                                                                                      
      proc sql noprint;                                                                                                               
        select nobs into :n_have                                                                                                      
          from dictionary.tables where libname='WORK' and memname='HAVE';                                                             
        select catx(' ',cats('_&n._',name),cats(ifc(type='char','$',''),length)) into :lengths separated by ' '                       
          from dictionary.columns where libname='WORK' and memname='HAVE' and upcase(name)^='GROUP';                                  
        select  cats('_&n._',name,'=',name,';') into: assigns separated by ' '                                                        
          from dictionary.columns where libname='WORK' and memname='HAVE' and upcase(name)^='GROUP';                                  
        select distinct cats('_?_',name,'=??_',name) into :rename_template separated by ' '                                           
          from dictionary.columns where libname='WORK' and memname='HAVE' and upcase(name) ^= 'GROUP' ;                               
      quit;                                                                                                                           
                                                                                                                                      
      %put _user_;                                                                                                                    
                                                                                                                                      
      filename renames temp ;                                                                                                         
      data want (keep=_: drop=_txt);                                                                                                  
        set have end=end_of_have;                                                                                                     
        length %do n=1 %to &n_have;  &lengths  %end;  ;                                                                               
        select (_n_);                                                                                                                 
          %do n=1 %to &n_have;                                                                                                        
            when (&n) do;  &assigns  end;                                                                                             
          %end;                                                                                                                       
        end;                                                                                                                          
                                                                                                                                      
        file renames;   /* Modify macrovar RENAME_TEMPLATE and output for later INCLUDE */                                            
        length _txt $32767 ;                                                                                                          
        _txt=tranwrd("&rename_template","??",trim(group));                                                                            
        _txt=tranwrd(_txt,'?',cats(_N_));                                                                                             
        put 'rename ' _txt ';' ;                                                                                                      
                                                                                                                                      
        retain _: ;                                                                                                                   
        if end_of_have;                                                                                                               
      run;                                                                                                                            
      proc datasets lib=WORK   nolist;                                                                                                
        modify want;                                                                                                                  
          %include renames /source2;                                                                                                  
        run;                                                                                                                          
      quit;                                                                                                                           
                                                                                                                                      
    %mend flatten;                                                                                                                    
    %flatten ;                                                                                                                        
                                                                                                                                      
                                                                                                                                      
