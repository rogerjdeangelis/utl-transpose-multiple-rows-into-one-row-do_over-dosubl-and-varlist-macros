Transpose multiple rows into one row do_over dosubl and varlist macros                                                     
                                                                                                                           
Academic solution                                                                                                          
                                                                                                                           
github                                                                                                                     
https://tinyurl.com/yblaekkw                                                                                               
https://github.com/rogerjdeangelis/utl-transpose-multiple-rows-into-one-row-do_over-dosubl-and-varlist-macros              
                                                                                                                           
macros                                                                                                                     
https://tinyurl.com/y9nfugth                                                                                               
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                                 
                                                                                                                           
SAS Forum                                                                                                                  
https://tinyurl.com/ybj3yrkf                                                                                               
https://communities.sas.com/t5/SAS-Programming/change-structure-of-table-from-long-to-wide-with-one-row/m-p/646231         
                                                                                                                           
                                                                                                                           
                                                                                                                           
 This solution uses macros                                                                                                 
     1. utlnopts (turn log off except errors warnings and notes)                                                           
     2. utlopts (turn debug options on)                                                                                    
     3. varlist (Soron's macro                                                                                             
     4. array and do_over (Ted Clay)                                                                                       
     5. dosubl                                                                                                             
                                                                                                                           
*_                   _                                                                                                     
(_)_ __  _ __  _   _| |_                                                                                                   
| | '_ \| '_ \| | | | __|                                                                                                  
| | | | | |_) | |_| | |_                                                                                                   
|_|_| |_| .__/ \__,_|\__|                                                                                                  
        |_|                                                                                                                
;                                                                                                                          
Data have;                                                                                                                 
input group$ x y z xx yy zz w t q r;                                                                                       
cards;                                                                                                                     
a 1 2 3 4 5 6 7 8 9 10                                                                                                     
b 11 12 13 14 15 16 17 18 19 20                                                                                            
all  3 5 7 9 11 13 17 21 30 40                                                                                             
;                                                                                                                          
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
                                                                                                                           
                                                                                                                           
