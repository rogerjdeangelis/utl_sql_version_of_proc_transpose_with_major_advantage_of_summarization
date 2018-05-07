SQL version of Proc Transpose with major advantage of summarization

A realize you can also do this with a macro, but one less level
of indirection is better?

github
https://tinyurl.com/ya9rsjnf
https://github.com/rogerjdeangelis/utl_sql_version_of_proc_transpose_with_major_advantage_of_summarization

https://communities.sas.com/t5/Base-SAS-Programming/Help-in-my-sql-code/m-p/460402

INPUT
=====

WORK.HAVE total obs=16

 ID    TRT    RECORDS    DURATION    COMPLY

  1     A        4           9          1
  1     A        4           9          1
  1     A        4           9          1
  1     A        4           9          1

  1     B        4           9          1
  1     B        4           9          1
  1     B        4           9          1
  1     B        4           9          1
  2     A        4           9          1
  2     A        4           9          1
  2     A        4           9          1
  2     A        4           9          1
  2     B        4           9          1
  2     B        4           9          1
  2     B        4           9          1
  2     B        4           9          1

EXAMPLE OUTPUT

WORK.WANT total obs=12

Obs    ID    TRT     PARAM      AVAL

  1     1     A     COMPLY        4    1+1+1+1  Transpose cannot do this?
  2     1     A     DURATION     36    9+9+9+9
  3     1     A     RECORDS      16    4+4+4+4
...
 10     2     B     COMPLY        4
 11     2     B     DURATION     36
 12     2     B     RECORDS      16


PROCESS
=======

%array(vars,values=RECORDS DURATION COMPLY);
proc sql;
  create
    table want as
  select
   %do_over(vars,phrase=%str(
         id
        ,trt
        ,"?" as param length=32
        ,sum(?) as aval)
        ,between=%str(from have group by id, trt union select ))
   from have group by id, trt
;quit;

OUTPUT
======

WORK.WANT total obs=12

 ID    TRT     PARAM      AVAL

  1     A     COMPLY        4
  1     A     DURATION     36
  1     A     RECORDS      16
  1     B     COMPLY        4
  1     B     DURATION     36
  1     B     RECORDS      16
  2     A     COMPLY        4
  2     A     DURATION     36
  2     A     RECORDS      16
  2     B     COMPLY        4
  2     B     DURATION     36
  2     B     RECORDS      16

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
input ID TRT $ RECORDS DURATION COMPLY;
cards4;
1 A 4 9 1
1 A 4 9 1
1 A 4 9 1
1 A 4 9 1
1 B 4 9 1
1 B 4 9 1
1 B 4 9 1
1 B 4 9 1
2 A 4 9 1
2 A 4 9 1
2 A 4 9 1
2 A 4 9 1
2 B 4 9 1
2 B 4 9 1
2 B 4 9 1
2 B 4 9 1
;;;;
run;quit;

%array(vars,values=RECORDS DURATION COMPLY);
proc sql;
  create
    table want as
  select
   %do_over(vars,phrase=%str(
         id
        ,trt
        ,"?" as param length=32
        ,sum(?) as aval)
        ,between=%str(from have group by id, trt union select ))
   from have group by id, trt
;quit;



