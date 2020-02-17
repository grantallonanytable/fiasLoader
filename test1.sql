select 'NEW' as ID, a.SHORTNAME, a.FORMALNAME, a.OFFNAME, null as suzId, a.ATG_CODE, null as slug, a.AOGUID,
(select
listagg(a2.SHORTNAME||' '||a2.FORMALNAME, ', ') within group (order by decode(a2.AOLEVEL,6,0,a2.AOLEVEL))
from FIAS_ADDROBJ a2
connect by prior a2.PARENTGUID=a2.AOGUID
start with a2.AOGUID=a.AOGUID) as full_name
from FIAS_ADDROBJ a where a.AOLEVEL=6

    select 'NEW' as ID, nvl(s.NAME,a.SHORTNAME), a.FORMALNAME, a.OFFNAME, null as suzId, null as slug, a.AOGUID,
    (select
         listagg(a2.SHORTNAME||' '||a2.FORMALNAME, ', ') within group (order by decode(a2.AOLEVEL,6,0,a2.AOLEVEL))
         from FIAS_ADDROBJ a2  connect by prior a2.PARENTGUID=a2.AOGUID  start with a2.AOID=a.AOID) as full_name,
    (select min(ATG_CODE) keep (dense_rank LAST order by level) from FIAS_ADDROBJ a4 connect by prior a4.PARENTGUID=a4.AOGUID
     start with a4.AOID=a.AOID) as area,
    s.KOD_T_ST
          from FIAS_ADDROBJ a
    left join FIAS_SOCR s on (s.CODE=a.SHORTNAME and s.SOCR_LEVEL=a.AOLEVEL)
    where a.AOLEVEL =6 --and a.AOID='3841f7d26-c9fa-4f24-b777-c5bfbd54fc63'

select min(ATG_CODE) keep (dense_rank LAST order by level) as AREAS from FIAS_ADDROBJ a4 connect by prior a4.PARENTGUID=a4.AOGUID
 start with a4.AOID='841f7d26-c9fa-4f24-b777-c5bfbd54fc63'

select * from FIAS_SOCR  where SOCR_LEVEL=6 order by CODE

select a.REGIONCODE,a.offname, s."NAME"||' '||a.OFFNAME from FIAS_ADDROBJ a join FIAS_SOCR s on s.SOCR_LEVEL=a.AOLEVEL and s.code=a.SHORTNAME where aolevel=1
select  (select
          listagg(a2.SHORTNAME||' '||a2.FORMALNAME, ', ') within group (order by decode(a2.AOLEVEL,6,0,a2.AOLEVEL))
          from FIAS_ADDROBJ a2  connect by prior a2.PARENTGUID=a2.AOGUID  start with a2.AOGUID=a.AOGUID) as full_name,
          a.*
 from FIAS_ADDROBJ a
    where a.AOLEVEL =6

begin
  for j in (
    select o.OFFNAME, a.name, a.code, o.AOID, o.aoguid,
    count(a.code) over(partition by o.aoid) as atg_code_cnt
    --,o.*, count(1) over() as all_cnt
    from FIAS_ATG_AREAS a
    full join FIAS_ADDROBJ o on (lower(a.name) like lower('%'||o.OFFNAME||'%'))
    where o.AOLEVEL=1
) loop
  update FIAS_ADDROBJ set ATG_CODE=j.code where aoid=j.aoid;
end loop;
commit;
end;

  select o.offname, o.atg_code, a.name, a.code, o.aoid, o.aoguid, a2.code, a2.name,
    count(a.code) over(partition by o.aoid) as atg_code_cnt
    --,o.*, count(1) over() as all_cnt
    from FIAS_ATG_AREAS a
    full join FIAS_ADDROBJ o on (lower(a.name) like lower('%'||o.offname||'%'))
    left join FIAS_ATG_AREAS a2 on a2.code=o.atg_code
    where o.AOLEVEL=1 and (o.atg_code is null)

update FIAS_ADDROBJ set ATG_CODE=300001 where OFFNAME='Алтай'
update FIAS_ADDROBJ set ATG_CODE=300035 where OFFNAME='Омская'
update FIAS_ADDROBJ set ATG_CODE=300031 where OFFNAME='Ненецкий'
update FIAS_ADDROBJ set ATG_CODE=300024 where OFFNAME='Красноярский'
update FIAS_ADDROBJ set ATG_CODE=300029 where OFFNAME='Московская'



  select o.offname, o.atg_code, a.name, a.code, o.aoid, o.aoguid, a2.code, a2.name,
    count(a.code) over(partition by o.aoid) as atg_code_cnt
    from FIAS_ATG_AREAS a
    full join FIAS_ADDROBJ o on (lower(a.name) like lower('%'||trim(substr(o.offname, 1, 4))||'%') or (o.OFFNAME='Корякский' and lower(a.name) like '%камча%'))
    left join FIAS_ATG_AREAS a2 on a2.code=o.atg_code
    where o.AOLEVEL=1 and (o.atg_code is null)

begin
update FIAS_ADDROBJ set ATG_CODE=300054 where OFFNAME='Северная Осетия - Алания';
update FIAS_ADDROBJ set ATG_CODE=300014 where OFFNAME='Иркутская обл Усть-Ордынский Бурятский';
update FIAS_ADDROBJ set ATG_CODE=300012 where OFFNAME='Байконур';
update FIAS_ADDROBJ set ATG_CODE=300067 where OFFNAME='Таймырский (Долгано-Ненецкий)';
update FIAS_ADDROBJ set ATG_CODE=300053 where OFFNAME='Саха /Якутия/';
update FIAS_ADDROBJ set ATG_CODE=300076 where OFFNAME='Ханты-Мансийский Автономный округ - Югра';
update FIAS_ADDROBJ set ATG_CODE=300079 where OFFNAME='Чувашская Республика -';
update FIAS_ADDROBJ set ATG_CODE=300012 where OFFNAME='Забайкальский край Агинский Бурятский';
update FIAS_ADDROBJ set ATG_CODE=300049 where OFFNAME='Коми-Пермяцкий';
update FIAS_ADDROBJ set ATG_CODE=300018 where OFFNAME='Корякский';
commit;
end;
Корякский АО -> Камчатский край

=========================================================================================
 select a4.SHORTNAME as CITY_TYPE,a4.FORMALNAME,a4.OFFNAME,a4.AREAS,a4.AOGUID,
     a4.FULLNAME,'NEW' as ID,null as SLUG,null as SUZID
     from (
      select a.SHORTNAME,a.FORMALNAME,a.OFFNAME,a.AOLEVEL,a.AOGUID,
         (select listagg(a2.SHORTNAME||' '||a2.FORMALNAME, ', ') within group (order by decode(a2.AOLEVEL,6,0,a2.AOLEVEL))
           from FIAS_ADDROBJ a2
           connect by prior a2.PARENTGUID=a2.AOGUID
           start with a2.AOID=a.AOID) as FULLNAME,
       (select min(ATG_CODE) keep (dense_rank LAST order by level) from FIAS_ADDROBJ a3
           connect by prior a3.PARENTGUID=a3.AOGUID
           start with a3.AOID=a.AOID) as AREAS
       from FIAS_ADDROBJ a
      where a.AOLEVEL=6) a4
     where a4.AREAS=:area or :area is null


=========================================================================================
-- drop table FIAS_ATG_CITIES
-- alter table FIAS_ATG_CITIES rename to FIAS_ATG_CITIES_v2
create table FIAS_ATG_CITIES as
 select
   'NEW' as ID,a.OFFNAME as name,
   (select min(ATG_CODE) keep (dense_rank LAST order by level) from FIAS_ADDROBJ a3
           connect by prior a3.PARENTGUID=a3.AOGUID
           start with a3.AOID=a.AOID) as AREAS,a.AOGUID as fiasCode,
   a.SHORTNAME as cityType,a.FORMALNAME as searchableName,
   (select listagg(a2.SHORTNAME((a2.SHORTNAME||decode(substr(a2.SHORTNAME,length(a2.SHORTNAME)-1,1),'.','','.')||' '||a2.FORMALNAME, ', ') within group (order by decode(connect_by_root aoid,aoid,0,a2.AOLEVEL))
     from FIAS_ADDROBJ a2
     connect by prior a2.PARENTGUID=a2.AOGUID
     start with a2.AOID=a.AOID
   ) as fullName,
   a.AOID
 from FIAS_ADDROBJ a
 join FIAS_SOCR s on (s.CODE=a.SHORTNAME and s.SOCR_LEVEL=a.AOLEVEL
   and s.KOD_T_ST in (103,111,112,401,402,417,418,419,605,636,606,621,624,630,651))
 --where a.SHORTNAME in ('аал') --('г','г.','г.ф.з.')

=========================================================================================
select
  (select min(ATG_CODE) keep (dense_rank LAST order by level) from FIAS_ATG_CITIES a3
           connect by prior a3.PARENT_FIASCODE=a3.FIASCODE
           start with a3.AOID=c.AOID) as AREAS,

~~~~~~~~~~~~~~~~~~~~~~~~~
select
  c.id, c.name as "name", c.areas as "areas", null as "slug", null as "suzId",
  c.fiascode as "fiasCode", c.citytype as "cityType", c.searchablename as "searchableName", c.fullname as "fullName"
from FIAS_ATG_CITIES c
where AREAS='300069'
minus select
  c.id, c.name as "name", c.areas as "areas", null as "slug", null as "suzId",
  c.fiascode as "fiasCode", c.citytype as "cityType", c.searchablename as "searchableName", c.fullname as "fullName"
from FIAS_ATG_CITIES_V1 c
where AREAS='300023'
minus select
  c.id, c.name as "name", c.areas as "areas", null as "slug", null as "suzId",
  c.fiascode as "fiasCode", c.citytype as "cityType", c.searchablename as "searchableName", c.fullname as "fullName"
from FIAS_ATG_CITIES_V2 c
where AREAS='300023'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


select
  c.id, c.name as "name", c.areas as "areas", null as "slug", null as "suzId",
  c.fiascode as "fiasCode", c.citytype as "cityType", c.searchablename as "searchableName", c.fullname as "fullName"
from FIAS_ATG_CITIES c
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

select * from all_tab_columns c
where c.owner like 'C##%' and table_name='T2_CITY' and lower(substr(column_name,1,4)) in ('full','sear','city')





select min(ATG_CODE) keep (dense_rank LAST order by level) from FIAS_ATG_CITIES a3
           connect by prior a3.PARENT_FIASCODE=a3.FIASCODE
           start with a3.AOID='8df25458-39ef-45df-83a2-a5e3c07ad4c7'



select
  listagg(KOD_T_ST,',') within group (order by KOD_T_ST) codes,
  listagg(name,',') within group (order by KOD_T_ST) name,
   code
from FIAS_SOCR s
where
  s.KOD_T_ST in  (111,418,112,602,6537,9133,103,401,605,606,736,9136,6541,623,751,9151,655,630,755,9155,6568,631,756,9156,6570,633)
group by code


select  * from FIAS_ADDROBJ where SHORTNAME='аал'
select * from FIAS_ADDROBJ where SHORTNAME='б-г'

select listagg(a2.SHORTNAME||' '||a2.FORMALNAME, ', ') within group (order by decode(a2.AOLEVEL,6,0,a2.AOLEVEL)) fullName
 from FIAS_ADDROBJ a2
           connect by prior a2.PARENTGUID=a2.AOGUID
           start with a2.SHORTNAME in ('б-г', 'Чувашия' )
 group by aoid
            a2.AOID



select distinct SOCR_LEVEL, f.SHORTNAME, f.N, fs.name from FIAS_SOCR fs,
(select SHORTNAME, AOLEVEL, count (*) N from FIAS_ADDROBJ group by SHORTNAME, AOLEVEL order by N desc)f
where f.SHORTNAME = fs.code and AOLEVEL=SOCR_LEVEL  order by f.SHORTNAME;

select * from FIAS_SOCR s where  s.KOD_T_ST in  (111,418,112,602,6537,9133,103,401,605,606,736,9136,6541,623,751,9151,655,630,755,9155,6568,631,756,9156,6570,633,636,621,630)
select * from FIAS_SOCR s where  s.KOD_T_ST in (103,111,112,401,402,417,418,419,605,636,606,621,624,630,651)

>> надо максу 401 417 402 419
select aolevel , count(1) from FIAS_ADDROBJ where AOLEVEL in (91,65,7) group by aolevel



------
Количество городов в областях
`````````
select count(1),a.NAME,c.areas
from FIAS_ATG_CITIES c
join FIAS_ATG_AREAS a on a.code=c.AREAS
group by c.areas,a.NAME

select distinct aolevel from FIAS_ADDROBJ

select * from FIAS_ADDROBJ where AOLEVEL=1 and SHORTNAME like ('г%')


select * from FIAS_ADDROBJ where AOGUID in ('aa548026-019c-4de6-bb6e-ff672f9fb908',
'326e5969-bfaf-47fb-985a-59bb7bec2e67',
'733432e1-1d74-4bc3-b65c-549d5a054020')

select * from (
  --select count(1) cn, fullname from FIAS_ATG_CITIES group by FULLNAME
  select count(1) cn, parentguid,OFFNAME,AOLEVEL from FIAS_ADDROBJ
  where aolevel=6
  group by  parentguid,offname,aolevel
) where cn>1

select * from "C##PUB".T2_CITY where fias_code='034a6b9c-0a4d-42ba-9a63-87dc635d3f20' or fias_code='efc8ff57-4d93-4041-badb-0a817e82a973'
select * from "C##PUB".T2_CITY c where  WORKSPACE_ID='63400_test' and fias_code='c8db1747-21bf-4056-bcb2-f13b6f63a757'

 order by c.CITY_ID*1.0 desc
select count(1) from  "C##PUB".T2_CITY where WORKSPACE_ID='63400_test' -- 65534
select count(1) from  "C##PUB".T2_CITY where WORKSPACE_ID='63301_test' --12100

select 158900-158884 from dual

select count(1) from "C##PUB".T2_CITY
select count(1) from "C##STAGE".T2_CITY
select count(1) from "C##SWITCH_A".T2_CITY

select * from T2_AREA


select count(1) c from T2_CITY where FIAS_CODE like '%-300083-1'

select * from FIAS_ATG_AREAS

select count(1) from FIAS_ATG_CITIES

begin RECREATEATGCITIESTABLE; end;

select max(length(s.fiascode)) from FIAS_ATG_CITIES s